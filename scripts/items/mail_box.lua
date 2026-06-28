local NUM_PEDESTALS = 0
local ROOM_PEDESTALS_IDX = {}

local function getPedestalsInRoom()
    local pedestals = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        -1,
        false,
        false
    )
    return pedestals
end

local function useItem(_, 
    item, ---@param item CollectibleType
    rng,    ---@param rng RNG
    player  ---@param player EntityPlayer
) 
    local pedestals = getPedestalsInRoom()
    local has_rerolled = false
    local optionPickupIndexes = {}

    for i=1, #pedestals do
        local pedestal = pedestals[i]:ToPickup()
        if pedestal and not pedestal:IsShopItem() and pedestal.SubType ~= 0 then
            if not (optionPickupIndexes[pedestal.OptionsPickupIndex] == true) then
                NUM_PEDESTALS = NUM_PEDESTALS + 1
                has_rerolled = true
                if (pedestal.OptionsPickupIndex > 0) then
                    optionPickupIndexes[pedestal.OptionsPickupIndex] = true
                end
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,pedestals[i].Position,Vector.Zero,nil) 
                pedestal:TriggerTheresOptionsPickup()
            end
            pedestals[i]:Remove()
        end
    end

    if NUM_PEDESTALS > 0 then
        local room_desc = Game():GetLevel():GetCurrentRoomDesc()
        if room_desc.Data.Type == RoomType.ROOM_CHALLENGE and
                room_desc.Data.Subtype == 1 then
            Ambush:StartChallenge()
        end
    end

    for _,player in pairs(PlayerManager.GetPlayers()) do
        local sprite = player:GetSprite()
        player:GetData().mail_box_reroll_held_item = false
        if sprite:GetAnimation():match("Pickup") then
            has_rerolled = true
            player:GetData().mail_box_reroll_held_item = true
            NUM_PEDESTALS = NUM_PEDESTALS + 1
        end
    end
    -- Gérer l'item tenu au dessus d'isaac

    return {
        Discharge = has_rerolled,
        Remove = false,
        ShowAnim = has_rerolled
    }
end

local function postNewLevel()
    ROOM_PEDESTALS_IDX = {}
    for i=1, NUM_PEDESTALS do
        local room_idx = Game():GetLevel():GetRandomRoomIndex(false, Game():GetLevel():GetGenerationRNG():Next())
        ROOM_PEDESTALS_IDX[i] = room_idx
    end
    NUM_PEDESTALS = 0
end

local function postNewRoom()
    local room_idx = Game():GetLevel():GetCurrentRoomIndex()
    for i=1, #ROOM_PEDESTALS_IDX do
        if room_idx == ROOM_PEDESTALS_IDX[i] then
            ROOM_PEDESTALS_IDX[i] = nil
            local room = Game():GetRoom()
            local spawn_pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true, false)
            
            Game():Spawn(
                EntityType.ENTITY_PICKUP, 
                PickupVariant.PICKUP_COLLECTIBLE, 
                spawn_pos, 
                Vector.Zero, 
                nil,
                0,
                Game():GetRoom():GetSpawnSeed())
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, MAIL_BOX_ID)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, postNewLevel)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom)

local function preAddCollectible(_,
    type, ---@param type CollectibleType
    charge, ---@param charge integer
    firstTime, ---@param firstTime boolean
    slot,
    varData, ---@param varData integer
    player ---@param player EntityPlayer
)
    if (player:GetData().mail_box_reroll_held_item) then
        player:GetData().mail_box_reroll_held_item = false
        return false
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, preAddCollectible)
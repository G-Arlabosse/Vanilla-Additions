local item_config = Isaac.GetItemConfig()
local pending_morhped_items = {}
local devil_pedestals = {}
local fallen_angel = Isaac.GetItemIdByName("Fallen Angel")

local function FallenAngelActive ()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    if not (roomDesc.Type == RoomType.ROOM_ANGEL) then return false end
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if player:GetCollectibleNum(fallen_angel) > 0 then
            return true
        end
    end
    return false
end

function GetPedestalsInRoom()
    local pedestals = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        -1,
        false,
        false
    )

    return pedestals
end

function Mod:InitPedestals()
    if not Game():GetRoom():IsFirstVisit() then return end
    
    if FallenAngelActive() then
        local pedestals = GetPedestalsInRoom()
        
        for i=1, #pedestals do
            local pickup = pedestals[i]:ToPickup()
            if pickup then
                local item_id = pickup.SubType
                local pickup_item_config = item_config:GetCollectible(item_id)
                pickup.Price = -pickup_item_config.DevilPrice
                pickup.AutoUpdatePrice = false
            end
        end
    end
end


local function ActiveItemPickedUp ()
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if not player:IsItemQueueEmpty() then
            return true
        end
    end
    return false
end


function Mod:PostUpdate() 
    if not FallenAngelActive() then return end

    if #pending_morhped_items > 0 then
        if not ActiveItemPickedUp() then
            for _,pickup in pairs(pending_morhped_items) do
                local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
                if config then
                    pickup.Price = -config.DevilPrice
                    pickup.AutoUpdatePrice = false
                end
            end
        end
        pending_morhped_items = {}
    end
end

local morphed_item_devil = false

function Mod:PrePickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant,    ---@param variant PickupVariant
    subtype
)
    if not FallenAngelActive() then return end
    print("=== Pre Morph ===")
    print("Item: ", pickup.SubType, "ShopId: ", pickup.Index)
    if pickup.Price < 0 then
        morphed_item_devil = true
    end
    pickup:GetData().priceReset = true
    pickup.Price = 0
    
end


function Mod:PostPickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant    ---@param variant PickupVariant
)
    if not FallenAngelActive() then return end
    print("=== POST MORPH ===")
    if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE and morphed_item_devil then
        pending_morhped_items[#pending_morhped_items + 1] = pickup
        morphed_item_devil = false
    end
    
end



Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, Mod.PrePickupMorph)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, Mod.PostPickupMorph)

-- On room enter
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.InitPedestals)

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE , Mod.PostUpdate)

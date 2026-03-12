local item_config = Isaac.GetItemConfig()
local pending_morhped_items = {}
local devil_pickups = {}
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

local function GetPedestalsInRoom()
    local pedestals = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        -1,
        false,
        false
    )
    return pedestals
end

local function InitPedestals()
    devil_pickups = {}
    if FallenAngelActive() then
        local pedestals = GetPedestalsInRoom()
        
        for i=1, #pedestals do
            local pickup = pedestals[i]:ToPickup()
            if pickup then
                if Game():GetRoom():IsFirstVisit() then
                    local item_id = pickup.SubType
                    local pickup_item_config = item_config:GetCollectible(item_id)
                    pickup.Price = -pickup_item_config.DevilPrice
                    pickup.AutoUpdatePrice = false
                    pickup.OptionsPickupIndex = 0
                    devil_pickups[pickup.Index] = pickup
                elseif pickup.Price < 0 then
                    devil_pickups[pickup.Index] = pickup
                end
            end
        end
    end
end


function ActiveItemPickedUp ()
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if not player:IsItemQueueEmpty() then
            return true
        end
    end
    return false
end

function GetClosestPlayer(pickup)
    local closestPlayer = nil
    local closestDistance = math.huge

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local distance = player.Position:Distance(pickup.Position)
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end
    return closestPlayer
end

local function PostUpdate() 
    if not FallenAngelActive() then return end

    if #pending_morhped_items > 0 then
        if not ActiveItemPickedUp() then
            for _,pickup in pairs(pending_morhped_items) do
                local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
                if config then
                    pickup.AutoUpdatePrice = false
                    devil_pickups[pickup.Index] = pickup
                end
            end
        end
        pending_morhped_items = {}
    end

    for _,pickup in pairs(devil_pickups) do ---@param pickup EntityPickup  
        local closestPlayer = GetClosestPlayer(pickup)
        if closestPlayer and pickup then
            local playerHearts = closestPlayer:GetHearts()
            local pickup_devil_price = item_config:GetCollectible(pickup.SubType).DevilPrice
            if pickup_devil_price == -PickupPrice.PRICE_ONE_HEART then
                if playerHearts >= 2 then
                    pickup.Price = PickupPrice.PRICE_ONE_HEART
                else
                    pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                end
            elseif pickup_devil_price == -PickupPrice.PRICE_TWO_HEARTS then
                if playerHearts >= 4 then
                    pickup.Price = PickupPrice.PRICE_TWO_HEARTS
                elseif playerHearts >= 2 then
                    pickup.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
                else
                    pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
                end 
            end
        end
    end
end

local morphed_item_devil = false

local function PrePickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant,    ---@param variant PickupVariant
    subtype
)
    if not FallenAngelActive() then return end
    if pickup.Price < 0 then
        morphed_item_devil = true
        pickup:GetData().priceReset = true
        pickup.Price = 0
        pickup.AutoUpdatePrice = true
        
        devil_pickups[pickup.Index] = nil
    end
end


local function PostPickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant    ---@param variant PickupVariant
)
    if not FallenAngelActive() then return end
    if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE and morphed_item_devil then
        pending_morhped_items[#pending_morhped_items + 1] = pickup
        morphed_item_devil = false
    end
    
end

local function PickupCollision(pickup, entity, low) 
    devil_pickups[pickup.Index] = nil

    if pickup.SubType == fallen_angel then
        print("Picked up Fallen Angel !")
    end
end

local function OnNewFloor ()
    
end

local function EntityKilled(
    npc ---@param npc EntityNPC
)
    if not FallenAngelActive() then return end
    if npc.Type == EntityType.ENTITY_URIEL or npc.Type == EntityType.ENTITY_GABRIEL then
        local entity = Game():Spawn(
            EntityType.ENTITY_PICKUP, 
            PickupVariant.PICKUP_COLLECTIBLE, 
            npc.Position, 
            Vector.Zero, 
            nil,
            0,
            Game():GetRoom():GetSpawnSeed())
    end
end

-- Before a morph
Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, PrePickupMorph)
-- After a morph
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, PostPickupMorph)

-- On room enter
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, InitPedestals)

-- Update every frame
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE , PostUpdate)

-- Picking up an item
Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, PickupCollision)

-- Killed an entity
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EntityKilled)

-- On New Floors
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnNewFloor)
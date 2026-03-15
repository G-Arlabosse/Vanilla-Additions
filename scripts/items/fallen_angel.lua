local item_config = Isaac.GetItemConfig()
local pending_morhped_items = {}
local devil_pickups = {}
local fallen_angel = Isaac.GetItemIdByName("Fallen Angel")

local function InAngelRoom ()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    return roomDesc.Type == RoomType.ROOM_ANGEL
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

local function GetClosestPlayer(pickup)
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

local function ChangePrice (pickup)
    local closestPlayer = GetClosestPlayer(pickup)
    if closestPlayer and pickup then
        local playerHearts = closestPlayer:GetHearts()
        local pickup_devil_price = item_config:GetCollectible(pickup.SubType).DevilPrice
        local playerType = closestPlayer:GetPlayerType()
        
        pickup.OptionsPickupIndex = 0
        -- KEEPER/T KEEPER --
        if playerType == PlayerType.PLAYER_KEEPER or playerType == playerType == PlayerType.PLAYER_KEEPER_B then
            pickup.AutoUpdatePrice = true
        -- T BLUE BABY/T JUDAS --
        elseif playerType == PlayerType.PLAYER_BLUEBABY_B or playerType == PlayerType.PLAYER_JUDAS_B or playerType == PlayerType.PLAYER_BETHANY_B then
            pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
            pickup.AutoUpdatePrice = false
        -- BLUE BABY --
        elseif playerType == PlayerType.PLAYER_BLUEBABY then
            if pickup_devil_price == -PickupPrice.PRICE_ONE_HEART then
                pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                pickup.AutoUpdatePrice = false
            elseif pickup_devil_price == -PickupPrice.PRICE_TWO_HEARTS then
                pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                pickup.AutoUpdatePrice = false
            end
        -- OTHER CHARACTERS --
        else
            -- ONE HEART COST --
            if pickup_devil_price == -PickupPrice.PRICE_ONE_HEART then    
                if playerHearts >= 2 then
                    pickup.Price = PickupPrice.PRICE_ONE_HEART
                    pickup.AutoUpdatePrice = false
                else
                    pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                    pickup.AutoUpdatePrice = false
                end
            -- TWO HEARTS COST --
            elseif pickup_devil_price == -PickupPrice.PRICE_TWO_HEARTS then
                if playerHearts >= 4 then
                    pickup.Price = PickupPrice.PRICE_TWO_HEARTS
                    pickup.AutoUpdatePrice = false
                elseif playerHearts >= 2 then
                    pickup.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
                    pickup.AutoUpdatePrice = false
                else
                    pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
                    pickup.AutoUpdatePrice = false
                end 
            end
        end
    end
end

local function InitPedestals()
    devil_pickups = {}
    if InAngelRoom() and Mod:PlayersHaveItem(fallen_angel) then
        local pedestals = GetPedestalsInRoom()
        
        for i=1, #pedestals do
            local pickup = pedestals[i]:ToPickup()
            if pickup then
                if Game():GetRoom():IsFirstVisit() then
                    ChangePrice(pickup)
                    devil_pickups[pickup.Index] = pickup
                elseif pickup.Price < 0 then
                    devil_pickups[pickup.Index] = pickup
                end
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



local function PostUpdate() 
    if not (InAngelRoom() or Mod:PlayersHaveItem(fallen_angel)) then return end

    -- Used to check if morph is from a reroll or an active swap
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

    -- Update price according to player data
    for _,pickup in pairs(devil_pickups) do ---@param pickup EntityPickup  
        ChangePrice(pickup)
    end
end

local morphed_item_devil = false

local function PrePickupMorph(_,
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant,    ---@param variant PickupVariant
    subtype
)
    if not (InAngelRoom() or Mod:PlayersHaveItem(fallen_angel)) then return end
    -- Reset Price
    if pickup.Price < 0 then
        morphed_item_devil = true
        pickup:GetData().priceReset = true
        pickup.Price = 0
        pickup.AutoUpdatePrice = true
        
        devil_pickups[pickup.Index] = nil
    end
end


local function PostPickupMorph(_,
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant    ---@param variant PickupVariant
)
    if not (InAngelRoom() or Mod:PlayersHaveItem(fallen_angel)) then return end
    -- Add pickup to reroll list
    if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE and morphed_item_devil then
        pending_morhped_items[#pending_morhped_items + 1] = pickup
        morphed_item_devil = false
    end
    
end

local function PickupCollision(_, pickup, entity, low)
    -- Remove collectible from update list 
    devil_pickups[pickup.Index] = nil
end

local function EntityKilled(_,
    npc ---@param npc EntityNPC
)
    if not (InAngelRoom() or Mod:PlayersHaveItem(fallen_angel)) then return end

    -- Spawn item on Angel kill
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

local function PreLevelInit()
    if Mod:PlayersHaveItem(fallen_angel) then
        local level = Game():GetLevel()
        level:AddAngelRoomChance(1-level:GetAngelRoomChance())
    end
end

local function OnNPCInit (_, npc)
    if InAngelRoom() and Mod:PlayersHaveItem(fallen_angel) then
        if npc.Type == EntityType.ENTITY_URIEL then
            npc:Morph(EntityType.ENTITY_URIEL, 1, 0, -1)
        end

        if npc.Type == EntityType.ENTITY_GABRIEL then
            npc:Morph(EntityType.ENTITY_GABRIEL, 1, 0, -1)
        end
    end
end

local function AddCollectible (_,
    type,       ---@param type CollectibleType
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)
    if type == fallen_angel then
        local level = Game():GetLevel()
        level:AddAngelRoomChance(1-level:GetAngelRoomChance())
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

-- Killed an Angel
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EntityKilled)

-- Update Angel Chance
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, PreLevelInit)

-- Spawn Dark Uriel/Gabriel
Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, OnNPCInit)

-- Update Angel Chance after picking up Fallen Angel
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
local item_config = Isaac.GetItemConfig()
local devil_pickups = {}
local FALLEN_ANGEL_ID = Isaac.GetItemIdByName("Fallen Angel")
local collision = false

local function InAngelRoom ()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    return roomDesc.Type == RoomType.ROOM_ANGEL
end

local function FallenAngelActive ()
    return InAngelRoom() and PlayerManager.AnyoneHasCollectible(FALLEN_ANGEL_ID)
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

local function ChangePrice (
    pickup ---@param pickup EntityPickup
)
    local closestPlayer = GetClosestPlayer(pickup)
    if closestPlayer and pickup and 
        pickup.Price ~= 0 then


        local playerHearts = closestPlayer:GetHearts()
        local pickup_devil_price = item_config:GetCollectible(pickup.SubType).DevilPrice
        local playerHealthType = closestPlayer:GetHealthType()
        
        -- COINS --
        if playerHealthType == HealthType.COIN then
            pickup.AutoUpdatePrice = true
            if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                pickup.Price = math.floor(15*pickup_devil_price/2)
                pickup.ShopItemId = -2
            else
                pickup.Price = 15*pickup_devil_price
                pickup.ShopItemId = -1
            end
        -- SOUL HEARTS --
        elseif playerHealthType == HealthType.SOUL then
            -- Tainted Characters --
            if EntityConfig.GetPlayer(closestPlayer:GetPlayerType()):IsTainted() then
                pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
                pickup.AutoUpdatePrice = false
            else
                if pickup_devil_price == -PickupPrice.PRICE_ONE_HEART then
                    pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                    pickup.AutoUpdatePrice = false
                elseif pickup_devil_price == -PickupPrice.PRICE_TWO_HEARTS then
                    pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                    pickup.AutoUpdatePrice = false
                end
            end
            
        -- RED / BONE --
        else
            -- ONE HEART COST --
            if pickup_devil_price == -PickupPrice.PRICE_ONE_HEART then    
                if playerHearts >= 2 then
                    pickup.Price = PickupPrice.PRICE_ONE_HEART
                    pickup.AutoUpdatePrice = false
                else
                    pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
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

        if pickup.Price == PickupPrice.PRICE_TWO_HEARTS and PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_JUDAS_TONGUE) then
            pickup.Price = PickupPrice.PRICE_ONE_HEART
        end
    end
end

local function InitPedestals()
    devil_pickups = {}
    if FallenAngelActive() then
        local pedestals = GetPedestalsInRoom()
        
        for i=1, #pedestals do
            local pickup = pedestals[i]:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                if Game():GetRoom():IsFirstVisit() then
                    pickup.OptionsPickupIndex = 0
                    pickup.Price = -1
                    devil_pickups[pickup.Index] = {}
                    devil_pickups[pickup.Index].pickup = pickup
                    ChangePrice(pickup)
                elseif pickup.Price < 0 then
                    devil_pickups[pickup.Index] = {}
                    devil_pickups[pickup.Index].pickup = pickup
                end
            end
        end
    end
end

local function PostUpdate() 
    if not (FallenAngelActive()) then return end

    collision = false

    -- Update price according to player data
    for _,data in pairs(devil_pickups) do 
        ChangePrice(data.pickup)
    end
end

local morphed_item_devil = false

local function PrePickupMorph(_,
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant,    ---@param variant PickupVariant
    subtype
)
    if not (FallenAngelActive()) then return end
    -- Reset Price
    if not (pickup.Price == 0) then
        morphed_item_devil = true
        pickup:GetData().priceReset = true
---@diagnostic disable-next-line: assign-type-mismatch
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
    if not (FallenAngelActive()) then return end

    --- d6 reroll (or other)
    if entityType == EntityType.ENTITY_PICKUP and 
            variant == PickupVariant.PICKUP_COLLECTIBLE and 
            morphed_item_devil and 
            not collision then

        pickup.AutoUpdatePrice = false
        pickup.Price = -1
                   
        devil_pickups[pickup.Index] = {} 
        devil_pickups[pickup.Index].pickup = pickup
        ChangePrice(pickup)
    end
    morphed_item_devil = false
    
end

local function PickupCollision(_, pickup, entity, low)
    -- Remove collectible from update list 
    if devil_pickups[pickup.Index] ~= nil then
        collision = true
        devil_pickups[pickup.Index] = nil
    end
end

local function EntityKilled(_,
    npc ---@param npc EntityNPC
)
    if not (FallenAngelActive()) then return end

    -- Spawn item on Angel kill
    if npc.Type == EntityType.ENTITY_URIEL or npc.Type == EntityType.ENTITY_GABRIEL then
        local room = Game():GetRoom()
        local free_pos = room:FindFreePickupSpawnPosition(npc.Position)
        print(npc.Position.X .. ":" .. npc.Position.Y .. " , " .. free_pos.X .. ":" .. free_pos.Y)
        local entity = Game():Spawn(
            EntityType.ENTITY_PICKUP, 
            PickupVariant.PICKUP_COLLECTIBLE, 
            free_pos, 
            Vector.Zero, 
            nil,
            0,
            Game():GetRoom():GetSpawnSeed())
    end
end

local function PreLevelInit()
    if PlayerManager.AnyoneHasCollectible(FALLEN_ANGEL_ID) then
        local level = Game():GetLevel()
        level:AddAngelRoomChance(1-level:GetAngelRoomChance())
    end
end

local function OnNPCInit (_, npc)
    if FallenAngelActive() then
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
    if type == FALLEN_ANGEL_ID then
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
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, PostUpdate)

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


local function UpdateAllPrices()
    if FallenAngelActive() then
        print("CHANGE ALL")
        local pedestals = GetPedestalsInRoom()
        for i=1, #pedestals do
            local pickup = pedestals[i]:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                ChangePrice(pickup)
            end
        end
    end    
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, UpdateAllPrices, TrinketType.TRINKET_JUDAS_TONGUE)
Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, UpdateAllPrices, TrinketType.TRINKET_JUDAS_TONGUE)


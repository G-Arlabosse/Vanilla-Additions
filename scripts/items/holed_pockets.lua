local COIN_SPAWN_CHANCE = 0.3

local function playerTakeDamage (_,
    entity,             ---@param entity Entity
    damage,             ---@param damage number
    damageFlags,        ---@param damageFlags DamageFlag 
    source,             ---@param source EntityRef 
    damageCountdown,    ---@param damageCountdown integer 
    extraSource         ---@param extraSource EntityRef 
)
    local player = entity:ToPlayer()
    if player and player:HasCollectible(HOLED_POCKETS_ID) then
        local dropped_coins = player:GetData().holed_pockets_rng :RandomInt(1,3)
        dropped_coins = math.min(dropped_coins, player:GetNumCoins()) 
        player:AddCoins(-dropped_coins)

        for _=1, dropped_coins do
            local coin = Game():Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COIN,
                player.Position,
                RandomVector() * 3,
                player,
                1,
                1
            ):ToPickup()
            coin.Timeout = 60
        end
    end
end

local function postAddCollectible(_,
    type,
    charge,
    firstTime,
    slot,
    varData,
    player  ---@param player EntityPlayer
)
    player:GetData().holed_pockets_rng = RNG(Game():GetSeeds():GetStartSeed())
end

local function postRoomTriggerClear()
    local room = Game():GetRoom()
    for _,player in pairs(PlayerManager.GetPlayers()) do
        for _=1, player:GetCollectibleNum(HOLED_POCKETS_ID) do
            local r = player:GetData().holed_pockets_rng:RandomFloat()
            if r < COIN_SPAWN_CHANCE then
                Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COIN,
                    room:FindFreePickupSpawnPosition(room:GetCenterPos()),
                    Vector.Zero,
                    player,
                    0,
                    Game():GetSeeds():GetStartSeed()
                )
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, playerTakeDamage, EntityType.ENTITY_PLAYER)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddCollectible, HOLED_POCKETS_ID)
Mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, postRoomTriggerClear)
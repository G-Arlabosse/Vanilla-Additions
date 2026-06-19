local rng = RNG()
local previous_rng_seed = 0
local rerolled = false

local GLOABL_COINS_WEIGHTS = {
    [CoinSubType.COIN_PENNY]        =   {normalValue = 75, goldenValue = 60,    achievement = nil},
    [CoinSubType.COIN_NICKEL]       =   {normalValue = 15, goldenValue = 25,    achievement = nil},
    [CoinSubType.COIN_LUCKYPENNY]   =   {normalValue = 4,  goldenValue = 6,     achievement = Achievement.LUCKY_PENNIES},
    [CoinSubType.COIN_DIME]         =   {normalValue = 3,  goldenValue = 5,     achievement = nil},
    [CoinSubType.COIN_GOLDEN]       =   {normalValue = 2,  goldenValue = 3,     achievement = Achievement.GOLDEN_PENNY},
    [CoinSubType.COIN_STICKYNICKEL] =   {normalValue = 1,  goldenValue = 1,     achievement = Achievement.STICKY_NICKELS},
}
local COINS_WEIGHTS = {}
local TOTAL_COINS_WEIGHTS = {normalValue = 0, goldenValue = 0}

local function PostPickupInit(_, 
    pickup  ---@param pickup EntityPickup
)
    if Mod:PlayersHaveTrinket(MIMICS_FAVOR_ID, false) then
        if pickup.Variant == PickupVariant.PICKUP_CHEST or
                pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST or
                pickup.Variant == PickupVariant.PICKUP_HAUNTEDCHEST or
                pickup.Variant == PickupVariant.PICKUP_REDCHEST or
                pickup.Variant == PickupVariant.PICKUP_ETERNALCHEST then
            
            local new_pickup = Game():Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_MIMICCHEST,
                pickup.Position,
                pickup.Velocity,
                nil,
                0,
                rng:Next()
            )
            pickup:Remove()
        end
    end
end

local function PostNewRoom ()
    previous_rng_seed = rng:GetSeed()
end

local function OnGlowingHourglass ()
    rng:SetSeed(previous_rng_seed)
end

local function NewGame ()
    rng:SetSeed(Game():GetSeeds():GetNextSeed(), 35)

    local isac_data = Isaac.GetPersistentGameData()
    TOTAL_COINS_WEIGHTS = {normalValue = 0, goldenValue = 0}
    for coin_subtype, coin_data in pairs(GLOABL_COINS_WEIGHTS) do
        if not coin_data.achievement or isac_data:Unlocked(coin_data.achievement) then
           COINS_WEIGHTS[coin_subtype] = { 
                normalValue = coin_data.normalValue,
                goldenValue = coin_data.goldenValue 
            }
           TOTAL_COINS_WEIGHTS.normalValue = TOTAL_COINS_WEIGHTS.normalValue + coin_data.normalValue
           TOTAL_COINS_WEIGHTS.goldenValue = TOTAL_COINS_WEIGHTS.goldenValue + coin_data.goldenValue
        else
            COINS_WEIGHTS[coin_subtype] = 0
        end 
    end 
end

local function PrePickupInit (_,
    type,
    variant,
    subType,
    position,
    velocity,
    spawner,
    seed
)
    if Mod:PlayersHaveTrinket(MIMICS_FAVOR_ID, true) then
        if type == EntityType.ENTITY_PICKUP and
                variant == PickupVariant.PICKUP_COIN and
                subType == 0 then
            local random_value = rng:RandomInt(TOTAL_COINS_WEIGHTS.goldenValue)
            local acc = 0
            for random_subtype, weight in pairs(COINS_WEIGHTS) do
                acc = acc + weight.goldenValue
                if acc > random_value then
                    print("Golden Mimic's Favor: Replacing coin subtype 0 with subtype " .. random_subtype)
                    return {type, variant, random_subtype}
                end
            end
        end
    elseif Mod:PlayersHaveTrinket(MIMICS_FAVOR_ID, false) then
        if type == EntityType.ENTITY_PICKUP and
                variant == PickupVariant.PICKUP_COIN and
                subType == 0 then
            local random_value = rng:RandomInt(TOTAL_COINS_WEIGHTS.normalValue)
            local acc = 0
            for random_subtype, weight in pairs(COINS_WEIGHTS) do
                acc = acc + weight.normalValue
                if acc > random_value then
                    print("Mimic's Favor: Replacing coin subtype 0 with subtype " .. random_subtype)
                    return {type, variant, random_subtype}
                end
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, NewGame)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, OnGlowingHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)
Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PrePickupInit)
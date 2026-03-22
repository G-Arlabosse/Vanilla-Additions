local mimics_favor = Isaac.GetTrinketIdByName("Mimic's Favor")
local rng = RNG()
local previous_rng_seed = 0
local rerolled = false

local COINS_WEIGHTS = {
    [CoinSubType.COIN_PENNY]        = 75,
    [CoinSubType.COIN_NICKEL]       = 15,
    [CoinSubType.COIN_LUCKYPENNY]   = 4,
    [CoinSubType.COIN_DIME]         = 3,
    [CoinSubType.COIN_GOLDEN]       = 2,
    [CoinSubType.COIN_STICKYNICKEL] = 1,
}


local function PostPickupInit(_, 
    pickup  ---@param pickup EntityPickup
)
    if Mod:PlayersHaveTrinket(mimics_favor) then
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
    if Mod:PlayersHaveTrinket(mimics_favor) then
        if type == EntityType.ENTITY_PICKUP and
                variant == PickupVariant.PICKUP_COIN and
                subType == 0 then
            local random_value = rng:RandomInt(100)
            local acc = 0
            for random_subtype, weight in pairs(COINS_WEIGHTS) do
                acc = acc + weight
                if acc > random_value then
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
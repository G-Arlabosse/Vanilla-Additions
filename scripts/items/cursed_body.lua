local cursed_body = Isaac.GetItemIdByName("Cursed Body")
local rng = RNG()
local rng_shift = 0

local function toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

local PLAYER_STATS = {
    speed = 0,
    damage = 0,
    tears = 0,
    range = 0,
    shotspeed = 0,
    luck = 0,
}

local DROP_PROBABILITY = 0.5 * 2
local DROP_TYPES = {
    PICKUP_HEART    = 1,
    PICKUP_COIN     = 2,
    PICKUP_BOMB     = 3,
    PICKUP_KEY      = 4,
    PICKUP_CARD     = 5,
    PICKUP_PILL     = 6,

    STAT_SPEED      = 10,
    STAT_DAMAGE     = 11,
    STAT_TEARS      = 12,
    STAT_RANGE      = 13,
    STAT_SHOTSPEED  = 14,
    STAT_LUCK       = 15,

    TRINKET         = 20,
    ITEM            = 30,
}

local DROP_WEIGHTS = {
    [DROP_TYPES.PICKUP_HEART]   = 15 + 100000, --pickupHeart
    [DROP_TYPES.PICKUP_COIN]    = 15, --pickupCoin
    [DROP_TYPES.PICKUP_BOMB]    = 10, --pickupBomb 
    [DROP_TYPES.PICKUP_KEY]     = 10, --pickupKey
    [DROP_TYPES.PICKUP_CARD]    = 5, --pickupCard 
    [DROP_TYPES.PICKUP_PILL]    = 5, --pickupPill 

    [DROP_TYPES.STAT_SPEED]     = 3,  --statSpeed
    [DROP_TYPES.STAT_DAMAGE]    = 3,  --statDamage
    [DROP_TYPES.STAT_TEARS]     = 3,  --statTears 
    [DROP_TYPES.STAT_RANGE]     = 3,  --statRange 
    [DROP_TYPES.STAT_SHOTSPEED] = 3,  --statShotspeed 
    [DROP_TYPES.STAT_LUCK]      = 3,  --statLuck 

    [DROP_TYPES.TRINKET]        = 2,  --trinket 
    [DROP_TYPES.ITEM]           = 1,   --item 
}

local TOTAL_WEIGHTS = 0
for i,j in pairs(DROP_WEIGHTS) do
    TOTAL_WEIGHTS = TOTAL_WEIGHTS + j
end

local function AddCollectible (_,
    type,       ---@param type CollectibleType
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)
    if type == cursed_body and not Mod:PlayersHaveItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_UNKNOWN, false)
    end
end


local function applyDrop(
    player, ---@param player EntityPlayer
    drop_type
) 
    if drop_type == DROP_TYPES.PICKUP_HEART then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1
    elseif drop_type == DROP_TYPES.PICKUP_COIN then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1
    elseif drop_type == DROP_TYPES.PICKUP_BOMB then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1
    elseif drop_type == DROP_TYPES.PICKUP_KEY then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1
    elseif drop_type == DROP_TYPES.PICKUP_CARD then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1
    elseif drop_type == DROP_TYPES.PICKUP_PILL then
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,player.Position,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
        rng_shift = rng_shift + 1

    elseif drop_type == DROP_TYPES.STAT_SPEED then
        PLAYER_STATS.speed = PLAYER_STATS.speed + 0.05
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_DAMAGE then
        PLAYER_STATS.damage = PLAYER_STATS.damage + 0.05
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_TEARS then
        PLAYER_STATS.tears = PLAYER_STATS.tears + 0.1
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_RANGE then
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        PLAYER_STATS.range = PLAYER_STATS.range + 0.2
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_SHOTSPEED then
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
        PLAYER_STATS.shotspeed = PLAYER_STATS.shotspeed + 0.05
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_LUCK then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        PLAYER_STATS.luck = PLAYER_STATS.luck + 0.1
        player:EvaluateItems()
    
    elseif drop_type == DROP_TYPES.TRINKET then
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,player.Position,Vector.Zero,nil)
    elseif drop_type == DROP_TYPES.ITEM then
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,player.Position,Vector.Zero,nil)
    end
end

local function TakeDamage (_,
    entity,         ---@param entity Entity
    damage,         ---@param damage number
    damageFlags,    ---@param damageFlags DamageFlag[]
    source,         ---@param source EntityRef
    damageCountdown ---@param damageCountdown integer
)
    local player = entity:ToPlayer()
    if not player then return end
    
    if Mod:PlayersHaveItem(cursed_body) then
        local rand_drop = rng:RandomFloat()
        rng_shift = rng_shift + 1
        if rand_drop < DROP_PROBABILITY then
            local rand_weight = rng:RandomFloat() * TOTAL_WEIGHTS
            rng_shift = rng_shift + 1
            local acc = 0
            for drop_type, weight in pairs(DROP_WEIGHTS) do
                acc = acc + weight
                if acc > rand_weight then
                    applyDrop(player, drop_type)
                    return
                end
            end
        end
    end
end

local function CalculateCache (_,
    player, ---@param player EntityPlayer
    flags   ---@param flags CacheFlag
)
    if Mod:PlayersHaveItem(cursed_body) then
        if flags == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + PLAYER_STATS.speed
        end
        if flags == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + PLAYER_STATS.range
        end
        if flags == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + PLAYER_STATS.shotspeed
        end
        if flags == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + PLAYER_STATS.luck
        end
    end
end

local function CalculateStat (_,
    player,         ---@param player EntityPlayer 
    stat,           ---@param stat EvaluateStatStage
    currentValue    ---@param currentValue number
)
    if Mod:PlayersHaveItem(cursed_body) then
        if stat == EvaluateStatStage.DAMAGE_UP then
            return currentValue + PLAYER_STATS.damage
        end
        if stat == EvaluateStatStage.TEARS_UP then
            return toMaxFireDelay(toTearsPerSecond(currentValue + PLAYER_STATS.tears))
        end
    end
end

local function OnNewGame ()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
    
    PLAYER_STATS.speed = 0
    PLAYER_STATS.damage = 0
    PLAYER_STATS.range = 0
    PLAYER_STATS.tears = 0
    PLAYER_STATS.shotspeed = 0
    PLAYER_STATS.luck = 0
end

local function NewLevel ()
    if Mod:PlayersHaveItem(cursed_body) and not Mod:PlayersHaveItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_UNKNOWN, false)
    end
    
end


local function NewRoom ()
    rng_shift = 0
    print(rng:PhantomFloat())
end

local function UseGlowingHourglass ()
    print("=== SHIFTS === ", rng_shift)
    for i=1, rng_shift do
        print(rng:Previous())
    end
    print(rng:PhantomFloat())
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewGame)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, NewLevel)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CalculateCache)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, CalculateStat)

Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TakeDamage, EntityType.ENTITY_PLAYER)

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseGlowingHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
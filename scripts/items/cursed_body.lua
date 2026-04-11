local rng = RNG()
local previous_rng = 0

local function toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

local PLAYER_STAT_BONUSES = {}
local PREVIOUS_STAT_BONUSES = {}

local DROP_PROBABILITY = 0.5
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
    [DROP_TYPES.PICKUP_HEART]   = 15, --pickupHeart
    [DROP_TYPES.PICKUP_COIN]    = 15, --pickupCoin
    [DROP_TYPES.PICKUP_BOMB]    = 11, --pickupBomb 
    [DROP_TYPES.PICKUP_KEY]     = 11, --pickupKey
    [DROP_TYPES.PICKUP_CARD]    = 7, --pickupCard 
    [DROP_TYPES.PICKUP_PILL]    = 7, --pickupPill 

    [DROP_TYPES.STAT_SPEED]     = 5,  --statSpeed
    [DROP_TYPES.STAT_DAMAGE]    = 5,  --statDamage
    [DROP_TYPES.STAT_TEARS]     = 5,  --statTears 
    [DROP_TYPES.STAT_RANGE]     = 5,  --statRange 
    [DROP_TYPES.STAT_SHOTSPEED] = 5,  --statShotspeed 
    [DROP_TYPES.STAT_LUCK]      = 5,  --statLuck 

    [DROP_TYPES.TRINKET]        = 3,  --trinket 
    [DROP_TYPES.ITEM]           = 1   --item 
}

local SPEED_BONUS = 0.1
local DAMAGE_BONUS = 1
local TEAR_BONUS = 0.25
local RANGE_BONUS = 40 -- 40 equal 1 tile
local SHOT_SPEED_BONUS = 0.1
local LUCK_BONUS = 1

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
    if type == CURSED_BODY_ID and not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_UNKNOWN, false)
    end
    
    if PLAYER_STAT_BONUSES[player:GetPlayerIndex()+1] then return end
    PLAYER_STAT_BONUSES[player:GetPlayerIndex()+1] = {
        speed = 0,
        damage = 0,
        tears = 0,
        range = 0,
        shotspeed = 0,
        luck = 0,
    }
end


local function applyDrop(
    player, ---@param player EntityPlayer
    drop_type
) 
    local index = player:GetPlayerIndex()+1

    if drop_type == DROP_TYPES.PICKUP_HEART then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.PICKUP_COIN then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.PICKUP_BOMB then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.PICKUP_KEY then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.PICKUP_CARD then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.PICKUP_PILL then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, false)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))

    elseif drop_type == DROP_TYPES.STAT_SPEED then
        PLAYER_STAT_BONUSES[index].speed = PLAYER_STAT_BONUSES[index].speed + SPEED_BONUS
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_DAMAGE then
        PLAYER_STAT_BONUSES[index].damage = PLAYER_STAT_BONUSES[index].damage + DAMAGE_BONUS
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_TEARS then
        PLAYER_STAT_BONUSES[index].tears = PLAYER_STAT_BONUSES[index].tears + TEAR_BONUS
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_RANGE then
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        PLAYER_STAT_BONUSES[index].range = PLAYER_STAT_BONUSES[index].range + RANGE_BONUS
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_SHOTSPEED then
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
        PLAYER_STAT_BONUSES[index].shotspeed = PLAYER_STAT_BONUSES[index].shotspeed + SHOT_SPEED_BONUS
        player:EvaluateItems()
    elseif drop_type == DROP_TYPES.STAT_LUCK then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        PLAYER_STAT_BONUSES[index].luck = PLAYER_STAT_BONUSES[index].luck + LUCK_BONUS
        player:EvaluateItems()
    
    elseif drop_type == DROP_TYPES.TRINKET then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true)
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,spawn_pos,Vector.Zero,nil,0,rng:RandomInt(2^31-1))
    elseif drop_type == DROP_TYPES.ITEM then
        local spawn_pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true)
        local itemID = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_CURSE, true, rng:RandomInt(2^31-1))
        Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,spawn_pos,Vector.Zero,nil,itemID,1)
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
    
    for _=0, player:GetCollectibleNum(CURSED_BODY_ID)-1 do
        local rand_drop = rng:RandomFloat()
        if rand_drop < DROP_PROBABILITY then
            local rand_weight = rng:RandomFloat() * TOTAL_WEIGHTS
            local acc = 0
            for drop_type, weight in pairs(DROP_WEIGHTS) do
                acc = acc + weight
                if acc > rand_weight then
                    applyDrop(player, drop_type)
                    goto continue
                end
            end
        end
        ::continue::
    end
end

local function CalculateCache (_,
    player, ---@param player EntityPlayer
    flags   ---@param flags CacheFlag
)
    if player:HasCollectible(CURSED_BODY_ID) then
        local index = player:GetPlayerIndex()+1
        if flags == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + PLAYER_STAT_BONUSES[index].speed
        end
        if flags == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + PLAYER_STAT_BONUSES[index].range
        end
        if flags == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + PLAYER_STAT_BONUSES[index].shotspeed
        end
        if flags == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + PLAYER_STAT_BONUSES[index].luck
        end
    end
end

local function CalculateStat (_,
    player,         ---@param player EntityPlayer 
    stat,           ---@param stat EvaluateStatStage
    currentValue    ---@param currentValue number
)
    if player:HasCollectible(CURSED_BODY_ID) then
        local index = player:GetPlayerIndex()+1
        if stat == EvaluateStatStage.DAMAGE_UP then
            return currentValue + PLAYER_STAT_BONUSES[index].damage
        end
        if stat == EvaluateStatStage.TEARS_UP then
            return toMaxFireDelay(toTearsPerSecond(currentValue + PLAYER_STAT_BONUSES[index].tears))
        end
    end
end

local function OnNewGame ()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
end

local function PostCurseEval (_, curses)
    if PlayerManager.AnyoneHasCollectible(CURSED_BODY_ID) and not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        curses = curses | LevelCurse.CURSE_OF_THE_UNKNOWN
    end 
    return curses
end


local function NewRoom ()
    previous_rng = rng:GetSeed()
    for p,_ in pairs(PLAYER_STAT_BONUSES) do
        PREVIOUS_STAT_BONUSES[p] = {}
        for i,j in pairs(PLAYER_STAT_BONUSES[p]) do
            PREVIOUS_STAT_BONUSES[p][i] = j
        end
    end
end

local function UseGlowingHourglass ()
    rng:SetSeed(previous_rng)
    
    for p,_ in pairs(PREVIOUS_STAT_BONUSES) do
        for i,j in pairs(PREVIOUS_STAT_BONUSES[p]) do
            PLAYER_STAT_BONUSES[p][i] = j
        end
    end
    for i=1, Game():GetNumPlayers() do
        local player = Game():GetPlayer(i)
        player:EvaluateItems()
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewGame)
Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CalculateCache)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, CalculateStat)

Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TakeDamage, EntityType.ENTITY_PLAYER)

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseGlowingHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
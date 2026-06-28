local DAMAGE_MULTIPLIER = 1.75
local TEAR_BONUS = -0.7
local SHOTSPEED_BONUS = 0.5

local function evaluateTearFlag(_, player, cache)
    if player:HasCollectible(NOTHINGNESS_ID) then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL        
    end
end

local function evaluateTearColor(_, player, cache)
    if player:HasCollectible(NOTHINGNESS_ID) then
        player.TearColor =  Color.Lerp(player.TearColor, Color(0,0,0,0.5), 0.5)
    end
end

local function evaluateDamageMult(_,player,cache)
    if player:HasCollectible(NOTHINGNESS_ID) then
        player.Damage = player.Damage * DAMAGE_MULTIPLIER     
    end
end

local function evaluateDamageBonus(_,player ---@param player EntityPlayer
    ,cache, value)
    if player:HasCollectible(NOTHINGNESS_ID) then
        if player:GetHealthType() == HealthType.RED or
            player:GetHealthType() == HealthType.SOUL or
            player:GetHealthType() == HealthType.COIN or
            player:GetHealthType() == HealthType.BONE
        then
            local health = player:GetHearts() + player:GetSoulHearts() + player:GetBlackHearts() + player:GetBoneHearts()
            health = math.max(1, health)
            return value + 8 * math.exp(math.log(2, math.exp(1)) * ((1 - health)/2) )
        end
    end
end

local function evaluateShotspeed(_,player,cache)
    if player:HasCollectible(NOTHINGNESS_ID) then
        player.ShotSpeed = player.ShotSpeed + SHOTSPEED_BONUS     
    end
end

local function evaluateFireDelay(_, player, cache, value)
    if player:HasCollectible(NOTHINGNESS_ID) then
        return value + TEAR_BONUS     
    end
end

local function postPlayerTakeDmg(_,
    entity, ---@param entity Entity
    damage,
    damageFlags,
    source,
    damageCountdown,
    extraSource
)
    local player = entity:ToPlayer()
    if player and player:HasCollectible(NOTHINGNESS_ID) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

local function changeHealthType(_, player, cache, value) ---@param player EntityPlayer
    if player:HasCollectible(NOTHINGNESS_ID) and 
        value == HealthType.DEFAULT and 
        not (player:GetPlayerType() == PlayerType.PLAYER_BETHANY or 
            player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B) then
        return HealthType.SOUL
    end
end

local function postPlayerAddHearts(_, player, addHealthType, optionalArg)
    if player:HasCollectible(NOTHINGNESS_ID) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

local function playerHealthTypeChange(_,
    player,
    newHealthType, 
    previousHealthType, 
    defaultHealthType
)
    if newHealthType == HealthType.SOUL then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)    
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, changeHealthType, CustomCacheTag.HEALTH_TYPE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateTearFlag, CacheFlag.CACHE_TEARFLAG)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateTearColor, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateDamageMult, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evaluateDamageBonus, EvaluateStatStage.DAMAGE_UP)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateShotspeed, CacheFlag.CACHE_SHOTSPEED)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evaluateFireDelay, EvaluateStatStage.TEARS_UP)

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, postPlayerTakeDmg, EntityType.ENTITY_PLAYER)
Mod:AddCallback(ModCallbacks.MC_PLAYER_HEALTH_TYPE_CHANGE, playerHealthTypeChange)

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_HEARTS, postPlayerAddHearts)


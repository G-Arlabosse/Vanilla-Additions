local SPEED_BONUS = 0.3
local DAMAGE_BONUS = 0.8
local TEARS_BONUS = 0.4
local RANGE_BONUS = 2.5 
local SHOTSPEED_BONUS = 0.16 
local LUCK_BONUS = 1.0 
local ANGEL_DEVIL_BONUS = 15
local PLANETARIUM_BONUS = 10

local function EvaluateSpeed(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.MoveSpeed = player.MoveSpeed + SPEED_BONUS
    end
end

local function EvaluateDamage(_, player, cache, currentValue)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        return currentValue + DAMAGE_BONUS
    end
end

local function toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

local function EvaluateTears(_, player, cache, currentValue)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        print(currentValue)
        return currentValue + TEARS_BONUS
    end
end

local function EvaluateRange(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.TearRange = player.TearRange + 40 * RANGE_BONUS
    end
end

local function EvaluateShotSpeed(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.ShotSpeed = player.ShotSpeed + SHOTSPEED_BONUS
    end
end

local function EvaluateLuck(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.Luck = player.Luck + LUCK_BONUS
    end
end

local function addDevilChance(_, chance)
    if Game():GetLevel():GetCurses() > 0 and PlayerManager.AnyoneHasCollectible(CURSED_SPIRIT_ID) then
        return chance + ANGEL_DEVIL_BONUS/100
    end
end

local function addPlanetariumChance(_, chance)
    if Game():GetLevel():GetCurses() > 0 and PlayerManager.AnyoneHasCollectible(CURSED_SPIRIT_ID) then
        return chance + PLANETARIUM_BONUS/100
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateSpeed, CacheFlag.CACHE_SPEED)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, EvaluateDamage, EvaluateStatStage.DAMAGE_UP)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, EvaluateTears, EvaluateStatStage.TEARS_UP)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateRange, CacheFlag.CACHE_RANGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateShotSpeed, CacheFlag.CACHE_SHOTSPEED)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateLuck, CacheFlag.CACHE_LUCK)

Mod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, addDevilChance)
Mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, addPlanetariumChance)
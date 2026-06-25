local SPEED_BONUS = 0.3
local DAMAGE_BONUS = 0.8
local TEARS_BONUS = 0.4
local RANGE_BONUS = 2.5 
local SHOTSPEED_BONUS = 0.16 
local LUCK_BONUS = 1.0 
local ANGEL_DEVIL_BONUS = 15
local PLANETARIUM_BONUS = 10

local function calcNumCurses()
    local curses = Game():GetLevel():GetCurses()
    local numCurses = 0
    for i=0, LevelCurse.NUM_CURSES do
        if (curses >> i) % 2 == 1 then
            numCurses = numCurses + 1
        end
    end
    return numCurses
end

local function calcBonusMult(nbItems)
    local bonus = 0
    for i=0, calcNumCurses()-1 do
        local p_i = 1 << i
        for j=0, nbItems-1 do
            bonus = bonus + 1/(p_i * (1 << j))
        end
    end
    return bonus
end

local function EvaluateSpeed(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.MoveSpeed = player.MoveSpeed + SPEED_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function EvaluateDamage(_, player, cache, currentValue)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        return currentValue + DAMAGE_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function EvaluateTears(_, player, cache, currentValue)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        print(currentValue)
        return currentValue + TEARS_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function EvaluateRange(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.TearRange = player.TearRange + 40 * RANGE_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function EvaluateShotSpeed(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.ShotSpeed = player.ShotSpeed + SHOTSPEED_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function EvaluateLuck(_, player, cache)
    if Game():GetLevel():GetCurses() > 0 and player:HasCollectible(CURSED_SPIRIT_ID) then
        player.Luck = player.Luck + LUCK_BONUS * calcBonusMult(player:GetCollectibleNum(CURSED_SPIRIT_ID))
    end
end

local function addDevilChance(_, chance)
    if Game():GetLevel():GetCurses() > 0 and PlayerManager.AnyoneHasCollectible(CURSED_SPIRIT_ID) then
        local nbItems = 0
        for _,player in ipairs(PlayerManager.GetPlayers()) do
            nbItems = nbItems + player:GetCollectibleNum(CURSED_SPIRIT_ID)
        end
        return chance + (ANGEL_DEVIL_BONUS/100) * calcBonusMult(nbItems)
    end
end

local function addPlanetariumChance(_, chance)
    if Game():GetLevel():GetCurses() > 0 and PlayerManager.AnyoneHasCollectible(CURSED_SPIRIT_ID) then
        local nbItems = 0
        for _,player in ipairs(PlayerManager.GetPlayers()) do
            nbItems = nbItems + player:GetCollectibleNum(CURSED_SPIRIT_ID)
        end
        return chance + (PLANETARIUM_BONUS/100) * calcBonusMult(nbItems)
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
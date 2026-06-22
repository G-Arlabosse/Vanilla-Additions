local PLANETARIUM_CHANCE = 7.77
local DEVIL_CHANCE = 20.0
local LUCK_MULTIPLIER = 1.5

local function addPlanetariumChance(_, chance)
    if PlayerManager.AnyoneHasCollectible(CLOVER_100_LEAF_ID) then
        return chance + PLANETARIUM_CHANCE/100
    end
end

local function addDevilChance(_, chance)
    if PlayerManager.AnyoneHasCollectible(CLOVER_100_LEAF_ID) then
        return chance + DEVIL_CHANCE/100
    end
end

local function addLuckMult(_, 
    player, ---@param player EntityPlayer 
    cacheFlag)
    if cacheFlag == CacheFlag.CACHE_LUCK and
        player:HasCollectible(CLOVER_100_LEAF_ID) then
            player.Luck = player.Luck * LUCK_MULTIPLIER
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, addPlanetariumChance)
Mod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, addDevilChance)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, addLuckMult)
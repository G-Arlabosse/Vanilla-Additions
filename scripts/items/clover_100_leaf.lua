local PLANETARIUM_CHANCE = 7.77
local DEVIL_CHANCE = 20.0
local LUCK_MULTIPLIER = 1.5

local function addPlanetariumChance(_, chance)
    for _, player in pairs(PlayerManager.GetPlayers()) do ---@param player EntityPlayer
        chance = chance + player:GetCollectibleNum(CLOVER_100_LEAF_ID) * PLANETARIUM_CHANCE/100 
    end
    return chance
end

local function addDevilChance(_, chance)
    for _, player in pairs(PlayerManager.GetPlayers()) do ---@param player EntityPlayer
        chance = chance + player:GetCollectibleNum(CLOVER_100_LEAF_ID) * DEVIL_CHANCE/100 
    end
    return chance
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
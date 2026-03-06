---@param player EntityPlayer

local bigRock = Isaac.GetItemIdByName("Big Rock")
local DAMAGE_MULTIPLIER = 1.2
local SPEED_MULTIPLIER = 0.75
local TEARS_BONUS = 0.4

local function evaluateCache(a, player, cacheFlags)
    if player:GetCollectibleNum(bigRock) >= 1 then
        if cacheFlags == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * SPEED_MULTIPLIER
            if player.MoveSpeed >= 1.5 then
                player.MoveSpeed = 1.5
            end
        end

        if cacheFlags == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * DAMAGE_MULTIPLIER
        end
        
        if cacheFlags == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 2
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FIREDELAY)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_SPEED)
print("end callbacks")
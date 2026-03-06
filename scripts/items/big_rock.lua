---@param player EntityPlayer

local bigRock = Isaac.GetItemIdByName("Big Rock")
local SPEED_MULTIPLIER = 0.75

local function evaluateCache(a, player, cacheFlags)
    if player:GetCollectibleNum(bigRock) >= 1 then
        if cacheFlags == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * SPEED_MULTIPLIER
            if player.MoveSpeed >= 1.5 then
                player.MoveSpeed = 1.5
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_SPEED)
print("end callbacks")
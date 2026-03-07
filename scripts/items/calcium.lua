---@param player EntityPlayer

local calcium = Isaac.GetItemIdByName("Calcium")
local DAMAGE_MULTIPLIER = 0.25
local FIRE_RATE_MULTIPLIER = 5.5

local function toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

local function calciumUse(_, item, rng, player)
    local data = player:GetData()
    data.opikoko_calcium_active = true

    -- Trigger stat change
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

-- Deactivate calcium for each player
local function calciumDeactivate()
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        data.opikoko_calcium_active = false
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
end

local function evaluateCache(_, player, cacheFlags)
    print(type(player), type(cacheFlags))
    print(player, "|", cacheFlags)
    local data = player:GetData()

    -- Update Damage
    if cacheFlags == CacheFlag.CACHE_DAMAGE then
        if data.opikoko_calcium_active then
            player.Damage = player.Damage * DAMAGE_MULTIPLIER
        end
    end
    -- Update Fire Rate with tears calculation
    if cacheFlags == CacheFlag.CACHE_FIREDELAY then
        if data.opikoko_calcium_active then
            player.MaxFireDelay = toMaxFireDelay(toTearsPerSecond(player.MaxFireDelay) * FIRE_RATE_MULTIPLIER)
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, calciumUse, calcium)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, calciumDeactivate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FIREDELAY)
print("end callbacks")
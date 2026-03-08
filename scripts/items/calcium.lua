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
    -- Update Tear color
    if cacheFlags == CacheFlag.CACHE_TEARCOLOR then
        if data.opikoko_calcium_active then
            player.TearColor = Color(1,1,1,1,0.5,0.5,0.5)
        end
    end
end

local function changeTearProperties(_, tear)
    local player = tear.SpawnerEntity
    local data = player:GetData()
    if data.opikoko_calcium_active then
        tear.Scale = tear.Scale * 0.4
        tear.KnockbackMultiplier = tear.KnockbackMultiplier * 0.2
    end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, calciumUse, calcium)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, calciumDeactivate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FIREDELAY)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, changeTearProperties)
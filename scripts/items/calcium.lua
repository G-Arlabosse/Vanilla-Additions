local calcium = Isaac.GetItemIdByName("Calcium")
local DAMAGE_MULTIPLIER = 0.25
local FIRE_RATE_MULTIPLIER = 5.5

local function toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

---@param player EntityPlayer
local function calciumUse(_, item, rng, player)
    local player_weapon_modifiers = player:GetWeaponModifiers()
    local data = player:GetData()

    --- ALMOND_MILK ---
    if player_weapon_modifiers & WeaponModifier.ALMOND_MILK > 0 then
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER/0.3
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER/4
    --- SOY_MILK ---
    elseif player_weapon_modifiers & WeaponModifier.SOY_MILK > 0 then
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER/0.2
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER/5.5

    else
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER
    end

    data.opikoko_calcium_active = true

    -- Trigger stat change
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
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

---@param player EntityPlayer
local function evaluateCache(_, player, cacheFlags)
    local data = player:GetData()
    if data.opikoko_calcium_active then
        -- Update Damage
        if cacheFlags == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * data.opikoko_calcium_damage_mult

        -- Update Fire Rate with tears calculation
        elseif cacheFlags == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = toMaxFireDelay(toTearsPerSecond(player.MaxFireDelay) * data.opikoko_calcium_fire_rate_mult)
        
            -- Update Tear color
        elseif cacheFlags == CacheFlag.CACHE_TEARCOLOR then
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

local function PostWeaponFire(_,
    weapon, ---@param weapon Weapon
    fireDirection,
    isShooting,
    isInterpolated
)
    if weapon:GetOwner():GetData().opikoko_calcium_active then
        weapon:SetModifiers(WeaponModifier.SOY_MILK)
    end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, calciumUse, calcium)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, calciumDeactivate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FIREDELAY)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, changeTearProperties)
Mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, PostWeaponFire)
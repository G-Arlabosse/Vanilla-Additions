local DAMAGE_MULTIPLIER = 0.25
local FIRE_RATE_MULTIPLIER = 5.5
local TEAR_SCALE = 0.4
local TEAR_KNOCKBACK = 0.2

---@param player EntityPlayer
local function calciumUse(_, item, rng, player)
    local player_weapon_modifiers = player:GetWeaponModifiers()
    local data = player:GetData()

    --- ALMOND_MILK ---
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER/0.3
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER/4
        data.opikoko_calcium_tear_scale = 1
        data.opikoko_calcium_tear_knockback = 1
    --- SOY_MILK ---
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER/0.2
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER/5.5
        data.opikoko_calcium_tear_scale = 1
        data.opikoko_calcium_tear_knockback = 1

    else
        data.opikoko_calcium_damage_mult = DAMAGE_MULTIPLIER
        data.opikoko_calcium_fire_rate_mult = FIRE_RATE_MULTIPLIER
        data.opikoko_calcium_tear_scale = TEAR_SCALE
        data.opikoko_calcium_tear_knockback = TEAR_KNOCKBACK
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
            player.MaxFireDelay = Mod:toMaxFireDelay(Mod:toTearsPerSecond(player.MaxFireDelay) * data.opikoko_calcium_fire_rate_mult)
        
            -- Update Tear color
        elseif cacheFlags == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color.TearSoy
        end
    end
end

local function changeTearProperties(_, tear)
    local player = tear.SpawnerEntity
    local data = player:GetData()
    if data.opikoko_calcium_active then
        tear.Scale = tear.Scale * data.opikoko_calcium_tear_scale
        tear.KnockbackMultiplier = tear.KnockbackMultiplier * data.opikoko_calcium_tear_knockback
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

local function PostAddCollectible(_,type,charge,firstTime,slot,varData,player)
    if player:GetData().opikoko_calcium_active then
        if type == CollectibleType.COLLECTIBLE_SOY_MILK or type == CollectibleType.COLLECTIBLE_ALMOND_MILK then
            calciumUse(_, CALCIUM_ID, RNG(), player)
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, calciumUse, CALCIUM_ID)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, calciumDeactivate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_DAMAGE)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FIREDELAY)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, changeTearProperties)
Mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, PostWeaponFire)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PostAddCollectible)
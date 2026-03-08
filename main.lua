Mod = RegisterMod("Vanilla Additions", 1)

--- Utilities ---
include("scripts.utility.EID")

--- Items ---
include("scripts.items.calcium")
include("scripts.items.big_rock")
include("scripts.items.cursed_floors")
include("scripts.items.rare_candy")

local damagePotion = Isaac.GetItemIdByName("Damage Potion")
local damagePotionDamage = 1

function Mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(damagePotion)
        local damageToAdd = damagePotionDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.EvaluateCache)

local bigRedButton = Isaac.GetItemIdByName("Big Red Button")

function Mod:RedButtonUse(item)
    local roomEntities = Isaac.GetRoomEntities()
    for _, entity in ipairs(roomEntities) do
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            entity:Kill()
        end
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, Mod.RedButtonUse, bigRedButton)
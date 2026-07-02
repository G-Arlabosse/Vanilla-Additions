Mod = RegisterMod("Vanilla Additions", 1)

--- Utilities ---
include("scripts.utility.CollectibleIDs") -- MUST BE LOADED FIRST
include("scripts.utility.EID")
include("scripts.utility.utils")

--- Items ---
include("scripts.items.calcium")
include("scripts.items.big_rock")
include("scripts.items.ominous_door")
include("scripts.items.rare_candy")
include("scripts.items.bell_baby")
include("scripts.items.fallen_angel")
include("scripts.items.life_orb")
include("scripts.items.corrupted_clover")
include("scripts.items.cursed_map")
include("scripts.items.poison_mush")
include("scripts.items.cursed_d6")
include("scripts.items.broken_compass")
include("scripts.items.cursed_body")
include("scripts.items.extinguished_candle")
include("scripts.items.clover_100_leaf")
include("scripts.items.nova")
include("scripts.items.cursed_spirit")
include("scripts.items.mail_box")
include("scripts.items.holed_pockets")
include("scripts.items.nothingness")
include("scripts.items.phoenix")

--- Trinkets ---
include("scripts.trinkets.broken_scissors")
include("scripts.trinkets.mimics_favor")

--- Consumables ---
include("scripts.consumables.uno_reverse_card")

--- Unlocks ---
include("scripts.achievements.poison_mush")



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
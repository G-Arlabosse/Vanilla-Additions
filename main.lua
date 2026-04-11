Mod = RegisterMod("Vanilla Additions", 1)

--- Utilities ---
include("scripts.utility.EID")
include("scripts.utility.utils")
include("scripts.utility.devil_costs")

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

--- Trinkets ---
include("scripts.trinkets.broken_scissors")
include("scripts.trinkets.mimics_favor")

--- Unlocks ---
include("scripts.achievements.poison_mush")

--- Item IDs ---
BELL_BABY_ID = Isaac.GetItemIdByName("Bell Baby")
BIG_ROCK_ID = Isaac.GetItemIdByName("Big Rock")
BROKEN_COMPASS_ID = Isaac.GetItemIdByName("Broken Compass")
CALCIUM_ID = Isaac.GetItemIdByName("Calcium")
CORRUPTED_CLOVER_ID = Isaac.GetItemIdByName("Corrupted Clover")
CURSED_BODY_ID = Isaac.GetItemIdByName("Cursed Body")
CURSED_D6_ID = Isaac.GetItemIdByName("Cursed D6")
CURSED_MAP_ID = Isaac.GetItemIdByName("Cursed Map")
EXTINGUISHED_CANDLE_ID = Isaac.GetItemIdByName("Extinguished Candle")
FALLEN_ANGEL_ID = Isaac.GetItemIdByName("Fallen Angel")
LIFE_ORB_ID = Isaac.GetItemIdByName("Life Orb")
OMINOUS_DOOR_ID = Isaac.GetItemIdByName("Ominous Door")
POISON_MUSH_ID = Isaac.GetItemIdByName("Poison Mush")
RARE_CANDY_ID = Isaac.GetItemIdByName("Rare Candy")

--- Trinket IDs ---
BROKEN_SCISSORS_ID = Isaac.GetTrinketIdByName("Broken Scissors")
MIMICS_FAVOR_ID = Isaac.GetTrinketIdByName("Mimic's Favor")

--- Consumable IDs ---
-- REVERSE_CARD_ID = Isaac.GetCardIdByName("Reverse Card")


--- Consumables ---
include("scripts.consumables.uno_reverse_card")

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
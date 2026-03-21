local cursed_baby = Isaac.GetItemIdByName("Cursed Baby")


local function PreLevelGen()
    
end

local function PreEntitySpawn ()
    
end

local function PickupSelection (_,
    pickup,             ---@param pickup EntityPickup 
    variant,            ---@param variant PickupVariant 
    subType,            ---@param subType integer
    requestedVariant,   ---@param requestedVariant PickupVariant
    requestedSubType,   ---@param requestedSubType integer
    rng                 ---@param rng RNG
)
    if Mod:PlayersHaveItem(cursed_baby) then
        if variant == PickupVariant.PICKUP_LOCKEDCHEST then
            return {PickupVariant.PICKUP_MEGACHEST, 1}
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, PreLevelGen)
Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PreEntitySpawn)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, PickupSelection)
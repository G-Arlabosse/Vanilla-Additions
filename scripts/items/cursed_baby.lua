local cursed_baby = Isaac.GetItemIdByName("Cursed Baby")


local function PreLevelGen()
    
end

local function PostNPCInit (_,
    entity  ---@param entity EntityNPC
)
    if entity.Type ~= 0 then
        entity:MakeChampion(Game():GetRoom():GetSpawnSeed(), ChampionColor.GIANT, false)
    end
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

local function PostPickupInit(_, 
    pickup
)
    if pickup.Variant == PickupVariant.PICKUP_PILL then
        
        local spawner = pickup.SpawnerEntity
        if spawner and spawner:ToNPC() then

            local npc = spawner:ToNPC()    
            if npc:GetChampionColorIdx() == ChampionColor.GIANT then
                local itemPool = Game():GetItemPool()
                local pillEffect = itemPool:GetPillEffect(pickup.SubType)
                if pillEffect == PillEffect.PILLEFFECT_LARGER then
                    pickup:Remove()
                end
            end
        end
    end
end

function PreEntitySpawn(_, type, variant, subtype, position, velocity, spawner, seed)
    print(type, variant, subtype)
    if type == EntityType.ENTITY_BOMB and variant == BombVariant.BOMB_TROLL then
        return {type, BombVariant.BOMB_GIGA, 0, seed}
    end

    if type == EntityType.ENTITY_PICKUP and
        variant == PickupVariant.PICKUP_BOMB and
        (subtype == 0 or subtype == BombSubType.BOMB_NORMAL or subtype == BombSubType.BOMB_DOUBLEPACK) then
        return {type, variant, BombSubType.BOMB_GIGA, seed}
    end

    if type == EntityType.ENTITY_PICKUP and
        variant == PickupVariant.PICKUP_PILL then
            return {type, variant, subtype + 2048, seed}
        end
end

Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, PreLevelGen)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PostNPCInit)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, PickupSelection)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)

Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PreEntitySpawn)
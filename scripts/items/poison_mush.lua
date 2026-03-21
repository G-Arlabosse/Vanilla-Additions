local poison_mush = Isaac.GetItemIdByName("Poison Mush")


local function PostCurses(_, curses)
    print(curses)
    if Mod:PlayersHaveItem(poison_mush) and not Mod:PlayersHaveItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        return curses | LevelCurse.CURSE_OF_GIANT
    end
    return curses
end

local function PostNPCInit (_,
    entity  ---@param entity EntityNPC
)
    if Mod:PlayersHaveItem(poison_mush) then
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
    if Mod:PlayersHaveItem(poison_mush) then
        if variant == PickupVariant.PICKUP_LOCKEDCHEST then
            return {PickupVariant.PICKUP_MEGACHEST, 1}
        end
    end
end

local function PostPickupInit(_, 
    pickup  ---@param pickup EntityPickup
)
    if not Mod:PlayersHaveItem(poison_mush) then return end

    if pickup.Variant == PickupVariant.PICKUP_PILL then
        local spawner = pickup.SpawnerEntity
        if spawner then

            local npc = spawner:ToNPC()  
            if npc and npc:GetChampionColorIdx() == ChampionColor.GIANT then
                local itemPool = Game():GetItemPool()
                local pillEffect = itemPool:GetPillEffect(pickup.SubType)
                if pillEffect == PillEffect.PILLEFFECT_LARGER then
                    pickup:Remove()
                end
            end
        end
    end

    --- Giga Bombs (Ingnited)
    if pickup.Variant == PickupVariant.PICKUP_BOMB and
        (pickup.SubType == BombSubType.BOMB_TROLL or pickup.SubType == BombSubType.BOMB_SUPERTROLL) then
        Game():Spawn(
            EntityType.ENTITY_BOMB, 
            BombVariant.BOMB_GIGA, 
            pickup.Position, 
            pickup.Velocity, 
            pickup.SpawnerEntity, 
            0, 
            0
        )
        pickup:Remove()

    --- Giga Bombs (Non ignited)
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB and
        (pickup.SubType == BombSubType.BOMB_NORMAL or pickup.SubType == BombSubType.BOMB_DOUBLEPACK) 
        and pickup.Price == 0 then
        local new_pickup = Game():Spawn(
            EntityType.ENTITY_PICKUP, 
            PickupVariant.PICKUP_BOMB, 
            pickup.Position, 
            pickup.Velocity, 
            pickup.SpawnerEntity, 
            BombSubType.BOMB_GIGA, 
            0
        )
        new_pickup:ToPickup().Price = pickup.Price
        pickup:Remove()
    end

    --- Horse Pills
    if pickup.Variant == PickupVariant.PICKUP_PILL then
        local itemPool = Game():GetItemPool()
        if (pickup.SubType & PillColor.PILL_GIANT_FLAG) == 0 then
            local new_pickup = Game():Spawn(
                EntityType.ENTITY_PICKUP, 
                PickupVariant.PICKUP_PILL, 
                pickup.Position, 
                pickup.Velocity, 
                pickup.SpawnerEntity, 
                pickup.SubType | PillColor.PILL_GIANT_FLAG, 
                0
            )
            new_pickup:ToPickup().Price = pickup.Price
            pickup:Remove()
        end
    end
end

function PreEntitySpawn(_, type, variant, subtype, position, velocity, spawner, seed)
    if not Mod:PlayersHaveItem(poison_mush) then return end
    
    --- Giga Bombs (from red chests)
    if type == EntityType.ENTITY_BOMB and 
    (variant == BombVariant.BOMB_TROLL or variant == BombVariant.BOMB_SUPERTROLL) then
        return {type, BombVariant.BOMB_GIGA, 0, seed}
    end
end

local function PickedCollectible(_,
    type,       ---@param type CollectibleType 
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)
    if not Mod:PlayersHaveItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_GIANT, false)
    end
    player:AddCacheFlags(CacheFlag.CACHE_SIZE)
    player:EvaluateItems()
end

function EvaluateCache(_, 
    player,     ---@param player EntityPlayer
    cacheFlag
)
    if cacheFlag == CacheFlag.CACHE_SIZE then
        local size_mult = 0.512^player:GetCollectibleNum(poison_mush)
        player.SpriteScale = player.SpriteScale * size_mult
        player.Size = player.Size * size_mult
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCache)

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurses)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PostNPCInit)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, PickupSelection)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)

Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PreEntitySpawn)

Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PickedCollectible, poison_mush)
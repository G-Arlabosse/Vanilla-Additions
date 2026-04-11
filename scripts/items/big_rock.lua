
local SPEED_MULTIPLIER = 0.75
local BIG_ROCK_SPAWN_CHANCE = 0.05
local has_bigRock_spawned = false

---@param player EntityPlayer
local function evaluateCache(_, player, cacheFlags)
    if player:GetCollectibleNum(BIG_ROCK_ID) >= 1 then
        if cacheFlags == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * SPEED_MULTIPLIER
            -- Cap the player's speed at 1.5 because of the multiplier
            if player.MoveSpeed >= 1.5 then
                player.MoveSpeed = 1.5
            end
        end
    end
end

local function spawnBigRock(_, rock, rock_type)
    if rock_type ~= GridEntityType.GRID_ROCKT then return end -- Ignore if what broke isn't a Tinted Rock
    if has_bigRock_spawned then return end -- Prevent Big Rock from appearing twice

    if math.random() < BIG_ROCK_SPAWN_CHANCE then

        local smallRockSpawned = false

        -- Remove any pickups that spawned at the same position unless they are The Small Rock
        for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
            if entity.Position:Distance(rock.Position) < 20 then
                if entity:GetType() == EntityType.ENTITY_PICKUP and entity.SubType == Isaac.GetItemIdByName("The Small Rock") then
                    smallRockSpawned = true
                else
                    entity:Remove()
                end
            end
        end

        -- Spawn Big Rock where the tinted rock was
        if smallRockSpawned ~= true then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                BIG_ROCK_ID,
                rock.Position,
                Vector.Zero,
                nil
            )
            has_bigRock_spawned = true
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_SPEED)
Mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, spawnBigRock)

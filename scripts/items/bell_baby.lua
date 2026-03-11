local itemConfig = Isaac.GetItemConfig()

local ITEM_ID = Isaac.GetItemIdByName("Bell Baby")
local CONFIG_BELL_BABY = itemConfig:GetCollectible(ITEM_ID)
local FAMILIAR_VARIANT = Isaac.GetEntityVariantByName("Bell Baby")
local RNG_SHIFT_INDEX = 35

-- States
local STATE_FOLLOW  = 0  -- no enemies nearby, trail behind player
local STATE_CHASE   = 1  -- chasing a target

-- Behavior constants
local DETECT_RANGE  = 200.0  -- how far to notice enemies (divide by 40 for tiles)
local CHASE_SPEED   = 6.0
local FOLLOW_SPEED  = 4.5
local FOLLOW_DIST   = 60
local CONTACT_DMG   = 1.5    -- per tick (like Blood Puppy)
local DMG_COOLDOWN  = 10     -- ticks between damage applications

-- Treasure probabilities (percentage)
local TREASURES = {
    ["COIN"] = 25,
    ["HEART"] = 10,
    ["BOMB"] = 20,
    ["KEY"] = 15,
    ["BATTERY"] = 8,
    ["CARD"] = 8,
    ["CHEST"] = 5,
    ["GOLD_CHEST"] = 3,
    ["BOMB_CHEST"] = 3,
    ["CRAWLSPACE"] = 3
}
local dig_chance = 0       -- updated with luck
local MIN_CHANCE = 0.4
local MAX_CHANCE = 0.8
local MIN_LUCK = 0
local MAX_LUCK = 20
local DOUBLE_DIG_CHANCE = 0.1

local TOTAL_TREASURES_WEIGHT = 0
for treasure, weight in pairs(TREASURES) do
    TOTAL_TREASURES_WEIGHT = TOTAL_TREASURES_WEIGHT + weight
end


local function getRandomTreasure(rng)
    local value = rng:RandomInt(TOTAL_TREASURES_WEIGHT)+1

    local weightIndex = 0
    for treasure, weight in pairs(TREASURES) do
        weightIndex = weightIndex + weight
        if weightIndex >= value then
            return treasure
        end 
    end
    return "NONE"
end

local function spawnTreasure(treasure, familiar)
    
    if treasure == "CRAWLSPACE" then
        local room = Game():GetRoom()
        room:SpawnGridEntity(
        room:GetGridIndex(familiar.Position),
        GridEntityType.GRID_STAIRS)
        return
    end
    local pickup_variant = PickupVariant.PICKUP_NULL
    if treasure == "COIN" then
        pickup_variant = PickupVariant.PICKUP_COIN
    elseif treasure == "HEART" then
        pickup_variant = PickupVariant.PICKUP_HEART
    elseif treasure == "BOMB" then
        pickup_variant = PickupVariant.PICKUP_BOMB
    elseif treasure == "KEY" then
        pickup_variant = PickupVariant.PICKUP_KEY
    elseif treasure == "BATTERY" then
        pickup_variant = PickupVariant.PICKUP_LIL_BATTERY
    elseif treasure == "CARD" then
        pickup_variant = PickupVariant.PICKUP_TAROTCARD
    elseif treasure == "CHEST" then
        pickup_variant = PickupVariant.PICKUP_CHEST
    elseif treasure == "GOLD_CHEST" then
        pickup_variant = PickupVariant.PICKUP_LOCKEDCHEST
    elseif treasure == "BOMB_CHEST" then
        pickup_variant = PickupVariant.PICKUP_BOMBCHEST
    -- elseif treasure == "PEDESTAL" then
    --     Game():Spawn(
    --     EntityType.ENTITY_PICKUP, 
    --     PickupVariant.PICKUP_COLLECTIBLE, 
    --     familiar.Position, 
    --     Vector.Zero, 
    --     nil,
    --     0,
    --     Game():GetRoom():GetSpawnSeed())
    --     return
    -- elseif treasure == "PORTAL" then
    --     Game():Spawn(
    --     EntityType.ENTITY_PICKUP, 
    --     51, 
    --     familiar.Position, 
    --     Vector.Zero, 
    --     nil,
    --     1,
    --     Game():GetRoom():GetSpawnSeed())
    end
    Game():Spawn(
    EntityType.ENTITY_PICKUP, 
    pickup_variant, 
    familiar.Position, 
    Vector.Zero, 
    nil,
    0,
    Game():GetRoom():GetSpawnSeed())
end

local function digTreasure()
    local familiars = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FAMILIAR_VARIANT, -1)
    for _, entity in ipairs(familiars) do
        local familiar = entity:ToFamiliar()
        if familiar then
            local player = familiar.Player
            local luck = player.Luck
            local rng = RNG()
            rng:SetSeed(Random(), 1)
            if rng:RandomFloat() < dig_chance then
                local treasure = getRandomTreasure(rng)
                spawnTreasure(treasure, familiar)
                -- Chance to dig twice
                if rng:RandomFloat() < DOUBLE_DIG_CHANCE then
                    local treasure = getRandomTreasure(rng)
                    spawnTreasure(treasure, familiar)
                end
            end
        end
    end
end

local function updateDigChance(_, player, cacheFlags)
    if player:GetCollectibleNum(ITEM_ID) >= 1 then
        if cacheFlags == CacheFlag.CACHE_LUCK then
            local luck = player.Luck
            local clamped_luck = math.min(MAX_LUCK, math.max(MIN_LUCK, luck))
            dig_chance = MIN_CHANCE + (MAX_CHANCE-MIN_CHANCE)*(luck-MIN_LUCK)/(MAX_LUCK-MIN_LUCK)
        end
    end
end

local function calculateVelocity(familiar, direction, speed)
    local room = Game():GetRoom()
    local vel = direction:Normalized() * speed

    -- Check X and Y axes separately so we can slide along walls
    local nextX = familiar.Position + Vector(vel.X, 0)
    local nextY = familiar.Position + Vector(0, vel.Y)

    -- Don't move if there is a collision
    if room:GetGridCollisionAtPos(nextX) ~= GridCollisionClass.COLLISION_NONE then
        vel.X = 0
    end
    if room:GetGridCollisionAtPos(nextY) ~= GridCollisionClass.COLLISION_NONE then
        vel.Y = 0
    end

    familiar.Velocity = vel
end

---@param familiar EntityFamiliar
---@param target Entity
local function chaseTarget(familiar, data, target)
    local dir = target.Position - familiar.Position
    local dist = dir:Length()

    if dist > 10 then
        calculateVelocity(familiar, dir, CHASE_SPEED)
    else
        familiar.Velocity = Vector.Zero
    end

    familiar.MoveDirection = Mod:Vec2Dir(dir:Normalized())

    -- Contact damage check
    if dist < 20.0 and data.dmgCooldown <= 0 then
        target:TakeDamage(
            CONTACT_DMG,
            0,
            EntityRef(familiar),
            0
        )
        data.dmgCooldown = DMG_COOLDOWN
    end
end

---@param familiar EntityFamiliar
---@param target Entity
local function followPlayer(familiar, target)
    -- Follow player, but stop when close enough (Leech-like idle hover)
    local player = familiar.Player
    local dir = (player.Position - familiar.Position)
    local distToPlayer = dir:Length()

    if distToPlayer > FOLLOW_DIST then
        calculateVelocity(familiar, dir, FOLLOW_SPEED)
    else
        -- Gently drift to a stop
        familiar.Velocity = familiar.Velocity * 0.7
    end

    familiar.MoveDirection = Mod:Vec2Dir(dir:Normalized())
end

---@param familiar EntityFamiliar
local function bellBabyBehavior(_, familiar)
    if familiar.Variant ~= FAMILIAR_VARIANT then return end

    local data = familiar:GetData()

    -- Initialize data
    if data.dmgCooldown == nil then data.dmgCooldown = 0 end
    if data.state == nil then data.state = STATE_FOLLOW end
    print(familiar.GridCollisionClass)

    -- Tick down cooldown
    data.dmgCooldown = math.max(0, data.dmgCooldown -1)

    -- Try to find a target
    familiar:PickEnemyTarget(DETECT_RANGE, 13, 1)
    local target = familiar.Target

    if target then
        data.state = STATE_CHASE
        chaseTarget(familiar, data, target)
    else
        data.state = STATE_FOLLOW
        followPlayer(familiar, familiar.Parent)
    end
    position = familiar.Position
    
    local sprite = familiar:GetSprite()
    local anim
    local doFlip = false

    if familiar.Velocity:Length() <= 2 then
        anim = "Idle "
    else
        anim = "Move "
    end

    if familiar.MoveDirection == Direction.LEFT then
        anim = anim .. "Hori"
        doFlip = true
    elseif familiar.MoveDirection == Direction.RIGHT then
        anim = anim .. "Hori"
    elseif familiar.MoveDirection == Direction.UP then
        anim = anim .. "Up"
    elseif familiar.MoveDirection == Direction.DOWN then
        anim = anim .. "Down"
    end

    sprite.FlipX = doFlip
    sprite:Play(anim, false)

end

---@param player EntityPlayer
local function evaluateCache(_, player, cacheFlag)
    if cacheFlag ~= CacheFlag.CACHE_FAMILIARS then return end

    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(ITEM_ID) + player:GetCollectibleNum(ITEM_ID)
    local rng = RNG()
    local seed = math.max(Random(),1)
    rng:SetSeed(seed, RNG_SHIFT_INDEX)

    player:CheckFamiliar(FAMILIAR_VARIANT, count, rng, CONFIG_BELL_BABY)
end

---@param familiar EntityFamiliar
local function handleInit(_, familiar)
    familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bellBabyBehavior, FAMILIAR_VARIANT)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FAMILIARS)
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, handleInit, FAMILIAR_VARIANT)
Mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, digTreasure)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, updateDigChance, CacheFlag.CACHE_LUCK)
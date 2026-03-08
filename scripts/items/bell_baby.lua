local itemConfig = Isaac.GetItemConfig()

local ITEM_ID = Isaac.GetItemIdByName("Bell Baby")
local CONFIG_BELL_BABY = itemConfig:GetCollectible(ITEM_ID)
local FAMILIAR_VARIANT = Isaac.GetEntityVariantByName("Bell Baby")
local RNG_SHIFT_INDEX = 35

-- States
local STATE_FOLLOW  = 0  -- no enemies nearby, trail behind player
local STATE_CHASE   = 1  -- chasing a target
--local STATE_CHARGE  = 2  -- (optional) blood puppy-style charge

local DETECT_RANGE  = 200.0  -- how far to notice enemies (divide by 40 for tiles)
local CHASE_SPEED   = 6.0
local FOLLOW_SPEED  = 4.5
local FOLLOW_DIST   = 60
local CONTACT_DMG   = 2.0    -- per tick (like Blood Puppy)
local DMG_COOLDOWN  = 5     -- ticks between damage applications


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

    if dist > 15 then
        calculateVelocity(familiar, dir, CHASE_SPEED)
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
    print(familiar)
    familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bellBabyBehavior, FAMILIAR_VARIANT)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache, CacheFlag.CACHE_FAMILIARS)
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, handleInit, FAMILIAR_VARIANT)
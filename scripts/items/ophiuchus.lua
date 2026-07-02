local MIN_CHANCE = 0.1
local MAX_CHANCE = 1.0
local MIN_LUCK = 0
local MAX_LUCK = 15
local CUSTOM_TEAR_SPRITE = "gfx/snake_shot.png"

local DAMAGE_MULT = 2
local SIZE_THRESHOLDS = {0.5,0.8,1.2,1.5,1.9}
local SNAKE_SIZES = {"Tiny","Small","Medium","Large","Huge","Gargantuan"}

local snakeTears = {}



local function getSnakeSize(size)
    for i, threshold in ipairs(SIZE_THRESHOLDS) do
        if size < threshold then
            return SNAKE_SIZES[i]
        end
    end
    return SNAKE_SIZES[#SNAKE_SIZES]
end

local function fireSnakeTear(_, tear)
    local player = tear.SpawnerEntity
    if not player or not player:ToPlayer() then return end
    player = player:ToPlayer()

    if not player:HasCollectible(OPHIUCHUS_ID) then return end

    local luck = player.Luck
    local clamped_luck = math.min(math.max(luck, MIN_LUCK), MAX_LUCK)
    local chance = math.min(MIN_CHANCE + clamped_luck * (MAX_CHANCE-MIN_CHANCE)/(MAX_LUCK-MIN_LUCK), MAX_CHANCE)
    local roll = math.random()

    if roll < chance then
        tear.TearFlags = tear.TearFlags
            | TearFlags.TEAR_HOMING
            | TearFlags.TEAR_POISON

        tear.CollisionDamage = tear.CollisionDamage * DAMAGE_MULT

        tear:GetSprite():Load("gfx/snake_tear.anm2", true)
        tear:GetSprite():Play(getSnakeSize(tear.Scale), true)

        -- Register this tear for rotation
        snakeTears[tear.Index] = true
    end
end

local function rotateSnakes(_, tear)
    if not snakeTears[tear.Index] then return end

    tear:GetSprite().Rotation = math.deg(math.atan(tear.Velocity.Y, tear.Velocity.X)) + 90
end

local function removeSnake(_, tear)
    snakeTears[tear.Index] = nil
end

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, fireSnakeTear)

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rotateSnakes)

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, removeSnake)

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = tear.SpawnerEntity
    -- if not player or not player:ToPlayer() then return end
    print("Damage: " .. tear.CollisionDamage .. " Scale: " .. tear.Scale)
end)
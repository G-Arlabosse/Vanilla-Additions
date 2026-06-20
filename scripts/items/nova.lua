local TEAR_SCALE_BONUS = -0.5
local EXPLOSION_BASE_DAMAGE = 20
local EXPLOSION_DAMAGE_MULTIPLIER = 10

local firingFormation = false
local firstEnemyKilled = true
local lastHitDamage = {}

local function ChangeTearColor(_, player, cacheFlag)
    if player:HasCollectible(NOVA_ID) then
        player.TearColor = Color(0.7, 0.7, 0.9, 1, 
            0.1, 0.1, 0.5, 
            0.1, 0.1, 0.3, 0.1)
    end

end

local function PostFireTear(_, tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player:HasCollectible(NOVA_ID) then return end
    
    if player:HasCollectible(NOVA_ID) then
        tear.Scale = tear.Scale + TEAR_SCALE_BONUS
    end

    if firingFormation then return end   

    local vel = tear.Velocity
    local pos = tear.Position
    local dir = vel:Normalized()
    local perp = Vector(-dir.Y, dir.X) -- 90° rotation of the direction

    local spread = (tear.Scale + 1) * 4 -- distance from center point to each tear in the formation
    firingFormation = true

    player:FireTear(pos + dir * spread, vel, false, true) -- front
    player:FireTear(pos - dir * spread, vel, false, true) -- back
    player:FireTear(pos + perp * spread, vel, false, true) -- left
    player:FireTear(pos - perp * spread, vel, false, true) -- right

    firingFormation = false

    tear:Remove() -- remove the original center tear so you end up with exactly 4
end

local function CalcRadiusMultiplier(range)
    local radiusMultiplier = math.log(range/40 + 4, 10)
    radiusMultiplier = math.max(radiusMultiplier, 0.9) -- Ensure the radius multiplier is at least 0.75
    radiusMultiplier = math.min(radiusMultiplier, 1.5) -- Ensure the radius multiplier does not exceed 3.0
    return radiusMultiplier
end

local function PostNpcDeath (_, 
    entityNpc ---@param entityNpc EntityNPC
)
    if not entityNpc:IsEnemy() then return end

    if not lastHitDamage[entityNpc.InitSeed] then return end
    local player = lastHitDamage[entityNpc.InitSeed]
    if not player:HasCollectible(NOVA_ID) then return end

    if firstEnemyKilled then

        firstEnemyKilled = false
        local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, entityNpc.Position, Vector(0, 0), player)
    blackHole:SetColor(Color(0.1, 0.1, 0.1, 0.9, 
        0, 0, 0, 
        0, 0, 0, 0), -1, 0, false, false)
        
        --blackHole:ToEffect().Position = entityNpc.Position
        
        blackHole:GetData().IsCustomGravityWell = true
        blackHole:GetData().Timer = 60 
        blackHole:GetData().Damage = player.Damage * EXPLOSION_DAMAGE_MULTIPLIER + EXPLOSION_BASE_DAMAGE
        blackHole:GetData().Position = entityNpc.Position
        blackHole:GetData().RadiusMultiplier = CalcRadiusMultiplier(player.TearRange)
        print("Black hole radiusMultiplier: " .. tostring(blackHole:GetData().RadiusMultiplier))
    end 
end

local function OnEffectUpdate(_, effect)
    if effect.Variant ~= EffectVariant.BLACK_HOLE then return end
    local data = effect:GetData()
    if not data.IsCustomGravityWell then return end
    
    if effect.State == 0 then
        effect.SpriteScale = Vector(1,1)
    else
        effect.SpriteScale = Vector(1,1) * data.RadiusMultiplier * data.RadiusMultiplier
    end
    
    data.Timer = data.Timer - 1

    if data.Timer <= 0 then
        -- Black hole's lifetime is up -- detonate it
        Game():BombExplosionEffects(
            effect.Position,
            data.Damage,
            TearFlags.TEAR_NORMAL,
            Color.Default,
            nil,
            data.RadiusMultiplier,     -- radius multiplier
            false, -- alternate explosion sprite
            false, -- damage source
            DamageFlag.DAMAGE_EXPLOSION      -- damage flags
        )
        effect:Remove()
        return
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, OnEffectUpdate)

local function PostNewRoom()
    firstEnemyKilled = true
    lastHitDamage = {}
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, PostNpcDeath)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ChangeTearColor, CacheFlag.CACHE_TEARCOLOR)


local function EntityTakeDamage(_, 
    entity, ---@param entity Entity
    amount, ---@param amount number
    flags,  ---@param flags DamageFlag
    source, ---@param source EntityRef
    countdown
)
    if not entity or not entity:IsEnemy() then return end
        if source.Entity and source.Entity.SpawnerType == EntityType.ENTITY_PLAYER then
            local player = source.Entity.SpawnerEntity:ToPlayer()
            lastHitDamage[entity.InitSeed] = player

    -- Brimstone synergy
    elseif source.Type == EntityType.ENTITY_PLAYER then 
        lastHitDamage[entity.InitSeed] = source.Entity:ToPlayer()
    else
        lastHitDamage[entity.InitSeed] = nil
    end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EntityTakeDamage)
local TEAR_SCALE_BONUS = -0.30
local EXPLOSION_BASE_DAMAGE = 20
local EXPLOSION_DAMAGE_MULTIPLIER = 10
local TEARS_MULTIPLIER = 0.42

local firingFormation = false
local lastHitDamage = {}

local function ChangeTearColor(_, player, cacheFlag)
    if player:HasCollectible(NOVA_ID) then
        player.TearColor = Color(0.7, 0.7, 0.9, 1, 
            0.1, 0.1, 0.5, 
            0.1, 0.1, 0.3, 0.1)
    end

end

local function ShootTears(_, player, tear, doubleNova)
    local vel = tear.Velocity
    local pos = tear.Position
    local dir = vel:Normalized()
    local directions = {} 
    if doubleNova then
        directions = {Vector(0, 0), dir, -dir, dir:Rotated(60), dir:Rotated(-60), dir:Rotated(120), dir:Rotated(-120)}
    else
        directions = {dir, -dir, dir:Rotated(90), dir:Rotated(-90)}
    end

    local spread = (tear.Scale + 1) * 4 -- distance from center point to each tear in the formation
    
    for _, d in ipairs(directions) do
        player:FireTear(pos + d * spread, vel, false, true)
    end
end

local function PostFireTear(_, tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player:HasCollectible(NOVA_ID) then return end
    
    if player:HasCollectible(NOVA_ID) then
        tear.Scale = tear.Scale + TEAR_SCALE_BONUS
    end

    if firingFormation then return end   

    firingFormation = true
    ShootTears(_, player, tear, player:GetCollectibleNum(NOVA_ID) > 1)
    firingFormation = false

    tear:Remove() -- remove the original tear
end

local function CalcRadiusMultiplier(playerRange)
    local radiusMultiplier = math.log(playerRange/40 + 4, 10)
    radiusMultiplier = math.max(radiusMultiplier, 0.9) -- Ensure the radius multiplier is at least 0.75
    radiusMultiplier = math.min(radiusMultiplier, 1.5) -- Ensure the radius multiplier does not exceed 3.0
    return radiusMultiplier
end

local function CalcExplosionDamage(playerDamage, hasMrMega)
    local damgage = playerDamage * EXPLOSION_DAMAGE_MULTIPLIER + EXPLOSION_BASE_DAMAGE
    if hasMrMega then
        damgage = damgage * 1.85
    end
    return damgage
end

local function PostNpcDeath (_, 
    entityNpc ---@param entityNpc EntityNPC
)
    if not entityNpc:IsEnemy() then return end

    if not lastHitDamage[entityNpc.InitSeed] then return end

    ---@param player EntityPlayer
    local player = lastHitDamage[entityNpc.InitSeed]
    if not player:HasCollectible(NOVA_ID) then return end
    local data = player:GetData()

    if not data.nbNovaTrigged then
        data.nbNovaTrigged = 0
    end

    print("Player " .. player:GetName() .. " has triggered Nova " .. data.nbNovaTrigged .. " times.")
    print("And has "  .. player:GetCollectibleNum(NOVA_ID) .. " Nova items.")
    if data.nbNovaTrigged < player:GetCollectibleNum(NOVA_ID) then
        data.nbNovaTrigged = data.nbNovaTrigged + 1

        local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, entityNpc.Position, Vector(0, 0), player)
    blackHole:SetColor(Color(0.1, 0.1, 0.1, 0.9, 
        0, 0, 0, 
        0, 0, 0, 0), -1, 0, false, false)
        
        --blackHole:ToEffect().Position = entityNpc.Position
        
        blackHole:GetData().IsCustomGravityWell = true
        blackHole:GetData().Timer = 60 
        blackHole:GetData().Damage = CalcExplosionDamage(player.Damage, player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA))
        blackHole:GetData().Position = entityNpc.Position
        blackHole:GetData().RadiusMultiplier = CalcRadiusMultiplier(player.TearRange)
        --print("Black hole radiusMultiplier: " .. tostring(blackHole:GetData().RadiusMultiplier))
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

local function PostNewRoom()
    --- resets the data of all players
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        data.nbNovaTrigged = 0
    end

    lastHitDamage = {}
end

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

local function EvaluateFireDelay(_, 
    player,     ---@param player EntityPlayer
    cacheFlag   ---@param cacheFlag CacheFlag
)
    if cacheFlag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(NOVA_ID) then
        print(player.MaxFireDelay)
        player.MaxFireDelay = Mod:toMaxFireDelay(Mod:toTearsPerSecond(player.MaxFireDelay) * TEARS_MULTIPLIER)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, PostNpcDeath)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, OnEffectUpdate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ChangeTearColor, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EntityTakeDamage)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateFireDelay, CacheFlag.CACHE_FIREDELAY)
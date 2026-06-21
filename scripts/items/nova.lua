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

local function getTearsToShootPositions(_, 
    player, ---@param player EntityPlayer
    entity, ---@param entity Entity
    tearSize
)
    local vel = entity.Velocity
    local pos = entity.Position
    local dir = vel:Normalized()
    local directions = {} 
    if player:GetCollectibleNum(NOVA_ID) > 1 then
        directions = {Vector(0, 0), dir, -dir, dir:Rotated(60), dir:Rotated(-60), dir:Rotated(120), dir:Rotated(-120)}
    else
        directions = {dir, -dir, dir:Rotated(90), dir:Rotated(-90)}
    end
    local spread = (tearSize + 1) * 4 -- distance from center point to each tear in the formation
    for i, d in ipairs(directions) do
        directions[i] = pos + d * spread
    end
    return directions
end

local function PostFireTear(_,
    tear ---@param tear EntityTear
)
    ---@param player EntityPlayer
    local player = tear.SpawnerEntity:ToPlayer()
    if player and not player:HasCollectible(NOVA_ID) then return end
    if tear.Variant == TearVariant.FETUS then return end

    tear.Scale = tear.Scale + TEAR_SCALE_BONUS

    if firingFormation then return end   
    
    local shootPositions = getTearsToShootPositions(_, player, tear, tear.Scale)
    firingFormation = true
    for _,p in pairs(shootPositions) do
        player:FireTear(p, tear.Velocity, true, false, false, player)
    end
    firingFormation = false
    tear:Remove() -- remove the original tear
end

local function PostFireBomb(_, 
    bomb ---@param bomb EntityBomb
)
    ---@param player EntityPlayer
    local player = bomb.SpawnerEntity:ToPlayer()
    if player and not player:HasCollectible(NOVA_ID) then return end

    if firingFormation then return end   
    
    local shootPositions = getTearsToShootPositions(_, player, bomb, 2)
    firingFormation = true
    for _,p in pairs(shootPositions) do
        player:FireBomb(p, bomb.Velocity, player)
        print(p)
    end
    firingFormation = false
    bomb:Remove() -- remove the original bomb
end

local function PostFireTechXLaser(_, 
    laser ---@param laser EntityLaser
)
    laser.Radius = laser.Radius * (1 + TEAR_SCALE_BONUS)
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
    player:GetWeaponModifiers()
    if cacheFlag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(NOVA_ID) then
        player.MaxFireDelay = Mod:toMaxFireDelay(Mod:toTearsPerSecond(player.MaxFireDelay) * TEARS_MULTIPLIER)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, PostNpcDeath)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_BOMB, PostFireBomb)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_X_LASER, PostFireTechXLaser)
--[[
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE_BALL, PostFireBrimstoneBall)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, PostFireBrimstone)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_KNIFE, PostFireKnife)
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_LASER, PostFireTechLaser)
--]]

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, OnEffectUpdate)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ChangeTearColor, CacheFlag.CACHE_TEARCOLOR)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EntityTakeDamage)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateFireDelay, CacheFlag.CACHE_FIREDELAY)



local function EvaluateMultiShotParams(_,
    player, ---@param player EntityPlayer 
    multiShotParams, ---@param multiShotParams MultiShotParams
    weaponType  ---@param weaponType WeaponType
)
    if player and player:HasCollectible(NOVA_ID) then
        --- BRIM, FETUS, LASER, KNIFE or TECH X ---
        if weaponType == WeaponType.WEAPON_BRIMSTONE or
            weaponType == WeaponType.WEAPON_FETUS or
            weaponType == WeaponType.WEAPON_LASER or
            weaponType == WeaponType.WEAPON_KNIFE or
            weaponType == WeaponType.WEAPON_TECH_X
        then
            if multiShotParams:GetNumTears() < 2 then
                multiShotParams:SetNumTears(2)
                multiShotParams:SetSpreadAngle(weaponType, 2)
                multiShotParams:SetNumLanesPerEye(2)
            end
            local tearNum = 2 * math.min(player:GetCollectibleNum(NOVA_ID), 4)
            if multiShotParams:GetNumRandomDirTears() < tearNum then
                multiShotParams:SetNumRandomDirTears(tearNum)
            end
            
        --- EPIC FETUS ---
        elseif weaponType == WeaponType.WEAPON_ROCKETS then
            local tearNum = 1 + math.min(player:GetCollectibleNum(NOVA_ID), 4)
            if multiShotParams:GetNumRandomDirTears() < tearNum then
                multiShotParams:SetNumRandomDirTears(tearNum)
                print(multiShotParams:GetNumRandomDirTears())
            end

        --- LUDOVICO ---
        elseif weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE then
            local tearNum = 2 * (1 + math.min(player:GetCollectibleNum(NOVA_ID), 4))
            if multiShotParams:GetNumTears() < tearNum then
                multiShotParams:SetNumTears(tearNum)
            end
        end
    end
    return multiShotParams
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_MULTI_SHOT_PARAMS, EvaluateMultiShotParams)
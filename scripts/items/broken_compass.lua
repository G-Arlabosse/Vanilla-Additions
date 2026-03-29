local broken_compass = Isaac.GetItemIdByName("Broken Compass")
local TELEPORT_CHANCE = 0.5
local ADDITIONAL_PICKUP_CHANCE = 0.33
local pickups = {
    {variant = PickupVariant.PICKUP_COIN, subtype = 0},
    {variant = PickupVariant.PICKUP_KEY, subtype = 0},
    {variant = PickupVariant.PICKUP_BOMB, subtype = 0},
    {variant = PickupVariant.PICKUP_HEART, subtype = 0},
}

local function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(broken_compass) and
            not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) and 
            Game():GetLevel():GetAbsoluteStage()%2 ~= 0 then 
        curses = curses | LevelCurse.CURSE_OF_LABYRINTH
    end
    return curses
end

local function OnRoomClear()
    if PlayerManager.AnyoneHasCollectible(broken_compass) then
        local level = Game():GetLevel()

        -- Check if on Home stage
        if level:GetAbsoluteStage() == LevelStage.STAGE8 then return end

        local room = Game():GetRoom()
        local seed = room:GetSpawnSeed()
        local rng = RNG(seed, 35)

        if rng:RandomFloat() < ADDITIONAL_PICKUP_CHANCE then
            local choice = pickups[rng:RandomInt(#pickups)+1]
            local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                choice.variant,
                choice.subtype,
                pos,
                Vector(0,0),
                nil
            )
        end

        if rng:RandomFloat() < TELEPORT_CHANCE then
            local index = level:GetRandomRoomIndex(false, seed)
            Game():StartRoomTransition(
                index,
                Direction.NO_DIRECTION,
                RoomTransitionAnim.TELEPORT
            )
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, OnRoomClear)

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
local cursed_floors = Isaac.GetItemIdByName("Cursed Floors")
local TELEPORT_CHANCE = 0.5
local ADDITIONAL_PICKUP_CHANCE = 0.33
local rewarded = false
local pickups = {
    {variant = PickupVariant.PICKUP_COIN, subtype = 0},
    {variant = PickupVariant.PICKUP_KEY, subtype = 0},
    {variant = PickupVariant.PICKUP_BOMB, subtype = 0},
    {variant = PickupVariant.PICKUP_HEART, subtype = 0},
}

local function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(cursed_floors) and
        not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        curses = curses | LevelCurse.CURSE_OF_LABYRINTH
    end
    return curses
end






local function OnRoomClear()
    print(rewarded)
    if rewarded then return end
    rewarded = true
    
    if PlayerManager.AnyoneHasCollectible(cursed_floors) then
        local level = Game():GetLevel()
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
            print("spawn")
        end

        if rng:RandomFloat() < TELEPORT_CHANCE then
            print("TP!")

            local index = level:GetRandomRoomIndex(false, seed)

            -- REPENTOGON: load custom room directly
            Game():StartRoomTransition(
                index,
                Direction.NO_DIRECTION,
                RoomTransitionAnim.TELEPORT
            )
        end
    end
end

local function PostNewRoom()
    print("Change reward")
    rewarded = false
end

Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, OnRoomClear)
Mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
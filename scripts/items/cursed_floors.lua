local cursed_floors = Isaac.GetItemIdByName("Cursed Floors")
local SpecialRooms = {}

-- Chance to replace a normal room
local replace_chance = 0
local MIN_LUCK = -5
local MAX_LUCK = 15
local MIN_RC = 0.3 -- 30%
local MAX_RC = 0.8 -- 80 %

local SPECIAL_ROOMS = {
    [RoomType.ROOM_SHOP] = 7,
    [RoomType.ROOM_TREASURE] = 7,
    
    --[RoomType.ROOM_SECRET] = 5,
    [RoomType.ROOM_CURSE] = 4,

    --[RoomType.ROOM_SUPERSECRET] = 3,
    [RoomType.ROOM_ARCADE] = 3,

    [RoomType.ROOM_CHEST] = 2,
    [RoomType.ROOM_DICE] = 2,
    [RoomType.ROOM_LIBRARY] = 2,
    [RoomType.ROOM_DEVIL] = 2,
    [RoomType.ROOM_ANGEL] = 2,

    [RoomType.ROOM_ISAACS] = 1,
    [RoomType.ROOM_BARREN] = 1,
    [RoomType.ROOM_PLANETARIUM] = 1,
    --[RoomType.ROOM_ULTRASECRET] = 1
}

local TOTAL_SPECIAL_ROOMS_WEIGHT = 0
for roomType, weight in pairs(SPECIAL_ROOMS) do
    TOTAL_SPECIAL_ROOMS_WEIGHT = TOTAL_SPECIAL_ROOMS_WEIGHT + weight
end



local function getRandomSpecialRoom(rng)
    local value = rng:RandomInt(TOTAL_SPECIAL_ROOMS_WEIGHT)+1
    -- Change math.random to a seeded random later ?

    local weightIndex = 0
    for room, weight in pairs(SPECIAL_ROOMS) do
        weightIndex = weightIndex + weight
        if weightIndex >= value then
            return room
        end 
    end
    return RoomType.ROOM_DEFAULT
end

-- Show Secret rooms on the map
-- Open Secret rooms fully
function PreLevelPlaceRoom(
    slot,       ---@param slot LevelGeneratorRoom 
    oldConfig,  ---@param oldConfig RoomConfigRoom
    seed        
)
    if PlayerManager.AnyoneHasCollectible(cursed_floors) then
        local rng = RNG()
        rng:SetSeed(seed)
        if oldConfig.Type == RoomType.ROOM_DEFAULT and slot:GenerationIndex() ~= 0 then
            if rng:RandomFloat() < replace_chance then                    
                local level = Game():GetLevel()
                -- pick a special room config
                local randomRoomType = getRandomSpecialRoom(rng)

                local config = RoomConfig.GetRandomRoom(
                    seed,                   -- Seed
                    true,                   -- ReduceWeight
                    0,                      -- Stage
                    randomRoomType,         -- Type
                    oldConfig.Shape,
                    0,                      -- MinVariant
                    6                       -- MaxVariant
                )
                
                if config then 
                    -- Convert Colum,Row to GetRoomByIdx(index)
                    local index =  slot:Column() + 13*slot:Row()
                    SpecialRooms[index] = true
                    return config
                end

            end
        end
    end
end

local bool function RoomNeedsToBeOpened(roomIdx)
    local level = Game():GetLevel()
    for index, _ in pairs(SpecialRooms) do
        if roomIdx==index then
            return true
        end
    end
    return false
end

function PostNewRoom()
    local game = Game()
    -- Room Isaac just Got in
    local room = game:GetRoom()
    local roomDescriptor = game:GetLevel():GetCurrentRoomDesc()

    local isSecret = roomDescriptor.Data.Type == RoomType.ROOM_SECRET|RoomType.ROOM_SUPERSECRET|RoomType.ROOM_ULTRASECRET
    for doorSlot, neighborDesc in pairs(roomDescriptor:GetNeighboringRooms()) do
        if RoomNeedsToBeOpened(neighborDesc.GridIndex)
        then
            room:GetDoor(doorSlot):SetLocked(false)
        end
    end
end

function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(cursed_floors) then
        curses = curses | LevelCurse.CURSE_OF_THE_CURSED
    end
    return curses
end

function PreInitLevel()
    --- Compute Replace Chance
    local luck = 0
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        luck = luck + player.Luck
    end

    luck = math.min(MAX_LUCK, math.max(MIN_LUCK, luck))
    replace_chance = MIN_RC + (MAX_RC-MIN_RC)*(luck-MIN_LUCK)/(MAX_LUCK-MIN_LUCK)
end


Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, PreLevelPlaceRoom)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, PreInitLevel)

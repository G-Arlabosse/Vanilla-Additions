local game = Game()

-- Chance to replace a normal room
local REPLACE_CHANCE = 0.5 -- 50%
local cursed_floors = Isaac.GetItemIdByName("Cursed Floors")
local LibraryRooms = {}

local SPECIAL_ROOMS = {
    [RoomType.ROOM_SHOP] = 10,
    [RoomType.ROOM_TREASURE] = 10,
    
    --[RoomType.ROOM_SECRET] = 5,
    [RoomType.ROOM_CURSE] = 5,

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
--local TOTAL_SPECIAL_ROOMS_WEIGHT = 20+10+6+10+4
local TOTAL_SPECIAL_ROOMS_WEIGHT = 20+5+3+10+3

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
function Mod:ReplaceRoomsFloorGen(
    slot,       ---@param slot LevelGeneratorRoom 
    oldConfig,  ---@param oldConfig RoomConfigRoom
    seed        
)
    local rng = RNG()
    rng:SetSeed(seed)

    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if player:GetCollectibleNum(cursed_floors) >= 1 then

            if oldConfig.Type == RoomType.ROOM_DEFAULT and slot:GenerationIndex() ~= 0 then
                if rng:RandomFloat() < REPLACE_CHANCE then                    
                    local level = Game():GetLevel()
                    -- pick a special room config
                    local randomRoomType = getRandomSpecialRoom(rng)

                    local config = RoomConfig.GetRandomRoom(
                        seed,                   -- Seed
                        true,                  -- ReduceWeight
                        0,                      -- Stage
                        randomRoomType,         -- Type
                        oldConfig.Shape         -- Shape
                    )
                    if config then 
                        -- Convert Colum,Row to GetRoomByIdx(index)
                        local index =  slot:Column() + 13*slot:Row()
                        LibraryRooms[index] = true
                        return config
                    end
                end
            end

        end
    end
end

local bool function RoomNeedsToBeOpened(roomIdx)
    local level = game:GetLevel()
    for index, _ in pairs(LibraryRooms) do
        if roomIdx==index then
            -- LibraryRooms[index] = nil
            return true
        end
    end
    return false
end

function Mod:UnlockSpecialRooms ()
    -- Room Isaac just Got in
    local room = game:GetRoom()
    -- RoomDescriptor --
    local roomDescriptor = game:GetLevel():GetCurrentRoomDesc()

    local isSecret = roomDescriptor.Data.Type == RoomType.ROOM_SECRET|RoomType.ROOM_SUPERSECRET|RoomType.ROOM_ULTRASECRET
    for doorSlot, neighborDesc in pairs(roomDescriptor:GetNeighboringRooms()) do
        if RoomNeedsToBeOpened(neighborDesc.GridIndex)
        then
            print(roomDescriptor.Data.Type)
            print(room)
            room:GetDoor(doorSlot):SetLocked(false)
        end
    end
end

function Mod:AddCurse (levelGenerator)
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if player:GetCollectibleNum(cursed_floors) >= 1 then
            game:GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_CURSED, false)
            return
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, Mod.ReplaceRoomsFloorGen)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.UnlockSpecialRooms)
Mod:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, Mod.AddCurse)

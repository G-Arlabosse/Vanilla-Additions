local SpecialRooms = {}

-- Chance to replace a normal room
local replace_chance = 0
local MIN_LUCK = -5
local MAX_LUCK = 15
local MIN_RC = 0.3 -- 30%
local MAX_RC = 0.8 -- 80 %

local SPECIAL_ROOMS = {
    {type = RoomType.ROOM_SHOP,         weight = 19,   minVariant = 0,     maxVariant = 6}, -- 90% of Shops
    {type = RoomType.ROOM_SHOP,         weight = 2,    minVariant = 14,    maxVariant = 17}, 
    {type = RoomType.ROOM_TREASURE,     weight = 21,   minVariant = -1,    maxVariant = -1},
    {type = RoomType.ROOM_CURSE,        weight = 12,   minVariant = 0,     maxVariant = 30}, --Or 31-40 with Voodoo Head ?
    {type = RoomType.ROOM_ARCADE,       weight = 9,    minVariant = 0,     maxVariant = 40}, --Or 41-51 with Cain Birthright ?
    {type = RoomType.ROOM_CHEST,        weight = 6,    minVariant = -1,    maxVariant = -1},
    {type = RoomType.ROOM_DICE,         weight = 6,    minVariant = -1,    maxVariant = -1},
    {type = RoomType.ROOM_LIBRARY,      weight = 6,    minVariant = -1,    maxVariant = -1},
    {type = RoomType.ROOM_DEVIL,        weight = 5,    minVariant = 0,     maxVariant = 24}, --Or 25-36 with Number Magnet
    {type = RoomType.ROOM_ANGEL,        weight = 5,    minVariant = 0,     maxVariant = 21},
    {type = RoomType.ROOM_ISAACS,       weight = 3,    minVariant = -1,    maxVariant = 29},
    {type = RoomType.ROOM_BARREN,       weight = 3,    minVariant = -1,    maxVariant = -1},
    {type = RoomType.ROOM_PLANETARIUM,  weight = 3,    minVariant = -1,    maxVariant = -1},

    --[RoomType.ROOM_ULTRASECRET] = 1
    --[RoomType.ROOM_SECRET] = 5,
    --[RoomType.ROOM_SUPERSECRET] = 3,
}

local TOTAL_SPECIAL_ROOMS_WEIGHT = 0
for i, data in pairs(SPECIAL_ROOMS) do
    TOTAL_SPECIAL_ROOMS_WEIGHT = TOTAL_SPECIAL_ROOMS_WEIGHT + data.weight
end


local function getRandomSpecialRoom(rng)
    local value = rng:RandomInt(TOTAL_SPECIAL_ROOMS_WEIGHT)+1

    local weightIndex = 0
    for i, data in pairs(SPECIAL_ROOMS) do
        weightIndex = weightIndex + data.weight
        if weightIndex >= value then
            return data
        end 
    end
    return nil
end

function PreLevelPlaceRoom(_,
    slot,       ---@param slot LevelGeneratorRoom 
    oldConfig,  ---@param oldConfig RoomConfigRoom
    seed        
)
    if PlayerManager.AnyoneHasCollectible(OMINOUS_DOOR_ID) then
        local rng = RNG(seed, 35)

        if oldConfig.Type == RoomType.ROOM_DEFAULT and slot:GenerationIndex() ~= 0 then
            if rng:RandomFloat() < replace_chance then                    
                local level = Game():GetLevel()
                -- pick a special room config
                local randomData = getRandomSpecialRoom(rng)
                if not randomData then return end

                local config = RoomConfig.GetRandomRoom(
                    seed,                   
                    true,                   
                    0,                      
                    randomData.type,         
                    oldConfig.Shape,
                    randomData.minVariant,
                    randomData.maxVariant,
                    0,
                    10,
                    oldConfig.Doors
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
 
    for doorSlot, neighborDesc in pairs(roomDescriptor:GetNeighboringRooms()) do
        if RoomNeedsToBeOpened(neighborDesc.GridIndex)
        then
            room:GetDoor(doorSlot):SetLocked(false)
        end
    end
end

function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(OMINOUS_DOOR_ID) and not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        curses = curses | LevelCurse.CURSE_OF_THE_CURSED
    end
    return curses
end

function PreInitLevel()
    SpecialRooms = {}

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

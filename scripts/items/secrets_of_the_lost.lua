local secrets_of_the_lost = Isaac.GetItemIdByName("Secrets of the Lost")

local ROOM_QUALITY = {
    BAD = 0.1,
    OK = 0.25,
    GOOD = 0.5,
    VERY_GOOD = 1
}

local ROOM_WEIGHS = {
    secret = {
        TOTAL_WEIGHT = 0,
        WEIGHTS = {
            --- BAD --- 0.1
            [1] = ROOM_QUALITY.BAD, -- 3 coins
            [8] = ROOM_QUALITY.BAD, -- 3 coins
            [4] = ROOM_QUALITY.BAD, -- 1 Slot Machine
            [6] = ROOM_QUALITY.BAD,  -- 1 chest
            [36] = ROOM_QUALITY.BAD, -- 1 chest
            [10] = ROOM_QUALITY.BAD, -- 1 lil' battery
            [11] = ROOM_QUALITY.BAD, -- 2 keys
            [16] = ROOM_QUALITY.BAD, -- 2 fire, 1 poop
            [17] = ROOM_QUALITY.BAD, -- 2 buttons
            [27] = ROOM_QUALITY.BAD, -- 2 buttons
            [20] = ROOM_QUALITY.BAD, -- 2 fire, 1 button
            [24] = ROOM_QUALITY.BAD, -- 10 bushroooms

            --- OK --- 0.25
            [2] = ROOM_QUALITY.OK, -- 6 coins
            [5] = ROOM_QUALITY.OK, -- 3 random Pickups
            [7] = ROOM_QUALITY.OK, -- 3 pills
            [9] = ROOM_QUALITY.OK, -- 3 bombs
            [12] = ROOM_QUALITY.OK, -- 2 bombs, 4 keepers
            [13] = ROOM_QUALITY.OK, -- 1 key, 1 key master
            [14] = ROOM_QUALITY.OK, -- 1 golden poop, 3 keepers
            [15] = ROOM_QUALITY.OK, -- double bomb
            [22] = ROOM_QUALITY.OK, -- 1 nickel, 2 fire, 3 keeper
            [25] = ROOM_QUALITY.OK, -- 2 bags
            [26] = ROOM_QUALITY.OK, -- 1 Troll bomb, 6 mushrooms
            [30] = ROOM_QUALITY.OK, -- 1 Mega Battery
            [32] = ROOM_QUALITY.OK, -- 5 coins, 10 mushrooms
            [33] = ROOM_QUALITY.OK, -- 1 card
            [35] = ROOM_QUALITY.OK, -- 3 coins, 1 chest, 1 golden chest
            [37] = ROOM_QUALITY.OK, -- 3 coins, 1 rotten beggar
            [38] = ROOM_QUALITY.OK, -- 1 wooden chest

            --- GOOD --- 0.5
            [3] = ROOM_QUALITY.GOOD, -- 9 coins
            [18] = ROOM_QUALITY.GOOD, -- 4 random pickups, 4 spiders
            [21] = ROOM_QUALITY.GOOD, -- 2 random (good) shit
            [29] = ROOM_QUALITY.GOOD, -- 1 item (flight)
            [31] = ROOM_QUALITY.GOOD, -- 1 rainbow poop, 3 keepers

            --- VERY GOOD --- 1
            [0] = ROOM_QUALITY.VERY_GOOD, -- 1 item
            [19] = ROOM_QUALITY.VERY_GOOD, -- 1 item, 4 keepers
            [23] = ROOM_QUALITY.VERY_GOOD, -- 1 restock machine, 1 bag
            [28] = ROOM_QUALITY.VERY_GOOD, -- 1 item, 2 chests
            [34] = ROOM_QUALITY.VERY_GOOD, -- 1 item, 2 keepers
        }
    },

    super_secret = {
        TOTAL_WEIGHT = 0,
        WEIGHTS = {
            --- BAD --- 0.1
            [2] = ROOM_QUALITY.BAD, -- 1 red chest
            [3] = ROOM_QUALITY.BAD, -- 1 fortune machine
            [4] = ROOM_QUALITY.BAD, -- 1 trinket
            [9] = ROOM_QUALITY.BAD, -- 1 black poop
            [22] = ROOM_QUALITY.BAD, -- 4 gapers
            [29] = ROOM_QUALITY.BAD, -- 1 golden battery

            --- OK --- 0.25
            [0] = ROOM_QUALITY.OK, -- 8 red hearts (force)
            [11] = ROOM_QUALITY.OK, -- 6 red hearts
            [5] = ROOM_QUALITY.OK, -- 5 pills
            [14] = ROOM_QUALITY.OK, -- 1 beggar, 1 blood donation
            [27] = ROOM_QUALITY.OK, -- 1 beggar, 1 blood donation
            [18] = ROOM_QUALITY.OK, -- 2 fortune, 3 slot machines
            [20] = ROOM_QUALITY.OK, -- 3 coins, 1 battery bum
            [21] = ROOM_QUALITY.OK, -- 4 bombbs, 1 bomb bum
            [23] = ROOM_QUALITY.OK, -- 3 rotten hearts (force)
            [24] = ROOM_QUALITY.OK, -- 5 micro battery, 1 random battery
            [25] = ROOM_QUALITY.OK, -- 1 golden key (83%) or bomb (17%)
            [28] = ROOM_QUALITY.OK, -- 2 black sacks
            [32] = ROOM_QUALITY.OK, -- 1 confessional

            --- GOOD --- 0.5
            [6] = ROOM_QUALITY.GOOD, -- 1 black heart (force)
            [8] = ROOM_QUALITY.GOOD, -- 2 bomb chests, fires..
            [10] = ROOM_QUALITY.GOOD, -- 1 mob, many randoms pickups
            [15] = ROOM_QUALITY.GOOD, -- many hearts (red/soul)
            [17] = ROOM_QUALITY.GOOD, -- 6 red chests
            [19] = ROOM_QUALITY.GOOD, -- 9 pills
            [26] = ROOM_QUALITY.GOOD, -- 1 GIGA bomb
            [30] = ROOM_QUALITY.GOOD, -- Mega chest, 2 keys
            [31] = ROOM_QUALITY.GOOD, -- 2 wooden chests

            --- VERY GOOD --- 1
            [1] = ROOM_QUALITY.VERY_GOOD, -- 1 eternal (force)
            [7] = ROOM_QUALITY.VERY_GOOD, -- 5 runes [clear reward]
            [12] = ROOM_QUALITY.VERY_GOOD, -- 1 angel, 3 souls hearts (force)
            [13] = ROOM_QUALITY.VERY_GOOD, -- 2 mobs, 3 black hearts (force)
            [16] = ROOM_QUALITY.VERY_GOOD, -- 1 rainbow poop, 2 eternal (force)
        }
    },

    ultra_secret = {
        TOTAL_WEIGHT = 0,
        WEIGHTS = {
            --- BAD ---
            [7] = ROOM_QUALITY.BAD, -- 14 keys

            --- OK ---
            [3] = ROOM_QUALITY.OK, -- NO FLY => KEY
            [4] = ROOM_QUALITY.OK, -- NO FLY => BOMB
            [5] = ROOM_QUALITY.OK, -- 4 Gapers

            --- GOOD ---
            [0] = ROOM_QUALITY.GOOD, -- 2 keys
            [1] = ROOM_QUALITY.GOOD, 
            [2] = ROOM_QUALITY.GOOD,
            [8] = ROOM_QUALITY.GOOD,

            --- VERY_GOOD ---
            [6] = ROOM_QUALITY.VERY_GOOD, -- 2 items
        }
    }
}

table.sum = function (list)
    local acc = 0
    for k, v in ipairs(list) do
        acc = acc + v
    end
    return acc
end
    


for k, room in pairs(ROOM_WEIGHS) do
    room.TOTAL_WEIGHT = table.sum(room.WEIGHTS)
end


local function PickupItem(_,
    type, ---@param type CollectibleType
    charge, ---@param charge integer
    firstTime, ---@param firstTime boolean
    slot, ---@param slot integer
    data, ---@param data integer
    player ---@param player EntityPlayer
)
    
end

local function PickRandomVariant(
    room_variants,
    seed
) 
    local rng = RNG(seed, 35)
    local r = rng:RandomFloat() * room_variants.TOTAL_WEIGHT
    local acc = 0
    for variant, weight in pairs(room_variants.WEIGHTS) do
        acc = acc + weight
        if r < acc then return variant end
    end
    print('Error')
end

local function PickRandomVariantTest(
    room_variants
) 
    local r = math.random() * room_variants.TOTAL_WEIGHT
    local acc = 0
    for variant, weight in pairs(room_variants.WEIGHTS) do
        acc = acc + weight
        if r < acc then return variant end
    end
    print('Error')
end

local function ReplaceRoom(_,
    slot,       ---@param slot LevelGeneratorRoom 
    roomConfig, ---@param roomConfig RoomConfigRoom
    seed        ---@param seed integer
)
    if Mod:PlayersHaveItem(secrets_of_the_lost) then
        if roomConfig.Type == RoomType.ROOM_SECRET then
            local variant = PickRandomVariant(ROOM_WEIGHS.secret, seed)
            local room = RoomConfig.GetRoomByStageTypeAndVariant(0, roomConfig.Type, variant)
            return room
        elseif roomConfig.Type == RoomType.ROOM_SUPERSECRET then
            local variant = PickRandomVariant(ROOM_WEIGHS.super_secret, seed)
            local room = RoomConfig.GetRoomByStageTypeAndVariant(0, roomConfig.Type, variant)
            return room
        elseif roomConfig.Type == RoomType.ROOM_ULTRASECRET then
            local variant = PickRandomVariant(ROOM_WEIGHS.ultra_secret, seed)
            local room = RoomConfig.GetRoomByStageTypeAndVariant(0, roomConfig.Type, variant)
            return room
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PickupItem)
Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, ReplaceRoom)

local result = {
    [ROOM_QUALITY.BAD] = 0,
    [ROOM_QUALITY.OK] = 0,
    [ROOM_QUALITY.GOOD] = 0,
    [ROOM_QUALITY.VERY_GOOD] = 0
}

local N = 10000
local room = ROOM_WEIGHS.ultra_secret

for i=1, N do
    local variant = PickRandomVariantTest(room)
    local weight = room.WEIGHTS[variant]
    result[weight] = result[weight] + 1 
end
print("BAD: "       .. result[ROOM_QUALITY.BAD]         .. " (" .. 100*result[ROOM_QUALITY.BAD]/N       .. "%)" ..
    "\nOK: "        .. result[ROOM_QUALITY.OK]          .. " (" .. 100*result[ROOM_QUALITY.OK]/N        .. "%)" ..
    "\nGOOD: "      .. result[ROOM_QUALITY.GOOD]        .. " (" .. 100*result[ROOM_QUALITY.GOOD]/N      .. "%)" ..
    "\nVERY_GOOD: " .. result[ROOM_QUALITY.VERY_GOOD]   .. " (" .. 100*result[ROOM_QUALITY.VERY_GOOD]/N .. "%)"
)
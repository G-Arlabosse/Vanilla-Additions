local blind_floors = Isaac.GetItemIdByName("Blind Floors")

local function OnNewLevel ()
    print("NEW LEVEL")
    if Mod:PlayersHaveItem(blind_floors) then
        local level = Game():GetLevel()
        level:AddCurse(LevelCurse.CURSE_OF_BLIND, false) 
        
        for i=0, Game():GetNumPlayers()-1 do
            local player = Game():GetPlayer(i)
            print("Player:"..i)
            for i,j in pairs(player:GetCollectiblesList()) do
                if j>0 then
                    print(i,j)
                end
            end
        end
    end
    print("END LEVEL")
end

local function AddCollectible(_,
    type,       ---@param type CollectibleType
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)
    if type == blind_floors then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_BLIND, true)
    end
end


local function GetRandomCollectibleByQuality(
    quality,    ---@param quality integer
    item_pool,  ---@param item_pool ItemPoolType
    rng         ---@param rng RNG
)
    local itemConfig = Isaac.GetItemConfig()
    local validItems = {}
    for i,j in pairs(Game():GetItemPool():GetCollectiblesFromPool(item_pool)) do
        local item = itemConfig:GetCollectible(j.itemID)

        if item and item.Quality == quality then
            validItems[#validItems+1] = item.ID
        end
    end

    if #validItems > 0 then
        return validItems[rng:RandomInt(#validItems)+1]
    end

    return nil
end

local function GeneratePedestal (_,
    type,       ---@param type CollectibleType 
    item_pool,  ---@param item_pool ItemPoolType
    decrease,   ---@param decrease boolean
    seed        ---@param seed integer
)
    local itemConfig = Isaac.GetItemConfig()
    local item = itemConfig:GetCollectible(type)
    local quality = item.Quality

    local rng = RNG(seed, 35)
    local r = rng:RandomFloat()

    print("Quality before:".. quality.. ", randomfloat=".. r)
    if quality == 4 and r < 0.9 then
        quality = rng:RandomInt(4)
        print("Rerolled quality 4 into quality ".. quality)
        return GetRandomCollectibleByQuality(quality, item_pool, rng)
    elseif quality == 3 and r < 0.5 then
        quality = rng:RandomInt(3)
        print("Rerolled quality 3 into quality ".. quality)
        return GetRandomCollectibleByQuality(quality, item_pool, rng)
    elseif quality == 2 and r < 0.1 then
        quality = rng:RandomInt(2)
        print("Rerolled quality 2 into quality ".. quality)
        return GetRandomCollectibleByQuality(quality, item_pool, rng)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnNewLevel)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
Mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, GeneratePedestal)
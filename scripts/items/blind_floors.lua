local blind_floors = Isaac.GetItemIdByName("Blind Floors")

local function OnNewLevel ()
    if Mod:PlayersHaveItem(blind_floors) then
        local level = Game():GetLevel()
        level:AddCurse(LevelCurse.CURSE_OF_BLIND, false) 
    end
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

local function GeneratePedestal (_,
    type,       ---@param type CollectibleType 
    item_pool,  ---@param item_pool ItemPoolType
    decrease,   ---@param decrease boolean
    seed        ---@param seed integer
)
    return 1
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnNewLevel)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
Mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, GeneratePedestal)
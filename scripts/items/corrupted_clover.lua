local UPGRADE_TYPE = {
    ANY = 0,
    PASSIVE_OR_FAMILIAR = 1,
    ACTIVE = 2
}

local UPGRADE_CHANCE = 0.1
local QUALITY_4_DOWNGRADE_CHANCE = 1
local QUALITY_3_DOWNGRADE_CHANCE = 0.66
local QUALITY_2_DOWNGRADE_CHANCE = 0

local corrupted_clover = Isaac.GetItemIdByName("Corrupted Clover")
local itemConfig = Isaac.GetItemConfig()
local tracked_item_pools = {}

local function GetRandomCollectibleByQuality(
    quality,    ---@param quality integer
    item_pool,  ---@param item_pool ItemPoolType
    rng,        ---@param rng RNG
    upgrade_type
)
    local itemConfig = Isaac.GetItemConfig()

    local validItems = {}
    for _,item_data in pairs(Game():GetItemPool():GetCollectiblesFromPool(item_pool)) do
        local item = itemConfig:GetCollectible(item_data.itemID)

        if (item and item.Quality == quality and item.Tags and not (item.Tags & ItemConfig.TAG_QUEST == ItemConfig.TAG_QUEST)) then
            if upgrade_type == UPGRADE_TYPE.ANY or
                ( upgrade_type == UPGRADE_TYPE.PASSIVE_OR_FAMILIAR and (item.Type == ItemType.ITEM_FAMILIAR or item.Type == ItemType.ITEM_PASSIVE) ) or 
                ( upgrade_type == UPGRADE_TYPE.ACTIVE and item.Type == ItemType.ITEM_ACTIVE ) then
                    validItems[#validItems+1] = item.ID
            end
        end
    end
    if #validItems > 0 then
        return validItems[rng:RandomInt(#validItems)+1]
    end
    return nil
end

local function TryUpgradeItem (
    id,         ---@param id integer
    rng,        ---@param rng RNG
    player      ---@param player EntityPlayer
)
    if rng:RandomFloat() < UPGRADE_CHANCE then
        local item_data = itemConfig:GetCollectible(id)
        local item_pool = tracked_item_pools[id]
        if not item_pool or (item_data.Tags & ItemConfig.TAG_NO_EDEN == ItemConfig.TAG_NO_EDEN) then return end
        local new_id
        -- Passive Items --
        if item_data.Type == ItemType.ITEM_PASSIVE or item_data.Type == ItemType.ITEM_FAMILIAR then 
            new_id = GetRandomCollectibleByQuality(item_data.Quality+1, item_pool, rng, UPGRADE_TYPE.PASSIVE_OR_FAMILIAR)
        -- Active Items --
        elseif item_data.Type == ItemType.ITEM_ACTIVE then             
            new_id = GetRandomCollectibleByQuality(item_data.Quality+1, item_pool, rng, UPGRADE_TYPE.ACTIVE)
        else 
            print("Previous:".. item_data.Name .. ", Item pool:" .. item_pool .. ", Item type:" .. item_data.Type)
        end

        -- Upgraded --
        if new_id then
            tracked_item_pools[new_id] = item_pool
            player:RemoveCollectible(id)
            player:AddCollectible(new_id)
        end
    end
end


local function OnNewLevel ()
    if Mod:PlayersHaveItem(corrupted_clover) then
        local level = Game():GetLevel()
        local rng = RNG(Game():GetSeeds():GetStageSeed(level:GetStage()), 35)

        for i=0, Game():GetNumPlayers()-1 do
            local player = Game():GetPlayer(i)
            local player_collectibles = player:GetCollectiblesList()
            for id,nb in pairs(player_collectibles) do
                for j=1, nb do
                    TryUpgradeItem(id, rng, player)
                end
            end
        end
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
    if type == corrupted_clover then
        if not Mod:PlayersHaveItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
            Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_BLIND, false)
        end
    else
        local item_pool = Game():GetItemPool():GetLastPool()
        tracked_item_pools[type] = item_pool
    end
end

local function GeneratePedestal (_,
    type,       ---@param type CollectibleType 
    item_pool,  ---@param item_pool ItemPoolType
    decrease,   ---@param decrease boolean
    seed        ---@param seed integer
)
    if Mod:PlayersHaveItem(corrupted_clover) then
        local item = itemConfig:GetCollectible(type)
        local quality = item.Quality

        local rng = RNG(seed, 35)
        local r = rng:RandomFloat()

        if quality == 4 and r < QUALITY_4_DOWNGRADE_CHANCE then
            quality = rng:RandomInt(4)
            return GetRandomCollectibleByQuality(quality, item_pool, rng, UPGRADE_TYPE.ANY)
        elseif quality == 3 and r < QUALITY_3_DOWNGRADE_CHANCE then
            quality = rng:RandomInt(3)
            return GetRandomCollectibleByQuality(quality, item_pool, rng, UPGRADE_TYPE.ANY)
        elseif quality == 2 and r < QUALITY_2_DOWNGRADE_CHANCE then
            quality = rng:RandomInt(2)
            return GetRandomCollectibleByQuality(quality, item_pool, rng, UPGRADE_TYPE.ANY)
        end
    end
end

local function PostCurseEval(_, curses)
    if Mod:PlayersHaveItem(corrupted_clover) then
        curses = curses | LevelCurse.CURSE_OF_BLIND
    end
    return curses
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnNewLevel)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCollectible)
Mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, GeneratePedestal)
Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
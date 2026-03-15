local ITEM_ID = Isaac.GetItemIdByName("Life Orb")
local LIFE_ORB_DAMAGE_PER_HEART = 1.0

---@param player EntityPlayer
local function addDamage(_, player, amount, healthType, optionalArg)
    if player:HasCollectible(ITEM_ID) then
        if healthType == AddHealthType.MAX and amount < 0 then
            local containers_lost = math.abs(amount) /2
            local data = player:GetData()
            local item_count = player:GetCollectibleNum(ITEM_ID)
            if data.opikoko_lifeorb_stacks then
                data.opikoko_lifeorb_stacks = data.opikoko_lifeorb_stacks + containers_lost
            else 
                data.opikoko_lifeorb_stacks = containers_lost
            end

            -- Call update for damage
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end

---@param player EntityPlayer
local function calculateDamage(_, player, statStage, value)
    if player:HasCollectible(ITEM_ID) then
        local data = player:GetData()
        local item_count = player:GetCollectibleNum(ITEM_ID)
        if data.opikoko_lifeorb_stacks then
            return value + data.opikoko_lifeorb_stacks * LIFE_ORB_DAMAGE_PER_HEART * item_count
        else 
            return value
        end
    end
end

---@param player EntityPlayer
local function removeHeartOnPickup(_, collectibleType, charge, firstTime, slot, varData, player)
    if not firstTime then return end
    player:AddMaxHearts(-2, true)
end

local function removeHeartOnFloor()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        for j=0, player:GetCollectibleNum(ITEM_ID)-1 do
            if player:GetMaxHearts() >= 2 then
                player:AddMaxHearts(-2, true)
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_HEARTS, addDamage)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, calculateDamage, EvaluateStatStage.DAMAGE_UP)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, removeHeartOnPickup, ITEM_ID)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, removeHeartOnFloor)
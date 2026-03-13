local config = Isaac.GetItemConfig()

local function setHeartCost(item_id, cost) 
    local item_config = config:GetCollectible(item_id)
    if item_config then
        item_config.DevilPrice = cost
    end
end

local function setItemHeartsCost()
    --- Fallen Angel ---
    setHeartCost(Isaac.GetItemIdByName("Fallen Angel"), 2)
    --- Life Orb ---
    setHeartCost(Isaac.GetItemIdByName("Life Orb"), 0)
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, setItemHeartsCost)

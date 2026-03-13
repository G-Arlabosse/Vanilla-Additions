local config = Isaac.GetItemConfig()

function Mod:SetShopItemsCost()
    --- Fallen Angel ---
    local rare_candy_id = Isaac.GetItemIdByName("Fallen Angel")
    local rare_candy_config = config:GetCollectible(rare_candy_id)
    if rare_candy_config then
        rare_candy_config.DevilPrice = 2
        print("Changed Devil Price")
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.SetShopItemsCost)
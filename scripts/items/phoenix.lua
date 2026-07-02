local function preTriggerPlayerDeath(_, player) ---@param player EntityPlayer
    if player:HasCollectible(PHOENIX_ID) and player:GetExtraLives() > 0 then
        player:SetMinDamageCooldown(120)  -- Grant iframes to the player.
        local effectList = player:GetEffects():GetEffectsList()
        for i=0, effectList.Size-1 do
            local effect = effectList:Get(i)
            if effect and effect.Item:HasCustomTag("revive") then
                if effect.Item:IsNull() then
                    player:GetEffects():RemoveNullEffect(Isaac.GetNullItemIdByName(effect.Item.Name))
                    return false
                end
            end
        end
        return true
    end
end

local function postAddCollectible(_,
    type,
    charge,
    firstTime,
    slot,
    varData,
    player  ---@param player EntityPlayer
)
    player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("Phoenix Extra Life"))
end

local function postPlayerRevive(_, player) ---@param player EntityPlayer
    if player:HasCollectible(PHOENIX_ID) then
        player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("Phoenix Boost"), false, 60)
    end
end

local function postPlayerTriggerEffectRemoved(_, 
    player,  ---@param player EntityPlayer
    item, ---@param item ItemConfigItem
    count
)
    print(item.Name, count)
    if item.Name == "Phoenix Boost" then
        player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("Phoenix Boost"), false, count-1)
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, preTriggerPlayerDeath)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddCollectible, PHOENIX_ID)

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, postPlayerRevive)
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, postPlayerTriggerEffectRemoved)

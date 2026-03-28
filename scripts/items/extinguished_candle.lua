local extinguished_candle = Isaac.GetItemIdByName("Extinguished Candle")

local function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(extinguished_candle) and
            not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        curses = curses | LevelCurse.CURSE_OF_DARKNESS
    end
    return curses
end

local function AddExtinguishedCandle(_,
    type,       ---@param type CollectibleType 
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)     
    if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_DARKNESS, false)
    end
end

local npc_colors = {}

---@param npc EntityNPC
local function NpcUpdate(_, npc)
    if not PlayerManager.AnyoneHasCollectible(extinguished_candle) then return end
    if not npc:IsActiveEnemy(false) then return end

    -- Store original color once
    if not npc_colors[npc.Index] then
        local c = npc:GetColor()
        npc_colors[npc.Index] = Color(c.R, c.G, c.B, c.A, c.RO, c.GO, c.BO)
    end

    local base_color = npc_colors[npc.Index]

    -- Find closest player with item
    local closestDist = math.huge
    local closestPlayer = nil

    
    for _, player in pairs(PlayerManager.GetPlayers()) do ---@param player EntityPlayer
        if player:HasCollectible(extinguished_candle) then 
            local dist = player.Position:Distance(npc.Position)
            if dist < closestDist then
                closestDist = dist
                closestPlayer = player
            end
        end
    end

    -- If no valid player, reset color and exit
    if not closestPlayer then
        return
    end
    print("not return")

    -- Compute alpha based on distance
    local alpha = -closestDist * 0.8 / 100 + 2.2
    alpha = math.min(alpha, 1)
    alpha = math.max(alpha, 0)
    if alpha < 0.05 then
        npc.Visible = false
    else
        npc.Visible = true
    end

    -- Create fresh color (IMPORTANT: no mutation)
    local new_color = Color(
        base_color.R,
        base_color.G,
        base_color.B,
        alpha,
        base_color.RO,
        base_color.GO,
        base_color.BO
    )
    
    -- Apply slowing if close
    if closestDist < 200 then
        new_color = Color(
            base_color.R,
            base_color.G,
            base_color.B,
            alpha,
            0.1,
            -0.1,
            0.1
        )
        if npc:GetSlowingCountdown() == 0 then
            npc:AddSlowing(
                EntityRef(closestPlayer),
                5,
                0,
                Color(0.7, 0.7, 0.7, 0, 0, 0, 0)
            )
        else
            npc:SetSlowingCountdown(5)
        end
    end

    npc:SetColor(new_color, 5, 0, true, false)
end


local function OnNPCRemove(_, npc)
    npc_colors[npc.Index] = nil
end
local function PostNewRoom()
    npc_colors = {}
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, NpcUpdate)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, OnNPCRemove)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)
Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddExtinguishedCandle, extinguished_candle)
---@param vector Vector
function Mod:Vec2Dir(vector)
    local x = vector.X
    local y = vector.Y
    if x >= 0 then
        if y >= x then return Direction.DOWN
        elseif -y >= x then return Direction.UP
        else return Direction.RIGHT
        end
    else
        if y >= -x then return Direction.DOWN
        elseif -y >= -x then return Direction.UP
        else return Direction.LEFT
        end
    end
end

function Mod:PlayersHaveTrinket (
    trinket    ---@param trinket TrinketType
)
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(trinket) then
            return true
        end
    end
    return false
end
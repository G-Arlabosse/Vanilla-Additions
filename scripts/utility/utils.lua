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

function Mod:toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

function Mod:toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

function Mod:PlayersHaveTrinket (
    trinket,    ---@param trinket TrinketType
    golden     ---@param golden boolean
)
    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if golden then
            if player:HasGoldenTrinket(trinket) then
                return true
            end
        else
            if player:HasTrinket(trinket) then
                return true
            end
        end
    end
    return false
end
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
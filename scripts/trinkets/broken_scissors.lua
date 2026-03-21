local broken_scissors = Isaac.GetTrinketIdByName("Broken Scissors")

local function PostPickupInit(_, 
    pickup  ---@param pickup EntityPickup
)
    if Mod:PlayersHaveTrinket(broken_scissors) then
        if pickup.Variant == PickupVariant.PICKUP_BOMB then
            if pickup.SubType == BombSubType.BOMB_NORMAL then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_BOMB,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    BombSubType.BOMB_TROLL,
                    0
                )
                pickup:Remove()
            elseif pickup.SubType == BombSubType.BOMB_DOUBLEPACK then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_BOMB,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    BombSubType.BOMB_SUPERTROLL,
                    0
                )
                pickup:Remove()
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)
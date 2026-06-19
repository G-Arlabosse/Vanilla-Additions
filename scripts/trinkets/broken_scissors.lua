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
            elseif pickup.SubType == BombSubType.BOMB_GOLDEN then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_BOMB,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    BombSubType.BOMB_GOLDENTROLL,
                    0
                )
                pickup:Remove()
            end
        
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            if pickup.SubType == KeySubType.KEY_NORMAL then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_KEY,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    KeySubType.KEY_CHARGED,
                    0
                )
                pickup:Remove()
            elseif pickup.SubType == KeySubType.KEY_DOUBLEPACK then
                local v = pickup.Velocity
                if v.X == 0 and v.Y == 0 then
                    v = RandomVector()
                    v.X = v.X / 3
                    v.Y = v.Y / 3
                end
                local new_pickup1 = Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,pickup.Position,v,nil,KeySubType.KEY_CHARGED,0)
                local new_pickup2 = Game():Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,pickup.Position,-v,nil,KeySubType.KEY_CHARGED,0)
                pickup:Remove()
            end

        end
    end

    if Mod:PlayersHaveTrinket(broken_scissors + 32768) then
        if pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY then
           if pickup.SubType == BatterySubType.BATTERY_MICRO then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_LIL_BATTERY,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    BatterySubType.BATTERY_NORMAL,
                    0
                )
                pickup:Remove() 
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)
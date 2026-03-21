local mimics_favor = Isaac.GetTrinketIdByName("Mimic's Favor")
local rng = RNG()


local function PostPickupInit(_, 
    pickup  ---@param pickup EntityPickup
)
    if Mod:PlayersHaveTrinket(mimics_favor) then
        if pickup.Variant == PickupVariant.PICKUP_CHEST or
                pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST or
                pickup.Variant == PickupVariant.PICKUP_HAUNTEDCHEST or
                pickup.Variant == PickupVariant.PICKUP_REDCHEST or
                pickup.Variant == PickupVariant.PICKUP_ETERNALCHEST then
            
            local new_pickup = Game():Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_MIMICCHEST,
                pickup.Position,
                pickup.Velocity,
                nil,
                1,
                1
            )
            pickup:Remove()
        
        elseif pickup.Variant == PickupVariant.PICKUP_COIN then
            if pickup.SubType == CoinSubType.COIN_PENNY then
                local new_pickup = Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COIN,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    -1,
                    1
                )
                pickup:Remove()
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PostPickupInit)
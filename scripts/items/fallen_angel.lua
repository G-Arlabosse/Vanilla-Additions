local item_config = Isaac.GetItemConfig()

function GetPedestalsInRoom()
    local pedestals = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        -1,
        false,
        false
    )

    return pedestals
end

function Mod:CheckPedestals(
    pickup ---@param pickup EntityPickup
)
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    if (roomDesc.Type == RoomType.ROOM_ANGEL) or (true) then
        --print(pickup.Variant, variant)
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if pickup.Price >= 0 then
                local item_config = item_config:GetCollectible(pickup.SubType)

                pickup.AutoUpdatePrice = false
                pickup.Price = -item_config.DevilPrice

                print("Price set to 1 heart")
                print("Name:" .. item_config.Name .. 
                ", DevilPrice:" .. item_config.DevilPrice ..
                ", ActualPrice:" .. pickup.Price)
            end
        end
        --local pedestals = GetPedestalsInRoom()
        --print(#pedestals)
        --[[for i=1, #pedestals do
            local pedestal = pedestals[i]:ToPickup()
            if pedestal then
                local item_id = pedestal.SubType
                --print(pedestal.SubType)
                local pedestal_item_config = item_config:GetCollectible(item_id)
                pedestal.Price = -pedestal_item_config.DevilPrice
                print(pedestal_item_config.Name, pedestal_item_config.DevilPrice, pedestal.Price)

            end
        end--]]
    end
end

function Mod:PickupUpdate(
    pickup ---@param pickup EntityPickup
)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        print("Not an Item")
        return
    end
    print("Tries to change ?")
    local data = pickup:GetData()

    -- run once per pedestal state
    if not data.DevilPriced then
        if pickup.Price == 0 and not pickup:IsShopItem() then
            pickup.AutoUpdatePrice = false
            pickup.Price = PickupPrice.PRICE_ONE_HEART
        end

        data.DevilPriced = true
    end
end

--Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Mod.PickupUpdate)

function Mod:PrePickupMorph(pickup, entityType, variant, subtype)
    if variant == PickupVariant.PICKUP_COLLECTIBLE then
        pickup.AutoUpdatePrice = false
        pickup.Price = PickupPrice.PRICE_ONE_HEART
        return true
    else
        return false
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, Mod.PrePickupMorph)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Mod.CheckPedestals, PickupVariant.PICKUP_COLLECTIBLE)

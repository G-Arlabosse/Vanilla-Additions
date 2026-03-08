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

function Mod:CheckPedestals()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    if (roomDesc.Type == RoomType.ROOM_ANGEL) or (true) then
        local pedestals = GetPedestalsInRoom()
        print(#pedestals)
        for i=1, #pedestals do
            local pedestal = pedestals[i]:ToPickup()
            if pedestal then
                local item_id = pedestal.SubType
                --print(pedestal.SubType)
                local pedestal_item_config = item_config:GetCollectible(item_id)
                print(pedestal_item_config.Name, pedestal_item_config.DevilPrice)
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.CheckPedestals)

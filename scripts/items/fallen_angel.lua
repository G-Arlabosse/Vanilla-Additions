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
    print("=== PICKUP ===")
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
    if (roomDesc.Type == RoomType.ROOM_ANGEL) or (true) then
        --print(pickup.Variant, variant)
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local item_config = item_config:GetCollectible(pickup.SubType)

            if pickup.Price >= 0 then

                pickup.AutoUpdatePrice = false
                pickup.Price = -item_config.DevilPrice

                print("Price set to 1 heart")
            end
            print(
                "Variant:" .. pickup.Variant ..
                ", Name:" .. item_config.Name .. 
                ", Id:" .. pickup.SubType ..
                ", DevilPrice:" .. item_config.DevilPrice ..
                ", ActualPrice:" .. pickup.Price
            )
            print(pickup:IsShopItem())
        else
            print("Variant: " .. pickup.Variant)
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
            pickup.Price = -1
        end

        data.DevilPriced = true
    end
end

--Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Mod.PickupUpdate)

function Mod:PrePickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant,    ---@param variant PickupVariant
    subtype
)
    print("=== PRE MORPH ===")
    if entityType == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        print("Yes")
        local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
        if config then

            -- Set Devil price
            pickup.Price = 0
            print(
                "EntityType:" .. entityType ..
                ", Variant" .. pickup.Variant ..
                ", Name:" .. config.Name .. 
                ", Id:" .. pickup.SubType ..
                ", DevilPrice:" .. config.DevilPrice ..
                ", ActualPrice:" .. pickup.Price)
            print(pickup:IsShopItem())
            
        end
    else
        print("Nope")
        return false
    end
end

function Mod:PostPickupMorph(
    pickup,     ---@param pickup EntityPickup
    entityType, ---@param entityType EntityType
    variant    ---@param variant PickupVariant
)
    print("=== POST MORPH ===")
    if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE then
        print("Okay")
        --pickup.Price = PickupPrice.PRICE_FREE
        local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
        if config then
            pickup.Price = -config.DevilPrice
            --pickup.AutoUpdatePrice = false
            -- Set Devil price
            print(
                "EntityType:" .. entityType ..
                ", Variant" .. pickup.Variant ..
                ", Name:" .. config.Name .. 
                ", Id:" .. pickup.SubType ..
                ", DevilPrice:" .. config.DevilPrice ..
                ", ActualPrice:" .. pickup.Price)
            print(pickup:IsShopItem())
        end
    else
        print("NotOkay")
    end
    
end


Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, Mod.PrePickupMorph)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, Mod.PostPickupMorph)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Mod.CheckPedestals)--, PickupVariant.PICKUP_COLLECTIBLE)
-- Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.CheckPedestals)

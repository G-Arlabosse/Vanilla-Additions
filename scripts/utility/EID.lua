if EID then
    local myItemId
    local description

    --- Big Rock ---
    myItemId = Isaac.GetItemIdByName("Big Rock");
    description = 
    [[{{ArrowUp}} +1 Damage
    #{{ArrowUp}} x1.2 Damage multiplier
    #{{ArrowUp}} +0.4 Tears
    #{{ArrowDown}} x0.75 Speed multiplier
    #{{Warning}} Speed is capped at 1.5]]
    EID:addCollectible(myItemId, description)

    --- Calcium ---
    myItemId = Isaac.GetItemIdByName("Calcium");
    description = 
    [[{{Timer}} Receive for the room:
    #{{Blank}} {{ArrowUp}} x5 Fire rate multiplier
    #{{Blank}} {{ArrowDown}} x0.25 Damage multiplier
    #{{Blank}} {{ArrowDown}} -0.3 Tear Size
    #{{Indent}} Drastically reduces knockback]]
    EID:addCollectible(myItemId, description)

    --- Cursed Floors ---
    myItemId = Isaac.GetItemIdByName("Cursed Floors");
    description = 
    [[{{CurseCursed}} Receive Curse of the Cursed at the start of each floor
    #42.5% to reroll a normal small room into a special room
    #{{Luck}} Caps at 80% at 15 luck]]
    EID:addCollectible(myItemId, description)

    --- Rare Candy --- 
    myItemId = Isaac.GetItemIdByName("Rare Candy");
    description = 
    [[{{Timer}} On use:
    #{{Indent}} Completes the transformation Isaac last progressed on.]]
    
    --- Bell Baby ---
    myItemId = Isaac.GetItemIdByName("Bell Baby");
    description = 
    [[#Chases enemies
    #Deals 4.5 damage per second
    #40% chance to dig a treasure from the ground when clearing a room
    #{{Luck}} Caps at 80% at 20 luck]]
    EID:addCollectible(myItemId, description)

    --- Corrupted Clover ---
    myItemId = Isaac.GetItemIdByName("Corrupted Clover");
    description = 
    [[{{CurseBlind}} Receive Curse of the Blind permanently
    #Prevents quality {{Quality4}} items from spawning
    #Quality {{Quality3}} items have a 66% chance to be rerolled
    #At the start of each floor, each of Isaac's item have a 10% chance to be rerolled into an item of the same pool of the above quality]]
    EID:addCollectible(myItemId, description)
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")
end
if EID then
    local myItemId
    local description
--- ITEMS ---
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
    #{{Blank}} {{ArrowUp}} x5.5 Fire rate multiplier
    #{{Blank}} {{ArrowDown}} x0.25 Damage multiplier
    #{{Blank}} {{ArrowDown}} -0.3 Tear Size
    #{{Indent}} Drastically reduces knockback]]
    EID:addCollectible(myItemId, description)
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_SOY_MILK, "Overrides {{ColorYellow}}Soy Milk{{ColorWhite}}'s multipliers")
    --EID:addCondition(CollectibleType.COLLECTIBLE_SOY_MILK, myItemId, "Overridden by {{ColorYellow}}Calcium{{ColorWhite}}")
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_ALMOND_MILK, "Overrides {{ColorYellow}}Almond Milk{{ColorWhite}}'s multipliers")
    --EID:addCondition(CollectibleType.COLLECTIBLE_ALMOND_MILK, myItemId, "Overridden by {{ColorYellow}}Calcium{{ColorWhite}}")

    --- Ominous Door ---
    myItemId = Isaac.GetItemIdByName("Ominous Door");
    description = 
    [[{{CurseCursed}} Receive Curse of the Cursed at the start of each floor
    #42.5% to reroll a normal small room into a special room
    #{{Luck}} Caps at 80% at 15 luck]]
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")
    EID:addCollectible(myItemId, description)

    --- Rare Candy --- 
    myItemId = Isaac.GetItemIdByName("Rare Candy");
    description = 
    [[{{Timer}} On use:
    #{{Indent}} Completes the transformation Isaac last progressed on.]]
    EID:addCollectible(myItemId, description)
    
    --- Bell Baby ---
    myItemId = Isaac.GetItemIdByName("Bell Baby");
    description = 
    [[#Chases enemies
    #Deals 4.5 damage per second
    #40% chance to dig a treasure from the ground when clearing a room
    #{{Luck}} Caps at 80% at 20 luck]]
    EID:addCollectible(myItemId, description)

    --- Life Orb ---
    myItemId = Isaac.GetItemIdByName("Life Orb");
    description = 
    [[#When losing a heart container, recieve permanently:
    #{{ArrowUp}} +1 Damage
    #Lose a heart container on pickup and at the start of every floor]]
    EID:addCollectible(myItemId, description)

    --- Corrupted Clover ---
    myItemId = Isaac.GetItemIdByName("Corrupted Clover");
    description = 
    [[{{CurseBlind}} Receive Curse of the Blind permanently
    #Prevents quality {{Quality4}} items from spawning
    #Quality {{Quality3}} items have a 66% chance to be rerolled
    #At the start of each floor, each of Isaac's items have a 10% chance to be rerolled into an item of the same pool of the above quality]]
    EID:addCollectible(myItemId, description)
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")

    --- Fallen Angel ---
    myItemId = Isaac.GetItemIdByName("Fallen Angel");
    description = 
    [[{{AngelChance}} Converts devil deal chance to angel 
    #Angel room items now cost health
    #Uriel and Gabriel now spawn as their dark version but drop angel items on death]]
    EID:addCollectible(myItemId, description)
    EID:addPlayerCondition(myItemId, PlayerType.PLAYER_KEEPER, "Items cost coins instead", nil, nil, nil, true)
    
    --- Cursed Map ---
    myItemId = Isaac.GetItemIdByName("Cursed Map");
    description = 
    [[#{{CurseMazeSmall}} Receive Curse of the Blind and Curse of the Maze permanently
    #{{UltraSecretRoom}} Secret, Super Secret and Ultra Secret rooms have a higher chance to have good layouts]]
    EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes curses")
    EID:addCollectible(myItemId, description)

    --- Poison Mush ---
    myItemId = Isaac.GetItemIdByName("Poison Mush");
    description = 
    [[{{ArrowUp}} Major Size Down
    #{{BossRoom}} All enemies are in their giant form
    #{{Bomb}} Bombs are turned into Giga Bombs
    #{{Pill}} Pills are turned into Horse Pills
    #{{GoldenChest}} Golden Chests are turned into Giant Chests]]
    EID:addCollectible(myItemId, description)

    --- Broken Compass ---
    myItemId = Isaac.GetItemIdByName("Broken Compass");
    description = 
    [[#{{CurseLabyrinth}} Receive Curse of the Labyrinth permanently
    # Upon Clearing a room:
    #{{Indent}}{{SecretRoom}} 50% chance to teleport in a random room
    #{{Indent}}{{Coin}} 33% chance to spawn an additional pickup as clear reward]]
    --EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes curses")
    EID:addCollectible(myItemId, description)
    
    --- Cursed D6 ---
    myItemId = Isaac.GetItemIdByName("Cursed D6");
    description = 
    [[{{Timer}} On use:
    #{{Collectible105}} Rerolls pedestal items in the room
    #{{CurseDarknessSmall}} Increases the chance to have a curse on the next floor
    #{{Warning}} Can add up to multiple curses]]
    EID:addCollectible(myItemId, description)

--- TRINKETS ---
    local myTrinketId

    --- Broken Scissors ---
    myTrinketId = Isaac.GetTrinketIdByName("Broken Scissors")
    description =
    [[{{Bomb}} Turns all Bombs into Troll Bombs
    #{{Key}} Turns all Keys into Charged Keys]]
    EID:addTrinket(myTrinketId, description)

    --- Mimic's Favor ---
    myTrinketId = Isaac.GetTrinketIdByName("Mimic's Favor")
    description =
    [[{{SpikedChest}} Turns all Chests into Trapped Chests
    #{{Coin}} Better value coins have a higher chance to appear]]
    EID:addTrinket(myTrinketId, description)

end
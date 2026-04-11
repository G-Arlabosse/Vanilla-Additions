local function loadItemsDescriptions()
    if not EID then return end

    local description
    --- Big Rock ---
    description = 
    [[{{ArrowUp}} +1 Damage
    #{{ArrowUp}} x1.2 Damage multiplier
    #{{ArrowUp}} +0.4 Tears
    #{{ArrowDown}} x0.75 Speed multiplier
    #{{Warning}} Speed is capped at 1.5]]
    EID:addCollectible(BIG_ROCK_ID, description)
    EID:addCondition(BIG_ROCK_ID, BIG_ROCK_ID, "The speed down multiplier doesn't stack")

    --- Calcium ---
    description = 
    [[{{Timer}} Receive for the room:
    #{{Blank}} {{ArrowUp}} x5.5 Fire rate multiplier
    #{{Blank}} {{ArrowDown}} x0.25 Damage multiplier
    #{{Blank}} {{ArrowDown}} -0.3 Tear Size
    #{{Indent}} Drastically reduces knockback]]
    EID:addCollectible(CALCIUM_ID, description)
    EID:addCondition(CALCIUM_ID, CollectibleType.COLLECTIBLE_SOY_MILK, "Overrides {{ColorYellow}}Soy Milk{{ColorWhite}}'s multipliers")
    --EID:addCondition(CollectibleType.COLLECTIBLE_SOY_MILK, myItemId, "Overridden by {{ColorYellow}}Calcium{{ColorWhite}}")
    EID:addCondition(CALCIUM_ID, CollectibleType.COLLECTIBLE_ALMOND_MILK, "Overrides {{ColorYellow}}Almond Milk{{ColorWhite}}'s multipliers")
    --EID:addCondition(CollectibleType.COLLECTIBLE_ALMOND_MILK, myItemId, "Overridden by {{ColorYellow}}Calcium{{ColorWhite}}")

    --- Ominous Door ---
    description = 
    [[{{CurseCursed}} Receive Curse of the Cursed at the start of each floor
    #42.5% to reroll a normal small room into a special room
    #{{Luck}} Caps at 80% at 15 luck]]
    EID:addCondition(OMINOUS_DOOR_ID, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")
    EID:addCondition(OMINOUS_DOOR_ID, OMINOUS_DOOR_ID, "No additional effect from multiple copies")
    EID:addCollectible(OMINOUS_DOOR_ID, description)
    

    --- Rare Candy --- 
    description = 
    [[{{Timer}} On use:
    #{{Indent}} Completes the transformation Isaac last progressed on.]]
    EID:addCollectible(RARE_CANDY_ID, description)
    
    --- Bell Baby ---
    description = 
    [[#Chases enemies
    #Deals 4.5 damage per second
    #40% chance to dig a treasure from the ground when clearing a room
    #{{Luck}} Caps at 80% at 20 luck]]
    EID:addCollectible(BELL_BABY_ID, description)

    --- Life Orb ---
    description = 
    [[#When losing a heart container, recieve permanently:
    #{{ArrowUp}} +1 Damage
    #Lose a heart container on pickup and at the start of every floor
    #{{Warning}} Can kill Isaac]]
    EID:addCondition(LIFE_ORB_ID, LIFE_ORB_ID, "Isaac loses an additional heart at the start of each floor, but the damage is multiplied by each copy of the item")
    EID:addCollectible(LIFE_ORB_ID, description)

    --- Corrupted Clover ---
    description = 
    [[{{CurseBlind}} Receive Curse of the Blind permanently
    #Prevents quality {{Quality4}} items from spawning
    #Quality {{Quality3}} items have a 66% chance to be rerolled
    #At the start of each floor, each of Isaac's items have a 10% chance to be rerolled into an item of the same pool of the above quality]]
    EID:addCollectible(CORRUPTED_CLOVER_ID, description)
    EID:addCondition(CORRUPTED_CLOVER_ID, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")
    EID:addCondition(CORRUPTED_CLOVER_ID, CORRUPTED_CLOVER_ID, "No additional effect from multiple copies")

    --- Fallen Angel ---
    description = 
    [[{{AngelChance}} Converts devil deal chance to angel 
    #Angel room items now cost health
    #Uriel and Gabriel now spawn as their dark version but drop angel items on death]]
    EID:addCollectible(FALLEN_ANGEL_ID, description)
    EID:addPlayerCondition(FALLEN_ANGEL_ID, PlayerType.PLAYER_KEEPER, "Items cost coins instead", nil, nil, nil, true)
    EID:addCondition(FALLEN_ANGEL_ID, FALLEN_ANGEL_ID, "No additional effect from multiple copies")

    --- Cursed Map ---
    description = 
    [[#{{CurseMazeSmall}} Receive Curse of the Blind and Curse of the Maze permanently
    #{{UltraSecretRoom}} Secret, Super Secret and Ultra Secret rooms have a higher chance to have good layouts]]
    EID:addCondition(CURSED_MAP_ID, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes curses")
    EID:addCollectible(CURSED_MAP_ID, description)
    EID:addCondition(CURSED_MAP_ID, CURSED_MAP_ID, "No additional effect from multiple copies")

    --- Poison Mush ---
    description = 
    [[{{ArrowUp}} Major Size Down
    #{{BossRoom}} All enemies are in their giant form
    #{{Bomb}} Bombs are turned into Giga Bombs
    #{{Pill}} Pills are turned into Horse Pills
    #{{GoldenChest}} Golden Chests are turned into Giant Chests]]
    EID:addCollectible(POISON_MUSH_ID, description)
    EID:addCondition(POISON_MUSH_ID, POISON_MUSH_ID, "No additional effect from multiple copies")

    --- Broken Compass ---
    description = 
    [[#{{CurseLabyrinth}} Receive Curse of the Labyrinth permanently
    # Upon Clearing a room:
    #{{Indent}}{{SecretRoom}} 50% chance to teleport in a random room
    #{{Indent}}{{Coin}} 33% chance to spawn an additional pickup as clear reward]]
    --EID:addCondition(myItemId, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes curses")
    EID:addCollectible(BROKEN_COMPASS_ID, description)
    EID:addCondition(BROKEN_COMPASS_ID, BROKEN_COMPASS_ID, "No additional effect from multiple copies")
    
    --- Extinguished Candle ---
    description = 
    [[#{{CurseDarkness}} Receive Curse of Darkness permanently
    #{{Slow}} Close enemies are slowed down
    # Distant enemies disapear in the shadows]]
    EID:addCondition(EXTINGUISHED_CANDLE_ID, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse and enemies stay visible")
    EID:addCollectible(EXTINGUISHED_CANDLE_ID, description)
    EID:addCondition(EXTINGUISHED_CANDLE_ID, EXTINGUISHED_CANDLE_ID, "No additional effect from multiple copies")
    
    --- Cursed D6 ---
    description = 
    [[{{Timer}} On use:
    #{{Collectible105}} Rerolls pedestal items in the room
    #{{CurseDarknessSmall}} Increases the chance to have a curse on the next floor
    #{{Warning}} Can add up to multiple curses]]
    EID:addCollectible(CURSED_D6_ID, description)

    --- Cursed Body ---
    description = 
    [[{{CurseUnknown}} Receive Curse of the Unknown permanently
    #On a hit, 50% to trigger one of the following effects:
    #{{Coin}} Spawn a random pickup
    #{{ArrowUp}} Give a permanent stat up
    #{{Trinket}} Spawn a trinket
    #{{CurseRoom}} Spawn a curse room item]]
    EID:addCondition(CURSED_BODY_ID, CollectibleType.COLLECTIBLE_BLACK_CANDLE, "{{ColorYellow}}Black Candle {{ColorWhite}}removes the curse")
    EID:addCollectible(CURSED_BODY_ID, description)
    EID:addCondition(CURSED_BODY_ID, CURSED_BODY_ID, "No additional effect from multiple copies")
end

local function loadTrinketsDescriptions()
    if not EID then return end

    local description

    --- Broken Scissors ---
    description =
    [[{{Bomb}} Turns all Bombs into Troll Bombs
    #{{Key}} Turns all Keys into Charged Keys]]
    EID:addTrinket(BROKEN_SCISSORS_ID, description)

    --- Mimic's Favor ---
    description =
    [[{{SpikedChest}} Turns all Chests into Trapped Chests
    #{{Coin}} Better value coins have a higher chance to appear]]
    EID:addTrinket(MIMICS_FAVOR_ID, description)
end

if EID then
    loadItemsDescriptions()
    loadTrinketsDescriptions()
end

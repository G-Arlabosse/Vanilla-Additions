--- BUG: Does not work with the Stompy transformation advancement from an item ---

local rare_candy = Isaac.GetItemIdByName("Rare Candy")
local itemConfig = Isaac.GetItemConfig()

local TRANSFORMATION_TAGS = {
    [ItemConfig.TAG_SYRINGE]    = PlayerForm.PLAYERFORM_DRUGS,
    [ItemConfig.TAG_MOM]        = PlayerForm.PLAYERFORM_MOM,
    [ItemConfig.TAG_GUPPY]      = PlayerForm.PLAYERFORM_GUPPY,
    [ItemConfig.TAG_FLY]        = PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES,
    [ItemConfig.TAG_BOB]        = PlayerForm.PLAYERFORM_BOB,
    [ItemConfig.TAG_MUSHROOM]   = PlayerForm.PLAYERFORM_MUSHROOM,
    [ItemConfig.TAG_BABY]       = PlayerForm.PLAYERFORM_BABY,
    [ItemConfig.TAG_ANGEL]      = PlayerForm.PLAYERFORM_ANGEL,
    [ItemConfig.TAG_DEVIL]      = PlayerForm.PLAYERFORM_EVIL_ANGEL,
    [ItemConfig.TAG_POOP]       = PlayerForm.PLAYERFORM_POOP,
    [ItemConfig.TAG_BOOK]       = PlayerForm.PLAYERFORM_BOOK_WORM,
    [ItemConfig.TAG_SPIDER]     = PlayerForm.PLAYERFORM_SPIDERBABY
    --- Add a Stompy Advencement via an Item ??? 
    
}

local TRANSFORMATIONS = {
    [PlayerForm.PLAYERFORM_ADULTHOOD] =         {name="Adult"        ,icon="Adult"},
    [PlayerForm.PLAYERFORM_ANGEL] =             {name="Seraphim"     ,icon="Seraphim"},
    [PlayerForm.PLAYERFORM_BABY] =              {name="Conjoined"    ,icon="Conjoined"},
    [PlayerForm.PLAYERFORM_BOB] =               {name="Bob"          ,icon="Bob"},
    [PlayerForm.PLAYERFORM_BOOK_WORM] =         {name="Bookworm"     ,icon="Bookworm"},
    [PlayerForm.PLAYERFORM_DRUGS] =             {name="Spun"         ,icon="Spun"},
    [PlayerForm.PLAYERFORM_EVIL_ANGEL] =        {name="Leviathan"    ,icon="Leviathan"},
    [PlayerForm.PLAYERFORM_GUPPY] =             {name="Guppy"        ,icon="Guppy"},
    [PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = {name="Beelzebub"    ,icon="LordoftheFlies"},
    [PlayerForm.PLAYERFORM_MOM] =               {name="Yes Mother?"  ,icon="Mom"},
    [PlayerForm.PLAYERFORM_MUSHROOM] =          {name="FunGuy"       ,icon="FunGuy"},
    [PlayerForm.PLAYERFORM_POOP] =              {name="Oh Crap"      ,icon="OhCrap"},
    [PlayerForm.PLAYERFORM_SPIDERBABY] =        {name="Spider Baby"  ,icon="SpiderBaby"},
    [PlayerForm.PLAYERFORM_STOMPY] =            {name="Stompy"       ,icon="Stompy"}
}

 
LAST_RARE_CANDY_TRANSFORMAION = nil
PLAYER_ID = 0

local function changeTransformation(previous, new)
   if EID then
        if previous then
            EID:removeTransformation("collectible", rare_candy, TRANSFORMATIONS[previous].icon)
        end
        if new then
            EID:assignTransformation("collectible", rare_candy, TRANSFORMATIONS[new].icon)
        end
    end
end

--- Checks transformation on Item Pickup ---
local function OnCollectibleAdded(_,
    type,       ---@param type CollectibleType
    charge,     ---@param charge integer
    firstTime,  ---@param firstTime boolean
    slot,       ---@param slot integer
    varData,    ---@param varData integer
    player      ---@param player EntityPlayer
)
    local item = itemConfig:GetCollectible(type)
    --print(item.ID, item.Tags)
    for tag, form in pairs(TRANSFORMATION_TAGS) do 
        --print("Tag:", tag, " HasTag:", item:HasTags(tag), " Form:", form)
        if item:HasTags(tag) then
            changeTransformation(LAST_RARE_CANDY_TRANSFORMAION, form)
            LAST_RARE_CANDY_TRANSFORMAION = form
            PLAYER_ID = player.Index
        end
    end
end 

--- Checks transformation on PillEffect ---
local function OnPillEffect(
    _,
    selectedPillEffect, ---@param selectedPillEffect PillEffect 
    player              ---@param player EntityPlayer
)
    if selectedPillEffect == PillEffect.PILLEFFECT_PUBERTY then
        changeTransformation(LAST_RARE_CANDY_TRANSFORMAION, PlayerForm.PLAYERFORM_ADULTHOOD)
        LAST_RARE_CANDY_TRANSFORMAION = PlayerForm.PLAYERFORM_ADULTHOOD
        PLAYER_ID = player.Index
    elseif selectedPillEffect == PillEffect.PILLEFFECT_LARGER then
        changeTransformation(LAST_RARE_CANDY_TRANSFORMAION, PlayerForm.PLAYERFORM_STOMPY)
        LAST_RARE_CANDY_TRANSFORMAION = PlayerForm.PLAYERFORM_STOMPY
        PLAYER_ID = player.Index
    end
end

--- Rare Candy is used ---
local function UseRareCandy (
    _,
    item, ---@param item CollectibleType
    rng, -- RNG
    player, ---@param player EntityPlayer
    useFlags, -- UseFlags [int]
    activeSlot, -- ActiveSlot
    customVarData -- CustomVarData [int]
)
    if LAST_RARE_CANDY_TRANSFORMAION then
        --player:IncrementPlayerFormCounter(Form, Count)
        player:IncrementPlayerFormCounter(LAST_RARE_CANDY_TRANSFORMAION, 3)

        changeTransformation(LAST_RARE_CANDY_TRANSFORMAION, nil)
        LAST_RARE_CANDY_TRANSFORMAION = nil
        return {      
            Discharge = false,
            Remove = true,
            ShowAnim = true,
        }
    end
end

local function OnNewRun()
    changeTransformation(LAST_RARE_CANDY_TRANSFORMAION, nil)
    LAST_RARE_CANDY_TRANSFORMAION = nil
    PLAYER_ID = nil
end


Mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, OnCollectibleAdded)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, OnPillEffect)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun)

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseRareCandy, rare_candy)
-- Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, Mod.ItemRemoved)
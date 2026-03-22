local CURSED_D6 = Isaac.GetItemIdByName("Cursed D6")

local CURSES_TEXTS = {
    "Greed will consume you",
    "...",
    "Shame on you",
    "Stop",
    "ISAAC !",
    "Blame Yourself",
    "That's your last chance",
    "You can't escape",
    "You chose your fate",
    "Curse you !",
    "ENOUGH !",
    "%§?O^$"
}

local CURSES = {
    LevelCurse.CURSE_OF_BLIND,      
    LevelCurse.CURSE_OF_DARKNESS,   
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN
}

local COLOR_MOD_TARGET = ColorModifier(0.5, 0.1, 0.8, 0.8, 0.0, 1.15)  -- R G B A Brightness Contrast
local EFFECTS_TIMER = 30

local floor_free_curses = {}
local previousMod = ColorModifier()
local purpleMod = ColorModifier()
local curse_chance = 0
local curse_chance_mod = 0  -- 1/3 or 1/5 depending on the difficulty
local effectTimer = 0

local function PostCurseEval(curses)

    --print("Curse chance: " .. curse_chance)

    for i=1, #CURSES do
        floor_free_curses[CURSES[i]] = true
    end

    local all_curses = LevelCurse.CURSE_NONE
    for i=1, #curses do
        --print("Had Curse: ".. curses[i])
        floor_free_curses[curses[i]] = nil
        all_curses = all_curses | curses[i]
        curse_chance = curse_chance - curse_chance_mod
    end
    --print("Reduced Curse Chance: ".. curse_chance)

    local game = Game()
    local absolute_stage = game:GetLevel():GetAbsoluteStage()
    local level_seed = game:GetSeeds():GetStageSeed(absolute_stage)
    local rng = RNG(level_seed, 35)

    local nb_curses = curse_chance // 1
    local p = curse_chance % 1
    --print("Nb curses:" .. nb_curses .. ", Proba curse:".. p)

    if (rng:RandomFloat() < p) then
        nb_curses = nb_curses + 1
        --print("Additional Curse ! ")
    end    

    for i=1, nb_curses do
        local random = rng:RandomInt(#floor_free_curses)
        local acc = 0
        for new_curse,j in pairs(floor_free_curses) do
            acc = acc + 1
            if acc > random then
                floor_free_curses[new_curse] = nil
                all_curses = all_curses | new_curse
                --print("Added Curse: "..new_curse)
                break
            end
        end
    end
    
    curse_chance = 0
    floor_free_curses = {}

    return all_curses

end

local function NewGame()
    local difficulty = Game().Difficulty
    if difficulty == Difficulty.DIFFICULTY_NORMAL or difficulty == Difficulty.DIFFICULTY_GREED then
        curse_chance_mod = 1/5
    else
        curse_chance_mod = 1/3
    end
end

local function UseCursedD6(_,
    item, ---@param item CollectibleType
    rng, -- RNG
    player, ---@param player EntityPlayer
    useFlags, -- UseFlags [int]
    activeSlot, -- ActiveSlot
    customVarData -- CustomVarData [int]
)
    curse_chance = curse_chance + curse_chance_mod
    --print(curse_chance)

    local game = Game()
    game:GetRoom():EmitBloodFromWalls(1, 20)    
    game:Darken(1, EFFECTS_TIMER)
    game:GetHUD():ShowItemText(CURSES_TEXTS[math.random(#CURSES_TEXTS)])
    game:ShakeScreen(EFFECTS_TIMER)
    
    SFXManager():Play(SoundEffect.SOUND_MOTHER_ANGER_SHAKE)
 
    effectTimer = EFFECTS_TIMER
    previousMod = Game():GetCurrentColorModifier()
    
    player:UseActiveItem(
            CollectibleType.COLLECTIBLE_D6,
            UseFlag.USE_NOANIM
        )

    return true ---Important (plays the animation of CURSED D6)
end

local function OnRender()
    if effectTimer > 0 then
        local t = (effectTimer-1) / EFFECTS_TIMER

        purpleMod.R             = COLOR_MOD_TARGET.R * (1 - t) + previousMod.R * t
        purpleMod.G             = COLOR_MOD_TARGET.G * (1 - t) + previousMod.G * t
        purpleMod.B             = COLOR_MOD_TARGET.B * (1 - t) + previousMod.B * t
        purpleMod.A             = COLOR_MOD_TARGET.A * (1 - t) + previousMod.A * t
        purpleMod.Brightness    = COLOR_MOD_TARGET.Brightness * (1 - t) + previousMod.Brightness * t
        purpleMod.Contrast      = COLOR_MOD_TARGET.Contrast * (1 - t) + previousMod.Contrast * t

        Game():SetColorModifier(purpleMod, false)
        effectTimer = effectTimer - 1
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseCursedD6, CURSED_D6)
Mod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, NewGame)
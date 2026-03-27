local cursed_floors = Isaac.GetItemIdByName("Cursed Rooms")

local function PostCurseEval(_, curses)
    if PlayerManager.AnyoneHasCollectible(cursed_floors) and
        not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        curses = curses | LevelCurse.CURSE_OF_LABYRINTH
    end
    return curses
end


Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PostCurseEval)
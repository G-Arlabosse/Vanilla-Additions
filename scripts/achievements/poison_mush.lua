local function TryUnlock()
    local data = Isaac.GetPersistentGameData()
    local poison_mush_unlock = Isaac.GetAchievementIdByName("Poison Mush")

    if data:Unlocked(Achievement.HORSE_PILLS)
            and data:Unlocked(Achievement.MEGA_CHEST)
            and not data:Unlocked(poison_mush_unlock) 
            then
        Isaac.GetPersistentGameData():TryUnlock(poison_mush_unlock)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_END, TryUnlock)
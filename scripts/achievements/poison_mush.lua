local data = Isaac.GetPersistentGameData()
local poison_mush_unlock = Isaac.GetAchievementIdByName("Poison Mush")

local function TryUnlock()
    if data:Unlocked(Achievement.HORSE_PILLS)
            and data:Unlocked(Achievement.MEGA_CHEST)
            and not data:Unlocked(poison_mush_unlock) 
            then
        Isaac.GetPersistentGameData():TryUnlock(poison_mush_unlock)
    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_END, TryUnlock)
Mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, TryUnlock)
Mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, TryUnlock)
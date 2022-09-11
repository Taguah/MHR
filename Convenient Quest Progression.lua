--Convenient Quest Progression
--Quests not designated as "key" for the purpose of story progression are now "key"
log.info("[CQP.lua] loaded")

local function getQuestProgressData()
    local questMan = sdk.get_managed_singleton("snow.QuestManager")
    local pQuestMan = sdk.get_managed_singleton("snow.progress.quest.ProgressQuestManager")
    if not (questMan and pQuestMan) then
        print("Quest managers inactive...")
        return
    end
    local qNo = questMan:call("getQuestNo")
    local qId = questMan:call("getActiveQuestIdentifier")
    local qTier = questMan:call("getQuestLv") --# of stars minus 1
    local qCat = questMan:call("getQuestRank_Lv") -- 0 = low, 1 = high, 2 = MR
    local keyNum = nil
    local keyDen = nil
    local keyList = {}  --list of snow.progress.quest.SelectQuestProgressData
    
    if qCat == 0 then -- low rank
        if questMan:call("isVillageCounterQuest") then
            keyNum = pQuestMan:call("getSelectQuestClearCount", 0, qTier)
            keyDen = pQuestMan:call("getSelectQuestCount", 0, qTier, false)
            keyList = pQuestMan:call("getSelectQuestList", 0)
        else -- gathering hub low rank
            keyNum = pQuestMan:call("getSelectQuestClearCount")
            keyDen = pQuestMan:call("getSelectQuestCount", 2, qTier, false)
            keyList = pQuestMan:call("getSelectQuestList", 2)
        end
    elseif qCat == 1 then -- high rank
        keyNum = pQuestMan:call("getSelectQuestClearCount")
        keyDen = pQuestMan:call("getSelectQuestCount", 2, qTier, false)
        keyList = pQuestMan:call("getSelectQuestList", 2)
    elseif qCat == 2 then -- master rank
        keyNum = pQuestMan:call("getSelectQuestClearCount", 7, qTier)
        keyDen = pQuestMan:call("getSelectQuestCount", 7, qTier, false)
        keyList = pQuestMan:call("getSelectQuestList", 7)
    end
    if ((keyDen > keyNum) and (not pQuestMan:call("isClear", qNo))) then
        --print(keyList[0]:call("ToString"))    --debug
        keyList[#keyList] = sdk.create_int32(qId)
        pQuestMan:call("updateSelectQuestClearCount")
    end
end


re.on_frame(function()
    getQuestProgressData()
end)
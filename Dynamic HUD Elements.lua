--Dynamic HUD Elements
--Modifies options (without menuing) so as to hide specified HUD elements out of combat
local cfg = json.load_file("DHE.json")

if not cfg then
    cfg = {
        timer = true,
        pInfo = true,
        vGauge = true,
        sGauge = true,
        qTarget = true,
        sharpness = true,
        wInfo = true,
        fInfo = true,
        map = true,
        tci = true,
        eInfo = true,
        bSlider = true,
        iSlider = true,
        aSlider = true,
        wGauge = true,
        iTypeMR = true,
        sScroll = true,
        sSkills = true
    }
  json.dump_file("DHE.json", cfg)
end


re.on_config_save(function()
    json.dump_file("DHE.json", cfg)
end)


local function UpdateHUD()
    local lobbyManager = sdk.get_managed_singleton("snow.LobbyManager")
    if lobbyManager:call("isInQuest") then  --Don't wanna be wasteful, do we?
        local optionManager = sdk.get_managed_singleton("snow.gui.OptionManager")
        local musicManager = sdk.get_managed_singleton("snow.wwise.WwiseMusicManager")
        local mixManager = sdk.get_managed_singleton("snow.wwise.WwiseMixManager")
        local questManager = sdk.get_managed_singleton("snow.QuestManager")
        local currentState = musicManager:get_field("_CurrentEnemyAction")
        local currentMix = mixManager:call("get_Current")
        local currentType = questManager:get_field("_QuestType")
        if (currentState == 3 or currentMix == 10 or currentMix == 31 or currentMix or
    currentType == 64) then --In combat
            local visList = {true, true, true, true, true, true, true, true, true, true,
            true, true, true, true, true, true, true, true} --show all UI
        else  --Out of combat
            local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
            local visList = {cfg.timer, cfg.pInfo, cfg.vGauge, cfg.sGauge, cfg.qTarget,
cfg.sharpness, cfg.wInfo, cfg.fInfo, cfg.map, cfg.tci, cfg.eInfo, cfg.bSlider, cfg.iSlider,
cfg.aSlider, cfg.wGauge, cfg.iTypeMR, cfg.sScroll, cfg.sSkills} --show specified UI
            if guiManager:call("get_ActionSliderState") == 1 then
                visList[14] = true --show actions when scrolling it
            end
            if guiManager:call("get_ItemSliderState") == 1 then
                visList[13] = true --show items when scrolling it
            end
            if guiManager:call("get_BulletSliderState") == 1 then
                visList[12] = true --show ammo when scrolling it
            end
        end
        optionManager:call("set_HudVisibleSettingList", visList) --Update options
    end
end

re.on_frame(function()
    UpdateHUD()
    imgui.begin_window("Visibility Checklist", true)
        local _, __ = nil, nil
        _, __ = imgui.checkbox("Timer", cfg.timer)
        if _ then cfg.timer = __ end
        _, __ = imgui.checkbox("Player Info", cfg.pInfo)
        if _ then cfg.pInfo = __ end
        _, __ = imgui.checkbox("Vital Gauge", cfg.vGauge)
        if _ then cfg.vGauge = __ end
        _, __ = imgui.checkbox("Stamina Gauge", cfg.sGauge)
        if _ then cfg.sGauge = __ end
        _, __ = imgui.checkbox("Quest Target", cfg.qTarget)
        if _ then cfg.qTarget = __ end
        _, __ = imgui.checkbox("Sharpness", cfg.sharpness)
        if _ then cfg.sharpness = __ end
        _, __ = imgui.checkbox("Weapon Info", cfg.wInfo)
        if _ then cfg.wInfo = __ end
        _, __ = imgui.checkbox("Friend Info", cfg.fInfo)
        if _ then cfg.fInfo = __ end
        _, __ = imgui.checkbox("Map", cfg.map)
        if _ then cfg.map = __ end
        _, __ = imgui.checkbox("Target Camera Icon", cfg.tci)
        if _ then cfg.tci = __ end
        _, __ = imgui.checkbox("Enemy Info", cfg.eInfo)
        if _ then cfg.eInfo = __ end
        _, __ = imgui.checkbox("Ammo Bar", cfg.bSlider)
        if _ then cfg.bSlider = __ end
        _, __ = imgui.checkbox("Item Bar", cfg.iSlider)
        if _ then cfg.iSlider = __ end
        _, __ = imgui.checkbox("Action Bar", cfg.aSlider)
        if _ then cfg.aSlider = __ end
        _, __ = imgui.checkbox("Wire Gauge", cfg.wGauge)
        if _ then cfg.wGauge = __ end
        _, __ = imgui.checkbox("Begin Item Type MR", cfg.iTypeMR)
        if _ then cfg.iTypeMR = __ end
        _, __ = imgui.checkbox("Switch Scroll", cfg.sScroll)
        if _ then cfg.sScroll = __ end
        _, __ = imgui.checkbox("Switch Skills", cfg.sSkills)
        if _ then cfg.sSkills = __ end
    imgui.end_window()
end)
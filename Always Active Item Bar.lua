--Always Active Item Bar
--Persistently holds the item bar in it's expanded form so the adjacent items may be seen (similar to world's item bar)
log.info("[AA_Item_Bar.lua] loaded")

local function expandBar()
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    local guiHud = sdk.find_type_definition("snow.gui.GuiHud_ItemActionSlider")

    if not guiManager then
        print("GUI inactive...")
        return
    end

    upItemMethod = guiHud:get_method("updateItemSliderState")
    itemBarState = guiManager:call("get_ItemSliderState")
    if guiManager:call("get_ActionSliderState") == 0 then
        guiManager:call("set_ItemSliderState", 1)
        upItemMethod:call()
    end
end

re.on_frame(function() --Very light, calling it each frame isn't horrible
    expandBar()
end)    --include optional functionality for action and ammo bars? maybe later
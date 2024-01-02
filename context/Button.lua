local ui = require "ui"

local menu = ui.Menu()
local Widget

-- create a menu item 
menu:add("Set icon...").onClick = function(self)
    local win = ui.Window("Load icon...", "fixed", 300, 200)
    win:center()
    local gb = ui.Groupbox(win, "", 10, 4, 160, 188)
    local icon = ui.Picture(gb, Widget.icofile or "")
    icon:center()
    
    local icofile
    
    local okbtn = ui.Button(win, "Ok", 184, 36, 110, 26)
    okbtn.enabled = false
    
    function okbtn:onClick(self)
        tracker:stop()
        Widget:loadicon(icofile)
        tracker:start(Widget)
        Widget.icofile = icofile
        win:hide()
    end

    local delbtn = ui.Button(gb, "Remove icon", 24, 154, 110, 26)
    
    function delbtn:onClick()
        ui.remove(icon)
        self:hide()
        okbtn.enabled = false
        icofile = nil
    end

    delbtn.visible = Widget.icofile
    
    ui.Button(win, "Cancel", 184, 158, 110, 26).onClick = function(self)
        win:hide()
    end
    
    ui.Button(win, "Select icon...", 184, 10, 110, 26).onClick = function(self)
        local file = ui.opendialog("Select icon...", false, "ICO files (*.ico)|*.ico")
        if file then
            icofile = file
            okbtn.enabled = true
            if icon then
                ui.remove(icon)
            end
            icon = ui.Picture(gb, icofile)
            icon:center()
            delbtn:show()
        end
    end    
    formWindow:showmodal(win)
end

menu:add("Autosize").onClick = function(self)
    tracker:stop()
    local x = Widget.x
    local y = Widget.y
    Widget.align = nil
    Widget:autosize()
    Widget.x = x
    Widget.y = y
    tracker:start(Widget)
end

menu:add("Center").onClick = function(self)
    tracker:stop()
    Widget:center()
    tracker:start(Widget)
end

return function(self)
    Widget = self
    return menu
end
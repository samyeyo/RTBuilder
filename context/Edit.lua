local ui = require "ui"

local menu = ui.Menu()
local Widget

-- create a menu item 
menu:add("Edit lines...").onClick = function(self)
    local win = ui.Window("Lines editor", "fixed", 400, 260)
    win:center()
    local edit = ui.Edit(win, "")
    edit.text = Widget.text
    edit.richtext = Widget.richtext
    edit.font = "Consolas"
    edit.fontsize = 8
    edit.align = "top"
    edit.height = 230
    
    ui.Button(win, "Ok", 220, 232, 80).onClick = function(self)
        Widget.text = edit.text
        win:hide()
    end
    
    ui.Button(win, "Cancel", 310, 232, 80).onClick = function(self)
        win:hide()
    end
    
    ui.Button(win, "Load from file...", 10, 232, 120).onClick = function(self)
        local file = ui.opendialog("Load lines from file...", false, "All files (*.*)|*.*|Text files (*.txt)|*.txt")
        if file then
            edit:load(file)
        end
    end    
    formWindow:showmodal(win)
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
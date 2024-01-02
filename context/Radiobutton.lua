local ui = require "ui"

local menu = ui.Menu()
local Widget


menu:add("Autosize").onClick = function(self)
    tracker:stop()
    local x = Widget.x
    local y = Widget.y
    Widget.align = nil
    Widget:autosize()
    Widget.x = x
    Widget.y = y
    tracker:start(Widget)
    inspector:onTrack(Widget)
end

menu:add("Center").onClick = function(self)
    tracker:stop()
    Widget:center()
    tracker:start(Widget)
end

menu:add("Toogle check").onClick = function(self)
    tracker:stop()
    Widget.checked = not Widget.checked
    tracker:start(Widget)
end

return function(self)
    Widget = self
    return menu
end
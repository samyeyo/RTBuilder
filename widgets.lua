local ui = require "ui"
local inspector = require "inspector"

local tabpos = 12

function findname(name)
    local i = 0
    repeat
        i = i + 1
    until Widgets[name..i] == nil
    return name..i
end

local function onClick(w)
    tracker:stop();
    local parent = w.parent
    local t = type(parent)
    if t == 'Tab' then
        tracker = parent.owner.tracker or Tracker(parent)
    else
        tracker = parent.tracker or Tracker(parent);
    end
    inspector.Update(w)
end

local function widgetOnClick(self)
    local name
    if formWindow == nil then
        ui.msg("You need to create a Window before using this widget.")
        return
    end
    local old = tracker.widget
    local w = type(old)
    local parent
    tracker:stop()
    if w == "Groupbox" or w == "Tab" then 
        if w == "Tab" then
            parent = old.selected
            parent.owner.tracker = parent.owner.tracker or Tracker(parent)
        else
            parent = old
            parent.tracker = parent.tracker or Tracker(parent)
        end
        tracker = w == "Tab" and parent.owner.tracker or parent.tracker
        parent.onClick = onClick;
    else 
        parent = old and old.parent or formWindow
        tracker = parent.tracker or parent.owner.tracker
    end
    local function create()
        name = findname(self.name)
        return ui[self.name](parent, name, 50, 50)
    end
    
    local function create_items()
        return ui[self.name](parent, {}, 50, 50)
    end
    local success, widget
    success, widget = pcall(create) 
    if not success then
        success, widget = pcall(create_items)
        if not success then
            widget = ui[self.name](parent)
        end
    end
    widget.name = name
    Widgets[name] = widget
    widget.get_visible = function(self) return self._visible == nil and super(self).get_visible(self) or self._visible end
    widget.set_visible = function(self, val) self._visible = val end
    widget.get_enabled = function(self) return self._enabled == nil and super(self).get_enabled(self) or self._enabled end
    widget.set_enabled = function(self, val) self._enabled = val end
    widget._enabled = true
    widget._visible = true
    widget.onClick = onClick
    if widget["get_selected"] ~= nil then
        widget.icons = {}
    end
    inspector.Update(widget)
end

function loadWidgets()
    for name, w in pairs(Widgets) do
        w.onClick = onClick
        w.cursor = "cardinal"
        w._enabled = w.enabled
        w._visible = w.visible        
        w.enabled = true
        w.visible = true
        w.get_visible = function(self) return self._visible == nil and super(self).get_visible(self) or self._visible end
        w.set_visible = function(self, val) self._visible = val end
        w.get_enabled = function(self) return self._enabled == nil and super(self).get_enabled(self) or self._enabled end
        w.set_enabled = function(self, val) self._enabled= val end
    end
end

local function addwidget(name)
    local name = name:capitalize()
    local widget = ui.Picture(widgetsTab.items[1], "resources/"..name..".png", tabpos+12, 6)
    local label = ui.Label(widgetsTab.items[1], name, widget.x, 31)
    widget.name = name
    label.name = name
    label.fontsize = 8
    label.x = widget.x - label.width/2 + 13
    widget.cursor = "hand"
    label.cursor = "hand"
    label.onHover = function() if (not label.fontstyle.underline) then label.fontstyle = {underline = true} end end
    widget.onHover = label.onHover
    label.onLeave = function() label.fontstyle = {underline = false} end
    widget.onLeave = label.onLeave
    widget.onClick = widgetOnClick
    label.onClick = widgetOnClick
    tabpos = tabpos + 64
end

addwidget("Label")
addwidget("Button")
addwidget("Checkbox")
tabpos = tabpos + 4
addwidget("Radiobutton")
tabpos = tabpos + 8
addwidget("Groupbox")
addwidget("Entry")
addwidget("Edit")
addwidget("List")
addwidget("Tab")
addwidget("Combobox")
addwidget("Tree")
addwidget("Calendar")
addwidget("Picture")
addwidget("Progressbar")
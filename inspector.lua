local ui = require "ui"
require "console"

local inspectWindow
local members = {}
local properties = {}
local elements = {}
local y

local widget_name

------------ Reject following properties
local reject = {
    Edit = { column = true, line = true, caret = true, modified = true},
}


------------ List all mouse cursors
local cursors_names = {}
local cursors_icons = {}
local i = 0

cursors_names[0] = "none"
for entry in each(sys.Directory(sys.currentdir.."/resources/cursors/ico/"):list("*.ico")) do
    i = i + 1
    cursors_names[i] = entry.name:gsub(entry.extension, "")
    cursors_icons[i] = entry.fullpath
end

function elements.items(win, tracked, value, property, i)
    local widget = ui.Button(win, "Edit items...", 99, y)
    widget.onClick = function(self)
        onContext[type(tracked)](tracked).items[1].onClick()        
    end
    y = y + 3
    return widget
end

function elements.selected(win, tracked, value, property, i)
    local widget = ui.Combobox(win, false, {}, 100, y)
    widget.style = "icons"
    local sel = tracked.selected
    if tracked.count > 0 then
        for item=1,tracked.count do
            local text = tracked.items[item].text
            widget:add(tracked.items[item].text):loadicon(tracked.icons[text])
        end
        if sel then
            print(sel.text)
            tracker:stop()
            widget.selected = widget.items[tracked.selected.text]
            members[i].value = widget.selected.text
            tracker:start(w)
        end
        widget.onSelect = function (self, item)
            tracked.selected = tracked.items[widget.selected.index]
            members[i].value = widget.selected.text
        end
    end
    return widget
end

function elements.style(win, tracked, value, property, i)
    local widget = ui.Combobox(win, false, {"text", "icons"}, 100, y)
    widget.selected = widget.items[tostring(value)]
    widget.onSelect = function (self, item)
        tracked.style = item.text
        members[i].value = item.text
    end
    return widget
end

function elements.cursor(win, tracked, value, property, i)
    local widget = ui.Combobox(win, false, cursors_names, 100, y)
    widget.style = "icons"
    for i = 1, widget.count do
        widget.items[i]:loadicon(cursors_icons[i])
    end
    widget.selected = widget.items[tostring(value)]
    widget.onSelect = function (self, item)
        tracked.cursor = item.text
        members[i].value = item.text
    end
    return widget
end

function elements.bgcolor(win, tracked, value, property, index)
    local widget = ui.Label(win, value, 134, y+5, 70, 20)
    widget.icon = ui.Panel(win, 100, y+4, 16, 16)
    widget.icon.border = true
    members[property] = string.format("0x%.6X", value)
    widget.icon.bgcolor = value
    widget.text = members[property]
    widget.textalign = "left"
    widget.icon.cursor = "hand"
    widget.update = function(w, color)
        members[index].value = color
        color = string.format("0x%.6X", color)
        widget.icon.bgcolor = color
        widget.text = color
        w[property] = color
    end
    widget.icon.onClick = function (self)
        local tracked = tracker.widget or tracked        
        local lastvalue = tracked[property]
        local color = ui.colordialog(lastvalue)
        if color and color ~= lastvalue then
           widget.update(tracked, color)
        end
    end
    return widget
end

function elements.fgcolor(win, tracked, value, property, index)
    return elements.bgcolor(win, tracked, value, property, index)
end

function elements.font(win, tracked, value, property, i)
    local widget = ui.Button(win, "", 99, y, 103)
    widget.textalign = "left"
    -- local fontupdate = function()
    --     widget.text = tracked.font..", "..tracked.fontsize
    --     -- widget.width = 103
    -- end
    -- fontupdate()
    widget.update = function(w, _, font, fontsize, fontstyle)
        tracker:stop()
        font = font or "Segoe UI"
        widget.text = font..", "..fontsize
        w.font = font
        w.fontsize = fontsize
        w.fontstyle = fontstyle
        print("Updating "..w.name.." font bold =", w.fontstyle.bold)
        if w.autosize ~= nil then
            w:autosize()
        end
        if w ~= formWindow then
            tracker:start(w)
        end
    end
    widget.update(tracked, nil, tracked.font, tracked.fontsize, tracked.fontstyle)
    widget.onClick = function(self)
        local result = {ui.fontdialog()}
        if #result > 0 then
            -- result[1] = #result[1] > 0 and result[1] or "Segoe UI"
            -- local try = pcall(function() tracked.font = result[1] end)
            -- if not try then
            --     ui.error("Failed to apply font "..result[1])
            -- else
                -- tracked.fontsize = result[2]
                -- tracked.fontstyle = result[3]
                -- tracker:stop()
                self.update(tracker.widget or tracked, nil, #result[1] > 0 and result[1] or nil, result[2], result[3])
                -- if tracked.autosize ~= nil then
                --     tracked:autosize()
                -- end
                -- tracker:start(tracked)
            -- end
        end
    end
    y = y + 3
    return widget
end

function elements.textalign(win, tracked, value, property, i)
    local widget = ui.Combobox(win, false, {'left', 'right', 'center'}, 100, y)
    widget.selected = widget.items[tostring(value)]
    widget.onSelect = function (self, item)
        tracked.textalign = item.text
        members[i].value = item.text
    end
    return widget
end

function elements.align(win, tracked, value, property, i)
    local init = true
    local widget = ui.Combobox(win, false, {"nil", 'all', 'bottom', 'top', 'right', 'left'}, 100, y)
    widget.selected = widget.items[tostring(value)]
    widget.onSelect = function (self, item)
        if init == true then
            init = false
            return
        end
        tracker:stop()
        tracked.align = item.text ~= "nil" and item.text or nil
        tracker:start(tracked)
        members[i].value = tracked.align
    end
    return widget
end

function elements.boolean(win, tracked, value, property, i)
    local widget = ui.Combobox(win, false, {"true", "false"}, 100, y)
    widget.selected = widget.items[tostring(value)]
    if property == "enabled" or property == "visible" then
        property = "_"..property
    end
    widget.onSelect = function (self, item)     
        tracked[property] = item.text == "true"
        members[i].value = item.text == "true"
        if property == "hastext" then
            if item.text == "true" then
                tracked.text = tracked.name
                for k = i+1, #members do
                    local m = members[k]
                    if m.property == "text" then
                        properties["text"].widget.text = tracked.name
                        members[k].value = tracked.name
                    end
                end
            end
            tracker:stop()
            tracked:autosize()
            tracker:start(tracked)
        end
    end
    return widget
end

local noval = { ["x"] = true, ["y"] = true, ["width"] = true, ["height"] = true}

function elements.entry(win, tracked, value, property, i)
    local widget = ui.Entry(win, tostring(value), 100, y, 100, 23)
    widget.onSelect = function (self)
        local lastvalue = tracked[property]
        if noval[property] then
            tracker:stop()
            lastvalue = tracked[property]
            if not pcall(function() tracked[property] = widget.text; members[i].value = widget.text end) then
                sys.beep()
                tracked[property] = lastvalue
                widget.text = lastvalue
            end
            tracker:start(tracked)
        elseif lastvalue ~= nil then
            local func = function() tracked[property] = widget.text; members[i].value = widget.text end
            if not pcall(func) then
                sys.beep()
                tracked[property] = lastvalue
                widget.text = lastvalue              
            elseif property == "name" then
                if lastvalue ~= widget.text and Widgets[widget.text] then
                    ui.error("A Widget named '"..widget.text.."' already exists.")
                    widget.text = lastvalue
                    tracked[property] = lastvalue
                else
                    win.title = widget.text.." properties"
                    Widgets[widget.text] = tracked
                    Widgets[lastvalue] = nil
                end
            end    
            if tracked.autosize ~= nil then
                tracker:stop()
                tracked:autosize()
                tracker:start(tracked)
            end
        end
    end
    return widget
end

local function list_properties(widget, ancestor)
    local t = type(widget)
    for member in pairs(ancestor) do
        local propname = member:match("^set_(.*)")
        if propname ~= nil and ancestor["_"..propname] == nil and not propname:match("font.+") then
            if not (reject[t] and reject[t][propname]) then
                members[#members+1] = {property = propname, value = widget[propname]}
            end
        end
    end
end

local function display_properties(self, widget)
    self.title = widget.name.." properties"
    list_properties(widget, super(widget), members)
    list_properties(widget, widget, members)
    members[#members+1] = {property = 'name', value = widget.name}
    table.sort(members, function(a,b) return (a.property:sub(1, 1) < b.property:sub(1, 1)) and (a.property:sub(1, 2) < b.property:sub(1, 2)) end)
    y = 12
    for i, member in ipairs(members) do
        properties[member.property] = {value = member.value}
        ui.Label(self, member.property, 10, y+4)
        local _widget
        local func = elements[member.property] or elements[type(member.value)] or elements.entry
        if func then
            _widget = func(self, widget, member.value, member.property, i)
        end
        properties[member.property].widget = _widget
        if widget ~= formWindow then
            sleep()
        end
        y = y + 26
    end
    self.height = y + 14
end


local function update_properties(widget)
    for i, member in ipairs(members) do
        if member.property == "selected" then
            properties[member.property].widget:clear()
            if widget.count > 0 then
                for item=1,widget.count do
                    local text = widget.items[item].text
                    properties[member.property].widget:add(text):loadicon(widget.icons[item])
                end
                local sel = widget.selected
                if sel then
                    tracker:stop()
                    properties[member.property].widget.selected = properties[member.property].widget.items[widget.items[sel.text].text]
                    tracker:start(widget)
                end
            end
        elseif member.property ~= "items" and widget[member.property] ~= member.value then
            local val = widget[member.property]
            -- if noval[member.property] then
            --     val = widget[member.property]
            -- end
            if type(properties[member.property].widget) == "Combobox" then
                properties[member.property].widget.selected = properties[member.property].widget.items[tostring(val)]
            else 
                properties[member.property].widget.text = tostring(val)
            end
            member.value = val
            if properties[member.property].widget.update then
                properties[member.property].widget.update(widget, val)
            end
        end
    end
end

local props = {"x", "y", "width", "height"}

local function onTrack()
    for prop in each(props) do
        properties[prop].widget.text = tracker[prop] or formWindow[prop]
    end
end

return {
    Update = function(w)  
        local t = type(w)
        if t ~= widget_name or inspectWindow == nil then
            local new_win = ui.Window("Widget properties", "float", 210, 500)
            new_win.x = mainWindow.x + mainWindow.width
            new_win.y = mainWindow.y + 60 + mainWindow.height
            members = {}
            properties = {}
            display_properties(new_win, w)
            new_win:show()
            formWindow:show()
            if inspectWindow ~= nil then
                ui.remove(inspectWindow)
                inspectWindow = nil
            end
            inspectWindow = new_win
            onTrack()
            tracker.onTrack = onTrack
            widget_name = t
        else
            inspectWindow.title = w.name.." properties"
            onTrack()
            update_properties(w)
        end
        if w ~= formWindow then
            tracker:start(w)
            tracker:onTrack()
        end
    end,

    Remove = function()
        if inspectWindow ~= nil then
            inspectWindow:hide()
            inspectWindow = nil
        end
    end
}
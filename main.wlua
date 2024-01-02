local ui = require "ui"
require "tracker"
require "dump"
inspector = require "inspector"

Widgets = {}
onContext = {}

filename = nil
formWindow = nil
mainWindow = ui.Window("RTBuilder v0.1", "fixed", 936, 110)
widgetsTab = ui.Tab(mainWindow, {"Widgets"}, 6, 6, 926,80)
mainWindow.menu = ui.Menu()

for entry in sys.Directory(sys.File(arg[1] and arg[1] or arg[0]).path.."/context"):list("*.lua") do
    onContext[entry.name:gsub("%.lua", "")] = loadfile(entry.fullpath)()
end

function Tracker(widget)
    local t = ui.Tracker(widget)
    t.onContext = function ()
        local func = onContext[t.widget and type(t.widget) or "Window"] or false
        if func then
            formWindow:popup(func(t.widget))
        end
    end
    t.onDelete = function(self)
        local w = tracker.widget
        self:stop()
        formWindow:onClick()
        Widgets[w.name] = nil
        ui.remove(w)
    end
    return t 
end

function CloseWindow(save)
    local save = (save == nil and true) or false
    if formWindow ~= nil then
        formWindow.tracker:stop()
        ui.remove(formWindow.tracker)
        formWindow.tracker = nil
        if save then
           return saveWindow()
        end
        inspector.Remove()
        formWindow.visible = false
        formWindow = nil
        filename = nil
        mainWindow:UpdateTitle()
    end
end

function onClose(self)
    if self ~= nil then
        result = ui.confirm("The current Window is about to be closed.\nDo you want to save before continuing ?")
        if result == "yes" then
           return saveWindow()    
        elseif result == "cancel" then
            return false
        end            
        CloseWindow(false)
    end
    return true
end    

function mainWindow:onClose()
   return onClose(formWindow)
end

function mainWindow:UpdateTitle()
    mainWindow.title = filename == nil and "RTBuilder v0.1" or "RTBuilder v0.1 - "..sys.File(filename).name
end

----------------------------- Window menu
local WindowMenu = ui.Menu()
mainWindow.menu:add("&Window").submenu = WindowMenu

-- Window => New 
local WindowNew = WindowMenu:add("&New\tCtrl+N")
function WindowNew:onClick()
    if formWindow ~= nil then
        if not formWindow:onClose() then
            return
        end
    end
    if formWindow == nil then
        formWindow = ui.Window("Window")
        Widgets = {}
        formWindow.tracker = Tracker(formWindow)
        formWindow.name = "Window"
        formWindow:center()
        formWindow.y = mainWindow.y + mainWindow.height + 60
        formWindow:show()        
        tracker = formWindow.tracker
        formWindow.onClick = function(self) tracker:stop(); inspector.Update(self) end
        formWindow.onMove = function(self) inspector.Update(self) end
        formWindow.onClose = onClose
    end
end

-- Window => Open 
local WindowOpen = WindowMenu:add("&Open...\tCtrl+O")
function WindowOpen:onClick()
    if formWindow ~= nil then
        formWindow:onClose()
    end
    if formWindow == nil then
        if loadWindow() then
            mainWindow:UpdateTitle(filename)
            formWindow.tracker = Tracker(formWindow)
            formWindow:show()        
            formWindow.onClick = function(self) tracker:stop(); inspector.Update(self) end
            formWindow.onMove = function(self) inspector.Update(self) end
            formWindow.onClose = onClose
            tracker = formWindow.tracker
        end
    end
end

-- Window => Save
local WindowSave = WindowMenu:add("&Save\tCtrl+S")
function WindowSave:onClick()
	saveWindow()
    mainWindow:UpdateTitle()
end

-- Window => Save as
local WindowSaveAs = WindowMenu:add("S&ave as...")
function WindowSaveAs:onClick()
    local fname = filename
    filename = nil
    if saveWindow() then
        mainWindow:UpdateTitle()
    else
        filename = fname
    end
end

-- Window => Close
local WindowClose = WindowMenu:add("&Close")
function WindowClose:onClick()
    if formWindow ~= nil then
        formWindow:onClose()
    end
end

-- Window => Exit
local WindowExit = WindowMenu:add("E&xit")
function WindowExit:onClick()
    if formWindow ~= nil then
        formWindow:onClose()
        if formWindow ~= nil then
            return
        end
    end
	mainWindow:hide()
end


require "Widgets"

mainWindow:center()
mainWindow.y = 60
WindowNew:onClick()

ui.run(mainWindow):wait()
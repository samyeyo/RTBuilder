local ui = require "ui"
require "tracker"
require "dump"

local VERSION = require "version"

Widgets = {}
onContext = {}

filename = nil
modified = false
formWindow = nil
mainWindow = ui.Window("RTBuilder "..VERSION, "single", 800, 110)
widgetsTab = ui.Tab(mainWindow, {}, 6, 6, 790,80)
mainWindow.menu = ui.Menu()

package.path = package.path..sys.currentdir..'/?/init.lua;'
package.cpath = package.cpath..sys.currentdir..'/widgets/?.dll;'

for entry in sys.Directory(sys.currentdir.."/context"):list("*.lua") do
    onContext[entry.name:gsub("%.lua", "")] = loadfile(entry.fullpath)()
end

function Tracker(widget)
    local t = ui.Tracker(widget)
    t.onContext = function ()
        local func = onContext[t.widget and t.widget.type or "Window"] or false
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
        modified = true
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
        formWindow.visible = false
		ui.remove(formWindow)
		inspector:hide()
        formWindow = nil
        filename = nil
        mainWindow:UpdateTitle()
    end
end

function onClose(self)
    if self ~= nil then
        if not filename then
            if modified then
                result = ui.confirm("The current Window is about to be closed.\nDo you want to save before continuing ?")
                if result == "cancel" then
                    return false
                elseif result == "yes" then
                    saveWindow()  
                end 
            end
        elseif modified then
            saveWindow()
        end
        CloseWindow(false)
    end
    return true
end    

function mainWindow:onClose()
   return onClose(formWindow)
end

function mainWindow:UpdateTitle()
    mainWindow.title = filename == nil and "RTBuilder "..VERSION or "RTBuilder "..VERSION.." - "..sys.File(filename).name
end

function init_formwindow(win)
    win.onClick = function(self) if tracker.widget then tracker:stop(); end inspector.Update(self) end
    win.onMove = function(self) inspector:onTrack(self) end
    win.onClose = onClose
    win.onContext = function (self)
        local func = onContext.Window or false
        if func then
            win:popup(func(self))
        end
    end
    win.onMinimize = function(self) mainWindow:minimize() end  
    win.onRestore = function(self) mainWindow:restore() end  
    win.tracker = Tracker(win)
    tracker = win.tracker
end

----------------------------- Window menu
local WindowMenu = ui.Menu()
mainWindow.menu:add("&Window").submenu = WindowMenu

-- Window => New 
local WindowNew = WindowMenu:add("&New")

function WindowNew:onClick()
    if formWindow ~= nil then
        if not formWindow:onClose() then
            return
        end
    end
    if formWindow == nil then
        local style = self.text:lower()
        inspector.Update("Window")
        formWindow = inspector.registry.Window("Window")
        Widgets = {}
        formWindow._style = "dialog"
        formWindow.name = "Window"
        formWindow:center()
        formWindow.y = mainWindow.y + mainWindow.height + 70
        formWindow.height = 400
        formWindow:show()           
        init_formwindow(formWindow)   
        mainWindow:tofront()
        inspector.Update(formWindow)
    end
end

local function do_openfile(f)
    if formWindow ~= nil then
        if not formWindow:onClose() then
            return
        end
    end  
    ui.update()
    local result = loadWindow(f)
    if result then
        filename = result
        mainWindow:UpdateTitle(filename)
        formWindow.tracker = Tracker(formWindow)
        formWindow:show()        
        formWindow.onClick = function(self) tracker:stop(); inspector.Update(self) end
        formWindow.onMove = function(self) inspector.Update(self) end
        formWindow.onClose = onClose
        tracker = formWindow.tracker
        inspector.Update(formWindow)
    elseif result == false then
        ui.error("The provided file is not a valid RTBuilder Window")
    end
end

-- Window => Open 
local WindowOpen = WindowMenu:add("&Open...\tCtrl+O")
function WindowOpen:onClick()
    do_openfile()
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
        onClose(formWindow)
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

function mainWindow:onMinimize()
    widgetsTab.width = mainWindow.width-10
    if formWindow then
        formWindow:minimize()
    end
end

function mainWindow:onRestore()
    widgetsTab.width = mainWindow.width-10
    if formWindow then
        formWindow:restore()
    end
end

------------------- Main window keyboard shortcuts
mainWindow:shortcut("o", WindowOpen.onClick, true)
mainWindow:shortcut("s", WindowSave.onClick, true)


------------------- Main window default position
mainWindow:center()
mainWindow.y = 60
mainWindow.topmost = true

inspector = require "inspector"
require "widgets"

mainWindow:show()

if #arg > 1 or (embed and #arg > 0) then
    local openfile = sys.File(embed and arg[1] or arg[2])
    if openfile.exists then
        do_openfile(openfile)
    end
end

if formWindow == nil then
    ------------------- Create a new empty Window
    WindowNew:onClick()
end

-- Task to update menu items state
async(function()
    while true do
        WindowClose.enabled = formWindow
        WindowSaveAs.enabled = formWindow
        WindowSave.enabled = formWindow
        sleep()
    end
end)

ui.run(mainWindow):wait()
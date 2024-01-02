local ui = require 'ui'

local Window = ui.Window("Window", 640, 480)
Window.name = 'Window'
Window.fontsize = 9
Window.font = 'Segoe UI'
Window.enabled = true
Window.y = 230
Window.traytooltip = ''
Window.fontstyle = {['italic'] = false,['underline'] = false,['strike'] = false,['bold'] = false,['heavy'] = false,['thin'] = false }
Window.cursor = 'arrow'
Window.title = 'Window'
Window.bgcolor = 15790320
Window.width = 640
Window.x = 639
Window.fullscreen = false
Window.height = 480
Window.name = 'Window'

local Label1 = ui.Label(Window, [[Label1]], 195, 145, 232, 143)
Label1.name = 'Label1'
Label1.fontsize = 9
Label1.font = 'Segoe UI'
Label1.enabled = true
Label1.fontstyle = {['italic'] = false,['underline'] = false,['strike'] = false,['bold'] = false,['heavy'] = false,['thin'] = false }
Label1.y = 145
Label1.textalign = 'left'
Label1.visible = true
Label1.height = 143
Label1.text = [[Label1]]
Label1.tooltip = ''
Label1.cursor = 'arrow'
Label1.width = 232
Label1.x = 195
Label1.name = 'Label1'
Label1.enabled = true
Label1.visible = true
Label1.bgcolor = 16711680
Label1.fgcolor = 0
return Window, { ['Label1'] = Label1 }

local ui = require 'ui'

local Window = ui.Window("Window", 640, 480)
Window.name = 'Window'
Window.title = 'Window'
Window.bgcolor = 15790320
Window.width = 640
Window.traytooltip = ''
Window.enabled = true
Window.fontsize = 9
Window.font = 'Segoe UI'
Window.x = 639
Window.height = 480
Window.fontstyle = {['thin'] = true,['strike'] = false,['italic'] = false,['underline'] = false,['heavy'] = false,['bold'] = false }
Window.cursor = 'arrow'
Window.y = 210
Window.name = 'Window'

local Button1 = ui.Button(Window, [[Button1]], 293, 226, 54, 27)
Button1.name = 'Button1'
Button1.cursor = 'cardinal'
Button1.width = 54
Button1.y = 226
Button1.tooltip = ''
Button1.enabled = true
Button1.fontsize = 9
Button1.font = 'Segoe UI'
Button1.x = 293
Button1.height = 27
Button1.visible = true
Button1.text = [[Button1]]
Button1.fontstyle = {['thin'] = true,['strike'] = false,['italic'] = false,['underline'] = false,['heavy'] = false,['bold'] = false }
Button1.name = 'Button1'
Button1.hastext = true
return Window, { ['Button1'] = Button1 }

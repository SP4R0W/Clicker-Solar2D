local composer = require("composer")
local widget = require("widget")

local background
local mainButton

local musicState = composer.setVariable("musicState",true)
local sfxState = composer.setVariable("sfxState",true)

local menuTheme = audio.loadSound("Audio/menuTheme.wav")

function clicked(event)
    if event.phase == "ended" then
        background:removeEventListener("touch",clicked)
        display.remove(background)

        audio.play(menuTheme,{channel=1})
        composer.gotoScene("maingame")
    end
end

audio.reserveChannels(3)

math.randomseed(os.time())

display.setDefault("background",128,128,128)

background = display.newImageRect("Images/logo.png",480,320)
background.x = display.contentCenterX
background.y = display.contentCenterY
background.alpha = 0
transition.fadeIn(background,{time=2500})

background:addEventListener("touch",clicked)

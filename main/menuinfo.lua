local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local font = "lato.ttf"

local buttonClicked

local background
local title
local mainText

local titleText = "Info:"
local mainTextText = "Tap on the main image \n to get points. Use points \n to buy songs, backgrounds \n and upgrades in the shop. \n Tap on the shop image in \n the main game to enter it."
local currentType = "info"

local changeButton
local gameButton

local buttonSprites =
{
    "Images/Buttons/arrowShopRight.png",
    "Images/Buttons/gameButtonLarge.png"
}

local function changeText(event)
    if event.phase == "ended" then
        print(currentType)
        if currentType == "info" then
            titleText = "Credits:"
            mainTextText = " All assets were used\n without permission from\n the original authors. This\n game has not been made\n for any profit and it is \n free to play no matter what.\n Coded by SP4R0W."
            currentType = "credits"
        elseif currentType == "credits" then
            titleText = "Info:"
            mainTextText = "Tap on the food image\n to get points. Use points\n to buy songs, backgrounds\n and upgrades in the shop.\n Tap on the shop image in\n the main game to enter it."
            currentType = "info"
        end

        title.alpha = 0
        mainText.alpha = 0

        title.text = titleText
        mainText.text = mainTextText

        transition.fadeIn(title,{time=1000})
        transition.fadeIn(mainText,{time=1000})
	end
end

local function gotoMenu(event)
	if event.phase == "ended" then
		audio.play(buttonClicked,{channel=3})
		composer.gotoScene("maingame")
	end
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    local params = event.params

    buttonClicked = audio.loadSound("Audio/buttonClicked.mp3")

    -- Code here runs when the scene is first created but has not yet appeared on screen
    background = display.newImageRect(params.bg,display.actualContentWidth,display.actualContentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    title = display.newText(titleText,display.contentCenterX,display.contentCenterY*0.05,font,50)
	title:setFillColor(255,255,255)
    title.alpha = 0
    transition.fadeIn(title,{time=1000})
    sceneGroup:insert(title)

    mainText = display.newText(mainTextText,display.contentCenterX,display.contentCenterY * 0.75,font,20,"center")
	mainText:setFillColor(255,255,255)
    mainText.alpha = 0
    transition.fadeIn(mainText,{time=1000,delay=500})
    sceneGroup:insert(mainText)

    changeButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 1.4,
			id = "menuButton1",
			onRelease = changeText,
			defaultFile = buttonSprites[1],
			overFile = buttonSprites[1],
		}
	)
    changeButton.alpha = 0
    transition.fadeIn(changeButton,{time=1000,delay=500})
    sceneGroup:insert(changeButton)

    gameButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 1.9,
			id = "menuButton2",
			onRelease = gotoMenu,
			defaultFile = buttonSprites[2],
			overFile = buttonSprites[2],
		}
	)
    gameButton.alpha = 0
    transition.fadeIn(gameButton,{time=1000})
    sceneGroup:insert(gameButton)
end


-- show()
function scene:show( event )

end


-- hide()
function scene:hide( event )
    if ( event.phase == "did" ) then
        composer.removeScene("menuinfo")
    end
end


-- destroy()
function scene:destroy( event )
    audio.dispose(buttonClicked)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
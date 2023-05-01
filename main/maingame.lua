local composer = require("composer")
local widget = require("widget")
local json = require("json")
local facebook = require("plugin.facebook.v4a")

local scene = composer.newScene()

local font = "lato.ttf"
local filePath = system.pathForFile("Data/saveData.json")
local data = {}

local score
local upgrade
local moneyAmount

local gameTheme
local buttonClicked
local clickSound

local background
local item

local title
local scoreText
local moneyText
local upgradeText
local helpText

local infoButton
local optionsButton
local shopButton
local facebookButton

local buttonSprites =
{
    "Images/Buttons/settingsButton.png",
    "Images/Buttons/shopButton.png",
    "Images/Buttons/facebookButton.png",
    "Images/Buttons/creditsButton.png"
}

local function loadData()
    local file = io.open(filePath,"r")
    if file then
        local contents = file:read("*a")
        file:close()

		data = json.decode(contents)

        moneyAmount = data["money"]
        score = data["totalClicks"]
        upgrade = data["upgrade"]
    end
end

local function saveData()
    data["totalClicks"] = score
    data["money"] = moneyAmount

    local file = io.open(filePath,"w")
    if file then
        file:write(json.encode(data))
        file:close()
    end
end

local function itemClicked(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        helpText.alpha = 0

        audio.play(clickSound,{channel=3})

        score = score + 1
        moneyAmount = moneyAmount + upgrade

        moneyText.text = "Money: " .. moneyAmount
        scoreText.text = "Total clicks: " .. score

        saveData()

        local img1 = display.newImage(data["currentItem"],math.random(display.contentCenterX * 0.2, display.contentCenterX * 1.8),display.contentCenterY * 1.8)
        img1:scale(0.2,0.2)
        transition.moveTo(img1,{time=250,x=display.contentCenterX,y=display.contentCenterY * 1.5,onComplete=function() display.remove(img1) end})
    end
end

local function musicPlay()
    if audio.isChannelPlaying(1) == false then
        gameTheme = audio.loadStream(data["currentSong"])
        audio.play(gameTheme,{channel=1,loops=-1})
    end
end

local function gotoShop(event)
    if event.phase == "ended" then
        audio.play(buttonClicked,{channel=3})
        composer.gotoScene("menushop",{params={bg=data["currentBackground"]}})
    end
end

local function gotoInfo(event)
    if event.phase == "ended" then
        audio.play(buttonClicked,{channel=3})
        composer.gotoScene("menuinfo",{params={bg=data["currentBackground"]}})
    end
end

local function gotoOptions(event)
    if event.phase == "ended" then
        audio.play(buttonClicked,{channel=3})
        composer.gotoScene("menuoptions",{params={bg=data["currentBackground"]}})
    end
end

local function facebookListener( event )
    if ( "fbinit" == event.name ) then
        facebook.logout()
    end
end

local function facebookPostMessage(event)
    if ( "session" == event.type ) then
        if ( "login" == event.phase ) then
            -- Post the message
            facebook.showDialog("link",{link="https://www.coronalabs.com/",title ="My score!",description="My score in Clicker is: " .. score .. "! Can you beat it? Created using Corona Labs."})
            facebook.logout()
        end
    end
end

local function logInFacebook(event)
    -- Facebook functionality no longer works

    -- if event.phase == "ended" then
    --     audio.play(buttonClicked,{channel=3})
    --     if facebook.isActive then
    --         facebook.login(facebookPostMessage,{"publish_actions"}) -- Login into facebook
    --     end
    -- end
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    loadData()

    gameTheme = audio.loadStream(data["currentSong"])
    buttonClicked = audio.loadSound("Audio/buttonClicked.mp3")
    clickSound = audio.loadSound("Audio/click.mp3")

    -- Code here runs when the scene is first created but has not yet appeared on screen
    background = display.newImageRect(data["currentBackground"],display.actualContentWidth,display.actualContentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    title = display.newText("Clicker",display.contentCenterX,display.contentCenterY*0.3,font,50)
	title:setFillColor(255,255,255)
    sceneGroup:insert(title)

    scoreText = display.newText("Total clicks: " .. score,display.contentCenterX,display.contentCenterY*0.55,font,30)
	scoreText:setFillColor(255,255,255)
    sceneGroup:insert(scoreText)

    moneyText = display.newText("Money: " .. moneyAmount,display.contentCenterX,display.contentCenterY*0.7,font,30)
	moneyText:setFillColor(255,255,255)
    sceneGroup:insert(moneyText)

    upgradeText = display.newText("Upgrade: " .. upgrade,display.contentCenterX,display.contentCenterY*0.85,font,30)
	upgradeText:setFillColor(255,255,255)
    sceneGroup:insert(upgradeText)

    helpText = display.newText("Tap the food to start!",display.contentCenterX,display.contentCenterY*1.8,font,20)
	helpText:setFillColor(255,255,255)
    sceneGroup:insert(helpText)

    if score == 0 then helpText.alpha = 1 else helpText.alpha = 0 end

    item = display.newImage(data["currentItem"],display.contentCenterX,display.contentCenterY * 1.3)
    sceneGroup:insert(item)

    shopButton = widget.newButton(
		{
			x = display.contentCenterX * 0.75,
			y = display.contentCenterY * 0.015,
			id = "menuButton1",
			onRelease = gotoShop,
			defaultFile = buttonSprites[2],
			overFile = buttonSprites[2],
		}
	)
    sceneGroup:insert(shopButton)

    facebookButton = widget.newButton(
		{
			x = display.contentCenterX * 1.1,
			y = display.contentCenterY * 0.015,
			id = "menuButton2",
			onRelease = logInFacebook,
			defaultFile = buttonSprites[3],
			overFile = buttonSprites[3],
		}
	)
    sceneGroup:insert(facebookButton)

    infoButton = widget.newButton(
		{
			x = display.contentCenterX * 1.45,
			y = display.contentCenterY * 0.015,
			id = "menuButton3",
			onRelease = gotoInfo,
			defaultFile = buttonSprites[4],
			overFile = buttonSprites[4],
		}
	)
    sceneGroup:insert(infoButton)

    optionsButton = widget.newButton(
		{
			x = display.contentCenterX * 1.8,
			y = display.contentCenterY * 0.015,
			id = "menuButton4",
			onRelease = gotoOptions,
			defaultFile = buttonSprites[1],
			overFile = buttonSprites[1],
		}
	)
    sceneGroup:insert(optionsButton)

    facebook.init(facebookListener)
end


-- show()
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "did" ) then
        system.activate("multitouch")
        musicPlay()
        item:addEventListener("touch",itemClicked)
    end
end


-- hide()
function scene:hide( event )

    if ( event.phase == "did" ) then

        timer.cancelAll()

        composer.removeScene("maingame")
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
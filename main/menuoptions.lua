local composer = require("composer")
local widget = require("widget")
local json = require("json")

local scene = composer.newScene()

local musicState = composer.getVariable("musicState")
local sfxState = composer.getVariable("sfxState")

local font = "lato.ttf"
local filePath = system.pathForFile("Data/saveData.json")
local data = {}

local buttonClicked

local background
local title

local musicButton
local sfxButton
local resetButton
local gameButton

local musicSequence =
{
    {
        name = "active",
        frames = {1}
    },
    {
        name = "unactive",
        frames = {2}
    }
}

local musicOptions =
{
    width = 96,
    height = 96,
    numFrames = 2
}

local musicButtonSheet = graphics.newImageSheet("Images/Buttons/musicButtons.png",musicOptions)

local sfxSequence =
{
    {
        name = "active",
        frames = {1}
    },
    {
        name = "unactive",
        frames = {2}
    }
}

local sfxOptions =
{
    width = 96,
    height = 96,
    numFrames = 2
}

local sfxButtonSheet = graphics.newImageSheet("Images/Buttons/sfxButtons.png",sfxOptions)

local buttonSprites =
{
    "Images/Buttons/gameButtonLarge.png",
    "Images/Buttons/resetButton.png"
}

local function setSequences()
    if musicState == true then
        musicButton:setSequence("active")
    else
        musicButton:setSequence("unactive")
    end

    if sfxState == true then
        sfxButton:setSequence("active")
    else
        sfxButton:setSequence("unactive")
    end
end

local function changeMusic()

    if musicState == true then
        composer.setVariable("musicState",false)
        audio.setVolume(0,{channel=1})
    elseif musicState == false then
        composer.setVariable("musicState",true)
        audio.rewind(0)
        timer.performWithDelay(550,function() audio.setVolume(1,{channel=1}) end)
    end

    musicState = composer.getVariable("musicState")
    setSequences()
end

local function changeSFX()

    if sfxState == true then
        composer.setVariable("sfxState",false)
        audio.setVolume(0,{channel=2})
        audio.setVolume(0,{channel=3})
    elseif sfxState == false then
        composer.setVariable("sfxState",true)
        audio.setVolume(1,{channel=2})
        audio.setVolume(1,{channel=3})
    end

    sfxState = composer.getVariable("sfxState")
    setSequences()
end

local function resetProgress(event)
    if event.phase == "ended" then
        audio.play(buttonClicked,{channel=3})
        local file = io.open(filePath,"r")

        if file then
            local contents = file:read("*a")
            file:close()
            data = json.decode(contents)
            data["upgrade"] = 1
            data["money"] = 0
            data["totalClicks"] = 0
            data["currentBackground"] = "Images/Backgrounds/1.png"
            data["currentItem"] = "Images/Items/1.png"
            data["currentSong"] = "Images/Songs/1.mp3"

            for x = 2,#data["ownedSongs"] do
                data["ownedSongs"][x] = 0
            end

            for x = 2,#data["ownedBackgrounds"] do
                data["ownedBackgrounds"][x] = 0
            end

            for x = 2,#data["ownedItems"] do
                data["ownedItems"][x] = 0
            end

            audio.stop(1)

            file = io.open(filePath,"w")
            file:write(json.encode(data))
            file:close()
        end
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

    title = display.newText("Settings:",display.contentCenterX,display.contentCenterY*0.05,font,50)
	title:setFillColor(255,255,255)
    title.alpha = 0
    transition.fadeIn(title,{time=1000})
    sceneGroup:insert(title)

    musicButton = display.newSprite(musicButtonSheet,musicSequence)
    musicButton.x = display.contentCenterX * 0.5
    musicButton.y = display.contentCenterY
    musicButton.myName = "menuButton2"
    musicButton.alpha = 0
    musicButton:setSequence("active")
    transition.fadeIn(musicButton,{time=1000,delay=500})
    sceneGroup:insert(musicButton)

    sfxButton = display.newSprite(sfxButtonSheet,sfxSequence)
    sfxButton.x = display.contentCenterX * 1.5
    sfxButton.y = display.contentCenterY
    sfxButton.myName = "menuButton3"
    sfxButton.alpha = 0
    sfxButton:setSequence("active")
    transition.fadeIn(sfxButton,{time=1000,delay=500})
    sceneGroup:insert(sfxButton)
    setSequences()

    resetButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 0.5,
			id = "menuButton1",
			onRelease = resetProgress,
			defaultFile = buttonSprites[2],
			overFile = buttonSprites[2],
		}
	)
    resetButton.alpha = 0
    transition.fadeIn(resetButton,{time=1000,delay=500})
    sceneGroup:insert(resetButton)

    gameButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 1.9,
			id = "menuButton4",
			onRelease = gotoMenu,
			defaultFile = buttonSprites[1],
			overFile = buttonSprites[1],
		}
	)
    gameButton.alpha = 0
    transition.fadeIn(gameButton,{time=1000})
    sceneGroup:insert(gameButton)

end


-- show()
function scene:show( event )
    if ( event.phase == "did" ) then
        musicButton:addEventListener("tap",changeMusic)
        sfxButton:addEventListener("tap",changeSFX)
    end
end


-- hide()
function scene:hide( event )

    if ( event.phase == "did" ) then
        musicButton:removeEventListener("tap",changeMusic)
        sfxButton:removeEventListener("tap",changeSFX)

        composer.removeScene("menuoptions")
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
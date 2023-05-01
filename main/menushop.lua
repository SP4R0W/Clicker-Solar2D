local composer = require("composer")
local widget = require("widget")
local json = require("json")

local scene = composer.newScene()

local font = "lato.ttf"
local filePath = system.pathForFile("Data/saveData.json")
local data = {}

local buttonClicked
local buySound
local errorSound
local equipSound

local background
local title
local itemTitle
local moneyText
local priceText
local currentItemImg
local currentBgImg
local equippedText

local changeShopLeftButton
local changeShopRightButton
local changeItemLeftButton
local changeItemRightButton
local purchaseButton
local playButton
local gameButton

local itemSequence =
{
    {
        name = "1",
        frames = {1}
    },
    {
        name = "2",
        frames = {2}
    },
    {
        name = "3",
        frames = {3}
    },
    {
        name = "4",
        frames = {4}
    },
    {
        name = "5",
        frames = {5}
    },
    {
        name = "6",
        frames = {6}
    },
    {
        name = "7",
        frames = {7}
    },
    {
        name = "8",
        frames = {8}
    },
    {
        name = "9",
        frames = {9}
    },
    {
        name = "10",
        frames = {10}
    },
    {
        name = "11",
        frames = {11}
    },
    {
        name = "12",
        frames = {12}
    },
    {
        name = "13",
        frames = {13}
    },
    {
        name = "14",
        frames = {14}
    },
    {
        name = "15",
        frames = {15}
    },
    {
        name = "16",
        frames = {16}
    },
    {
        name = "17",
        frames = {17}
    },
    {
        name = "18",
        frames = {18}
    },
    {
        name = "19",
        frames = {19}
    },
    {
        name = "20",
        frames = {20}
    },
    {
        name = "21",
        frames = {21}
    },
    {
        name = "22",
        frames = {22}
    },
    {
        name = "23",
        frames = {23}
    },
    {
        name = "24",
        frames = {24}
    }
}

local itemOptions =
{
    width = 119,
    height = 114,
    numFrames = 24
}

local itemSheet = graphics.newImageSheet("Images/Items/shopItems.png",itemOptions)

local backgroundSequence =
{
    {
        name = "1",
        frames = {1}
    },
    {
        name = "2",
        frames = {2}
    },
    {
        name = "3",
        frames = {3}
    },
    {
        name = "4",
        frames = {4}
    },
    {
        name = "5",
        frames = {5}
    },
    {
        name = "6",
        frames = {6}
    },
    {
        name = "7",
        frames = {7}
    },
    {
        name = "8",
        frames = {8}
    },
    {
        name = "9",
        frames = {9}
    },
    {
        name = "10",
        frames = {10}
    },
    {
        name = "11",
        frames = {11}
    },
    {
        name = "12",
        frames = {12}
    },
    {
        name = "13",
        frames = {13}
    },
    {
        name = "14",
        frames = {14}
    },
    {
        name = "15",
        frames = {15}
    }
}

local backgroundOptions =
{
    width = 68,
    height = 120,
    numFrames = 15
}

local backgroundSheet = graphics.newImageSheet("Images/Backgrounds/shopBackgrounds.png",backgroundOptions)

local shopSequence =
{
    {
        name = "buy",
        frames = {1}
    },
    {
        name = "equip",
        frames = {2}
    }
}

local shopOptions =
{
    width = 48,
    height = 48,
    numFrames = 2
}

local shopButtonSheet = graphics.newImageSheet("Images/Buttons/shopButtons.png",shopOptions)

local buttonSprites =
{
    "Images/Buttons/arrowShopLeft.png",
    "Images/Buttons/arrowShopRight.png",
    "Images/Buttons/arrowItemLeft.png",
    "Images/Buttons/arrowItemRight.png",
    "Images/Buttons/gameButtonLarge.png",
    "Images/Buttons/playButton.png"
}

local itemPrices = {0,100,250,500,1000,2500,5000,7500,10000,15000,20000,25000,30000,35000,40000,50000,65000,75000,85000,90000,100000,25000,50000,1000000}
local itemUpgrades = {1,2,3,5,10,15,20,25,50,65,75,100,125,150,175,200,250,350,450,500,650,750,850,1000}
local backgroundPrices = {0,500,1000,2500,5000,7500,8500,10000,15000,25000,35000,50000,65000,85000,100000}
local trackPrices = {0,1000,2500,5000,7500,10000,25000,50000,75000,100000}

local currentFolderNameType = "Items"
local currentDataNameType = "ownedItems"
local currentDataCurrentType = "currentItem"
local currentList = itemSequence
local currentImage
local currentType = 1
local currentItem = 1
local currentPrices = itemPrices
local currentPrice = itemPrices[1]

local function gotoMenu(event)
	if event.phase == "ended" then
		audio.play(buttonClicked,{channel=3})
		composer.gotoScene("maingame")
	end
end

local function loadData()
    local file = io.open(filePath,"r")
    if file then
        local contents = file:read("*a")
        file:close()
		data = json.decode(contents)
    end
end

local function saveData()
    local file = io.open(filePath,"w")
    if file then
        file:write(json.encode(data))
        file:close()
    end
end

local function checkEquipped()
    if currentType == 1 then
        if data["currentItem"] == "Images/Items/" .. tostring(currentItem) .. ".png" then
            equippedText.alpha = 1
        else
            equippedText.alpha = 0
        end
    elseif currentType == 2 then
        if data["currentBackground"] == "Images/Backgrounds/" .. tostring(currentItem) .. ".png" then
            equippedText.alpha = 1
        else
            equippedText.alpha = 0
        end
    elseif currentType == 3 then
        if data["currentSong"] == "Images/Songs/" .. tostring(currentItem) .. ".mp3" then
            equippedText.alpha = 1
        else
            equippedText.alpha = 0
        end
    end
end


local function redrawShopType()
    transition.cancel(currentItemImg)
    currentImage.alpha = 0

    if currentType == 1 then
        itemTitle.text = "Items:"
        currentFolderNameType = "Items"
        currentDataNameType = "ownedItems"
        currentDataCurrentType = "currentItem"

        currentItem = 1
        currentList = itemSequence
        currentPrices = itemPrices
        currentPrice = itemPrices[1]

        currentImage = currentItemImg
        currentImage.alpha = 1
        currentImage:setSequence("1")

        priceText.text = "Price: " .. currentPrices[1]
    elseif currentType == 2 then
        itemTitle.text = "Backgrounds:"
        currentFolderNameType = "Backgrounds"
        currentDataNameType = "ownedBackgrounds"
        currentDataCurrentType = "currentBackground"

        currentItem = 1
        currentList = backgroundSequence
        currentPrices = backgroundPrices
        currentPrice = backgroundPrices[1]

        currentImage = currentBgImg
        currentImage.alpha = 1
        currentImage:setSequence("1")

        priceText.text = "Price: " .. currentPrices[1]
    elseif currentType == 3 then
        itemTitle.text = "Tracks:"
        currentFolderNameType = "Songs"
        currentDataNameType = "ownedSongs"
        currentDataCurrentType = "currentSong"

        currentItem = 1
        currentList = trackPrices
        currentPrices = trackPrices
        currentPrice = currentPrices[1]

        currentImage = playButton
        currentImage.alpha = 1

        priceText.text = "Price: " .. currentPrices[1]
    end
end

local function changeShopType(event)
    if event.phase == "ended" then
        local id = event.target["id"]

        if id == "menuButton1" then
            currentType = currentType - 1
            if currentType < 1 then
                currentType = 3
            end
        elseif id == "menuButton2" then
            currentType = currentType + 1
            if currentType > 3 then
                currentType = 1
            end
        end

        redrawShopType()
        checkEquipped()
	end
end

local function changeItem(event)
    if event.phase == "ended" then
        local id = event.target["id"]

        if audio.isChannelPlaying(2) then -- Stop the preview
            audio.stop(2)
            audio.resume(1)
        end

        if id == "menuButton3" then
            currentItem = currentItem - 1
            if currentItem < 1 then
                currentItem = #currentList
            end
        elseif id == "menuButton4" then
            currentItem = currentItem + 1
            if currentItem > #currentList then
                currentItem = 1
            end
        end

        checkEquipped()

        currentPrice = currentPrices[currentItem]
        priceText.text = "Price: " .. currentPrices[currentItem]
        if currentType ~= 3 then
            currentImage:setSequence(tostring(currentItem))
        end

        if data[currentDataNameType][currentItem] == 1 then
            purchaseButton:setSequence("equip")
        else
            purchaseButton:setSequence("buy")
        end
	end
end

local function purchaseItem()
    if data["money"] >= currentPrice then
        audio.play(buySound,{channel=3})

        data["money"] = data["money"] - currentPrice
        data[currentDataNameType][currentItem] = 1
        if currentDataCurrentType ~= "currentSong" then
            data[currentDataCurrentType] = "Images/" .. currentFolderNameType .. "/" .. tostring(currentItem) .. ".png"
        else
            data[currentDataCurrentType] = "Images/" .. currentFolderNameType .. "/" .. tostring(currentItem) .. ".mp3"
        end

        if currentType == 1 then
            data["upgrade"] = itemUpgrades[currentItem]
        end

        if currentDataCurrentType == "currentSong" then
            audio.stop(1)
            audio.stop(2)

            local gameTheme = audio.loadStream(data["currentSong"])
            audio.play(gameTheme,{channel=1,loops=-1})
        end
        purchaseButton:setSequence("equip")
        moneyText.text = "Money: " .. data["money"]
        saveData()
        checkEquipped()
    else
        audio.play(errorSound,{channel=3})
    end
end

local function equipItem()
    audio.play(equipSound,{channel=3})

    if currentDataCurrentType ~= "currentSong" then
        data[currentDataCurrentType] = "Images/" .. currentFolderNameType .. "/" .. tostring(currentItem) .. ".png"
    else
        data[currentDataCurrentType] = "Images/" .. currentFolderNameType .. "/" .. tostring(currentItem) .. ".mp3"
        audio.stop(1)
        audio.stop(2)

        local gameTheme = audio.loadStream(data["currentSong"])
        audio.play(gameTheme,{channel=1,loops=-1})
    end

    saveData()
    checkEquipped()
end

local function checkButtonType()
    if purchaseButton.sequence == "buy" then
        purchaseItem()
    else
        equipItem()
    end
end

local function playPreviewSong(event)
    if event.phase == "ended" then
        local previewSong = audio.loadStream("Images/Songs/" .. tostring(currentItem) .. ".mp3")
        if audio.isChannelPlaying(2) then
            audio.stop(2)
            audio.resume(1)
            audio.dispose(previewSong)
        else
            audio.pause(1)
            audio.play(previewSong,{channel=2})
        end
	end
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    local params = event.params

    loadData()
    buttonClicked = audio.loadSound("Audio/buttonClicked.mp3")
    buySound = audio.loadSound("Audio/buy.mp3")
    errorSound = audio.loadSound("Audio/fail.mp3")
    equipSound = audio.loadSound("Audio/equip.mp3")

    background = display.newImageRect(params.bg,display.actualContentWidth,display.actualContentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    title = display.newText("Shop:",display.contentCenterX,display.contentCenterY*0.05,font,50)
	title:setFillColor(255,255,255)
    title.alpha = 0
    transition.fadeIn(title,{time=1000})
    sceneGroup:insert(title)

    itemTitle = display.newText("Items:",display.contentCenterX,display.contentCenterY*0.3,font,30)
	itemTitle:setFillColor(255,255,255)
    itemTitle.alpha = 0
    transition.fadeIn(itemTitle,{time=1000,delay=500})
    sceneGroup:insert(itemTitle)

    moneyText = display.newText("Money: " .. data["money"],display.contentCenterX * 1.5,display.contentCenterY * 1.25,font,20)
	moneyText:setFillColor(255,255,255)
    moneyText.alpha = 0
    transition.fadeIn(moneyText,{time=1000,delay=500})
    sceneGroup:insert(moneyText)

    priceText = display.newText("Price: " .. currentPrices[1],display.contentCenterX * 0.5,display.contentCenterY * 1.25,font,20)
	priceText:setFillColor(255,255,255)
    priceText.alpha = 0
    transition.fadeIn(priceText,{time=1000,delay=500})
    sceneGroup:insert(priceText)

    equippedText = display.newText("Equipped!",display.contentCenterX,display.contentCenterY*1.6,font,20)
	equippedText:setFillColor(255,255,255)
    equippedText.alpha = 0
    sceneGroup:insert(equippedText)

    currentItemImg = display.newSprite(itemSheet,itemSequence)
    currentItemImg.x = display.contentCenterX
    currentItemImg.y = display.contentCenterY * 0.85
    currentItemImg.alpha = 0
    currentItemImg:setSequence("1")
    transition.fadeIn(currentItemImg,{time=1000,delay=500})
    sceneGroup:insert(currentItemImg)
    currentImage = currentItemImg

    currentBgImg = display.newSprite(backgroundSheet,backgroundSequence)
    currentBgImg.x = display.contentCenterX
    currentBgImg.y = display.contentCenterY * 0.85
    currentBgImg.alpha = 0
    currentBgImg:setSequence("1")
    sceneGroup:insert(currentBgImg)

    playButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 0.8,
			id = "menuButton7",
			onRelease = playPreviewSong,
			defaultFile = buttonSprites[6],
			overFile = buttonSprites[6],
		}
	)
    playButton.alpha = 0
    sceneGroup:insert(playButton)

    changeShopLeftButton = widget.newButton(
		{
			x = display.contentCenterX * 0.2,
			y = display.contentCenterY * 0.35,
			id = "menuButton1",
			onRelease = changeShopType,
			defaultFile = buttonSprites[1],
			overFile = buttonSprites[1],
		}
	)
    changeShopLeftButton.alpha = 0
    transition.fadeIn(changeShopLeftButton,{time=1000,delay=500})
    sceneGroup:insert(changeShopLeftButton)

    changeShopRightButton = widget.newButton(
		{
			x = display.contentCenterX * 1.8,
			y = display.contentCenterY * 0.35,
			id = "menuButton2",
			onRelease = changeShopType,
			defaultFile = buttonSprites[2],
			overFile = buttonSprites[2],
		}
	)
    changeShopRightButton.alpha = 0
    transition.fadeIn(changeShopRightButton,{time=1000,delay=500})
    sceneGroup:insert(changeShopRightButton)

    changeItemLeftButton = widget.newButton(
		{
			x = display.contentCenterX * 0.35,
			y = display.contentCenterY * 0.85,
			id = "menuButton3",
			onRelease = changeItem,
			defaultFile = buttonSprites[3],
			overFile = buttonSprites[3],
		}
	)
    changeItemLeftButton.alpha = 0
    transition.fadeIn(changeItemLeftButton,{time=1000,delay=500})
    sceneGroup:insert(changeItemLeftButton)

    changeItemRightButton = widget.newButton(
		{
			x = display.contentCenterX * 1.65,
			y = display.contentCenterY * 0.85,
			id = "menuButton4",
			onRelease = changeItem,
			defaultFile = buttonSprites[4],
			overFile = buttonSprites[4],
		}
	)
    changeItemRightButton.alpha = 0
    transition.fadeIn(changeItemRightButton,{time=1000,delay=500})
    sceneGroup:insert(changeItemRightButton)

    purchaseButton = display.newSprite(shopButtonSheet,shopSequence)
    purchaseButton.x = display.contentCenterX
    purchaseButton.y = display.contentCenterY * 1.4
    purchaseButton.myName = "menuButton5"
    purchaseButton.alpha = 0
    purchaseButton:setSequence("equip")
    transition.fadeIn(purchaseButton,{time=1000,delay=500})
    sceneGroup:insert(purchaseButton)

    gameButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY * 1.9,
			id = "menuButton6",
			onRelease = gotoMenu,
			defaultFile = buttonSprites[5],
			overFile = buttonSprites[5],
		}
	)
    gameButton.alpha = 0
    transition.fadeIn(gameButton,{time=1000})
    sceneGroup:insert(gameButton)

    checkEquipped()
end


-- show()
function scene:show( event )
    if ( event.phase == "did" ) then
        purchaseButton:addEventListener("tap",checkButtonType)
    end
end


-- hide()
function scene:hide( event )
    if ( event.phase == "did" ) then
        audio.stop(2)

        purchaseButton:removeEventListener("tap",checkButtonType)
        gameButton:setEnabled(false)

        composer.removeScene("menushop")
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
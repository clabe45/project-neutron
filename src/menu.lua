Menu = {
	isActive = false,
	page = "main",
	maxSelection = 5,
	selection = 1,
	menuElements = {
		"Equipment",
		"Items",
		"Beastiary",
		"Books",
		"Options"
	},
	menuDescriptions = {
		"The things you wear!",
		"The things you use!",
		"The things you killed!",
		"The things you can read!",
		"The things you can change!"
	}
}

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

-- The frame containing the items in the list
local itemFrame = {
	x = 0,
	y = windowHeight/2,
	width = windowWidth/3,
	height = windowHeight - (windowHeight/2),
	text = nil
}

-- Individual items in the list
local itemElement = {
	x = itemFrame.x + 10,
	y = itemFrame.y + 10,
	width = itemFrame.width - 10,
	height = 30,
	text = "ITEM NAME"
}

-- The item preview, showing flavortext and icon
local itemPreview = {
	x = itemFrame.width + 30,
	y = itemFrame.y,
	width = windowWidth - itemFrame.width + 30,
	height = itemFrame.height,
	text = nil
}

-- The description of the currently hovered menu
local menuDescription = {
	x = 200,
	y = windowHeight - 160,
	width = 500,
	height = 100,
	text = Menu.menuDescriptions[Menu.selection]
}

-- The individual menu items in the list
local menuElement = {
	x = 20,
	y = menuDescription.y,
	width = 150,
	height = 20,
	text = "TEXT HERE"
}

-- drawMenu: Draws the current menu when paused
function Menu.drawMenu()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)
	if (Menu.page == "main") then
		-- Draw main window
		Menu.drawMainMenu()
	elseif (Menu.page == "items") then
		Menu.drawItemMenu()
	end
end

-- drawMainMenu: Draws the main menu to the screen
function Menu.drawMainMenu()
	Menu.drawElement(menuDescription)
	for i=1,#Menu.menuElements do
		-- Metatable hacks
		local currentElement_mt = {}
		currentElement_mt.__index = menuElement
		local currentElement = {}
		setmetatable(currentElement, currentElement_mt)
		if (Menu.selection == i) then
			currentElement.selected = true
		end
		currentElement.text = Menu.menuElements[i]
		currentElement.y = currentElement.y + ((i-1)*30)
		Menu.drawElement(currentElement)
	end
end

-- drawItemMenu: Draws the item menu to the screen
function Menu.drawItemMenu()
	Menu.drawElement(itemFrame)
	Menu.drawElement(itemPreview)
	for i=1,#Player.inventory do
		local currentItem = itemElement
		currentItem.text = Items.list[Player.inventory[i].id].name .. " " .. Player.inventory[i].amount
		Menu.drawElement(itemElement)
	end
	-- Add some way to switch to items
end

-- drawElement: Draws an element to the screen
function Menu.drawElement(element)
	if (element.selected) then
		love.graphics.setColor(0, 0, 1, 1)
	else
		love.graphics.setColor(.5, .5, .5, 1)
	end
	love.graphics.rectangle('fill', element.x, element.y, element.width, element.height)
	love.graphics.setColor(1, 1, 1, 1)
	if (element.text ~= nil) then
		love.graphics.print(element.text, element.x, element.y)
	end
end

-- shiftUp: Shift the menu selection up an item
function Menu.shiftUp()
	if (not (Menu.selection <= 1)) then
		Menu.selection = Menu.selection - 1
	end
end

-- shiftDown: Shift the menu selection down an item
function Menu.shiftDown()
	if (not (Menu.selection >= Menu.maxSelection)) then
		Menu.selection = Menu.selection + 1
	end
end


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

local itemFrame = {
	x = 0,
	y = windowHeight/2,
	width = windowWidth/3,
	height = windowHeight - (windowHeight/2),
	text = nil
}

local itemElement = {
	x = itemFrame.x + 10,
	y = itemFrame.y + 10,
	width = itemFrame.width - 10,
	height = 30,
	text = "ITEM NAME"
}

local itemPreview = {
	x = itemFrame.width + 30,
	y = itemFrame.y,
	width = windowWidth - itemFrame.width + 30,
	height = itemFrame.height,
	text = nil
}

local menuDescription = {
	x = 200,
	y = windowHeight - 160,
	width = 500,
	height = 100,
	text = Menu.menuDescriptions[Menu.selection]
}

local menuElement = {
	x = 20,
	y = menuDescription.y,
	width = 150,
	height = 20,
	text = "TEXT HERE"
}

-- drawMenu: Will later be used to draw a menu showing status
function Menu.drawMenu()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)
	if (Menu.page == "main") then
		-- Draw main window
		Menu.drawMainMenu()
		--Menu.drawElement("desc", 200, windowHeight-160, 500, 100, Menu.descFlavortext[Menu.selection], 0)
		---- Draw list items
		--Menu.drawElement("list", 20, windowHeight-160, 150, 20, "Equipment", 1)
		--Menu.drawElement("list", 20, windowHeight-130, 150, 20, "Items", 2)
		--Menu.drawElement("list", 20, windowHeight-100, 150, 20, "Beastiary", 3)
		--Menu.drawElement("list", 20, windowHeight-70, 150, 20, "Books", 4)
		--Menu.drawElement("list", 20, windowHeight-40, 150, 20, "Options", 5)
	elseif (Menu.page == "items") then
		Menu.drawItemMenu()
	end
end

function Menu.drawMainMenu()
	Menu.drawElement(menuDescription)
	for i=1,#Menu.menuElements do
		-- Oh god. Lua tables are just references so I have to make a BRAND NEW TABLE per element. Cool.
		local currentElement_mt = {}
		currentElement_mt.__index = menuElement
		local currentElement = {}
		setmetatable(currentElement, currentElement_mt)
		currentElement.text = Menu.menuElements[i]
		currentElement.y = currentElement.y + (i*30)
		currentElement.height = currentElement.height + (i*30)
		Menu.drawElement(currentElement)
	end
end

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

-- drawElement: Draws an element to the menu
--function Menu.drawElement(elementType, x, y, width, height, text, index)
	---- Draw the outer box
	--if (index == Menu.selection) then
		---- Make the selected one colored
		--love.graphics.setColor(0, 0, .5, 1)
	--else
		--love.graphics.setColor(.5, .5, .5, 1)
	--end
	--love.graphics.rectangle('fill', x, y, width, height)

	---- Draw the text
	--love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.print(text, x, y)
--end

function Menu.drawElement(element)
	love.graphics.setColor(.5, .5, .5, 1)
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


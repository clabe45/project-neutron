Menu = {
	isActive = false,
	page = "items",
	maxSelection = 5,
	selection = 1,
	descFlavortext = {
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
	selectors = {
		"Test selector"
	}
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
	selectors = nil
}

-- drawMenu: Will later be used to draw a menu showing status
function Menu.drawMenu()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)
	if (Menu.page == "main") then
		-- Draw main window
		Menu.drawElement("desc", 200, windowHeight-160, 500, 100, Menu.descFlavortext[Menu.selection], 0)
		-- Draw list items
		Menu.drawElement("list", 20, windowHeight-160, 150, 20, "Equipment", 1)
		Menu.drawElement("list", 20, windowHeight-130, 150, 20, "Items", 2)
		Menu.drawElement("list", 20, windowHeight-100, 150, 20, "Beastiary", 3)
		Menu.drawElement("list", 20, windowHeight-70, 150, 20, "Books", 4)
		Menu.drawElement("list", 20, windowHeight-40, 150, 20, "Options", 5)
	elseif (Menu.page == "items") then
		Menu.drawItemMenu()
	end
end

function Menu.drawItemMenu()
	Menu.drawElement("items", itemFrame.x, itemFrame.y, itemFrame.width, itemFrame.height, "TEST", 0)
	Menu.drawElement("itemDesc", itemPreview.x, itemPreview.y, itemPreview.width, itemPreview.height, "TEST", 0)
	-- Add some way to switch to items
end

-- drawElement: Draws an element to the menu
function Menu.drawElement(elementType, x, y, width, height, text, index)
	-- Draw the outer box
	if (index == Menu.selection) then
		-- Make the selected one colored
		love.graphics.setColor(0, 0, .5, 1)
	else
		love.graphics.setColor(.5, .5, .5, 1)
	end
	love.graphics.rectangle('fill', x, y, width, height)

	-- Draw the text
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(text, x, y)
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


Menu = {
	isActive = false,
	page = "main",
	maxSelection = 5,
	selection = 1
}

-- drawMenu: Will later be used to draw a menu showing status
function Menu.drawMenu()
	if (Menu.page == "main") then
		-- Draw main window
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)
		Menu.drawElement("list", 200, windowHeight-160, 500, windowHeight-40, "IDK", 0)
		-- Draw list items
		Menu.drawElement("list", 20, windowHeight-160, 150, 20, "Equipment", 1)
		Menu.drawElement("list", 20, windowHeight-130, 150, 20, "Items", 2)
		Menu.drawElement("list", 20, windowHeight-100, 150, 20, "Beastiary", 3)
		Menu.drawElement("list", 20, windowHeight-70, 150, 20, "Books", 4)
		Menu.drawElement("list", 20, windowHeight-40, 150, 20, "Options", 5)
	end
end

-- drawElement: Draws an element to the menu
function Menu.drawElement(elementType, x, y, width, height, text, index)
	if (index == Menu.selection) then
		love.graphics.setColor(0, 0, .5, 1)
	else
		love.graphics.setColor(.5, .5, .5, 1)
	end
	love.graphics.rectangle('fill', x, y, width, height)
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


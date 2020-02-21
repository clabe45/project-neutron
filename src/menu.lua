Menu = {}

-- drawMenu: Will later be used to draw a menu showing status
function Menu.drawMenu()
	-- Draw main window
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)
	-- Draw list items
	Menu.drawElement("list", 0+20, windowHeight-70, 150, 20, "Weapons")
	Menu.drawElement("list", 0+20, windowHeight-40, 150, 20, "Items")
end

-- drawElement: Draws an element to the menu
function Menu.drawElement(elementType, x, y, width, height, text)
	if (elementType == "list") then
		love.graphics.setColor(.5, .5, .5, 1)
	end
	love.graphics.rectangle('fill', x, y, width, height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(text, x, y)
end


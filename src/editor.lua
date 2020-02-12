Editor = {
	currentTile = 1,
	currentEntity = 1
}

Editor.commandMode = false
Editor.commandModeLine = ""
Editor.mode = "tile" -- Can be tile, entity, or item
editorMode = true

-- handleInput: Handles commandLine and level editor keys
function Editor.handleInput(key)
	if (Editor.commandMode) then
		if (key == "return") then
			Editor.executeCommand()
			Editor.commandModeLine = ""
			Editor.commandMode = false
		elseif (key == "backspace") then
			Editor.commandModeLine = Editor.commandModeLine:sub(1, -2)
		else
			if (key == "space") then
				key = " "
			-- Removing invalid characters
			elseif (key == "lshift" or key == "rshift" or key == "capslock"
				or key == "lalt" or key == "ralt" or key == "tab"
				or key == "lctrl" or key == "rctrl" or key == "up"
				or key == "down" or key == "left" or key == "right"
				or key == "escape") then
				key = ""
			end
			Editor.commandModeLine = Editor.commandModeLine .. key
		end
	elseif (editorMode) then
		-- Take editorMode off if e is pressed
		if (key == "e") then editorMode = false end

		-- Shift currently selected tile
		-- Move the bounds checkers into the if ladder
		if (key == "left" and editorMode and Editor.currentTile > 0) then
			if (Editor.mode == "tile") then
				Editor.currentTile = Editor.currentTile - 1
			elseif (Editor.mode == "entity") then
				Editor.currentEntity = Editor.currentEntity - 1
			end
		end
		if (key == "right" and editorMode and Editor.currentTile < Tiles.totalTiles) then
			if (Editor.mode == "tile") then
				Editor.currentTile = Editor.currentTile + 1
			elseif (Editor.mode == "entity") then
				Editor.currentEntity = Editor.currentEntity + 1
			end
		end 
		if (key == "down") then
			if (Editor.mode == "tile") then
				Editor.mode = "entity"
			end
		end
		if (key == "up") then
			if (Editor.mode == "entity") then
				Editor.mode = "tile"
			end
		end
		if (key == "m1") then
			if (Editor.mode == "tile") then
				local x = math.floor(love.mouse.getX() / 25) * 25
				local y = math.floor(love.mouse.getY() / 25) * 25
				local isNewTile = true
				for i=1,Level.tileCount do
					-- If tile currently exists, set isNewTile to false
					if (Level.tiles[i].x == x and Level.tiles[i].y == y and Level.tiles[i].id == Editor.currentTile) then
						isNewTile = false
					end
				end
				if (isNewTile) then
					Level.addTile(x, y, Editor.currentTile)
				end
			end
			if (Editor.mode == "entity") then
				local x = math.floor(love.mouse.getX() / 25) * 25
				local y = math.floor(love.mouse.getY() / 25) * 25
				-- Replace magic number
				-- Add something to check for mouseup?
				Entities.spawnEntity(x, y, 50, Editor.currentEntity)
			end
		end
	end
end

-- executeCommand: Executes a command, current commands include :w (write), :o (open), :set (change height/width of level)
function Editor.executeCommand()
	-- :w <levelname> (writes level to file)
	if (Editor.commandModeLine:sub(1, 1) == "w") then
		if (currentLevel == "" and Editor.commandModeLine:len() < 2) then
			print("Error: No level name defined.\n Usage: :w <filename>")
		else
			local args = split(Editor.commandModeLine, " ")
			Level.save(args[2])
		end
	-- :o <filename> (reads level from file)
	elseif (Editor.commandModeLine:sub(1, 1) == "o") then
		if (Editor.commandModeLine:len() > 2) then
			Level.clear()
			local args = split(Editor.commandModeLine, " ")
			Level.read(args[2])
		end
	-- :set <height/width> (sets level height/width)
	elseif (Editor.commandModeLine:sub(1, 3) == "set") then
		local args = split(Editor.commandModeLine, " ")
		if (args[2] == "height") then
			Level.height = args[3]
			print("Level height set to " .. args[3])
		elseif (args[2] == "width") then
			Level.width = args[3]
			print("Level width set to " .. args[3])
		else
			print("Error: Invalid arguments.\nUsage: set <variable> <value>")
		end
	-- :clear (clears level)
	elseif (Editor.commandModeLine:sub(1, 5) == "clear") then
		Level.clear()
	else
		print("Error. Command not found.")
	end
end

function Editor.drawEditor()
	-- Draw Commandline
	if (Editor.commandMode) then
		love.graphics.setColor(0, 1, 0)
		-- The "20" magic number will be replaced when we actually bother with font data
		love.graphics.printf(":" .. Editor.commandModeLine, 0, love.graphics.getHeight() - 20, 800, "left")
	elseif (editorMode) then
		-- Draw cursor
		love.graphics.setColor(1, 1, 1, .5)
		love.graphics.rectangle("fill", math.floor(love.mouse.getX() / 25) * 25, math.floor(love.mouse.getY() / 25) * 25, 25, 25)
	end
end


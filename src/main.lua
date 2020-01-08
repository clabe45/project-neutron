-- TODO: Fix bug on clipping, seems to occur when the player falls the .5 pixel when crossing gaps
require("level")
require("entities")
require("player")

Tiles = {
	{
		name = "Generic Collider",
		category = "block"
	},
	{
		name = "Door Marker",
		category = "phase"
	},
	totalTiles = 2
}

Editor = {
	currentTile = 1
}

commandMode = false
commandModeLine = ""
editorMode = true
isPaused = false
-- variable so the editor can do :w and know where to save to
currentLevel = ""

-- split: takes a string and returns an array with it split into smaller segments per 'character'
function split(string, character)
	local arr = {}
	local arrIndex = 1
	local lastStringIndex = 1
	local j = 1
	for i=1,string:len() do
		if (string:sub(i,i) == character) then
			arr[arrIndex] = string:sub(lastStringIndex, i - 1)
			arrIndex = arrIndex + 1
			lastStringIndex = i + 1
		end
		j = j + 1
	end
	arr[arrIndex] = string:sub(lastStringIndex, j - 1)
	return arr
end

-- drawMenu: Will later be used to draw a menu showing status
function drawMenu()
	print("Menu.")
end

-- executeCommand: Executes a command, current commands include :w (write), :o (open), :set (change height/width of level)
function executeCommand()
	-- :w <levelname> (writes level to file)
	if (commandModeLine:sub(1, 1) == "w") then
		if (currentLevel == "" and commandModeLine:len() < 2) then
			print("Error: No level name defined.\n Usage: :w <filename>")
		else
			local args = split(commandModeLine, " ")
			Level.save(args[2])
		end
	-- :o <filename> (reads level from file)
	elseif (commandModeLine:sub(1, 1) == "o") then
		if (commandModeLine:len() > 2) then
			Level.clear()
			local args = split(commandModeLine, " ")
			Level.read(args[2])
		end
	-- :set <height/width> (sets level height/width)
	elseif (commandModeLine:sub(1, 3) == "set") then
		local args = split(commandModeLine, " ")
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
	elseif (commandModeLine:sub(1, 5) == "clear") then
		Level.clear()
	else
		print("Error. Command not found.")
	end
end

-- load: Sets initial love values and creates a test enemy
function love.load()
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("testgame_v2")
	Entities.spawnEntity(250, 250, 25)
end

function love.keypressed(key, scancode, isrepeat)
	-- Commands
	if (commandMode) then
		if (key == "return") then
			executeCommand()
			commandModeLine = ""
			commandMode = false
		elseif (key == "backspace") then
			commandModeLine = commandModeLine:sub(1, -2)
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
			commandModeLine = commandModeLine .. key
		end
	-- Play mode
	else
		-- Activate level editor
		if (key == "e") then
			editorMode = not editorMode
		end
		-- Jumping
		if (key == "space" and not editorMode) then
			Player.dy = -10
		end
		-- Shift currently selected tile
		if (key == "left" and editorMode and Editor.currentTile > 0) then
			Editor.currentTile = Editor.currentTile - 1
		end
		if (key == "right" and editorMode and Editor.currentTile < Tiles.totalTiles) then
			Editor.currentTile = Editor.currentTile + 1
		end
		-- Player attackbox
		if (key == "z" and not editorMode) then
			hitboxPlayerX = Player.x + 25;
			hitboxPlayerY = Player.y + 15;
		end
		-- Pausing
		if (key == "return") then
			print("Pause.")
			isPaused = not isPaused
		end
	end
	if (key == ";") then
		commandMode = not commandMode
	end
end

function love.update(dt)
	-- Normal physics update
	if (not editorMode and not isPaused) then
		-- Check Keys
		if (love.keyboard.isDown("left")) then
			Player.dx = -5
		elseif (love.keyboard.isDown("right")) then
			Player.dx = 5
		else
			Player.dx = 0
		end
		-- Update positions
		Player.dy = Player.dy + .5 -- Gravity
		Entities.checkCollision(Player)
		Entities.applyGravity()
		Entities.updateEntities()
	end
end

function love.draw()
	if (isPaused) then
		drawMenu()
	else
		Level.draw()
		if (not editorMode) then
			Player.drawPlayer()
			Entities.drawEntities()
			-- Draw the hitbox
			if (hitboxPlayerX and hitboxPlayerY) then
				love.graphics.setColor(255, 0, 0)
				-- Depending on weapon equipped, the hitbox will be bigger/smaller
				love.graphics.rectangle("fill", hitboxPlayerX, hitboxPlayerY, 20, 30)
			end
		end

		-- Draw Debug
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("Player Coords: (" .. Player.x .. ", " .. Player.y .. ")\nPlayer dx: " .. tostring(Player.dx) .. "\nPlayer dy: " .. tostring(Player.dy) ..  "\nCurrent Tile: " .. Tiles[Editor.currentTile].name)

		-- Draw Commandline
		if (commandMode) then
			love.graphics.setColor(0, 255, 0)
			-- The "20" magic number will be replaced when we actually bother with font data
			love.graphics.printf(":" .. commandModeLine, 0, love.graphics.getHeight() - 20, 800, "left")
		end

		-- Level Editor
		if (editorMode) then
			-- Draw cursor
			love.graphics.setColor(1, 1, 1, .5)
			love.graphics.rectangle("fill", math.floor(love.mouse.getX() / 25) * 25, math.floor(love.mouse.getY() / 25) * 25, 25, 25)

			-- Add Tile
			if (love.mouse.isDown(1)) then
				local isNewTile = true
				for i=1,Level.tileCount do
					-- If tile currently exists, set isNewTile to false
					if (Level.tiles[i].x == math.floor(love.mouse.getX() / 25) * 25 and Level.tiles[i].y == math.floor(love.mouse.getY() / 25) * 25 and Level.tiles[i].id == Editor.currentTile) then
						isNewTile = false
					end
				end
				if (isNewTile) then
					Level.tileCount = Level.tileCount + 1
					Level.tiles[Level.tileCount] = {x = math.floor(love.mouse.getX() / 25) * 25, y = math.floor(love.mouse.getY() / 25) * 25, id = Editor.currentTile}
				end
			end
			-- Delete Tile
			if (love.mouse.isDown(2)) then
				for i=1,Level.tileCount do
					if (Level.tiles[i].x == math.floor(love.mouse.getX() / 25) * 25 and Level.tiles[i].y == math.floor(love.mouse.getY() / 25) * 25) then
						table.remove(Level.tiles, i)
						Level.tileCount = Level.tileCount - 1
						break
					end
				end
			end
		end
	end
end


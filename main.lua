-- TODO: Fix bug on clipping, seems to occur when the player falls the .5 pixel when crossing gaps
Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	hitboxX = 25,
	hitboxY = 50
}

Entities = {
	entities = {
		{}
	},
	entityCount = 0
}

Level = {
	height = 800,
	width = 600,
	-- Level tile format: x, y, id
	-- Some tiles will be rendered invisible, but for debug they'll be drawn
	tiles = {
		{}
	},
	tileCount = 0
}

Tiles = {
	{
		name = "Generic Collider",
		category = "block"
	},
	{
		name = "Door Marker",
		category = "phase"
	}
}

Editor = {
	currentTile = 0
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

function drawMenu()
	print("Menu.")
end

function Level.clear()
	for i=1,Level.tileCount do
		Level.tiles[i] = nil
	end
	Level.tileCount = 0
end

function Level.save(levelName)
	love.filesystem.write(levelName, "800 600")
	for i=2,Level.tileCount do
		love.filesystem.append(levelName, "\n" .. Level.tiles[i].x .. " " .. Level.tiles[i].y .. " " .. Level.tiles[i].id)
	end
end

function Level.read(levelName)
	local rawLevelData = love.filesystem.read(levelName)
	local levelLines = split(rawLevelData, "\n")
	local levelLineData
	-- BEWARE LINE 1, IT IS META DATA
	for i=2,#levelLines do
		levelLineData = split(levelLines[i], " ")
		Level.tiles[i - 1] = {x = tonumber(levelLineData[1]), y = tonumber(levelLineData[2]), id = tonumber(levelLineData[3])}
		Level.tileCount = Level.tileCount + 1
	end
end

function executeCommand()
	if (commandModeLine:sub(1, 1) == "w") then
		if (currentLevel == "" and commandModeLine:len() < 2) then
			print("Error: No level name defined")
		else
			local args = split(commandModeLine, " ")
			Level.save(args[2])
			print("Written \"" .. args[2] .. "\" to file.")
		end
	elseif (commandModeLine:sub(1, 1) == "o") then
		if (commandModeLine:len() > 2) then
			Level.clear()
			local args = split(commandModeLine, " ")
			Level.read(args[2])
			print("Loaded \"" .. args[2] .. "\" successfully.")
		end
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
	end
end

function Player.drawPlayer()
	love.graphics.setColor(100, 100, 100)
	love.graphics.rectangle('fill', Player.x, Player.y, Player.hitboxX, Player.hitboxY)
	--idlePlayer = love.graphics.newImage("idle.png")
	--love.graphics.draw(idlePlayer, Player.x, Player.y)
end

function Entities.spawnEntity(x, y, health)
	Entities.entities[Entities.entityCount] = {x = x, y = y, hp = health}
	Entities.entityCount = Entities.entityCount + 1
	print(Entities.entities[Entities.entityCount].x)
	print(Entities.entityCount)
end

function Entities.drawEntities()
	-- Loop over all the entities, incrementing by 1
	for i=0,Entities.entityCount-1 do
		love.graphics.setColor(0, 0, 255)
		love.graphics.rectangle('fill', Entities.entities[i].x, Entities.entities[i].y, Player.hitboxX, Player.hitboxY)
	end
end
-- Next up, detract hp when entity is hit, possibly make them blink, then despawn when hp is below 0

function love.load()
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("testgame")
	Entities.spawnEntity(250, 250)
end

function love.keypressed(key, scancode, isrepeat)
	if (commandMode) then
		if (key == "return") then
			executeCommand()
			commandModeLine = ""
			commandMode = false
		elseif (key == "backspace") then
			commandModeLine = commandModeLine:sub(1, -2)
		else
			commandModeLine = commandModeLine .. key
		end
	else
		-- Jumping
		if (key == "space") then
			Player.dy = -10
		end
		-- ActivatEntities.e level editor
		if (key == "e") then
			editorMode = not editorMode
		end
		-- Movement keys
		if (key == "left" and editorMode and Editor.currentTile > 0) then
			Editor.currentTile = Editor.currentTile - 1
		end
		-- No boundaries yet, since we have no clue how many tiles we'll add
		if (key == "right" and editorMode) then
			Editor.currentTile = Editor.currentTile + 1
		end
		-- Player hitbox
		if (key == "z" and not editormode) then
			hitboxPlayerX = Player.x + 25;
			hitboxPlayerY = Player.y + 15;
		end
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

		-- Checking Keys
		if (love.keyboard.isDown("left")) then
			Player.dx = -5
		elseif (love.keyboard.isDown("right")) then
			Player.dx = 5
		else
			Player.dx = 0
		end

		-- Checking Collisions
		Player.dy = Player.dy + .5
		local attemptedX = Player.x + Player.dx
		local attemptedY = Player.y + Player.dy
		local collisionX = false
		local collisionY = false

		for i=1,Level.tileCount do
			if (Player.x < Level.tiles[i].x + 25 and Player.x + 25 > Level.tiles[i].x and attemptedY < Level.tiles[i].y + 25 and attemptedY + 50 > Level.tiles[i].y) then
				Player.dy = 0
				collisionY = true
			end
			if (attemptedX < Level.tiles[i].x + 25 and attemptedX + 25 > Level.tiles[i].x and Player.y < Level.tiles[i].y + 25 and Player.y + 50 > Level.tiles[i].y) then
				collisionX = true
			end
		end

		-- Applying Forces
		if (not collisionY) then
			Player.y = Player.y + Player.dy
		end
		if (not collisionX) then
			Player.x = Player.x + Player.dx
		end
	end

end

function love.draw()
	if (isPaused) then
		drawMenu()
	else
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
		love.graphics.print("Player Coords: (" .. Player.x .. ", " .. Player.y .. ")\nPlayer dx: " .. tostring(Player.dx) .. "\nPlayer dy: " .. tostring(Player.dy) ..  "\nCurrent Tile: " .. Tiles[Editor.currentTile + 1].name)

		-- Draw Commandline
		if (commandMode) then
			love.graphics.setColor(0, 255, 0)
			-- The "20" magic number will be replaced when we actually bother with font data
			love.graphics.printf(":" .. commandModeLine, 0, love.window.getHeight() - 20, 800, "left")
		end

		-- Level Editor
		if (editorMode) then
			-- Hover
			love.graphics.setColor(255, 255, 255, 127)
			love.graphics.rectangle("fill", math.floor(love.mouse.getX() / 25) * 25, math.floor(love.mouse.getY() / 25) * 25, 25, 25)

			-- Press
			if (love.mouse.isDown(1)) then
				local isNewTile = true
				for i=1,Level.tileCount do
					if (Level.tiles[i].x == math.floor(love.mouse.getX() / 25) * 25 and Level.tiles[i].y == math.floor(love.mouse.getY() / 25) * 25 and Level.tiles[i].id == Editor.currentTile) then
						isNewTile = false
					end
				end
				if (isNewTile) then
					Level.tileCount = Level.tileCount + 1
					Level.tiles[Level.tileCount] = {x = math.floor(love.mouse.getX() / 25) * 25, y = math.floor(love.mouse.getY() / 25) * 25, id = Editor.currentTile}
				end
			end
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

		-- Print tiles
		if (Level.tileCount > 0) then
			for i=1,Level.tileCount do
				-- Temporary setup until textures happen
				if (Level.tiles[i].id == 0) then
					love.graphics.setColor(255, 255, 255)
					love.graphics.rectangle("fill", Level.tiles[i].x, Level.tiles[i].y, 25, 25)
				elseif (Level.tiles[i].id == 1) then
					love.graphics.setColor(200, 0, 0)
					love.graphics.rectangle("fill", Level.tiles[i].x, Level.tiles[i].y, 25, 25)
				end
			end
		end
	end

end


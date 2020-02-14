require("camera")

Level = {
	--height = 800,
	--width = 600,
	height = 1000,
	width = 1000,
	-- Level tile format: x, y, id
	-- Some tiles will be rendered invisible, but for debug they'll be drawn
	tiles = {
		{}
	},
	tileCount = 0,
	rooms = {
		{
			x = 975,
			y = 200,
			location = "newroom"
		}
	}
}

-- draw: Draws all loaded tiles
function Level.draw()
	if (Level.tileCount > 0) then
		for i=1,Level.tileCount do
			tileX = Camera.convert("x", Level.tiles[i].x)
			tileY = Camera.convert("y", Level.tiles[i].y)
			-- Temporary setup until textures happen
			if (Level.tiles[i].id == 1) then
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", tileX, tileY, 25, 25)
			elseif (Level.tiles[i].id == 2) then
				love.graphics.setColor(200, 0, 0)
				love.graphics.rectangle("fill", tileX, tileY, 25, 25)
			end
		end
	end
end

-- checkDoor: Checks if the Player is at the edge of the world
function Level.checkDoor()
	for i=1,#Level.rooms do
		if (Player.x == Level.rooms[i].x and Player.y == Level.rooms[i].y) then
			print("Teleporting player to " .. Level.rooms[i].location)
		end
	end
end

-- addTile: Adds a new tile to the level
function Level.addTile(x, y, id)
	Level.tileCount = Level.tileCount + 1
	Level.tiles[Level.tileCount] = {x = x, y = y, id = id}
end

-- list: Lists all the levels
function Level.list()
	return love.filesystem.getDirectoryItems("levels")
end

-- clear: removes all tiles currently drawn
function Level.clear()
	for i=1,Level.tileCount do
		Level.tiles[i] = nil
	end
	Level.tileCount = 0
end

-- save: writes the current tiles to a file
function Level.save(levelName)
	love.filesystem.write(levelName, "800 600")
	for i=1,Level.tileCount do
		love.filesystem.append(levelName, "\n" .. Level.tiles[i].x .. " " .. Level.tiles[i].y .. " " .. Level.tiles[i].id)
	end
	print("Written '" .. levelName .. "' to file.")
end

-- read: reads a file and draws tiles from it
function Level.read(levelName)
	local rawLevelData = love.filesystem.read(levelName)
	-- Check if file exists
	if (rawLevelData == nil) then
		print("File '" .. levelName .. "' not found.")
		return
	end

	local levelLines = split(rawLevelData, "\n")
	local levelLineData
	-- BEWARE LINE 1, IT IS META DATA
	for i=2,#levelLines do
		levelLineData = split(levelLines[i], " ")
		Level.tiles[i - 1] = {x = tonumber(levelLineData[1]), y = tonumber(levelLineData[2]), id = tonumber(levelLineData[3])}
		Level.tileCount = Level.tileCount + 1
	end
	print("Loaded '" .. levelName .. "' successfully.")
end


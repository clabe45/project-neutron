-- TODO: Fix bug on clipping, seems to occur when the player falls the .5 pixel when crossing gaps
require("level")
require("entities")
require("player")
require("editor")
require("camera")

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

-- load: Sets initial love values and creates a test enemy
function love.load()
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	love.window.setTitle("Project Neutron")
	love.keyboard.setKeyRepeat(true)
	-- May change to the parent for other data like savegame
	love.filesystem.setIdentity("testgame_v2")
	Entities.spawnEntity(250, 250, 25, 1)
end

function love.keypressed(key, scancode, isrepeat)
	-- Commands
	if (Editor.commandMode or editorMode) then
		Editor.handleInput(key)
	else
		-- Activate level editor
		if (key == "e") then
			editorMode = true
		end
		-- Jumping
		if (key == "space" and not editorMode) then
			Entities.jump(Player)
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
	-- Open commandline
	if (key == ";") then
		Editor.commandMode = not Editor.commandMode
	end
	-- Quit the game
	if (key == "escape") then
		love.event.quit()
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
		Camera.update()
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
				love.graphics.setColor(1, 0, 0)
				-- Depending on weapon equipped, the hitbox will be bigger/smaller
				love.graphics.rectangle("fill", hitboxPlayerX, hitboxPlayerY, 20, 30)
			end
		end

		-- Building the debug dialog
		local debugLine = "Player Coords: (" .. Player.x .. ", " .. Player.y .. ")\n"
		debugLine = debugLine .. "Player dx: " .. Player.dx .. "\n"
		debugLine = debugLine .. "Player dy: " .. Player.dy .. "\n"
		if (Editor.mode == "tile") then
			debugLine = debugLine .. "Current Tile: " .. Tiles[Editor.currentTile].name .. "\n"
		elseif (Editor.mode == "entity") then
			debugLine = debugLine .. "Current Entity: " .. Entities.list[Editor.currentEntity].name .. "\n"
		end

		-- Draw Debug
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(debugLine)

		Editor.drawEditor()
		-- Level Editor
		if (editorMode) then
			-- Add Tile
			if (love.mouse.isDown(1)) then
				Editor.handleInput("m1")
			end
			-- Delete Tile
			if (love.mouse.isDown(2)) then
				for i=1,Level.tileCount do
					local x = math.floor((love.mouse.getX() + Camera.x) / 25) * 25
					local y = math.floor((love.mouse.getY() + Camera.y) / 25) * 25
					if (Level.tiles[i].x == x and Level.tiles[i].y == y) then
						table.remove(Level.tiles, i)
						Level.tileCount = Level.tileCount - 1
						break
					end
				end
			end
		end
	end
end


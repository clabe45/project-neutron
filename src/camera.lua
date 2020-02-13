require("player")
-- On keypress, shift all tiles to the direction at the player's speed
-- Keep player in center unless approaching room bounds
Camera = {
	x = 0,
	y = 0
}

-- Add x and y directions
function Camera.shift(direction)
	Camera.x = Player.x - windowWidth / 2
	-- Checking the bounds of the level
	if (Camera.x < 0) then
		Camera.x = 0
	elseif (Camera.y < 0) then
		Camera.y = 0
	elseif (Camera.x > (Level.width - windowWidth)) then
		Camera.x = Level.width - windowWidth
	elseif (Camera.y > (Level.height - windowHeight)) then
		Camera.y = Level.height - windowHeight
	end

	-- Moving the camera
	--Camera.x = Camera.x + direction
end

function Camera.convert(axis, value)
	if (axis == "x") then
		return value - Camera.x
	elseif (axis == "y") then
		return value - Camera.y
	else
		print("Invalid conversion")
	end
end

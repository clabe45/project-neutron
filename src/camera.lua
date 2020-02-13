-- On keypress, shift all tiles to the direction at the player's speed
-- Keep player in center unless approaching room bounds
Camera = {
	x = 0,
	y = 0
}

-- Add x and y directions
function Camera.shift(direction)
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
	print("Shifting camera: " .. direction)
	Camera.x = Camera.x + direction
end


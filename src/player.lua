Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	hitboxX = 25,
	hitboxY = 50
}

-- drawPlayer: Draws the player sprite
function Player.drawPlayer()
	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle('fill', Camera.convert("x", Player.x), Camera.convert("y",Player.y), Player.hitboxX, Player.hitboxY)
	--idlePlayer = love.graphics.newImage("idle.png")
	--love.graphics.draw(idlePlayer, Player.x, Player.y)
end


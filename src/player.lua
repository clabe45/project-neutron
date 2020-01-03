Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	hitboxX = 25,
	hitboxY = 50
}

function Player.drawPlayer()
	love.graphics.setColor(100, 100, 100)
	love.graphics.rectangle('fill', Player.x, Player.y, Player.hitboxX, Player.hitboxY)
	--idlePlayer = love.graphics.newImage("idle.png")
	--love.graphics.draw(idlePlayer, Player.x, Player.y)
end


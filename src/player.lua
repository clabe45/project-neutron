Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	hitboxX = 25,
	hitboxY = 50,
	idleSprite = love.graphics.newImage("assets/char_sprites/MC.png"),
	spriteOffsetX = -38,
	spriteOffsetY = -40
}

-- drawPlayer: Draws the player sprite
function Player.drawPlayer()
	-- The hitbox
	love.graphics.setColor(0, 1, 0, .1)
	--love.graphics.rectangle('fill', Camera.convert("x", Player.x), Camera.convert("y",Player.y), Player.hitboxX, Player.hitboxY)
	-- The graphic
	love.graphics.setColor(1, 1, 1, 1)
	-- The graphic is currently being blown up 2x, this results in some fuzziness
	love.graphics.draw(Player.idleSprite, Player.x + Player.spriteOffsetX, Player.y + Player.spriteOffsetY, 0, 2, 2)
end


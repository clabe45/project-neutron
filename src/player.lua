Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	hitboxX = 25,
	hitboxY = 50,
	idleSprite = love.graphics.newImage("assets/char_sprites/MC/MC.png"),
	walkFrames = {
		love.graphics.newImage("assets/char_sprites/MC/walk/frame1.png"),
		love.graphics.newImage("assets/char_sprites/MC/walk/frame2.png"),
		love.graphics.newImage("assets/char_sprites/MC/walk/frame3.png"),
		love.graphics.newImage("assets/char_sprites/MC/walk/frame4.png"),
		love.graphics.newImage("assets/char_sprites/MC/walk/frame5.png"),
		love.graphics.newImage("assets/char_sprites/MC/walk/frame6.png"),
	},
	walkFrame = 1,
	spriteOffsetX = 18,
	spriteOffsetY = 20,
	isWalking = false,
	isDashing = false,
	forwardFace = true
}

-- drawPlayer: Draws the player sprite
function Player.drawPlayer()
	local currentSprite = Player.idleSprite
	local scaleX = 2
	local faceOffsetX = 0 -- Responsible for when the player faces left to correct hitbox proximity
	-- The hitbox
	--love.graphics.setColor(0, 1, 0, .1)
	--love.graphics.rectangle('fill', Camera.convert("x", Player.x), Camera.convert("y",Player.y), Player.hitboxX, Player.hitboxY)

	-- Make the walking animation
	if (Player.isWalking) then
		-- Update the walk animation index
		if (Player.walkFrame+1 > 6) then
			Player.walkFrame = 1
		else
			if (frameCounter % 6 == 0) then
				Player.walkFrame = Player.walkFrame + 1
			end
		end
		currentSprite = Player.walkFrames[Player.walkFrame]
	else
		Player.walkFrame = 1
		currentSprite = Player.idleSprite
	end

	if (not Player.forwardFace) then
		scaleX = -2
		faceOffsetX = 13
	end

	-- Draw the graphic
	love.graphics.setColor(1, 1, 1, 1)
	-- The graphic is currently being blown up 2x, this results in some fuzziness
	love.graphics.draw(currentSprite, Camera.convert("x", Player.x), Camera.convert("y", Player.y), 0, scaleX, 2, Player.spriteOffsetX+faceOffsetX, Player.spriteOffsetY)
end

function Player.airdash()
	-- dx should depend on direction of player face
	if (not Player.isDashing) then
		print("Dashed")
		Player.dx = Player.dx + 15
		Player.isDashing = true
	end
end

function Player.updatePhysics()
	if (Player.isDashing) then
		if (not Player.dx == 0) then
			Player.dx = Player.dx - 1
		elseif (Player.dy == 0) then
			Player.isDashing = false
		end
	end
end


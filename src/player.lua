Player = {
	x = 0,
	y = 0,
	dx = 0,
	dy = 0,
	width = 25,
	height = 75,
	hurtboxX = 0,
	hurtboxY = 0,
	hurtboxWidth = 0,
	hurtboxHeight = 0,
	hurtboxDuration = 0,
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
	spriteOffsetY = 7,
	isWalking = false,
	isDashing = false,
	isAttacking = false,
	forwardFace = true,
	health = 100,
	weaponAttack = 40
}

-- drawPlayer: Draws the player sprite
function Player.drawPlayer()
	local currentSprite = Player.idleSprite
	local scaleX = 2
	local faceOffsetX = 0 -- Responsible for when the player faces left to correct hitbox proximity
	-- The hitbox
	--love.graphics.setColor(0, 1, 0, .1)
	--love.graphics.rectangle('fill', Camera.convert("x", Player.x), Camera.convert("y",Player.y), Player.width, Player.height)

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
		if (Player.forwardFace) then
			Player.dx = Player.dx + 15
		else
			Player.dx = Player.dx - 15
		end
		Player.isDashing = true
	end
end

function Player.attack()
	-- Depending on weapon equipped, the hurtbox will be bigger/smaller
	Player.isAttacking = true

	-- Placing the hitbox in front of the players head
	if (Player.forwardFace) then
		Player.hurtboxX = Camera.convert("x", Player.x + 25)
	else
		Player.hurtboxX = Camera.convert("x", Player.x - 25)
	end

	Player.hurtboxY = Camera.convert("y", Player.y + 15)
	Player.hurtboxWidth = 20
	Player.hurtboxHeight = 30
	-- Have the attack last for a five frames
	Player.hurtboxDuration = 5
end

function Player.checkHurtbox()
	for i=1,Entities.entityCount do
		local entity = Entities.entities[i]
		if ((entity.x < Player.hurtboxX + Player.hurtboxWidth and entity.x + entity.width > Player.hurtboxX) or (entity.y < Player.hurtboxY + Player.hurtboxHeight and entity.y + entity.height > Player.hurtboxY)) then
			Entities.damageEntity(entity, Player.weaponAttack, true)
		end
	end
end

function Player.updatePhysics()
	-- Gradually slow dash down
	if (Player.isDashing) then
		if (not Player.dx == 0) then
			Player.dx = Player.dx - 1
		elseif (Player.dy == 0) then
			Player.isDashing = false
		end
	end
	-- End attack hurtbox after a certain length of time
	if (Player.isAttacking) then
		Player.checkHurtbox()
		Player.hurtboxDuration = Player.hurtboxDuration - 1
		if (Player.hurtboxDuration == 0) then
			Player.isAttacking = false
		end
	end
end


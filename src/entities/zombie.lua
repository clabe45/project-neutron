Zombie = {
	name = "Zombie",
	walkFrames = {
		love.graphics.newImage("assets/entity_sprites/zombie/zombie_walk1.png")
	},
	walkFrame = 1,
	spriteOffsetX = 20,
	spriteOffsetY = 6,
	width = 25,
	height = 75,
	health = 100
}

-- idle: When the zombie is standing still, do this
function Zombie.idle(this)
	this.dx = 0
	Entities.jump(this)
end

-- aggro: What to do when the player is seen
function Zombie.aggro(this)
	-- Follow the player
	if (Player.x > this.x) then
		this.dx = 3
	else
		this.dx = -3
	end
end

-- doBehaivor: Do different behaivors based on the state
function Zombie.doBehaivor(this)
	if (math.abs(Player.x - this.x) < 200) then
		Zombie.aggro(this)
	else
		Zombie.idle(this)
	end
end

function Zombie.draw(this)
	entityX = Camera.convert("x", this.x)
	entityY = Camera.convert("y", this.y)
	love.graphics.draw(Zombie.walkFrames[1], entityX, entityY, 0, 2, 2, Zombie.spriteOffsetX, Zombie.spriteOffsetY)
end


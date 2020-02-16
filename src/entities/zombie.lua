Zombie = {
	name = "Zombie",
	width = 50,
	height = 100,
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


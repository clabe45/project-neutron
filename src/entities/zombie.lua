Zombie = {
	width = 50,
	height = 100
}

-- idle: When the zombie is standing still, do this
function Zombie.idle(this)
	this.dy = this.dy + 100
end

-- doBehaivor: Do different behaivors based on the state
function Zombie.doBehaivor(this)
	Zombie.idle(this)
end


Zombie = {
	width = 50,
	height = 100
}

-- idle: When the zombie is standing still, do this
function Zombie.idle(this)
	Entities.jump(this)
end

-- doBehaivor: Do different behaivors based on the state
function Zombie.doBehaivor(this)
	Zombie.idle(this)
end


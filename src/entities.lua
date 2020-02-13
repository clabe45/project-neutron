require("level")
require("entities/zombie")

Entities = {
	entities = {
	},
	entityCount = 0,
	list = {
		Zombie
	}
}

-- spawnEntity: creates an entity at (x, y) and loads it into the Entities object
-- TODO: Take out health parameter and have object provide it
function Entities.spawnEntity(x, y, health, id)
	if (id == 1) then
		Entities.entities[Entities.entityCount + 1] = {id = id, x = x, y = y, dx = 0, dy = 0, Zombie.width, Zombie.height, hp = health, isFalling = false}
	end
	Entities.entityCount = Entities.entityCount + 1
end

-- drawEntity: iterates over the Entities object and draws them to the screen
function Entities.drawEntities()
	-- Loop over all the entities, incrementing by 1
	for i=1,Entities.entityCount do
		entityX = Entities.entities[i].x - Camera.x
		entityY = Entities.entities[i].y - Camera.y
		-- Set the color and draw a rectangle based on entity
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle('fill', entityX, entityY, Player.hitboxX, Player.hitboxY)
	end
end
-- Next up, detract hp when entity is hit, possibly make them blink, then despawn when hp is below 0

-- jump: Allows an entity to jump
function Entities.jump(entity)
	-- Later add a flag for if they're already on a moving platform
	-- Since the logic here is to disable jumping when dy != 0
	if (not entity.isFalling) then
		entity.dy = -10
		entity.isFalling = true
	end
end

-- applyGravity: Applys the force of gravity (.5) to all entities
function Entities.applyGravity()
	for i=1,Entities.entityCount do
		Entities.entities[i].dy = Entities.entities[i].dy + .5
	end
end

-- updateEntities: Updates the position of all spawned entities
function Entities.updateEntities()
	for i=1,Entities.entityCount do
		Entities.checkCollision(Entities.entities[i])
		if (Entities.entities[i].id == 1) then
			Zombie.doBehaivor(Entities.entities[i])
		end
	end
end

-- checkCollision: Given a Player or Entity object, move the entity if their movements do not conflict with tiles
function Entities.checkCollision(entity)
	local attemptedX = entity.x + entity.dx
	local attemptedY = entity.y + entity.dy
	local collisionX = false
	local collisionY = false

	for i=1,Level.tileCount do
		if (entity.x < Level.tiles[i].x + 25 and entity.x + 25 > Level.tiles[i].x and attemptedY < Level.tiles[i].y + 25 and attemptedY + 50 > Level.tiles[i].y) then
			entity.dy = 0
			entity.isFalling = false
			collisionY = true
		end
		if (attemptedX < Level.tiles[i].x + 25 and attemptedX + 25 > Level.tiles[i].x and entity.y < Level.tiles[i].y + 25 and entity.y + 50 > Level.tiles[i].y) then
			collisionX = true
		end
	end

	-- Applying Forces
	if (not collisionY) then
		entity.y = entity.y + entity.dy
	end
	if (not collisionX) then
		entity.x = entity.x + entity.dx
	end
end


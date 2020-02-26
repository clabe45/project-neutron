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
-- Maybe change the id == 1 cond to list[i]
function Entities.spawnEntity(x, y, id)
	print("Func called")
	print(id)
	-- Bug, spawnEntity is being hit a bunch by mouseclick
	-- Spawn zombie
	if (id == 1) then
		print("Zombie called")
		Entities.entities[Entities.entityCount + 1] = {index = Entities.entityCount + 1, id = id, x = x, y = y, dx = 0, dy = 0, width = Zombie.width, height = Zombie.height, health= Zombie.health, isFalling = false, invulnCooldown = 0}
	end
	Entities.entityCount = Entities.entityCount + 1
end

-- despawnEntity: Remove an entitiy from the table by overwriting it with the one in front of it
function Entities.despawnEntity(index)
	local shift = false
	for i=1,Entities.entityCount do
		if (index == i) then
			shift = true
		end
		if (shift and not (i >= Entities.entityCount)) then
			Entities.entities[i] = Entities.entities[i+1]
			Entities.entities[i].index = i
			Entities.entityCount = Entities.entityCount - 1
		end
		if (shift and (i == Entities.entityCount)) then
			Entities.entities[i] = nil
			Entities.entityCount = Entities.entityCount - 1
		end
	end
end

-- drawEntity: iterates over the Entities object and draws them to the screen
function Entities.drawEntities()
	-- Loop over all the entities, incrementing by 1
	for i=1,Entities.entityCount do
		entityX = Camera.convert("x", Entities.entities[i].x)
		entityY = Camera.convert("y", Entities.entities[i].y)

		-- If the enemy has been hit, draw it faded
		if (Entities.entities[i].invulnCooldown == 0) then
			love.graphics.setColor(1, 0, 0)
		else
			love.graphics.setColor(1, 0, 0, .5)
		end

		-- Draw a rectangle based on entity
		love.graphics.rectangle('fill', entityX, entityY, Entities.entities[i].width, Entities.entities[i].height)
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
	print(Entities.entityCount)
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
		-- Tick the cooldown downward
		if (not (Entities.entities[i].invulnCooldown == 0)) then
			Entities.entities[i].invulnCooldown = Entities.entities[i].invulnCooldown - 1
		end
	end
end

-- damageEntity: Make the entity take damage
function Entities.damageEntity(entity, damage, hasCooldown)
	-- if the entity's cooldown is 0, damage the entity and renew it
	if (entity.invulnCooldown == 0) then
		entity.health = entity.health - damage
		entity.invulnCooldown = 60
	end
	-- If the enemy is dead, do this
	if (entity.health <= 0) then
		Entities.despawnEntity(entity.index)
	end
end

-- checkCollision: Given a Player or Entity object, move the entity if their movements do not conflict with tiles
function Entities.checkCollision(entity)
	local attemptedX = entity.x + entity.dx
	local attemptedY = entity.y + entity.dy
	local collisionX = false
	local collisionY = false

	for i=1,Level.tileCount do
		-- Apply only to solid blocks
		if (Tiles[Level.tiles[i].id].category == "block") then
			if (entity.x < Level.tiles[i].x + 25 and entity.x + entity.width > Level.tiles[i].x and attemptedY < Level.tiles[i].y + 25 and attemptedY + entity.height > Level.tiles[i].y) then
				entity.dy = 0
				entity.isFalling = false
				collisionY = true
			end
			if (attemptedX < Level.tiles[i].x + 25 and attemptedX + entity.width > Level.tiles[i].x and entity.y < Level.tiles[i].y + 25 and entity.y + entity.height > Level.tiles[i].y) then
				collisionX = true
			end
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


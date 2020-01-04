Entities = {
	entities = {
		{}
	},
	entityCount = 0
}

-- spawnEntity: creates an entity at (x, y) and loads it into the Entities object
function Entities.spawnEntity(x, y, health)
	Entities.entities[Entities.entityCount] = {x = x, y = y, hp = health}
	Entities.entityCount = Entities.entityCount + 1
	print(Entities.entities[Entities.entityCount].x)
	print(Entities.entityCount)
end

-- drawEntity: iterates over the Entities object and draws them to the screen
function Entities.drawEntities()
	-- Loop over all the entities, incrementing by 1
	for i=0,Entities.entityCount-1 do
		love.graphics.setColor(0, 0, 255)
		love.graphics.rectangle('fill', Entities.entities[i].x, Entities.entities[i].y, Player.hitboxX, Player.hitboxY)
	end
end
-- Next up, detract hp when entity is hit, possibly make them blink, then despawn when hp is below 0


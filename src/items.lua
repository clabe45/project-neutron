require("items/souls")

Items = {
	items = {
	},
	itemCount = 0,
	list = {
		Souls
	},
	totalItems = 1
}

function Items.loadItem(x, y, itemId)
	print(Items.list[itemId].name)
	Items.items[Items.itemCount + 1] = {id = itemId, x = x, y = y, width = 32, height = 32, dx = 0, dy = 0}
	Items.itemCount = Items.itemCount + 1
end

function Items.unloadItem(index)
	local shift = false -- shift the item list over to remove the item
	for i=1,Items.itemCount do
		if (index == i) then
			shift = true
		end
		if (shift and (i == Items.itemCount)) then
			Items.items[i] = nil
		end
		if (shift and (i < Items.itemCount)) then
			Items.items[i] = Items.items[i+1]
			Items.items[i].index = i
		end
	end
	Items.itemCount = Items.itemCount - 1
end

function Items.draw()
	for i=1,Items.itemCount do
		itemX = Camera.convert("x", Items.items[i].x)
		itemY = Camera.convert("y", Items.items[i].y)
		love.graphics.draw(Items.list[Items.items[i].id].sprite, itemX, itemY, 0, 1, 1, 0, 0)
	end
end

function Items.updateItems()
	for i=1,Items.itemCount do
		Items.items[i].dy = Items.items[i].dy + .5
		Entities.checkCollision(Items.items[i])
	end
end


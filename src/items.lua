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
	Items.items[Items.itemCount + 1] = {id = itemId, x = x, y = y}
	Items.itemCount = Items.itemCount + 1
end

function Items.draw()
	for i=1,Items.itemCount do
		itemX = Camera.convert("x", Items.items[i].x)
		itemY = Camera.convert("y", Items.items[i].y)
		love.graphics.draw(Items.list[Items.items[i].id].sprite, itemX, itemY, 0, 2, 2, 0, 0)
	end
end


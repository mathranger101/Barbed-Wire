local alpha = { "a", "b", "c", "d", "e", "f", "g", "h" }
local items = {}

for i,wireType in ipairs({"standard", "reinforced", "slowing", "conductive", "reinforced-slowing", "reinforced-conductive", "slowing-conductive", "reinforced-slowing-conductive"}) do
	table.insert(items,
		{
			type = "item",
			name = wireType.."-barbed-wire",
			icon = "__Barbed-Wire__/graphics/"..wireType.."-safe.png",
			flags = { "goes-to-quickbar" },
			subgroup = "barbed-wires",
			order = "g-"..alpha[i],
			place_result = wireType.."-barbed-wire",
			stack_size = 50
		}
	)
end

data:extend(items)

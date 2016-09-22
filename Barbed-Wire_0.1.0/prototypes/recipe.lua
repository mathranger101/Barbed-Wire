data:extend({
	{
		type = "recipe",
        name = "barbed-wire",
        enabled = false,
        ingredients =
		{
			{"iron-stick", 8},
			{"iron-plate", 2}
		},
        result = "barbed-wire"
	},
	{
		type = "recipe",
        name = "reinforced-barbed-wire",
        enabled = false,
        ingredients =
		{
			{"barbed-wire", 1},
			{"steel-plate", 2},
			{"iron-stick", 8}
		},
        result = "reinforced-barbed-wire"
	},
	{
		type = "recipe",
        name = "slow-barbed-wire",
        enabled = false,
        ingredients =
		{
			{"barbed-wire", 1},
			{"coal", 4}
		},
        result = "slow-barbed-wire"
	},
	{
		type = "recipe",
        name = "reinforced-slow-barbed-wire",
        enabled = false,
        ingredients =
		{
			{"reinforced-barbed-wire", 1},
			{"slow-barbed-wire", 1},
			{"steel-plate", 2},
			{"coal", 2}
		},
        result = "reinforced-slow-barbed-wire"
	}
})
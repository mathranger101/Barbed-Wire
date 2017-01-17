data:extend({
    {
        type = "recipe",
        name = "standard-barbed-wire",
        enabled = false,
        ingredients =
        {
            { "iron-stick", 4 },
            { "iron-plate", 2 }
        },
        result = "standard-barbed-wire"
    },
    {
        type = "recipe",
        name = "reinforced-barbed-wire",
        enabled = false,
        ingredients =
        {
            { "standard-barbed-wire", 1 },
            { "steel-plate", 2 },
            { "iron-stick", 2 }
        },
        result = "reinforced-barbed-wire"
    },
    {
        type = "recipe",
        name = "slowing-barbed-wire",
        enabled = false,
        ingredients =
        {
            { "standard-barbed-wire", 1 },
            { "coal", 4 }
        },
        result = "slowing-barbed-wire"
    },
	{
        type = "recipe",
        name = "conductive-barbed-wire",
        enabled = false,
        ingredients =
        {
            { "standard-barbed-wire", 1 },
            { "copper-cable", 4 }
        },
        result = "conductive-barbed-wire"
    },
	{
		type = "recipe",
		name = "reinforced-slowing-barbed-wire",
		enabled = false,
		ingredients = 
		{
			{ "reinforced-barbed-wire", 1 },
			{ "slowing-barbed-wire", 1 },
			{ "steel-plate", 1},
			{ "coal", 2 }
		},
		result = "reinforced-slowing-barbed-wire"
	},
	{
		type = "recipe",
		name = "slowing-conductive-barbed-wire",
		enabled = false,
		ingredients = 
		{
			{ "slowing-barbed-wire", 1 },
			{ "conductive-barbed-wire", 1 },
			{ "coal", 2 },
			{ "copper-cable", 2}
		},
		result = "slowing-conductive-barbed-wire"
	},
	{
		type = "recipe",
		name = "reinforced-conductive-barbed-wire",
		enabled = false,
		ingredients = 
		{
			{ "reinforced-barbed-wire", 1 },
			{ "conductive-barbed-wire", 1 },
			{ "steel-plate", 1},
			{ "copper-cable", 2}
		},
		result = "reinforced-conductive-barbed-wire"
	},
	{
		type = "recipe",
		name = "reinforced-slowing-conductive-barbed-wire",
		enabled = false,
		ingredients = 
		{
			{ "reinforced-slowing-barbed-wire", 1 },
			{ "slowing-conductive-barbed-wire", 1 },
			{ "reinforced-conductive-barbed-wire", 1 }
		},
		result = "reinforced-slowing-conductive-barbed-wire"
	}
})
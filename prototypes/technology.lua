-- military 1
table.insert(data.raw["technology"]["military"].effects,
    {
        type = "unlock-recipe",
        recipe = "standard-barbed-wire"
    }
)
-- military 2
table.insert(data.raw["technology"]["military-2"].effects,
    {
        type = "unlock-recipe",
        recipe = "reinforced-barbed-wire"
    }
)
table.insert(data.raw["technology"]["military-2"].effects,
	{
        type = "unlock-recipe",
        recipe = "slowing-barbed-wire"
    }
)
table.insert(data.raw["technology"]["military-2"].effects,
	{
		type = "unlock-recipe",
		recipe = "conductive-barbed-wire"
	}
)
-- military 3
table.insert(data.raw["technology"]["military-3"].effects,
    {
        type = "unlock-recipe",
        recipe = "reinforced-slowing-barbed-wire"
    }
)
table.insert(data.raw["technology"]["military-3"].effects,
	{
        type = "unlock-recipe",
        recipe = "slowing-conductive-barbed-wire"
    }
)
table.insert(data.raw["technology"]["military-3"].effects,
	{
		type = "unlock-recipe",
		recipe = "reinforced-conductive-barbed-wire"
	}
)
-- military 4
table.insert(data.raw["technology"]["military-4"].effects,
    {
        type = "unlock-recipe",
        recipe = "reinforced-slowing-conductive-barbed-wire"
    }
)
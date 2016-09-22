local dmg = 2
local multi = 3 
local health = 15
local attackArea = 0.7

local energy = 
{
	type = "electric",
	buffer_capacity = "0.0002MJ",
	usage_priority = "secondary-input",
	input_flow_limit = "0.002kW",
	output_flow_limit = "1kW"
}

data:extend({

	-- MISC -- 
	
	-- slow down sticker
	{
		
		type = "sticker",
		name = "barbed-wire-slowdown-sticker",
		flags = {"not-on-map"},
		flags = {},
		animation =
		{
			filename = "__base__/graphics/entity/slowdown-sticker/slowdown-sticker.png",
			priority = "extra-high",
			width = 11,
			height = 11,
			frame_count = 13,
			animation_speed = 0.4
		},
		duration_in_ticks = 30,
		target_movement_modifier = 0.5
	},
	
	-- PROJECTILES --
	
	-- signal 
	{
		type = "projectile",
		name = "barbed-wire-signal",
		flags = {"not-on-map"},
		acceleration = 0,
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			frame_count = 1,
			width = 32,
			height = 32,
			priority = "high"
		}
	},
	-- charged
	{
		type = "projectile",
		name = "barbed-wire-charged-projectile",
		flags = {"not-on-map"},
		acceleration = 0,
		action =
		{
			type = "area",
			perimeter = attackArea,
			collision_mask = {"player-layer"},
			action_delivery =
			{
				type = "instant",
				target_effects =
				{
					type = "damage",
					damage = {amount = dmg, type = "laser"}
				}
			}
		},
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			frame_count = 1,
			width = 32,
			height = 32,
			priority = "high"
		}
	},
	-- reinforced-charge
	{
		type = "projectile",
		name = "reinforced-barbed-wire-charged-projectile",
		flags = {"not-on-map"},
		acceleration = 0,
		action =
		{
			type = "area",
			perimeter = attackArea,
			collision_mask = {"player-layer"},
			action_delivery =
			{
				type = "instant",
				target_effects =
				{
					type = "damage",
					damage = {amount = dmg * multi, type = "laser"}
				}
			}
		},
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			frame_count = 1,
			width = 32,
			height = 32,
			priority = "high"
		}
	},
	
	-- LAND-MINES --
	
	-- standard 
	{
		type = "land-mine",
		name = "barbed-wire",
		icon = "__Barbed-Wire__/graphics/standard-safe.png",
		flags = 
		{
			"placeable-player",
			"placeable-enemy",
			"player-creation"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "barbed-wire"},
		max_health = health,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		collision_mask = {"object-layer", "water-tile"},
		picture_safe =
		{
			filename = "__Barbed-Wire__/graphics/standard-safe.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		picture_set =
		{
			filename = "__Barbed-Wire__/graphics/standard-set.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		trigger_radius = attackArea,
		action =
		{
			type = "direct",
			action_delivery =
			{
				type = "instant",
				source_effects =
				{
					{
						type = "nested-result",
						affects_target = true,
						action =
						{	
							type = "area",
							perimeter = attackArea,
							collision_mask = {"player-layer"},
							action_delivery =
							{
								type = "instant",
								target_effects =
								{	
									{
										type = "damage",
										damage = { amount = dmg, type = "physical"}
									}
								}
							}
						}
					},
					{
						type = "create-entity",
						trigger_created_entity = true,
						entity_name = "barbed-wire-signal"
					}
				}
			}
		}
	},
	-- reinforced
	{
		type = "land-mine",
		name = "reinforced-barbed-wire",
		icon = "__Barbed-Wire__/graphics/reinforced-safe.png",
		flags = 
		{
			"placeable-player",
			"placeable-enemy",
			"player-creation"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "reinforced-barbed-wire"},
		max_health = health * 2,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		collision_mask = {"object-layer", "water-tile"},
		picture_safe =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-safe.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		picture_set =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-set.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		trigger_radius = attackArea,
		action =
		{
			type = "direct",
			action_delivery =
			{
				type = "instant",
				source_effects =
				{
					{
						type = "nested-result",
						affects_target = true,
						action =
						{	
							type = "area",
							perimeter = attackArea,
							collision_mask = {"player-layer"},
							action_delivery =
							{
								type = "instant",
								target_effects =
								{	
									{
										type = "damage",
										damage = { amount = dmg * multi, type = "physical"}
									}
								}
							}
						}
					},
					{
						type = "create-entity",
						trigger_created_entity = true,
						entity_name = "barbed-wire-signal"
					}
				}
			}
		}
	},
	-- slow
	{
		type = "land-mine",
		name = "slow-barbed-wire",
		icon = "__Barbed-Wire__/graphics/slow-safe.png",
		flags = 
		{
			"placeable-player",
			"placeable-enemy",
			"player-creation"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "slow-barbed-wire"},
		max_health = health,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		collision_mask = {"object-layer", "water-tile"},
		picture_safe =
		{
			filename = "__Barbed-Wire__/graphics/slow-safe.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		picture_set =
		{
			filename = "__Barbed-Wire__/graphics/slow-set.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		trigger_radius = attackArea,
		action =
		{
			type = "direct",
			action_delivery =
			{
				type = "instant",
				source_effects =
				{
					{
						type = "nested-result",
						affects_target = true,
						action =
						{	
							type = "area",
							perimeter = attackArea,
							collision_mask = {"player-layer"},
							action_delivery =
							{
								type = "instant",
								target_effects =
								{	
									{
										type = "damage",
										damage = { amount = dmg, type = "physical"}
									},
									{
										type = "create-sticker",
										sticker = "barbed-wire-slowdown-sticker"
									}
								}
							}
						}
					},
					{
						type = "create-entity",
						trigger_created_entity = true,
						entity_name = "barbed-wire-signal"
					}
				}
			}
		}
	},
	-- reinforced-slow
	{
		type = "land-mine",
		name = "reinforced-slow-barbed-wire",
		icon = "__Barbed-Wire__/graphics/reinforced-slow-safe.png",
		flags = 
		{
			"placeable-player",
			"placeable-enemy",
			"player-creation"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "reinforced-slow-barbed-wire"},
		max_health = health * 2,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		collision_mask = {"object-layer", "water-tile"},
		picture_safe =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-slow-safe.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		picture_set =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-slow-set.png",
			priority = "medium",
			width = 32,
			height = 32,
		},
		trigger_radius = attackArea,
		action =
		{
			type = "direct",
			action_delivery =
			{
				type = "instant",
				source_effects =
				{
					{
						type = "nested-result",
						affects_target = true,
						action =
						{	
							type = "area",
							perimeter = attackArea,
							collision_mask = {"player-layer"},
							action_delivery =
							{
								type = "instant",
								target_effects =
								{	
									{
										type = "damage",
										damage = { amount = dmg * multi, type = "physical"}
									},
									{
										type = "create-sticker",
										sticker = "barbed-wire-slowdown-sticker"
									}
								}
							}
						}
					},
					{
						type = "create-entity",
						trigger_created_entity = true,
						entity_name = "barbed-wire-signal"
					}
				}
			}
		}
	},
	
	-- ACCUMULATORS --
	
	-- standard
	{
		type = "accumulator",
		name = "barbed-wire-accumulator",
		icon = "__Barbed-Wire__/graphics/standard-safe.png",
		flags = 
		{
			"player-creation",
			"not-repairable",
			"not-blueprintable",
			"not-deconstructable"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "barbed-wire"},
		max_health = health,
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {"object-layer", "water-tile"},
		energy_source = energy,
		picture =
		{
			filename = "__Barbed-Wire__/graphics/standard-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			shift = {0.0555, 0}
		},
		charge_animation =
		{
			filename = "__Barbed-Wire__/graphics/standard-charge.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 8,
			frame_count = 8,
			shift = {0.0555, 0}
		},
		charge_cooldown = 30,
		charge_light = {intensity = 0.1, size = 1},
		discharge_animation =
		{
			filename = "__Barbed-Wire__/graphics/standard-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 1,
			frame_count = 1,
			shift = {0.0555, 0}
		},
		discharge_cooldown = 60,
		discharge_light = {intensity = 0, size = 0}
	},
	-- reinforced
	{
		type = "accumulator",
		name = "reinforced-barbed-wire-accumulator",
		icon = "__Barbed-Wire__/graphics/reinforced-safe.png",
		flags = 
		{
			"player-creation",
			"not-repairable",
			"not-blueprintable",
			"not-deconstructable"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "reinforced-barbed-wire"},
		max_health = health * 2,
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {"object-layer", "water-tile"},
		energy_source = energy,
		picture =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			shift = {0.0555, 0}
		},
		charge_animation =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-charge.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 8,
			frame_count = 8,
			shift = {0.0555, 0}
		},
		charge_cooldown = 30,
		charge_light = {intensity = 0.1, size = 1},
		discharge_animation =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 1,
			frame_count = 1,
			shift = {0.0555, 0}
		},
		discharge_cooldown = 60,
		discharge_light = {intensity = 0, size = 0}
	},
	-- slow
	{
		type = "accumulator",
		name = "slow-barbed-wire-accumulator",
		icon = "__Barbed-Wire__/graphics/slow-safe.png",
		flags = 
		{
			"player-creation",
			"not-repairable",
			"not-blueprintable",
			"not-deconstructable"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "slow-barbed-wire"},
		max_health = health,
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {"object-layer", "water-tile"},
		energy_source = energy,
		picture =
		{
			filename = "__Barbed-Wire__/graphics/slow-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			shift = {0.0555, 0}
		},
		charge_animation =
		{
			filename = "__Barbed-Wire__/graphics/slow-charge.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 8,
			frame_count = 8,
			shift = {0.0555, 0}
		},
		charge_cooldown = 30,
		charge_light = {intensity = 0.1, size = 1},
		discharge_animation =
		{
			filename = "__Barbed-Wire__/graphics/slow-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 1,
			frame_count = 1,
			shift = {0.0555, 0}
		},
		discharge_cooldown = 60,
		discharge_light = {intensity = 0, size = 0}
	},
	-- reinforced-slow
	{
		type = "accumulator",
		name = "reinforced-slow-barbed-wire-accumulator",
		icon = "__Barbed-Wire__/graphics/reinforced-slow-safe.png",
		flags = 
		{
			"player-creation",
			"not-repairable",
			"not-blueprintable",
			"not-deconstructable"
		},
		fast_replaceable_group = "barbed-wires",
		minable = {mining_time = 0.2, result = "reinforced-slow-barbed-wire"},
		max_health = health * 2,
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {"object-layer", "water-tile"},
		energy_source = energy,
		picture =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-slow-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			shift = {0.0555, 0}
		},
		charge_animation =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-slow-charge.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 8,
			frame_count = 8,
			shift = {0.0555, 0}
		},
		charge_cooldown = 30,
		charge_light = {intensity = 0.1, size = 1},
		discharge_animation =
		{
			filename = "__Barbed-Wire__/graphics/reinforced-slow-accumulator.png",
			priority = "medium",
			width = 36,
			height = 32,
			line_length = 1,
			frame_count = 1,
			shift = {0.0555, 0}
		},
		discharge_cooldown = 60,
		discharge_light = {intensity = 0, size = 0}
	},

	-- SIMPLE-ENTITIES -- 
	
	-- standard
	{
		type = "simple-entity",
		name = "barbed-wire-dummy",
		flags = {},
		icon = "__Barbed-Wire__/graphics/standard-safe.png",
		subgroup = "barbed-wires",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {},
		render_layer = "corpse",
		max_health = 0,
		pictures =
		{
			{
				filename = "__Barbed-Wire__/graphics/standard-barbed-wire.png",
				width = 32,
				height = 32
			}
		}
	},
	-- reinforced
	{
		type = "simple-entity",
		name = "reinforced-barbed-wire-dummy",
		flags = {},
		icon = "__Barbed-Wire__/graphics/reinforced-safe.png",
		subgroup = "barbed-wires",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {},
		render_layer = "corpse",
		max_health = 0,
		pictures =
		{
			{
				filename = "__Barbed-Wire__/graphics/reinforced-barbed-wire.png",
				width = 32,
				height = 32
			}
		}
	},
	-- slow
	{
		type = "simple-entity",
		name = "slow-barbed-wire-dummy",
		flags = {},
		icon = "__Barbed-Wire__/graphics/slow-safe.png",
		subgroup = "barbed-wires",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {},
		render_layer = "corpse",
		max_health = 0,
		pictures =
		{
			{
				filename = "__Barbed-Wire__/graphics/slow-barbed-wire.png",
				width = 32,
				height = 32
			}
		}
	},
	-- reinforced-slow
	{
		type = "simple-entity",
		name = "reinforced-slow-barbed-wire-dummy",
		flags = {},
		icon = "__Barbed-Wire__/graphics/reinforced-slow-safe.png",
		subgroup = "barbed-wires",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		collision_mask = {},
		render_layer = "corpse",
		max_health = 0,
		pictures =
		{
			{
				filename = "__Barbed-Wire__/graphics/reinforced-slow-barbed-wire.png",
				width = 32,
				height = 32
			}
		}
	}
})
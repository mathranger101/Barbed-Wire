local dmg = 2
local chargeDmg = dmg/4
local multi = 3
local health = 15
local attackArea = 0.7

local entities = 
{
	-- slowdown sticker
	{
		type = "sticker",
		name = "barbed-wire-slowdown-sticker",
		flags = { "not-on-map" },
		flags = {},
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			priority = "extra-high",
			width = 1,
			height = 1,
			frame_count = 1
		},
		duration_in_ticks = 30,
		target_movement_modifier = 0.7
	},
	-- super slowdown sticker
	{
		type = "sticker",
		name = "barbed-wire-super-slowdown-sticker",
		flags = { "not-on-map" },
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
		target_movement_modifier = 0.4
	},
	-- charge projectile
	{
		type = "projectile",
		name = "barbed-wire-charge-projectile",
		flags = {"not-on-map"},
		acceleration = 10,
		action = 
		{
			type = "area",
			perimeter = 0.7,
			collision_mask = { "player-layer" },
			action_delivery =
			{
				type = "instant",
				target_effects =
				{
					{
						type = "damage",
						damage = {amount = chargeDmg, type = "laser"}
					}
				}
			}
		},
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			priority = "medium",
			width = 1,
			height = 1,
			frame_count = 1,
			direction_count = 1
		}
	},
	-- reinforced charge projectile
	{
		type = "projectile",
		name = "barbed-wire-reinforced-charge-projectile",
		flags = {"not-on-map"},
		acceleration = 10,
		action = 
		{
			type = "area",
			perimeter = 0.7,
			collision_mask = { "player-layer" },
			action_delivery =
			{
				type = "instant",
				target_effects =
				{
					{
						type = "damage",
						damage = {amount = chargeDmg * multi, type = "laser"}
					}
				}
			}
		},
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			priority = "medium",
			width = 1,
			height = 1,
			frame_count = 1,
			direction_count = 1
		}
	},
	-- signal
	{
		type = "projectile",
		name = "barbed-wire-signal",
		flags = {"not-on-map"},
		acceleration = 0,
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			priority = "medium",
			width = 1,
			height = 1,
			frame_count = 1,
			direction_count = 1
		}
	},
	-- reinforced signal
	{
		type = "projectile",
		name = "barbed-wire-reinforced-signal",
		flags = {"not-on-map"},
		acceleration = 0,
		animation =
		{
			filename = "__Barbed-Wire__/graphics/clear.png",
			priority = "medium",
			width = 1,
			height = 1,
			frame_count = 1
		}
	},
	-- temp dummy
	{
		type = "simple-entity",
		name = "barbed-wire-temp-dummy",
		flags = {"not-on-map"},
		collision_mask = {},
		render_layer = "object",
		pictures =
		{
			{
				filename = "__Barbed-Wire__/graphics/clear.png",
				width = 1,
				height = 1
			}
		}
	}
}

for _,wireType in ipairs({"standard", "reinforced", "slowing", "conductive", "reinforced-slowing", "reinforced-conductive", "slowing-conductive", "reinforced-slowing-conductive"}) do

	-- reinforced properties
	local dmgMulti
	local healthMulti
	local chargeType
	if string.find(wireType, "reinforced", 1, true) then
		dmgMulti = multi
		healthMulti = 2
		chargeType = "-reinforced"
	else
		dmgMulti = 1
		healthMulti = 1
		chargeType = ""
	end

	-- slowing properties
	local stickerType
	if string.find(wireType, "slowing", 1, true) then
		stickerType = "barbed-wire-super-slowdown-sticker"
	else
		stickerType = "barbed-wire-slowdown-sticker"
	end

	-- land mine
	table.insert(entities,
		{
			type = "land-mine",
			name = wireType.."-barbed-wire",
			icon = "__Barbed-Wire__/graphics/"..wireType.."-safe.png",
			flags =
			{
				"placeable-player",
				"placeable-enemy",
				"player-creation"
			},
			fast_replaceable_group = "barbed-wires",
			minable = { mining_time = 0.2, result = wireType.."-barbed-wire" },
			max_health = health * healthMulti,
			corpse = "small-remnants",
			collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
			selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
			collision_mask = { "object-layer", "water-tile" },
			picture_safe =
			{
				filename = "__Barbed-Wire__/graphics/"..wireType.."-safe.png",
				priority = "medium",
				width = 36,
				height = 32,
				shift = {0.055, 0}
			},
			picture_set =
			{
				filename = "__Barbed-Wire__/graphics/"..wireType.."-set.png",
				priority = "medium",
				width = 36,
				height = 32,
				shift = {0.055, 0}
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
								collision_mask = { "player-layer" },
								action_delivery =
								{
									type = "instant",
									target_effects =
									{
										{
											type = "damage",
											damage = { amount = dmg * dmgMulti, type = "physical" }
										},
										{
											type = "create-sticker",
											sticker = stickerType
										}
									}
								}
							}
						}
					}
				}
			}
		}
	)

	-- simple entity
	table.insert(entities,
		{
			type = "simple-entity",
			name = wireType.."-barbed-wire-dummy",
			flags = {},
			icon = "__Barbed-Wire__/graphics/"..wireType.."-safe.png",
			subgroup = "barbed-wires",
			collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
			collision_mask = {"object-layer", "water-tile"},
			render_layer = "corpse",
			pictures =
			{
				{
					filename = "__Barbed-Wire__/graphics/"..wireType.."-barbed-wire-base.png",
					width = 36,
					height = 32,
					shift = {0.055, 0}
				}
			}
		}
	)
	
	if string.find(wireType, "conductive", 1, true) then 
		-- turret
		table.insert(entities,
			{
				type = "electric-turret",
				name = wireType.."-barbed-wire-charge-turret",
				icon = "__Barbed-Wire__/graphics/"..wireType.."-safe.png",
				flags = 
				{
					"not-repairable", 
					"not-blueprintable", 
					"not-deconstructable"
				},
				collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
				collision_mask = {"object-layer", "water-tile"},
				rotation_speed = 1,
				preparing_speed = 0.2,
				folding_speed = 0.1,
				energy_source =
				{
					type = "electric",
					buffer_capacity = "1kJ",
					input_flow_limit = "0.2kW",
					drain = "0.02kW",
					usage_priority = "secondary-input"
				},
				folded_animation =
				{
					layers =
					{
						{
							filename = "__Barbed-Wire__/graphics/"..wireType.."-barbed-wire-tower.png",
							priority = "medium",
							width = 36,
							height = 32,
							frame_count = 1,
							direction_count = 1,
							shift = {0.055, 0}
						}
					}
				},
				preparing_animation =
				{
					layers =
					{
						{
							filename = "__Barbed-Wire__/graphics/"..wireType.."-charge.png",
							priority = "medium",
							width = 36,
							height = 32,
							frame_count = 5,
							direction_count = 1,
							animation_speed = 0.02,
							shift = {0.055, 0}
						}
					}
				},
				prepared_animation =
				{
					layers =
					{
						{
							filename = "__Barbed-Wire__/graphics/"..wireType.."-charge.png",
							priority = "medium",
							width = 36,
							height = 32,
							frame_count = 5,
							direction_count = 1,
							animation_speed = 0.02,
							shift = {0.055, 0}
						}
					}
				},
				folding_animation = 
				{
					layers =
					{
						{
							filename = "__Barbed-Wire__/graphics/"..wireType.."-charge.png",
							priority = "medium",
							width = 36,
							height = 32,
							frame_count = 5,
							direction_count = 1,
							animation_speed = 0.02,
							shift = {0.055, 0}
						}
					}
				},
				base_picture =
				{
					layers =
					{
						{
							filename = "__Barbed-Wire__/graphics/"..wireType.."-barbed-wire-tower.png",
							priority = "medium",
							width = 36,
							height = 32,
							frame_count = 1,
							direction_count = 1,
							shift = {0.055, 0}
						}
					}
				},
				attack_parameters =
				{
					type = "projectile",
					ammo_category = "electric",
					cooldown = 0,
					projectile_center = {0, 0},
					projectile_creation_distance = 0,
					range = attackArea * 2,
					damage_modifier = 1,
					ammo_type =
					{
						type = "projectile",
						category = "barbed-wire-charge",
						energy_consumption = "0.02kJ",
						action =
						{
							{
								type = "direct",
								action_delivery =
								{
									type = "instant",
									target_effects =
									{
										type = "create-entity",
										trigger_created_entity = true,
										entity_name = "barbed-wire"..chargeType.."-signal"
									}
								}
							}
						}
					}
				},
				call_for_help_radius = 0
			}
		)
	else
		-- simple entity part deux 
		table.insert(entities,
			{
				type = "simple-entity",
				name = wireType.."-barbed-wire-dummy2",
				flags = {},
				icon = "__Barbed-Wire__/graphics/"..wireType.."-barbed-wire-tower.png",
				subgroup = "barbed-wires",
				collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
				collision_mask = {"object-layer", "water-tile"},
				render_layer = "object",
				pictures =
				{
					{
						filename = "__Barbed-Wire__/graphics/"..wireType.."-barbed-wire-tower.png",
						width = 36,
						height = 32,
						shift = {0.055, 0}
					}
				}
			}
	)
	end	
end

data:extend(entities)
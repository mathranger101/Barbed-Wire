local energyIter = 10
local updateIter = 15
local waitIter = 5
local waitTime = (120 / waitIter) - (120 / waitIter) % 1

local function poskey(entity)
	local position = entity.position
	return tostring(entity.surface.name)..":"..tostring(position.x)..":"..tostring(position.y)
end

script.on_init(function()
	-- poskey, entity
	global.barbedWireMains = {}
	global.barbedWireAccums = {}
	global.barbedWireDummies = {}
	-- poskey, health
	global.barbedWireHealth = {}
	-- poskey, {entity, time}
	global.barbedWireWaiting = {}
end)

script.on_event(
	defines.events.on_tick,
	function(event)
		local tick = event.tick
		if tick % energyIter == 0 then
			for _,accum in pairs(global.barbedWireAccums) do
				accum.energy = 0
			end
		end
		if tick % waitIter == 0 then
			local Waiting = global.barbedWireWaiting
			for key, waiter in pairs(Waiting) do
				-- reduce counter
				waiter[2] = waiter[2] - 1
				-- build accumulator
				if waiter[2] == 0 then
					local wire = waiter[1]
					local createEntity = wire.surface.create_entity
					local accum = createEntity { name = wire.name .. "-accumulator", position = wire.position, force = wire.force }
					local dummy = createEntity { name = wire.name .. "-dummy", position = wire.position, force = wire.force }
					accum.health = wire.health
					global.barbedWireAccums[key] = accum
					global.barbedWireDummies[key] = dummy
					Waiting[key] = nil
				end
			end
		end
		if tick % updateIter == 0 then
			for key, wire in pairs(global.barbedWireMains) do
				local accum = global.barbedWireAccums[key]
				local Health = global.barbedWireHealth
				-- manage health
				if wire.health ~= Health[key] then
					local newHealth = wire.health
					if accum then
						accum.health = newHealth
					end
					Health[key] = newHealth
				elseif accum and accum.health > Health[key] then
					local newHealth = accum.health
					wire.health = newHealth
					Health[key] = newHealth
				elseif accum and accum.health < Health[key] then
					local newHealth = accum.health
					wire.damage(Health[key] - accum.health, "neutral")
					Health[key] = newHealth
				end
			end
		end
	end
)

script.on_event(
	{
		defines.events.on_built_entity,
		defines.events.on_robot_built_entity
	},
	function(event)
		local entity = event.created_entity
		local entityName = entity.name
		if entityName == "barbed-wire" or entityName == "reinforced-barbed-wire"
				or entityName == "slow-barbed-wire" or entityName == "reinforced-slow-barbed-wire" then
			-- index
			local key = poskey(entity)
			global.barbedWireMains[key] = entity
			global.barbedWireWaiting[key] = { entity, waitTime }
			global.barbedWireHealth[key] = entity.health
		end
	end
)

script.on_event(
	defines.events.on_trigger_created_entity,
	function(event)
		local entity = event.entity
		-- signal
		if entity.name == "barbed-wire-signal" then
			local Mains = global.barbedWireMains
			local key = poskey(entity)
			local surface = entity.surface
			-- check for unregistered wires
			if Mains[key] == nil then
				local pos = entity.position
				local findEntities = surface.find_entities_filtered
				local wire = findEntities { name = "barbed-wire", position = pos }[1] or
						findEntities { name = "reinforced-barbed-wire", position = pos }[1] or
						findEntities { name = "slow-barbed-wire", position = pos }[1] or
						findEntities { name = "reinforced-slow-barbed-wire", position = pos }[1]
				Mains[key] = wire
				global.barbedWireWaiting[key] = { wire, waitTime }
			end
			-- spawn charge projectile
			local accum = global.barbedWireAccums[key]
			if accum and accum.energy > 0 then
				if accum.name == "reinforced-barbed-wire-accumulator" or accum.name == "reinforced-slow-barbed-wire-accumulator" then
					surface.create_entity { name = "reinforced-barbed-wire-charged-projectile", position = entity.position, force = entity.force, speed = 1.0, target = accum }
				else
					surface.create_entity { name = "barbed-wire-charged-projectile", position = entity.position, force = entity.force, speed = 1.0, target = accum }
				end
			end
			entity.destroy()
		end
	end
)
	
script.on_event(
	{
		defines.events.on_preplayer_mined_item,
		defines.events.on_robot_pre_mined
	},
	function(event)
		local entity = event.entity
		local name = entity.name
		if name == "barbed-wire" or name == "reinforced-barbed-wire"
				or name == "slow-barbed-wire" or name == "reinforced-slow-barbed-wire" then
			local Accums = global.barbedWireAccums
			local Dummies = global.barbedWireDummies
			local key = poskey(entity)
			global.barbedWireMains[key] = nil
			if Accums[key] then
				Accums[key].destroy()
				Accums[key] = nil
				Dummies[key].destroy()
				Dummies[key] = nil
			end
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		elseif name == "barbed-wire-accumulator" or name == "reinforced-barbed-wire-accumulator"
				or name == "slow-barbed-wire-accumulator" or name == "reinforced-slow-barbed-wire-accumulator" then
			local Mains = global.barbedWireMains
			local Dummies = global.barbedWireDummies
			local key = poskey(entity)
			Mains[key].destroy()
			Mains[key] = nil
			Dummies[key].destroy()
			Dummies[key] = nil
			global.barbedWireAccums[key] = nil
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		end
	end)
	
script.on_event(
	defines.events.on_entity_died,
	function(event)
		local entity = event.entity
		local name = entity.name
		if name == "barbed-wire" or name == "reinforced-barbed-wire"
				or name == "slow-barbed-wire" or name == "reinforced-slow-barbed-wire" then
			local Accums = global.barbedWireAccums
			local Dummies = global.barbedWireDummies
			local key = poskey(entity)
			global.barbedWireMains[key] = nil
			if Accums[key] then
				Accums[key].destroy()
				Accums[key] = nil
				Dummies[key].destroy()
				Dummies[key] = nil
			end
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		elseif name == "barbed-wire-accumulator" or name == "reinforced-barbed-wire-accumulator"
				or name == "slow-barbed-wire-accumulator" or name == "reinforced-slow-barbed-wire-accumulator" then
			global.barbedWireMains[poskey(entity)].die()
		end
	end
)
local energyIter = 10
local updateIter = 15
local waitIter = 5
local waitTime = (120 / waitIter) - (120 / waitIter) % 1

local function poskey(entity)
	local position = entity.position
	return tostring(entity.surface.name)..":"..tostring(position.x)..":"..tostring(position.y)
end

local function init()
	if game.forces.barbedWire == nil then
		local wireForce = game.create_force("barbedWire")
		for _,force in pairs(game.forces) do
			wireForce.set_cease_fire(force, false)
		end
	end
	-- poskey, entity
	global.barbedWireMains = global.barbedWireMains or {}
	global.barbedWireAccums = global.barbedWireAccums or {}
	global.barbedWireDummies = global.barbedWireDummies or {}
	global.barbedWireHazards = global.barbedWireHazards or {}
	-- poskey, health
	global.barbedWireHealth = global.barbedWireHealth or {}
	-- poskey, {entity, time}
	global.barbedWireWaiting = global.barbedWireWaiting or {}
end

local function indexWires()
	local Mains = global.barbedWireMains
	local Waiting = global.barbedWireWaiting
	local Health = global.barbedWireHealth
	local Hazards = global.barbedWireHazards
	for _,surface in pairs(game.surfaces) do
		for _,wire in pairs(surface.find_entities_filtered{name = "barbed-wire"}) do 
			local key = poskey(wire)
			if Mains[key] == nil then
				local hazard = wire.surface.create_entity{name = wire.name.."-hazard", position = wire.position, force = "barbedWire"}
				Mains[key] = wire
				Waiting[key] = { wire, waitTime }
				Health[key] = wire.health
				Hazards[key] = hazard
			end
		end
		for _,wire in pairs(surface.find_entities_filtered{name = "reinforced-barbed-wire"}) do 
			local key = poskey(wire)
			if Mains[key] == nil then
				local hazard = wire.surface.create_entity{name = wire.name.."-hazard", position = wire.position, force = "barbedWire"}
				Mains[key] = wire
				Waiting[key] = { wire, waitTime }
				Health[key] = wire.health
				Hazards[key] = hazard
			end
		end
		for _,wire in pairs(surface.find_entities_filtered{name = "slow-barbed-wire"}) do 
			local key = poskey(wire)
			if Mains[key] == nil then
				local hazard = wire.surface.create_entity{name = wire.name.."-hazard", position = wire.position, force = "barbedWire"}
				Mains[key] = wire
				Waiting[key] = { wire, waitTime }
				Health[key] = wire.health
				Hazards[key] = hazard
			end
		end
		for _,wire in pairs(surface.find_entities_filtered{name = "reinforced-slow-barbed-wire"}) do 
			local key = poskey(wire)
			if Mains[key] == nil then
				local hazard = wire.surface.create_entity{name = wire.name.."-hazard", position = wire.position, force = "barbedWire"}
				Mains[key] = wire
				Waiting[key] = { wire, waitTime }
				Health[key] = wire.health
				Hazards[key] = hazard
			end
		end
	end
end

local function unlockTech(reset)
	for _,force in pairs(game.forces) do
		if reset then 
			force.reset_recipes()
			force.reset_technologies()
		end
		if force.technologies["military"].researched then
			force.recipes["barbed-wire"].enabled = true
		end
		if force.technologies["military-2"].researched then
			force.recipes["reinforced-barbed-wire"].enabled = true
		end
		if force.technologies["military-3"].researched then
			force.recipes["slow-barbed-wire"].enabled = true
		end
		if force.technologies["military-4"].researched then
			force.recipes["reinforced-slow-barbed-wire"].enabled = true
		end
	end
end

script.on_init(function()
	init()
	indexWires()
end)

script.on_configuration_changed(
	function(data)
		if data.mod_changes ~= nil and data.mod_changes["Barbed-Wire"] ~= nil and data.mod_changes["Barbed-Wire"].old_version == nil then
			init()
			unlockTech(false) -- do not reset
		end
		if data.mod_changes ~= nil and data.mod_changes["Barbed-Wire"] ~= nil and data.mod_changes["Barbed-Wire"].old_version ~= nil then
			init()
			indexWires()
			unlockTech(true) -- do reset
		end
	end
)

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
	defines.events.on_force_created,
	function(event)
		local force = event.force
		if force ~= game.forces.barbedWire then
			game.forces.barbedWire.set_cease_fire(force, false)
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
			local hazard = entity.surface.create_entity{name = entityName.."-hazard", position = entity.position, force = "barbedWire"}
			global.barbedWireMains[key] = entity
			global.barbedWireWaiting[key] = { entity, waitTime }
			global.barbedWireHealth[key] = entity.health
			global.barbedWireHazards[key] = hazard
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
				wire.surface.create_entity{name = wire.name.."-hazard", position = wire.position, force = "barbedWire"}
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
			local Hazards = global.barbedWireHazards
			local key = poskey(entity)
			global.barbedWireMains[key] = nil
			if Accums[key] then
				Accums[key].destroy()
				Accums[key] = nil
				Dummies[key].destroy()
				Dummies[key] = nil
			end
			if Hazards[key] then
				Hazards[key].destroy()
				Hazards[key] = nil
			end
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		elseif name == "barbed-wire-accumulator" or name == "reinforced-barbed-wire-accumulator"
				or name == "slow-barbed-wire-accumulator" or name == "reinforced-slow-barbed-wire-accumulator" then
			local Mains = global.barbedWireMains
			local Dummies = global.barbedWireDummies
			local Hazards = global.barbedWireHazards
			local key = poskey(entity)
			Mains[key].destroy()
			Mains[key] = nil
			Dummies[key].destroy()
			Dummies[key] = nil
			Hazards[key].destroy()
			Hazards[key] = nil
			global.barbedWireAccums[key] = nil
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		end
	end
)
	
script.on_event(
	defines.events.on_entity_died,
	function(event)
		local entity = event.entity
		local name = entity.name
		if name == "barbed-wire" or name == "reinforced-barbed-wire"
				or name == "slow-barbed-wire" or name == "reinforced-slow-barbed-wire" then
			local Accums = global.barbedWireAccums
			local Dummies = global.barbedWireDummies
			local Hazards = global.barbedWireHazards
			local key = poskey(entity)
			global.barbedWireMains[key] = nil
			if Accums[key] then
				Accums[key].destroy()
				Accums[key] = nil
				Dummies[key].destroy()
				Dummies[key] = nil
			end
			if Hazards[key] then
				Hazards[key].destroy()
				Hazards[key] = nil
			end
			global.barbedWireWaiting[key] = nil
			global.barbedWireHealth[key] = nil
		elseif name == "barbed-wire-accumulator" or name == "reinforced-barbed-wire-accumulator"
				or name == "slow-barbed-wire-accumulator" or name == "reinforced-slow-barbed-wire-accumulator" then
			global.barbedWireMains[poskey(entity)].die()
		end
	end
)
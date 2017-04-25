local dmg = 2
local multi = 3
local playerCheckIter = 10
local waitIter = 5
local waitTime = (120 / waitIter) - (120 / waitIter) % 1

local function poskey(entity)
	-- gives the rounded down position of entity
    local position = entity.position
    return tostring(entity.surface.name) .. ":" .. tostring(position.x - position.x % 1) .. ":" .. tostring(position.y - position.y % 1)
end

local function endsWith(str, key)
	-- checks if str ends with key
    return key == "" or key == string.sub(str, -string.len(key))
end

local function init()
    -- poskey, entity
    global.barbedWireMains = global.barbedWireMains or {}
    global.barbedWireDummies = global.barbedWireDummies or {}
    global.barbedWireDummies2 = global.barbedWireDummies2 or {}
    global.barbedWireTurrets = global.barbedWireTurrets or {}
    -- poskey, {entity, time}
    global.barbedWireWaiting = global.barbedWireWaiting or {}
end

local function indexAllWires()
    local Mains = global.barbedWireMains
    local Waiting = global.barbedWireWaiting
    -- search for all barbed-wires and index them
    for _, surface in pairs(game.surfaces) do
        for _, wire in pairs(surface.find_entities_filtered { type = "land-mine" }) do
            if endsWith(wire.name, "barbed-wire") then
                local key = poskey(wire)
                if Mains[key] == nil then
                    Mains[key] = wire
                    Waiting[key] = { wire, waitTime }
                end
            end
        end
    end
end

local function unlockTech()
    for _, force in pairs(game.forces) do
		force.reset_recipes()
		force.reset_technologies()
		local tech = force.technologies
		local recipes = force.recipes
        if tech["military"].researched then
            recipes["standard-barbed-wire"].enabled = true
        end
        if tech["military-2"].researched then
            recipes["reinforced-barbed-wire"].enabled = true
            recipes["slowing-barbed-wire"].enabled = true
            recipes["conductive-barbed-wire"].enabled = true
        end
        if tech["military-3"].researched then
            recipes["reinforced-slowing-barbed-wire"].enabled = true
            recipes["reinforced-conductive-barbed-wire"].enabled = true
            recipes["slowing-conductive-barbed-wire"].enabled = true
        end
        if tech["military-4"].researched then
            recipes["reinforced-slowing-conductive-barbed-wire"].enabled = true
        end
    end
end

script.on_init(function()
    init()
    indexAllWires()
end)

script.on_configuration_changed(function(data)
	-- added
    if data.mod_changes ~= nil and data.mod_changes["Barbed-Wire"] ~= nil and data.mod_changes["Barbed-Wire"].old_version == nil then
        init()
        unlockTech()
    end
	-- updated
    if data.mod_changes ~= nil and data.mod_changes["Barbed-Wire"] ~= nil and data.mod_changes["Barbed-Wire"].old_version ~= nil then
        init()
		-- clear everything but mains, then reindex everything
		global.barbedWireMains = {}
		global.barbedWireAccums = nil
		global.barbedWireHazards = nil
		global.barbedWireHealth = nil
		for _, surface in pairs(game.surfaces) do
			for _, dummy in pairs(surface.find_entities_filtered {}) do
				if endsWith(dummy.name, "barbed-wire-dummy") then
					dummy.destroy()
				elseif endsWith(dummy.name, "barbed-wire-dummy2") then
					dummy.destroy()
				elseif endsWith(dummy.name, "barbed-wire-charge-turret") then
					dummy.destroy()
				elseif endsWith(dummy.name, "barbed-wire-signal") then
					dummy.destroy()
				end
			end
		end
        indexAllWires()
    end
end)

script.on_event(defines.events.on_tick,
    function(event)
        local tick = event.tick
		-- build objects on delay
        if tick % waitIter == 0 then
            local Waiting = global.barbedWireWaiting
            for key, waiter in pairs(Waiting) do
                -- reduce counter
                waiter[2] = waiter[2] - 1
                -- build
                if waiter[2] == 0 then
                    local wire = waiter[1]
					local wireName = wire.name
					local pos = wire.position 
					local frc = wire.force
                    local createEntity = wire.surface.create_entity
                    local dummy = createEntity { name = wireName .. "-dummy", position = pos, force = frc }
					dummy.destructible = false
                    global.barbedWireDummies[key] = dummy
                    if string.find(wire.name, "conductive", 1, true) then
                        local turret = createEntity { name = wireName .. "-charge-turret", position = pos, force = frc }
						turret.destructible = false
                        global.barbedWireTurrets[key] = turret
                    else
                        local dummy2 = createEntity { name = wireName .. "-dummy2", position = pos, force = frc }
						dummy2.destructible = false
                        global.barbedWireDummies2[key] = dummy2
                    end
                    Waiting[key] = nil
                end
            end
        end
		-- check for and damage players standing on wire
        if tick % playerCheckIter == 0 then
            for _, player in pairs(game.players) do
                local character = player.character
                if character then
                    local key = poskey(character)
                    if global.barbedWireDummies[key] then
                        local wire = global.barbedWireMains[key]
                        local damage = dmg
                        if string.find(wire.name, "reinforced", 1, true) then
                            damage = dmg * multi
                        end
                        character.damage(damage, wire.force, "physical")
                    end
                end
            end
        end
    end)

script.on_event(defines.events.on_trigger_created_entity,
    function(event)
        local entity = event.entity
        local entityName = entity.name
		-- check what type of signal is sent, then send charge projectile at enemy
        if entityName == "barbed-wire-signal" then
            local createEntity = entity.surface.create_entity
            local pos = entity.position
            local temp = createEntity { name = "barbed-wire-temp-dummy", position = pos, force = "neutral" }
            createEntity { name = "barbed-wire-charge-projectile", position = pos, force = entity.force, speed = 10, target = temp }
            temp.destroy()
			entity.destroy()
        elseif entityName == "barbed-wire-reinforced-signal" then
            local createEntity = entity.surface.create_entity
            local pos = entity.position
            local temp = createEntity { name = "barbed-wire-temp-dummy", position = pos, force = "neutral" }
            createEntity { name = "barbed-wire-reinforced-charge-projectile", position = pos, force = entity.force, speed = 10, target = temp }
            temp.destroy()
			entity.destroy()
        end
    end)
	
script.on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity
},
    function(event)
        local entity = event.created_entity
        local entityName = entity.name
        if endsWith(entityName, "barbed-wire") then
            -- index
            local key = poskey(entity)
            global.barbedWireMains[key] = entity
            global.barbedWireWaiting[key] = { entity, waitTime }
        end
    end)

script.on_event({
    defines.events.on_preplayer_mined_item,
    defines.events.on_robot_pre_mined,
	defines.events.on_entity_died
},
    function(event)
		local Dummies = global.barbedWireDummies
		local Turrets = global.barbedWireTurrets
		local Dummies2 = global.barbedWireDummies2
        local entity = event.entity
        local entityName = entity.name
        if endsWith(entityName, "barbed-wire") then
            local key = poskey(entity)
            global.barbedWireMains[key] = nil
            global.barbedWireWaiting[key] = nil
            if Dummies[key] then
                Dummies[key].destroy()
                Dummies[key] = nil
            end
            if Turrets[key] then
                Turrets[key].destroy()
                Turrets[key] = nil
            elseif Dummies2[key] then
                Dummies2[key].destroy()
                Dummies2[key] = nil
            end
        end
    end)
game.reload_script()

global.barbedWireMains = global.barbedWireMains or {}
global.barbedWireDummies = global.barbedWireDummies or {}
global.barbedWireDummies2 = global.barbedWireDummies2 or {}
global.barbedWireTurrets = global.barbedWireTurrets or {}
global.barbedWireWaiting = global.barbedWireWaiting or {}

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


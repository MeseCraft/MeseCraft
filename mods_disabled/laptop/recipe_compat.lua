laptop.recipe_compat = {
	-- Init all used vars to avoid crash if missed
	tin = '-unknown-', copper = '-unknown-', gold = '-unknown-',
	steel = '-unknown-', glass = '-unknown-', diamond = '-unknown-',
	silicon = '-unknown-', fiber = '-unknown-',
	gates_diode = '-unknown-', gates_and = '-unknown-', gates_or = '-unknown-',
	gates_nand = '-unknown-', gates_xor = '-unknown-', gates_not = '-unknown-',
	fpga = '-unknown-', programmer = '-unknown-', delayer = '-unknown-',
	controller = '-unknown-', light_red = '-unknown-', light_green = '-unknown-',
	light_blue = '-unknown-',
}

local rc = laptop.recipe_compat

-- Fallback values from default mod
if minetest.get_modpath('default') then
	rc.tin = 'default:tin_ingot'
	rc.copper = 'default:copper_ingot'
	rc.gold = 'default:gold_ingot'
	rc.steel = 'default:steel_ingot'
	rc.glass = 'default:glass'
	rc.diamond = 'default:diamond'
end

if minetest.get_modpath('homedecor') then
	rc.gates_diode = 'homedecor:paraffin'
	rc.gates_and = 'homedecor:power_crystal'
	rc.gates_or = 'homedecor:steel_strip'
	rc.gates_nand = 'homedecor:steel_wire'
	rc.gates_xor = 'homedecor:copper_wire'
	rc.gates_not = 'homedecor:copper_strip'
	rc.fpga = 'homedecor:ic'
	rc.programmer = 'homedecor:heating_element'
	rc.controller = 'homedecor:motor'
end

if minetest.get_modpath('mesecons_materials') then
	rc.silicon = 'mesecons_materials:silicon'
	rc.fiber = 'mesecons_materials:fiber'
end

if minetest.get_modpath('mesecons_gates') then
	rc.gates_diode = 'mesecons_gates:diode_off'
	rc.gates_and = 'mesecons_gates:and_off'
	rc.gates_or = 'mesecons_gates:or_off'
	rc.gates_nand = 'mesecons_gates:nand_off'
	rc.gates_xor = 'mesecons_gates:xor_off'
	rc.gates_not = 'mesecons_gates:not_off'
end

if minetest.get_modpath('mesecons_fpga') then
	rc.fpga = 'mesecons_fpga:fpga0000'
	rc.programmer = 'mesecons_fpga:programmer'
end

if minetest.get_modpath('mesecons_delayer') then
	rc.delayer = 'mesecons_delayer:delayer_off_1'
end

if minetest.get_modpath('mesecons_luacontroller') then
	rc.controller = 'mesecons_luacontroller:luacontroller0000'
end

if minetest.get_modpath('mesecons_lightstone') then
	rc.light_red = 'mesecons_lightstone:lightstone_red_off'
	rc.light_green = 'mesecons_lightstone:lightstone_green_off'
	rc.light_blue = 'mesecons_lightstone:lightstone_blue_off'
end

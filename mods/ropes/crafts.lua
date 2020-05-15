-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

if minetest.get_modpath("farming") then
-- this doesn't work reliably due to side effects of https://github.com/minetest/minetest/issues/5518
--	local old_def = minetest.registered_craftitems["farming:cotton"]
--	if old_def then
--		old_def.groups["thread"] = 1
--		minetest.override_item("farming:cotton", {
--			groups = old_def.groups
--		})
--	end
	minetest.register_craft({
		output = 'ropes:ropesegment',
		recipe = {
			{'farming:cotton','farming:cotton'},
			{'farming:cotton','farming:cotton'},
			{'farming:cotton','farming:cotton'},
		}
	})
end

if minetest.get_modpath("hemp") then
	minetest.register_craft({
		output = 'ropes:ropesegment',
		recipe = {
			{'hemp:hemp_rope'},
			{'hemp:hemp_rope'},
		}
	})
end

if minetest.get_modpath("cottages") then
	minetest.register_craft({
		output = 'ropes:ropesegment',
		recipe = {
			{'cottages:rope'},
			{'cottages:rope'},
		}
	})
end

minetest.register_craft({
	output = 'ropes:ropesegment',
	recipe = {
		{'group:thread','group:thread'},
		{'group:thread','group:thread'},
		{'group:thread','group:thread'},
	}
})

minetest.register_craftitem("ropes:ropesegment", {
	description = S("Rope Segment"),
	_doc_items_longdesc = ropes.doc.ropesegment_longdesc,
    _doc_items_usagehelp = ropes.doc.ropesegment_usage,
	groups = {vines = 1},
	inventory_image = "ropes_item.png",
})

local cotton_burn_time = 1
ropes.wood_burn_time = minetest.get_craft_result({method="fuel", width=1, items={ItemStack("default:wood")}}).time
ropes.rope_burn_time = cotton_burn_time * 6
local stick_burn_time = minetest.get_craft_result({method="fuel", width=1, items={ItemStack("default:stick")}}).time
ropes.ladder_burn_time = ropes.rope_burn_time * 2 + stick_burn_time * 3

minetest.register_craft({
	type = "fuel",
	recipe = "ropes:ropesegment",
	burntime = ropes.rope_burn_time,
})
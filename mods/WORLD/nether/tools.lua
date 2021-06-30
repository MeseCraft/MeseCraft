--[[

  Copyright (C) 2020 lortas

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
  WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
  BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
  OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
  SOFTWARE.

]]--

local S = nether.get_translator

minetest.register_tool("nether:pick_nether", {
	description = S("Nether Pickaxe"),
	inventory_image = "nether_tool_netherpick.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.90, [2]=0.9, [3]=0.4}, uses=35, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_tool("nether:shovel_nether", {
	description = S("Nether Shovel"),
	inventory_image = "nether_tool_nethershovel.png",
	wield_image = "nether_tool_nethershovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.0, [2]=0.4, [3]=0.25}, uses=35, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1}
})

minetest.register_tool("nether:axe_nether", {
	description = S("Nether Axe"),
	inventory_image = "nether_tool_netheraxe.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.9, [2]=0.7, [3]=0.4}, uses=35, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_tool("nether:sword_nether", {
	description = S("Nether Sword"),
	inventory_image = "nether_tool_nethersword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.5, [2]=0.6, [3]=0.2}, uses=45, maxlevel=3},
		},
		damage_groups = {fleshy=10},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craftitem("nether:nether_ingot", {
	description = S("Nether Ingot"),
	inventory_image = "nether_nether_ingot.png"
})
minetest.register_craftitem("nether:nether_lump", {
	description = S("Nether Lump"),
	inventory_image = "nether_nether_lump.png",
})

minetest.register_craft({
	type = "cooking",
	output = "nether:nether_ingot",
	recipe = "nether:nether_lump",
	cooktime = 30,
})
minetest.register_craft({
	output = "nether:nether_lump",
	recipe = {
		{"nether:brick_compressed","nether:brick_compressed","nether:brick_compressed"},
		{"nether:brick_compressed","nether:brick_compressed","nether:brick_compressed"},
		{"nether:brick_compressed","nether:brick_compressed","nether:brick_compressed"},
	}
})

minetest.register_craft({
	output = "nether:pick_nether",
	recipe = {
		{"nether:nether_ingot","nether:nether_ingot","nether:nether_ingot"},
		{"", "group:stick", ""},
		{"", "group:stick", ""}
	}
})
minetest.register_craft({
	output = "nether:shovel_nether",
	recipe = {
		{"nether:nether_ingot"},
		{"group:stick"},
		{"group:stick"}
	}
})
minetest.register_craft({
	output = "nether:axe_nether",
	recipe = {
		{"nether:nether_ingot","nether:nether_ingot"},
		{"nether:nether_ingot","group:stick"},
		{"","group:stick"}
	}
})
minetest.register_craft({
	output = "nether:sword_nether",
	recipe = {
		{"nether:nether_ingot"},
		{"nether:nether_ingot"},
		{"group:stick"}
	}
})

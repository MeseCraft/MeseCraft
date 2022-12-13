-- FIREPLACE -----------------------------------------------

minetest.register_node("fireplace:fireplace", {
	description = "Fireplace",
	tiles = {"fireplace_top.png", "fireplace_top.png", "fireplace_side.png", "fireplace_top.png", "fireplace_top.png", "fireplace_front.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	paramtype2 = "facedir",
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "fireplace:fireplace_active"
		minetest.set_node(pos, node)
		minetest.sound_play("fire", {
			pos = pos,
			max_hear_distance = 10,
			gain = 6,
		})
	end
})

minetest.register_node("fireplace:fireplace_active", {
	tiles = {
	"fireplace_top.png", "fireplace_top.png", "fireplace_side.png", "fireplace_top.png", "fireplace_top.png",
		{
			image = "fireplace_active.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}
	},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	paramtype2 = "facedir",
	light_source = 8,
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "fireplace:fireplace"
		minetest.set_node(pos, node)
	end
})

minetest.register_craft({
	output = 'fireplace:fireplace',
	recipe = {
		{'default:wood', 'default:wood', 'default:wood'},
		{'default:stone', 'default:coalblock', 'default:stone'},
		{'default:stone', 'default:stone', 'default:stone'},
	}
})

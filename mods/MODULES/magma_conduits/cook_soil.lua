minetest.register_abm{
    label = "soil burning",
	nodenames = {"group:soil"},
	neighbors = {"default:lava_source", "default:lava_flowing"},
	interval = 10,
	chance = 5,
	action = function(pos)
		minetest.set_node(pos, {name = "default:sand"})
		minetest.check_for_falling(pos)
	end,
}

minetest.register_craft({
	output = 'decoblocks:scarecrow',
	recipe = {
		{'', 'farming:pumpkin', ''},
		{'default:stick', 'farming:straw', 'default:stick'},
		{'', 'group:wood', ''},
	}
})

minetest.register_craft({
	output = 'decoblocks:paper_lantern',
	recipe = {
		{'group:wood', 'default:paper', 'group:wood'},
		{'default:paper', 'morelights:bulb', 'default:paper'},
		{'group:wood', 'default:paper', 'group:wood'},
	}
})

minetest.register_craft({
        output = 'decoblocks:spikes 4',
        recipe = {
                {'', '', ''},
                {'', 'default:steel_ingot', ''},
                {'', 'default:steel_ingot', ''},
        }
})

--These recipes depend on Ethereal, but are more logical.

minetest.register_craft({
        output = 'decoblocks:bamboo_fence',
        recipe = {
                {'', '', ''},
                {'ethereal:bamboo', 'default:stick', 'ethereal:bamboo'},
                {'ethereal:bamboo', 'default:stick', 'ethereal:bamboo'},
        }
})

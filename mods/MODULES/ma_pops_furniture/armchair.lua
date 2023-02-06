local S = ma_pops_furniture.intllib

--Arm Chairs of all colors--
local chair2_table = { --name, color, colorize(hex or color name:intensity(1-255))
{'Black', 'black', 'black:225'},
{'Blue', 'blue', 'blue:225'},
{'Brown', 'brown', 'brown:225'},
{'Cyan', 'cyan', 'cyan:200'},
{'Dark Green', 'dark_green', 'green:225'},
{'Dark Grey', 'dark_grey', 'black:200'},
{'Green', 'green', '#32cd32:150'},
{'Grey', 'grey', 'black:100'},
{'Magenta', 'magenta', 'magenta:200'},
{'Orange', 'orange', 'orange:225'},
{'Pink', 'pink', 'pink:225'},
{'Red', 'red', 'red:225'},
{'Violet', 'violet', 'violet:225'},
{'White', 'white', 'white:1'},
{'Yellow', 'yellow', 'yellow:225'},
}

for i in ipairs (chair2_table) do
    local name = chair2_table[i][1]
    local color = chair2_table[i][2]
    local hex = chair2_table[i][3]

local cb = "^([combine:16x16:0,0=ma_pops_furniture_cb.png^[mask:ma_pops_furniture_mask.png)"
local cf = "^([combine:16x16:0,0=ma_pops_furniture_cf.png^[mask:ma_pops_furniture_mask.png)"

minetest.register_node("ma_pops_furniture:chair2_"..color, {
    description = S(name.." Arm Chair"),
    tiles = {"wool_"..color..".png","wool_"..color..".png"..cb,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, armchair = 1, furniture = 1, fall_damage_add_percent=-80, bouncy=80},
	sounds = {wood = {name="furn_bouncy", gain=0.8}},
    on_rightclick = ma_pops_furniture.sit,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, -0.3, -0.4, -0.3},
            {-0.4, -0.5, 0.4, -0.3, -0.4, 0.3},
            {0.4, -0.5, 0.4, 0.3, -0.4, 0.3},
            {0.4, -0.5, -0.4, 0.3, -0.4, -0.3},
            -----------------------------------
            {-0.450, -0.4, -0.450, 0.450, 0.1, 0.450},
            {-0.5, 0.1, -0.5, -0.3, 0.3, 0.0},
            {0.5, 0.1, -0.5, 0.3, 0.3, 0.0},
            {0.450, 0.1, -0.0, -0.450, 0.5, 0.450},
        },
    }
})

minetest.register_craft({
    output = 'ma_pops_furniture:chair2_'..color,
    recipe = {
        {'wool:'..color, 'wool:'..color, 'wool:'..color, },
        {'wool:'..color, 'wool:'..color, 'wool:'..color, },
        {'group:wood', '', 'group:wood', },
    }
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_'..color,
	type = "shapeless",
	recipe = {'group:armchair', 'dye:'..color}
})
end


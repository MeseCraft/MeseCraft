minetest.register_node("letter_blocks:letter_blocks_apostrophe_sign",{
	description = "Carbon Apostrophe Sign",
	tiles = {"letter_blocks_apostrophe_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_apostrophe_sign",
	recipe = {
		{"","dye:white",""},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_a_sign",{
	description = "Carbon A Sign",
	tiles = {"letter_blocks_a_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_a_sign",
	recipe = {
		{"","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_blank_sign",{
	description = "Carbon Blank Sign",
	tiles = {"letter_blocks_blank_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	type = "cooking",
	output = "letter_blocks:letter_blocks_blank_sign",
	recipe = "wool:white",
	cooktime = 5,

})

--block break

minetest.register_node("letter_blocks:letter_blocks_b_sign",{
	description = "Carbon B Sign",
	tiles = {"letter_blocks_b_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_b_sign",
	recipe = {
		{"dye:white","dye:white","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_check_sign",{
	description = "Carbon Check Sign",
	tiles = {"letter_blocks_check_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_check_sign",
	recipe = {
		{"","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign",""},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_comma_sign",{
	description = "Carbon Comma Sign",
	tiles = {"letter_blocks_comma_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_comma_sign",
	recipe = {
		{"","",""},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_c_sign",{
	description = "Carbon C Sign",
	tiles = {"letter_blocks_c_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_c_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_double_quote_sign",{
	description = "Carbon Double Quote Sign",
	tiles = {"letter_blocks_double_quote_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_double_quote_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_d_sign",{
	description = "Carbon D Sign",
	tiles = {"letter_blocks_d_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_d_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_e_sign",{
	description = "Carbon E Sign",
	tiles = {"letter_blocks_e_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_e_sign",
	recipe = {
		{"dye:white","dye:white","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_exclamation_sign",{
	description = "Carbon Exclamation Sign",
	tiles = {"letter_blocks_exclamation_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_exclamation_sign",
	recipe = {
		{"","","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_f_sign",{
	description = "Carbon F Sign",
	tiles = {"letter_blocks_f_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_f_sign",
	recipe = {
		{"dye:white","dye:white","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_g_sign",{
	description = "Carbon G Sign",
	tiles = {"letter_blocks_g_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_g_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_h_sign",{
	description = "Carbon H Sign",
	tiles = {"letter_blocks_h_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_h_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_i_sign",{
	description = "Carbon I Sign",
	tiles = {"letter_blocks_i_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_i_sign",
	recipe = {
		{"","","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_j_sign",{
	description = "Carbon J Sign",
	tiles = {"letter_blocks_j_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_j_sign",
	recipe = {
		{"","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_k_sign",{
	description = "Carbon K Sign",
	tiles = {"letter_blocks_k_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_k_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_l_sign",{
	description = "Carbon L Sign",
	tiles = {"letter_blocks_l_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_l_sign",
	recipe = {
		{"dye:white","",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_m_sign",{
	description = "Carbon M Sign",
	tiles = {"letter_blocks_m_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_m_sign",
	recipe = {
		{"dye:white","dye:white","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_n_sign",{
	description = "Carbon N Sign",
	tiles = {"letter_blocks_n_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_n_sign",
	recipe = {
		{"","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_o_sign",{
	description = "Carbon O Sign",
	tiles = {"letter_blocks_o_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_o_sign",
	recipe = {
		{"","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_p_sign",{
	description = "Carbon P Sign",
	tiles = {"letter_blocks_p_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_p_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_q_sign",{
	description = "Carbon Q Sign",
	tiles = {"letter_blocks_q_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_q_sign",
	recipe = {
		{"","dye:white","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","","dye:white"}
	}
})

--block break
minetest.register_node("letter_blocks:letter_blocks_question_sign",{
	description = "Carbon Question Sign",
	tiles = {"letter_blocks_question_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_question_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_r_sign",{
	description = "Carbon R Sign",
	tiles = {"letter_blocks_r_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_r_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign",""},
		{"dye:white","",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_s_sign",{
	description = "Carbon S Sign",
	tiles = {"letter_blocks_s_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_s_sign",
	recipe = {
		{"","dye:white",""},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_t_sign",{
	description = "Carbon T Sign",
	tiles = {"letter_blocks_t_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_t_sign",
	recipe = {
		{"dye:white","dye:white","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_u_sign",{
	description = "Carbon U Sign",
	tiles = {"letter_blocks_u_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_u_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_v_sign",{
	description = "Carbon V Sign",
	tiles = {"letter_blocks_v_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_v_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","dye:white",""}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_w_sign",{
	description = "Carbon W Sign",
	tiles = {"letter_blocks_w_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_w_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"dye:white","letter_blocks:letter_blocks_blank_sign","dye:white"},
		{"dye:white","dye:white","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_x_sign",{
	description = "Carbon X Sign",
	tiles = {"letter_blocks_x_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_x_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"letter_blocks:letter_blocks_blank_sign","dye:white",""},
		{"dye:white","","dye:white"}
	}
})

--block break

minetest.register_node("letter_blocks:letter_blocks_y_sign",{
	description = "Carbon Y Sign",
	tiles = {"letter_blocks_y_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_y_sign",
	recipe = {
		{"dye:white","","dye:white"},
		{"letter_blocks:letter_blocks_blank_sign","dye:white",""},
		{"","dye:white",""}
	}
})

--block break


minetest.register_node("letter_blocks:letter_blocks_z_sign",{
	description = "Carbon Z Sign",
	tiles = {"letter_blocks_z_sign.png"},
	groups = {oddly_breakable_by_hand = 1},
})

minetest.register_craft({
	output = "letter_blocks:letter_blocks_z_sign",
	recipe = {
		{"dye:white","dye:white",""},
		{"","letter_blocks:letter_blocks_blank_sign",""},
		{"","dye:white","dye:white"}
	}
})

--block break

































--[[

   Hidden Doors - Adds various wood, stone, etc. doors.

   Copyright (C) 2017-2018  Hamlet

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

]]--


--
-- Minetest Game's based hidden doors
--

minetest.register_lbm({
   name = ":standard_remover_a",
   nodenames = {"doors:hidden_door_stone_a", "doors:hidden_door_cobble_a",
                "doors:hidden_door_stone_brick_a",
                "doors:hidden_door_stone_block_a",
                "doors:hidden_door_mossycobble_a",
                "doors:hidden_door_desert_stone_a",
                "doors:hidden_door_desert_cobble_a",
                "doors:hidden_door_desert_stone_brick_a",
                "doors:hidden_door_desert_stone_block_a",
                "doors:hidden_door_sandstone_a",
                "doors:hidden_door_sandstone_brick_a",
                "doors:hidden_door_sandstone_block_a",
                "doors:hidden_door_desert_sandstone_a",
                "doors:hidden_door_desert_sandstone_brick_a",
                "doors:hidden_door_desert_sandstone_block_a",
                "doors:hidden_door_silver_sandstone_a",
                "doors:hidden_door_silver_sandstone_brick_a",
                "doors:hidden_door_silver_sandstone_block_a",
                "doors:hidden_door_obsidian_a",
                "doors:hidden_door_obsidian_brick_a",
                "doors:hidden_door_obsidian_block_a",
                "doors:hidden_door_tree_a", "doors:hidden_door_jungletree_a",
                "doors:hidden_door_pine_tree_a",
                "doors:hidden_door_acacia_tree_a",
                "doors:hidden_door_aspen_tree_a", "doors:hidden_door_wood_a",
                "doors:hidden_door_junglewood_a",
                "doors:hidden_door_pine_wood_a",
                "doors:hidden_door_acacia_wood_a",
                "doors:hidden_door_aspen_wood_a",
                "doors:hidden_door_bronze_block_a",
                "doors:hidden_door_copper_block_a",
                "doors:hidden_door_gold_block_a",
                "doors:hidden_door_steel_block_a",
                "doors:hidden_door_tin_block_a",
                "doors:hidden_door_dirt_a", "doors:hidden_door_brick_a",
                "doors:hidden_door_ice_a", "doors:hidden_door_diamond_block_a",
                "doors:hidden_door_mese_block_a",
                "doors:hidden_door_bookshelf_a",
                "doors:hidden_door_sand_a", "doors:hidden_door_silver_sand_a",
                "doors:hidden_door_desert_sand_a",
   },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
})


minetest.register_lbm({
   name = ":standard_remover_b",
   nodenames = {"doors:hidden_door_stone_b", "doors:hidden_door_cobble_b",
                "doors:hidden_door_stone_brick_b",
                "doors:hidden_door_stone_block_b",
                "doors:hidden_door_mossycobble_b",
                "doors:hidden_door_desert_stone_b",
                "doors:hidden_door_desert_cobble_b",
                "doors:hidden_door_desert_stone_brick_b",
                "doors:hidden_door_desert_stone_block_b",
                "doors:hidden_door_sandstone_b",
                "doors:hidden_door_sandstone_brick_b",
                "doors:hidden_door_sandstone_block_b",
                "doors:hidden_door_desert_sandstone_b",
                "doors:hidden_door_desert_sandstone_brick_b",
                "doors:hidden_door_desert_sandstone_block_b",
                "doors:hidden_door_silver_sandstone_b",
                "doors:hidden_door_silver_sandstone_brick_b",
                "doors:hidden_door_silver_sandstone_block_b",
                "doors:hidden_door_obsidian_b",
                "doors:hidden_door_obsidian_brick_b",
                "doors:hidden_door_obsidian_block_b",
                "doors:hidden_door_tree_b", "doors:hidden_door_jungletree_b",
                "doors:hidden_door_pine_tree_b",
                "doors:hidden_door_acacia_tree_b",
                "doors:hidden_door_aspen_tree_b", "doors:hidden_door_wood_b",
                "doors:hidden_door_junglewood_b",
                "doors:hidden_door_pine_wood_b",
                "doors:hidden_door_acacia_wood_b",
                "doors:hidden_door_aspen_wood_b",
                "doors:hidden_door_bronze_block_b",
                "doors:hidden_door_copper_block_b",
                "doors:hidden_door_gold_block_b",
                "doors:hidden_door_steel_block_b",
                "doors:hidden_door_tin_block_b",
                "doors:hidden_door_dirt_b", "doors:hidden_door_brick_b",
                "doors:hidden_door_ice_b", "doors:hidden_door_diamond_block_b",
                "doors:hidden_door_mese_block_b",
                "doors:hidden_door_bookshelf_b",
                "doors:hidden_door_sand_b", "doors:hidden_door_silver_sand_b",
                "doors:hidden_door_desert_sand_b",
   },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
})


--
-- Compatible modules' based hidden doors
--

if minetest.get_modpath("darkage") then

	minetest.register_lbm({
		name = ":darkage_remover_a",
		nodenames = {"doors:hidden_door_adobe_a", "doors:hidden_door_basalt_a",
                   "doors:hidden_door_basalt_rubble_a",
                   "doors:hidden_door_basalt_brick_a",
                   "doors:hidden_door_basalt_block_a",
                   "doors:hidden_door_gneiss_a",
                   "doors:hidden_door_gneiss_rubble_a", 
                   "doors:hidden_door_gneiss_brick_a",
                   "doors:hidden_door_gneiss_block_a",
                   "doors:hidden_door_marble_a",
                   "doors:hidden_door_marble_tile_a",
                   "doors:hidden_door_ors_a", "doors:hidden_door_ors_rubble_a",
                   "doors:hidden_door_ors_brick_a",
                   "doors:hidden_door_ors_block_a",
                   "doors:hidden_door_serpentine_a",
                   "doors:hidden_door_shale_a", "doors:hidden_door_slate_a",
                   "doors:hidden_door_schist_a",
                   "doors:hidden_door_slate_rubble_a",
                   "doors:hidden_door_slate_tile_a",
                   "doors:hidden_door_slate_block_a",
                   "doors:hidden_door_slate_brick_a", "doors:hidden_door_tuff_a",
                   "doors:hidden_door_tuff_bricks_a",
                   "doors:hidden_door_tuff_rubble_a",
                   "doors:hidden_door_rhyolitic_tuff_a",
                   "doors:hidden_door_rhyolitic_tuff_bricks_a",
                   "doors:hidden_door_old_tuff_bricks_a",
                   "doors:hidden_door_rhyolitic_tuff_rubble_a",
      },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
	})


	minetest.register_lbm({
		name = ":darkage_remover_b",
		nodenames = {"doors:hidden_door_adobe_b", "doors:hidden_door_basalt_b",
                   "doors:hidden_door_basalt_rubble_b",
                   "doors:hidden_door_basalt_brick_b",
                   "doors:hidden_door_basalt_block_b",
                   "doors:hidden_door_gneiss_b",
                   "doors:hidden_door_gneiss_rubble_b", 
                   "doors:hidden_door_gneiss_brick_b",
                   "doors:hidden_door_gneiss_block_b",
                   "doors:hidden_door_marble_b",
                   "doors:hidden_door_marble_tile_b",
                   "doors:hidden_door_ors_b", "doors:hidden_door_ors_rubble_b",
                   "doors:hidden_door_ors_brick_b",
                   "doors:hidden_door_ors_block_b",
                   "doors:hidden_door_serpentine_b",
                   "doors:hidden_door_shale_b", "doors:hidden_door_slate_b",
                   "doors:hidden_door_schist_b",
                   "doors:hidden_door_slate_rubble_b",
                   "doors:hidden_door_slate_tile_b",
                   "doors:hidden_door_slate_block_b",
                   "doors:hidden_door_slate_brick_b", "doors:hidden_door_tuff_b",
                   "doors:hidden_door_tuff_bricks_b",
                   "doors:hidden_door_tuff_rubble_b",
                   "doors:hidden_door_rhyolitic_tuff_b",
                   "doors:hidden_door_rhyolitic_tuff_bricks_b",
                   "doors:hidden_door_old_tuff_bricks_b",
                   "doors:hidden_door_rhyolitic_tuff_rubble_b",
      },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
   })
end


if minetest.get_modpath("moreblocks") then

	minetest.register_lbm({
      name = ":moreblocks_remover_a",
      nodenames = {"doors:hidden_door_jungletree_top_a",
                   "doors:hidden_door_tree_top_a",
                   "doors:hidden_door_cactus_brick_a",
                   "doors:hidden_door_circle_stone_bricks_a",
                   "doors:hidden_door_coal_stone_a",
                   "doors:hidden_door_cobble_compressed_a",
                   "doors:hidden_door_copperpatina_a",
                   "doors:hidden_door_empty_bookshelf_a",
                   "doors:hidden_door_grey_bricks_a",
                   "doors:hidden_door_iron_stone_a",
                   "doors:hidden_door_iron_stone_bricks_a",
                   "doors:hidden_door_plankstone_a",
                   "doors:hidden_door_split_stone_tile_a",
                   "doors:hidden_door_split_stone_tile_alt_a",
                   "doors:hidden_door_stone_tile_a",
                   "doors:hidden_door_tar_a",
                   "doors:hidden_door_trap_stone_a",
                   "doors:hidden_door_wood_tile_full_a",
      },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
   })


	minetest.register_lbm({
      name = ":moreblocks_remover_b",
      nodenames = {"doors:hidden_door_jungletree_top_b",
                   "doors:hidden_door_tree_top_b",
                   "doors:hidden_door_cactus_brick_b",
                   "doors:hidden_door_circle_stone_bricks_b",
                   "doors:hidden_door_coal_stone_b",
                   "doors:hidden_door_cobble_compressed_b",
                   "doors:hidden_door_copperpatina_b",
                   "doors:hidden_door_empty_bookshelf_b",
                   "doors:hidden_door_grey_bricks_b",
                   "doors:hidden_door_iron_stone_b",
                   "doors:hidden_door_iron_stone_bricks_b",
                   "doors:hidden_door_plankstone_b",
                   "doors:hidden_door_split_stone_tile_b",
                   "doors:hidden_door_split_stone_tile_alt_b",
                   "doors:hidden_door_stone_tile_b",
                   "doors:hidden_door_tar_b",
                   "doors:hidden_door_trap_stone_b",
                   "doors:hidden_door_wood_tile_full_b",
      },

		action = function(pos)
         minetest.remove_node(pos)

         local new_x = pos.x
         local new_y = (pos.y + 1)
         local new_z = pos.z
         local upper_pos = {x = new_x, y = new_y, z = new_z}

         minetest.remove_node(upper_pos)
		end,
   })
end

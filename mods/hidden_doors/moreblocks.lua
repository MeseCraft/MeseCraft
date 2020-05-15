--[[
	Hidden Doors - Adds various wood, stone, etc. doors.
	Copyright © 2017, 2019 Hamlet <hamlatmesehub@riseup.net> and contributors.

	Licensed under the EUPL, Version 1.2 or – as soon they will be
	approved by the European Commission – subsequent versions of the
	EUPL (the "Licence");
	You may not use this work except in compliance with the Licence.
	You may obtain a copy of the Licence at:

	https://joinup.ec.europa.eu/software/page/eupl
	https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863

	Unless required by applicable law or agreed to in writing,
	software distributed under the Licence is distributed on an
	"AS IS" basis,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.
	See the Licence for the specific language governing permissions
	and limitations under the Licence.

--]]


--
-- Variables
--

-- Used for localization, choose either built-in or intllib.

local s_ModPath, S, NS = nil

if (minetest.get_modpath("intllib") == nil) then
	S = minetest.get_translator("hidden_doors")

else
	-- internationalization boilerplate
	s_ModPath = minetest.get_modpath(minetest.get_current_modname())
	S, NS = dofile(s_ModPath.."/intllib.lua")

end


--
-- Moreblocks module support
--

hidden_doors.RegisterHiddenDoors("default", "jungletree_top",
	s_RecipeItem1, "moreblocks:slab_all_faces_jungle_tree",
	"moreblocks:slab_all_faces_jungle_tree", S("All-faces Jungle Tree"),
	t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("default", "tree_top",
	s_RecipeItem1, "moreblocks:slab_all_faces_tree",
	"moreblocks:slab_all_faces_tree", S("All-faces Tree"),
	t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "cactus_brick",
	s_RecipeItem1, "moreblocks:slab_cactus_brick",
	"moreblocks:slab_cactus_brick", S("Cactus Brick"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

--[[ Disabled due to additional texture manipulation required

hidden_doors.RegisterHiddenDoors("moreblocks", "cactus_checker",
	s_RecipeItem1, "moreblocks:slab_cactus_checker",
	"moreblocks:slab_cactus_checker", S("Cactus Checker"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

]]--

hidden_doors.RegisterHiddenDoors("moreblocks", "circle_stone_bricks",
	s_RecipeItem1, "moreblocks:slab_circle_stone_bricks",
	"moreblocks:slab_circle_stone_bricks", S("Circle Stone Bricks"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

--[[ Disabled due to additional texture manipulation required

hidden_doors.RegisterHiddenDoors("moreblocks", "coal_checker",
	s_RecipeItem1, "moreblocks:slab_coal_checker",
	"moreblocks:slab_coal_checker", S("Coal Checker"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

]]--

hidden_doors.RegisterHiddenDoors("moreblocks", "coal_stone",
	s_RecipeItem1, "moreblocks:slab_coal_stone",
	"moreblocks:slab_coal_stone", S("Coal Stone"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "cobble_compressed",
	s_RecipeItem1, "moreblocks:slab_cobble_compressed",
	"moreblocks:slab_cobble_compressed", S("Cobble Compressed"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "copperpatina",
	s_RecipeItem1, "moreblocks:slab_copperpatina",
	"moreblocks:slab_copperpatina", S("Copper Patina"),
	t_MetalDefault, s_MetalOpen, s_MetalClose)


hidden_doors.RegisterHiddenDoors("moreblocks", "empty_shelf",
	s_RecipeItem1, "moreblocks:empty_shelf", nil, S("Empty Shelf"),
	t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "grey_bricks",
	s_RecipeItem1, "moreblocks:slab_grey_bricks",
	"moreblocks:slab_grey_bricks", S("Stone Bricks"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

--[[ Disabled due to additional texture manipulation required

hidden_doors.RegisterHiddenDoors("moreblocks", "iron_checker",
	s_RecipeItem1, "moreblocks:slab_iron_checker",
	"moreblocks:slab_iron_checker", S("Iron Checker"),
	t_MetalDefault, s_MetalOpen, s_MetalClose)

]]--

hidden_doors.RegisterHiddenDoors("moreblocks", "iron_stone",
	s_RecipeItem1, "moreblocks:slab_iron_stone",
	"moreblocks:slab_iron_stone", S("Iron Stone"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "iron_stone_bricks",
	s_RecipeItem1, "moreblocks:slab_iron_stone_bricks",
	"moreblocks:slab_iron_stone_bricks", S("Iron Stone Bricks"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "plankstone",
	s_RecipeItem1, "moreblocks:slab_plankstone", "moreblocks:slab_plankstone",
	S("Plankstone"), t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "split_stone_tile",
	s_RecipeItem1, "moreblocks:slab_split_stone_tile",
	"moreblocks:slab_split_stone_tile", S("Split Stone Tile"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "stone_tile",
	s_RecipeItem1, "moreblocks:slab_stone_tile",
	"moreblocks:slab_stone_tile", S("Stone Tile"),
	t_StoneDefault, t_StoneOpen, t_StoneClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "tar",
	s_RecipeItem1, "moreblocks:slab_tar", "moreblocks:slab_tar",
	S("Tar"), t_StoneDefault, t_StoneOpen, t_StoneClose)

--[[ Disabled due to additional texture manipulation required

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile",
	s_RecipeItem1, "moreblocks:slab_wood_tile", "moreblocks:slab_wood_tile",
	S("Wooden Tile"), t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_center",
	s_RecipeItem1, "moreblocks:slab_wood_tile_center",
	"moreblocks:slab_wood_tile_center", S("Centered Wooden Tile"),
	t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_down",
	s_RecipeItem1, "moreblocks:wood_tile_down", nil,
	S("Downwards Wooden Tile"), t_WoodDefault, s_WoodOpen, s_WoodClose)

]]--

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_full",
	s_RecipeItem1, "moreblocks:slab_wood_tile_full",
	"moreblocks:slab_wood_tile_full", S("Full Wooden Tile"),
	t_WoodDefault, s_WoodOpen, s_WoodClose)

--[[ Disabled due to additional texture manipulation required

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_left",
	s_RecipeItem1, "moreblocks:wood_tile_left", nil,
	S("Leftwards Wooden Tile"), t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_right",
	s_RecipeItem1, "moreblocks:wood_tile_right", nil,
	S("Rightwards Wooden Tile"), t_WoodDefault, s_WoodOpen, s_WoodClose)

hidden_doors.RegisterHiddenDoors("moreblocks", "wood_tile_up",
	s_RecipeItem1, "moreblocks:wood_tile_up", nil,
	S("Upwards Wooden Tile"), t_WoodDefault, s_WoodOpen, s_WoodClose)

]]--

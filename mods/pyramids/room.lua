local S = minetest.get_translator("pyramids")

-- ROOM LAYOUTS

local ROOM_WIDTH = 9

local room_types = {
	-- Pillar room
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","^"," ","^"," ","^"," ","^"," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" ","v"," ","v"," ","v"," ","v"," ",
			" "," "," "," "," "," "," "," "," "
		},
		traps = true,
	},
	-- Hieroglyph walls
	{
		style = "yrepeat",
		layout = {
			"s","h","h","h","h","h","h","h","s",
			"h"," "," "," "," "," "," "," ","h",
			"h"," "," "," "," "," "," "," ","h",
			"h"," "," "," "," "," "," "," ","h",
			" "," "," "," ","<"," "," "," ","h",
			"h"," "," "," "," "," "," "," ","h",
			"h"," "," "," "," "," "," "," ","h",
			"h"," "," "," "," "," "," "," ","h",
			"s","h","h","h","h","h","h","h","s"
		},
	},
	-- 4 large pillars
	{
		style = "yrepeat",
		layout = {
			" "," "," "," ","v"," "," "," "," ",
			" ","c","c"," "," "," ","c","c"," ",
			" ","c","c"," "," "," ","c","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","<",
			" "," "," "," "," "," "," "," "," ",
			" ","c","c"," "," "," ","c","c"," ",
			" ","c","c"," "," "," ","c","c"," ",
			" "," "," "," ","^"," "," "," "," "
		},
		traps = true,
	},
	-- hidden room
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","c","S","c","S","c"," "," ",
			" "," ","S"," "," "," ","S"," "," ",
			" "," ","c"," ",">"," ","c"," ","<",
			" "," ","S"," "," "," ","S"," "," ",
			" "," ","c","S","c","S","c"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," "
		},
	},
	-- spiral 1
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," ","c","c","c"," ","S"," ",
			" ","S"," ","c","v","c"," ","S"," ",
			"S","S"," ","c"," ","c"," ","S"," ",
			"S","S"," ","c"," "," "," ","S"," ",
			"v","S"," ","S","S","S","S","S"," ",
			" ","S"," "," "," "," "," "," "," "
		},
	},
	-- spiral 2
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S","S","S","S","S"," ",
			" "," "," ","c"," "," "," ","S"," ",
			"S","S"," ","c"," ","c"," ","S"," ",
			" ","S"," ","c","^","c"," ","S"," ",
			" ","S"," ","c","c","c"," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S","S","S","S","S","S","S"," ",
			" "," "," "," "," "," "," "," "," "
		},
	},
	-- pillar mania
	{
		style = "yrepeat",
		layout = {
			" "," ","v"," ","v"," ","v"," ","v",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," ","^"," ","^"," ","^"," ","^",
		},
		traps = true,
	},
	-- plusses
	{
		style = "yrepeat",
		layout = {
			"c"," "," "," "," "," "," "," ","c",
			" "," ","c",">"," ","<","c"," "," ",
			" ","c","s","c"," ","c","s","c"," ",
			" "," ","c"," "," "," ","c"," "," ",
			" "," "," "," ","<"," "," "," "," ",
			" "," ","c"," "," "," ","c"," "," ",
			" ","c","s","c"," ","c","s","c"," ",
			" "," ","c",">"," ","<","c"," "," ",
			"c"," "," "," "," "," "," "," ","c",
		},
		traps = true,
	},
	-- diamond
	{
		style = "yrepeat",
		layout = {
			">","s","s","c","c","c","s","s","s",
			"s","s","c"," "," "," ","c","s","s",
			"s","c"," "," "," "," "," ","c","s",
			"c"," "," "," "," "," "," "," ","c",
			" "," "," "," "," "," "," ","<","c",
			"c"," "," "," "," "," "," "," ","c",
			"s","c"," "," "," "," "," ","c","s",
			"s","s","c"," "," "," ","c","s","s",
			">","s","s","c","c","c","s","s","s",
		},
	},
	-- square
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S","^","S","S","S"," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S","S","S","S","S","S",">"," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S","S","S","v","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
		},
	},
	-- hallway 2
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S",">"," "," "," "," ",
			"S","S","S","S","S","^","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","v","S","S"," ",
			"S","S","S","S",">"," "," "," "," ",
		},
	},
	-- hallway 3
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S"," "," "," "," ",
			"S","S","S","S","c",">"," "," "," ",
			"S","c","S","c","S","c","S"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			"S","c","S","c","S","c","S"," "," ",
			"S","S","S","S","c",">"," "," "," ",
			"S","S","S","S","S"," "," "," "," ",
		},
		traps = true,
	},
	-- hallway 4
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S","v","S","S","S",
			"S","S","S","S","S","S","S","S","S",
			"c","S","c","S","c","S","c","S","c",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","<",
			" "," "," "," "," "," "," "," "," ",
			"c","S","c","S","c","S","c","S","c",
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","^","S","S","S",
		},
	},
	-- tiny
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S","S","S","S","v",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S"," "," "," ","S","S"," ",
			" "," "," "," ","<"," ","S","S"," ",
			"S","S","S"," "," "," ","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","S","S","S"," ",
			"S","S","S","S","S","S","S","S","^",
		},
	},
	-- small
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
			"S","S"," ","v"," ","v"," ","S","S",
			"S","S",">"," "," "," ","<","S"," ",
			" "," "," "," ","c"," "," ","S"," ",
			"S","S",">"," "," "," ","<","S"," ",
			"S","S"," ","^"," ","^"," ","S","S",
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
		},
	},
	-- small 2
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S","S","S","S","S"," ",
			" ","S"," "," ","v"," "," ","S"," ",
			"S","S"," "," "," "," "," ","S"," ",
			" "," "," "," "," "," ","<","S"," ",
			"S","S"," "," "," "," "," ","S"," ",
			" ","S"," "," ","^"," "," ","S"," ",
			" ","S","S","S","S","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
		},
	},
	-- big pillar
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","^"," "," "," "," ",
			" "," "," ","c","c","c"," "," "," ",
			" "," ","<","c","S","c",">"," "," ",
			" "," "," ","c","c","c"," "," "," ",
			" "," "," "," ","v"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- pacman
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," ","c","c","c"," "," "," ",
			" "," ","c","c","v","c","c"," "," ",
			" "," ","c",">"," "," "," "," "," ",
			" "," ","c","c","^","c","c"," "," ",
			" "," "," ","c","c","c"," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- the wall
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S","S","S"," ","<",
			"s","c","s","c","s","c","s"," ","c",
			"c"," "," "," "," "," ","c"," ","<",
			"s"," "," "," "," "," ","s"," ","c",
			" "," "," "," "," ","<","c"," ","<",
			"s"," "," "," "," "," ","s"," ","c",
			"c"," "," "," "," "," ","c"," ","<",
			"s","c","s","c","s","c","s"," ","c",
			"S","S","S","S","S","S","S"," ","<",
		},
		traps = true,
	},
	-- split
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," ","^"," ","^"," "," "," ",
			" "," "," ","c"," ","c"," "," "," ",
			" "," "," ","v"," ","v"," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- 4 small pillars
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","^"," "," "," "," ",
			" "," "," "," ","c"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" ","<","c"," "," "," ","c",">"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","c"," "," "," "," ",
			" "," "," "," ","v"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- 6 pillars
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," ","^"," ","^"," ","^"," "," ",
			" "," ","c"," ","c"," ","c"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","c"," ","c"," ","c"," "," ",
			" "," ","v"," ","v"," ","v"," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- stripes
	{
		style = "yrepeat",
		layout = {
			" ","S","v","S","v","S","v","S","v",
			" ","S"," ","S"," ","S"," ","S"," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" ","S"," ","S"," ","S"," ","S"," ",
			" ","S","^","S","^","S","^","S","^",
		},
		traps = true,
	},
	-- inside
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","c"," "," "," "," "," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," ","c","S","c"," "," "," ",
			" "," "," ","S",">"," "," "," "," ",
			" "," "," ","c","S","c"," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c"," "," "," "," "," ","c"," ",
			" "," "," "," "," "," "," "," "," ",
		},
	},
	-- 1 chest
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","<"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- 2 chests
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","<",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","<",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- X
	{
		style = "yrepeat",
		layout = {
			"c"," "," "," "," "," "," "," ","c",
			"c","c",">"," "," "," ","<","c","c",
			" ","c","c"," "," "," ","c","c"," ",
			" "," ","c","c"," ","c","c"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","c","c"," ","c","c"," "," ",
			" ","c","c"," "," "," ","c","c"," ",
			"c","c",">"," "," "," ","<","c","c",
			"c"," "," "," "," "," "," "," ","c",
		},
	},
	-- split 2
	{
		style = "yrepeat",
		layout = {
			"S","S","S","S","S","S","S","S","S",
			"S","S","S"," "," "," "," "," "," ",
			"S","S","S"," "," "," "," "," "," ",
			"S","S","S"," "," ","^","^","^","^",
			" "," "," "," "," ","c","c","c","c",
			"S","S","S"," "," ","v","v","v","v",
			"S","S","S"," "," "," "," "," "," ",
			"S","S","S"," "," "," "," "," "," ",
			"S","S","S","S","S","S","S","S","S",
		},
	},
	-- split 3
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" ","^"," ","^"," ","^"," ","^"," ",
			" ","c"," ","c"," ","c"," ","c"," ",
			" ","v"," ","v"," ","v"," ","v"," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- diamond 2
	{
		style = "yrepeat",
		layout = {
			"S","S"," "," "," "," "," ","S","S",
			"S"," "," "," ","c"," "," "," ","S",
			" "," ","<","S","S","S",">"," "," ",
			" "," ","S","S","S","S","S"," "," ",
			" ","c","S","S","S","S","S","c"," ",
			" "," ","S","S","S","S","S"," "," ",
			" "," ","<","S","S","S",">"," "," ",
			"S"," "," "," ","c"," "," "," ","S",
			"S","S"," "," "," "," "," ","S","S",
		},
		traps = true,
	},
	-- ultra pillars
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" ","c","^","c"," ","c","^","c"," ",
			" ","c","c","c"," ","c","c","c"," ",
			" ","c","c","c"," ","c","c","c"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","c","c","c"," ","c","c","c"," ",
			" ","c","c","c"," ","c","c","c"," ",
			" ","c","v","c"," ","c","v","c"," ",
			" "," "," "," "," "," "," "," "," ",
		},
	},
	-- vstripes
	{
		style = "yrepeat",
		layout = {
			"S"," "," "," "," "," "," "," "," ",
			"S"," "," ","^"," "," ","^"," "," ",
			"S"," "," ","c"," "," ","c"," "," ",
			"S"," "," "," "," "," "," "," "," ",
			" "," "," ","c"," "," ","c"," "," ",
			"S"," "," "," "," "," "," "," "," ",
			"S"," "," ","c"," "," ","c"," "," ",
			"S"," "," ","v"," "," ","v"," "," ",
			"S"," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- sides
	{
		style = "yrepeat",
		layout = {
			"c"," ","c"," ","c"," ","c"," ","c",
			" "," ","v"," ","v"," ","v"," "," ",
			"c"," "," "," "," "," "," "," ","c",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","c",
			" "," "," "," "," "," "," "," "," ",
			"c"," "," "," "," "," "," "," ","c",
			" "," ","^"," ","^"," ","^"," "," ",
			"c"," ","c"," ","c"," ","c"," ","c",
		},
		traps = true,
	},
	-- 9 pillars
	{
		style = "yrepeat",
		layout = {
			" "," "," "," "," "," "," "," "," ",
			" "," ","^"," ","^"," ","^"," "," ",
			" "," ","c"," ","c"," ","c"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","c"," ","c"," ","c"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","c"," ","c"," ","c"," "," ",
			" "," ","v"," ","v"," ","v"," "," ",
			" "," "," "," "," "," "," "," "," ",
		},
		traps = true,
	},
	-- Ankh statue
	{
		style = "stacked",
		layout = { {
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s",">"," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","s"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		}},
		stype = "desert_sandstone",
		wall = {
			"S","S","S","S","S","S","S","S","S",
			"s","1","s","1","s","1","s","1","s",
			"S","S","S","S","S","S","S","S","S",
			"1","s","1","s","1","s","1","s","1",
			"S","S","S","S","S","S","S","S","S",
		},
	},
--[[
	-- Cactus room 1
	{
		style = "stacked",
		layout_offset = -1,
		layout_height = 5,
		layout = {{
			"s","s","s","s","s","s","s","s","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","a","a","a","a","a","a","a","s",
			"s","s","s","s","s","s","s","s","s",
		},{
			" "," "," "," "," "," "," "," ","<",
			" ","C"," ","C"," ","C"," ","C"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","C"," ","C"," ","C"," ","C"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","C"," ","C"," ","C"," ","C"," ",
			" "," "," "," "," "," "," "," "," ",
			" ","C"," ","C"," ","C"," ","C"," ",
			" "," "," "," "," "," "," "," ","<",

		}},
		wall = {
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
			"s","3","s","3","s","3","s","3","s",
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
		},
		stype = "desert_sandstone",
	},
]]
	-- Cactus room 2
	{
		style = "stacked",
		layout_offset = -1,
		layout_height = 5,
		layout = {{
			"S","S","S","S","S","S","S","S","S",
			"S","s","s","s","s","s","s","s","S",
			"S","s","a","a","a","a","a","s","S",
			"S","s","a","a","a","a","a","s","S",
			"S","s","a","a","a","a","a","s","S",
			"S","s","a","a","a","a","a","s","S",
			"S","s","a","a","a","a","a","s","S",
			"S","s","s","s","s","s","s","s","S",
			"S","S","S","S","S","S","S","S","S",
		},{
			" "," "," "," "," "," "," "," ","<",
			" "," "," "," "," "," "," "," "," ",
			" "," ","C"," ","C"," ","C"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","C"," ","C"," ","C"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," ","C"," ","C"," ","C"," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," ","<",

		}},
		wall = {
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
			"s","3","s","3","s","3","s","3","s",
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
		},
		stype = "desert_sandstone",
	},
	-- Sun room
	{
		style = "stacked",
		layout_offset = 0,
		layout_height = 8,
		layout = {{
			"n","s","s","s","s","s","s","s","n",
			"s","n","s","s","s","s","s","n","s",
			"s","s","n","n","n","n","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","n","n","n","n","s","s",
			"s","n","s","s","s","s","s","n","s",
			"n","s","s","s","s","s","s","s","n",
		},{
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," ","<"," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			"n","s","s","s","s","s","s","s","n",
			"s","n","s","s","s","s","s","n","s",
			"s","s","n","n","n","n","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","s","s","s","n","s","s",
			"s","s","n","n","n","n","n","s","s",
			"s","n","s","s","s","s","s","n","s",
			"n","s","s","s","s","s","s","s","n",
		}},
		wall = {
			"S","S","S","S","S","S","S","S","S",
			"s","3","s","3","s","3","s","3","s",
			"S","S","S","S","S","S","S","S","S",
			"3","s","3","s","3","s","3","s","3",
			"S","S","S","S","S","S","S","S","S",
		},
		stype = "sandstone",
		open_roof = true,
	},
	-- Attic
	{
		style = "stacked",
		layout_height = 6,
		layout_offset = 1,
		layout = { {
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S"," ","S","S","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" "," "," "," ","c",">"," "," "," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S","S","S"," ","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S"," ","S","S","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" "," "," "," ","c"," "," "," "," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S","S","S"," ","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			" "," "," "," "," "," "," "," "," ",
			" ","S","S","S"," ","S","S","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" "," "," "," ","c"," "," "," "," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S"," "," "," "," "," ","S"," ",
			" ","S","S","S"," ","S","S","S"," ",
			" "," "," "," "," "," "," "," "," ",
		},{
			"s","s","s","s","s","s","s","s","s",
			"s","S","S","S","S","S","S","S","s",
			"s","S","s","s","s","s","s","S","s",
			"s","S","s","s","s","s","s","S","s",
			"s","S","s","s","s","s","s","S","s",
			"s","S","s","s","s","s","s","S","s",
			"s","S","s","s","s","s","s","S","s",
			"s","S","S","S","S","S","S","S","c",
			"s","s","s","s","s","s","s","s","s",
		},{
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","v","S","S","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S",">"," "," "," "," "," ","<","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S","S","S","^","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
		},{
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S"," "," "," "," "," ","S","S",
			"S","S","S","S","S","S","S","S","S",
			"S","S","S","S","S","S","S","S","S",
		}},
	},
}

local layout_traps_template = {
	"S","S","S","S","S","S","S","S","S",
	"?","?","?","?","?","?","?","?","S",
	"?","?","?","?","?","?","?","?","S",
	"?","?","?","?","?","?","?","?","S",
	"?","?","?","?","?","?","?","?","S", -- << entrance on left side
	"?","?","?","?","?","?","?","?","S",
	"?","?","?","?","?","?","?","?","S",
	"?","?","?","?","?","?","?","?","S",
	"S","S","S","S","S","S","S","S","S"
}

local code_sandstone = {
	[" "] = "air",
	["c"] = "default:sandstone",
	["s"] = "default:sandstone",
	["n"] = "default:desert_sandstone",
	["h"] = "default:sandstone",
	["S"] = "default:sandstonebrick",
	["1"] = "default:sandstone",
	["2"] = "default:sandstone",
	["3"] = "default:sandstone",
	["^"] = "default:chest",
	["<"] = "default:chest",
	[">"] = "default:chest",
	["v"] = "default:chest",
	["~"] = "default:lava_source",
	["t"] = "default:sandstone",
	["C"] = "default:large_cactus_seedling",
	["a"] = "default:sand",
}
local code_desert_sandstone = table.copy(code_sandstone)
code_desert_sandstone["c"] = "default:desert_sandstone"
code_desert_sandstone["s"] = "default:desert_sandstone"
code_desert_sandstone["n"] = "default:sandstone"
code_desert_sandstone["h"] = "default:desert_sandstone"
code_desert_sandstone["1"] = "default:desert_sandstone"
code_desert_sandstone["2"] = "default:desert_sandstone"
code_desert_sandstone["3"] = "default:desert_sandstone"
code_desert_sandstone["S"] = "default:desert_sandstone_brick"
code_desert_sandstone["t"] = "default:desert_sandstone"
code_desert_sandstone["a"] = "default:desert_sand"

local code_desert_stone = table.copy(code_sandstone)
code_desert_stone["c"] = "default:desert_stone_block"
code_desert_stone["s"] = "default:desert_stone_block"
code_desert_stone["n"] = "default:desert_stone_block"
code_desert_stone["h"] = "default:desert_stone_block"
code_desert_stone["1"] = "default:desert_stone_block"
code_desert_stone["2"] = "default:desert_stone_block"
code_desert_stone["3"] = "default:desert_stone_block"
code_desert_stone["S"] = "default:desert_stonebrick"
code_desert_stone["t"] = "air"
code_desert_stone["a"] = "default:desert_sand"

local function replace(str, iy, code_table, deco, column_style)
	if iy < 4 and (str == "<" or str == ">" or str == "^" or str == "v") then str = " " end
	if str == "h" then
		local r = math.random(0,3)
		if r > 0 then
			str = deco[r]
		else
			str = "c"
		end
	elseif column_style == 1 or column_style == 2 then
		if iy == 0 and str == "c" then str = deco[1] end
		if iy == 3 and str == "c" then str = deco[2] end
	elseif column_style == 3 then
		if iy == 0 and str == "c" then str = deco[1] end
		if iy == 2 and str == "c" then str = deco[2] end
	elseif column_style == 4 then
		if iy == 2 and str == "c" then str = deco[1] end
	end
	return code_table[str]
end

local function replace2(str, iy, depth, code_table, trap_node)
	if iy == depth then
		-- Sandstone at the bottom-most layer
		str = "s"
	elseif iy == depth-1 then
		-- Brick at the layer above
		str = "S"
	elseif iy == 0 and str == "~" then
		-- Trap stones at the top layer
		str = "t"
	elseif str == "~" then
		if iy < depth-3 then
			-- Air below the trap stones
			str = " "
		else
			str = trap_node
		end
	end
	-- Everything else is untouched (will stay pyramid material)

	return code_table[str]
end

local function get_flat_index(x, y, width)
	return 1 + x + y * width
end

local function rotate_layout_single(layout, width)
	local size = width*width
	local new_layout = {}
	for x=0, width-1 do
		for y=0, width-1 do
			local symbol = layout[get_flat_index((width-1) - y, x, width)]
			-- Rotate chest
			if symbol == "^" then
				symbol = "<"
			elseif symbol == "<" then
				symbol = "v"
			elseif symbol == "v" then
				symbol = ">"
			elseif symbol == ">" then
				symbol = "^"
			end
			new_layout[get_flat_index(x, y, width)] = symbol
		end
	end
	return new_layout
end

local function rotate_layout(layout, width, rotations)
	local new_layout = table.copy(layout)
	for r=1, rotations do
		new_layout = rotate_layout_single(new_layout, width)
	end
	return new_layout
end

-- pos: Position to spawn pyramid
-- stype: Sand type ("sandstone" or "desert")
-- room_id: Room layout identified (see list of rooms above)
-- rotations: Number of times to rotate the room (0-3)
function pyramids.make_room(pos, stype, room_id, rotations)
	local code_table = code_sandstone
	if stype == "desert_sandstone" then
		code_table = code_desert_sandstone
	elseif stype == "desert_stone" then
		code_table = code_desert_stone
	end
	-- Select random deco block
	local deco_ids = {"1", "2", "3"}
	local deco = {}
	for i=1, 3 do
		local r = math.random(1, #deco_ids)
		table.insert(deco, deco_ids[r])
		table.remove(deco_ids, r)
	end
	local hole = {x=pos.x+7,y=pos.y+5, z=pos.z+7}
	if room_id == nil then
		room_id = math.random(1, #room_types)
	end
	local room
	if room_id < 1 or room_id > #room_types then
		return false, S("Incorrect room type ID: @1", room_id)
	end
	local room = table.copy(room_types[room_id])
	local tries = 0
	while tries < #room_types do
		if room.stype and room.stype ~= stype then
			room_id = room_id + 1
			if room_id > #room_types then
				room_id = 1
			end
			room = table.copy(room_types[room_id])
		else
			break
		end
		tries = tries + 1
	end
	local chests = {}
	local column_style
	if stype == "desert_stone" then
		column_style = 0
	else
		column_style = math.random(0,4)
	end
	-- Custom room walls
	if room.wall then
		for iy=0,4,1 do
			for ie=0,8,1 do
				local nn = code_table[room.wall[iy*9+ie+1]]
				minetest.set_node({x=hole.x+ie, y=hole.y-iy, z=hole.z-1}, {name=nn})
				minetest.set_node({x=hole.x-1, y=hole.y-iy, z=hole.z+ie}, {name=nn})

				minetest.set_node({x=hole.x+ie, y=hole.y-iy, z=hole.z+9}, {name=nn})
				minetest.set_node({x=hole.x+9, y=hole.y-iy, z=hole.z+ie}, {name=nn})
			end
		end
	end
	local layout
	-- Place the room nodes
	if room.style == "yrepeat" then
		layout = rotate_layout(room.layout, ROOM_WIDTH, rotations)
		for iy=0,4,1 do
			for ix=0,8,1 do
				for iz=0,8,1 do
					local n_str = layout[ix*9+iz+1]
					local p2 = 0
					if n_str == "<" then
						p2 = 0
					elseif n_str == ">" then
						p2 = 2
					elseif n_str == "^" then
						p2 = 1
					elseif n_str == "v" then
						p2 = 3
					end
					local cpos = {x=hole.x+ix,y=hole.y-iy,z=hole.z+iz}
					local nn = replace(n_str, iy, code_table, deco, column_style)
					minetest.set_node(cpos, {name=nn, param2=p2})
					if nn == "default:chest" then
						table.insert(chests, cpos)
					end
				end
			end
		end
	elseif room.style == "stacked" then
		local layout_list = room.layout
		local layout
		local layout_offset = room.layout_offset
		local layout_height = room.layout_height
		if not layout_offset then
			layout_offset = 0
		end
		if not layout_height then
			layout_height = 5
		end
		for iy=0,layout_height-1,1 do
			layout = nil
			if layout_list[layout_height-iy] then
				layout = rotate_layout(layout_list[layout_height-iy], ROOM_WIDTH, rotations)
			end
			for ix=0,8,1 do
				for iz=0,8,1 do
					local n_str
					if layout then
						n_str = layout[ix*9+iz+1]
					else
						n_str = " "
					end
					local p2 = 0
					if n_str == "<" then
						p2 = 0
					elseif n_str == ">" then
						p2 = 2
					elseif n_str == "^" then
						p2 = 1
					elseif n_str == "v" then
						p2 = 3
					end
					local cpos = {x=hole.x+ix,y=hole.y-iy+layout_offset,z=hole.z+iz}
					local nn = code_table[n_str]
					minetest.set_node(cpos, {name=nn, param2=p2})
					if nn == "default:chest" then
						table.insert(chests, cpos)
					end
				end
			end
		end
	else
		minetest.log("error", "Invalid pyramid room style! room type ID="..r)
	end
	local sanded = room.flood_sand ~= false and stype ~= "desert_stone" and math.random(1,8) == 1
	if #chests > 0 then
		-- Make at least 8 attempts to fill chests
		local filled = 0
		local chests_with_treasure = 0
		while filled < 8 do
			for c=1, #chests do
				local has_treasure = pyramids.fill_chest(chests[c], stype, sanded, 30)
				if has_treasure then
					chests_with_treasure = chests_with_treasure + 1
				end
				filled = filled + 1
			end
		end
		-- If no chests were filled with treasure so far, fill a random chest guaranteed
		if chests_with_treasure == 0 then
			pyramids.fill_chest(chests[math.random(1, #chests)], stype, sanded, 100)
		end
	end
	if room.traps and math.random(1,4) == 1 then
		pyramids.make_traps(pos, stype, rotations, layout)
	end
	if sanded then
		pyramids.flood_sand(pos, stype)
	end
	return true, nil, sanded
end

local shuffle_traps = function(layout_traps, layout_room, chance)
	for a=1, #layout_traps do
		-- Delete trap if this space of the room is occupied
		if layout_room[a] ~= " " then
			layout_traps[a] = "S"
		-- Randomly turn tile into a trap, or not
		elseif layout_traps[a] == "?" then
			-- percentage for a trap
			if math.random(1,100) <= chance then
				layout_traps[a] = "~"
			else
				layout_traps[a] = "S"
			end
		end
	end
end

function pyramids.make_traps(pos, stype, rotations, layout_room)
	local code_table = code_sandstone
	if stype == "desert_sandstone" then
		code_table = code_desert_sandstone
	elseif stype == "desert_stone" then
		code_table = code_desert_stone
	end
	local layout_traps = table.copy(layout_traps_template)
	layout_traps = rotate_layout(layout_traps, ROOM_WIDTH, rotations)
	shuffle_traps(layout_traps, layout_room, math.random(10,100))
	-- Depth is total depth of trap area:
	-- * top layer with trap stones
	-- * followed by air layers
	-- * followed by 2 layers of lava
	-- * and 2 layers of sandstone/brick at the bottom (to prevent lava escaping)
	-- The depth of air between trap stones and lava layer is <depth> - 4
	local deep_trap = math.random(1,2) == 1
	local trap_node
	if deep_trap then
		trap_node = " "
		depth = 14
	else
		trap_node = "~"
		depth = 7
	end
	local wmin, wmax = -1,9
	local hole = {x=pos.x+7,y=pos.y, z=pos.z+7}
	for iy=0,depth,1 do
		for ix=wmin,wmax,1 do
			for iz=wmin,wmax,1 do
				local n_str
				if ix == wmin or ix == wmax or iz == wmin or iz == wmax then
					-- Walls around room
					if iy == depth then
						n_str = code_table["s"]
					else
						n_str = code_table["S"]
					end
					minetest.set_node({x=hole.x+ix,y=hole.y-iy,z=hole.z+iz}, {name=n_str})
				else
					n_str = layout_traps[ix*9+iz+1]
					minetest.set_node({x=hole.x+ix,y=hole.y-iy,z=hole.z+iz}, {name=replace2(n_str, iy, depth, code_table, trap_node)})
				end
			end
		end
	end
end

function pyramids.flood_sand(pos, stype)
	local set_to_sand = {}
	local nn = "default:sand"
	if stype == "desert_sandstone" or stype == "desert_stone" then
		nn = "default:desert_sand"
	end
	local hole = {x=pos.x+7,y=pos.y+1, z=pos.z+7}
	local maxh = math.random(1,4)
	local chance = math.random(1,7)
	for ix=0,8,1 do
		for iz=0,8,1 do
			if math.random(1,chance) == 1 then
				local h = math.random(1,maxh)
				for iy=0,h,1 do
					local p = {x=hole.x+ix,y=hole.y+iy,z=hole.z+iz}
					if minetest.get_node(p).name == "air" then
						table.insert(set_to_sand, p)
					end
				end
			end
		end
	end
	minetest.bulk_set_node(set_to_sand, {name=nn})
end


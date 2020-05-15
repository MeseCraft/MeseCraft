## Dependencies

[named_waypoints](https://github.com/FaceDeer/named_waypoints) is required even if waypoints won't be shown to the player, the underlying data structure is used to keep track of town locations so this mod can space them out appropriately.

## API

Settlement definitions are registered with the call `settlements.register_settlement(settlement_name, definition)`

Where `settlement_name` is a unique identifier string and `definition` is a table with the following properties:

```
local medieval_settlements = {
	-- a general name for this kind of settlement, used by bookgen when describing the settlement in travel guides
	description = S("village"),
	
	-- this settlement will be placed on nodes with this surface material type.
	surface_materials = {
		"default:dirt",
		"default:dirt_with_grass",
		"default:dry_dirt_with_dry_grass",
		"default:dirt_with_snow",
		"default:dirt_with_dry_grass",
		"default:dirt_with_coniferous_litter",
		"default:sand",
		"default:silver_sand",
		"default:snow_block",
	},

	-- nodes in all schematics will be replaced with these nodes, or a randomly-selected node
	-- from a list of choices if a list is provided
	replacements = {
		["default:junglewood"] = "settlements_medieval:junglewood",
	},

	-- Affected by per-building replace_nodes flag
	replacements_optional = {
		["default:cobble"] = {
			"default:junglewood",
			"default:pine_wood",
			"default:wood",
			"default:aspen_wood",
			"default:acacia_wood",
			"default:stonebrick",
			"default:cobble",
			"default:desert_stonebrick",
			"default:desert_cobble",
			"default:sandstone",
		},
	},

	-- This node will be replaced with the surface material of the location the building is placed on.
	replace_with_surface_material = "default:dirt_with_grass",

	-- Trees often interfere with surface detection. These nodes will be ignored when detecting surface level.
	ignore_surface_materials = {
		"default:tree",
		"default:jungletree",
		"default:pine_tree",
		"default:acacia_tree",
		"default:aspen_tree",
		"default:bush_stem",
		"default:bush_leaves",
		"default:acacia_bush_stem",
		"default:acacia_bush_leaves",
		"default:pine_bush_stem",
		"default:pine_bush_needles",
		"default:blueberry_bush_leaves_with_berries",
		"default:blueberry_bush_leaves",
	},

	-- The materials that will be used when building platforms underneath uneven building sites
	platform_shallow = "default:dirt",
	platform_deep = "default:stone",
	
	-- The material used to lay down pathways between buildings. Leave undefined to disable pathway generation.
	path_material = "default:gravel",

	schematics = schematic_table, -- See below for schematic definitions

	-- Select one of these to place at the center of town. If not defined, one will be picked at random from the regular schematic table
	central_schematics = {
		townhall_schematic,
		kingsmarket_schematic,
	},

	building_count_min = 5,
	building_count_max = 25,

	altitude_min = 2,
	altitude_max = 300,

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("settlement_towns")
		end
		return S("Town")
	end,

	-- Returns a randomly generated book, used by the bookgen ABM to slowly refill bookshelves in this settlement
	-- leave undefined to disable book generation.
	generate_book = function (pos, town_name)
	
	-- This is a special-purpose property used for cleaning up leaf blobs that might have been left behind
	-- when tree trunks got removed by buildings. It goes through every node in the mapchunk and sets the
	-- node's timer going if it matches (using find_nodes_in_area).
	trigger_timers_for_nodes = "group:leafdecay",
}
```

Schematics are in LUA format. Non-binary schematics are needed to allow randomized node replacements. If you want to use existing binary schematics when creating a settlement mod, the function "settlements.convert_mts_to_lua" exists as a way to get a LUA version without having to recreate it. References to schematics are wrapped in a table that contains various properties used by this mod:

```
local townhall_schematic = {
	name = "townhall", -- A unique identifier for this schematic
	schematic = dofile(schem_path.."medieval_townhall.lua"), -- A lua schematic, not a binary.
	buffer = 2, -- buffer space around the building, footprint is treated as radius max(size.x, size.z) + buffer for spacing purposes
	max_num = 0.1, -- This times the number of buildings in a settlement gives the maximum number of these buildings in a settlement.
					-- So for example, 0.1 means at most 1 of these buildings in a 10-building settlement and 2 in a 20-building settlement.
	replace_nodes_optional = true, -- If true, replacements_optional replacements from the settlement definition will be used. The same
					-- random replacement from replacements_optional will be used for all buildings in a settlement
	initialize_node = function(pos, node, node_def, settlement_info), -- allows additional post-creation actions to be executed
					-- on schematic nodes once they're constructed
	platform_ignore_group_above = "group:leafdecay", -- causes special handling of nodes belonging to this group. If 
		-- the node is in the space above the schematic being placed it will not be turned into air.
		-- For leaves, make sure to add trigger_timers_for_nodes = "group:leafdecay" to the settlement settings to clean
		-- up blobs of leaves that might be left over from trunks that have been removed.
}

local well_schematic = {
{
	name = "well",
	schematic = dofile(schem_path.."medieval_well.lua"),
	buffer = 2,
	max_num = 0.045,
	height_adjust = -2, -- adjusts the y axis of where the schematic is built, to allow for "basement" stuff
	platform_ignore_group_above = "group:leafdecay",
},
```

## Examples

See [settlements_fantasy](https://github.com/FaceDeer/settlements_fantasy) for a collection of fantasy-themed default settlements that exercise this API in various ways.

## Administrative commands and tools

This mod adds a set of items that are intended as administrative tools and will only function for players with the "server" privilege.

### Settlements build tool

![](/textures/settlements_settlement_marker.png)

When the user of this tool clicks on a surface, settlements will attempt to build an appropriate settlement for the material that was clicked on. It may fail to build the settlement if a node with no associated settlement was clicked on or if a settlement couldn't be fitted to the terrain.

### Settlement marking tool

![](/textures/settlements_location_marker.png)

This tool can be set to any registered settlement type by right-clicking (it cycles through them one by one), and when left-clicked it will mark that location as being a settlement of that type without regard to the actual surroundings and without placing any buildings.

This tool is primarily intended for marking a player-built settlement in such a way that it's handled by settlements' systems (travel guide generation, HUD waypoint markers, etc).

### Building placement tool

![](/textures/settlements_building_marker.png)

This tool forcibly places a single building schematic on the node that's been clicked on. Right-click to cycle through all registered building schematics from all registered settlements.

### Chat commands

`/settlements_rename_nearest [name]`

Lets you set the name of the nearest visible settlement. If you leave the name parameter blank then the settlement's name will be randomly regenerated.

`/settlements_regenerate_names <settlement_type>`

Randomly generates new names for all settlements of the given type. This command is useful if you've modified the random name generation and don't want to have to visit each settlement in turn to regenerate them.

`/settlements_remove_nearest`

Removes the nearest settlement from settlement's list. Note that this won't affect the physical structures of the settlement, you'll need to manually remove those. Regenerating the map block may potentially cause the settlements mod to decide this is a good place to put a new settlement, though, so take care.

`/settlements_create_in_mapchunk`

This is equivalent to using the settlement build tool on the terrain node in the exact center of the map chunk you're currently in.

## Credits

This iteration of the mod was written in 2020 by FaceDeer

This mod is based on "settlements" by Rochambeau (2018)

Which was in turn based on "ruins" by BlockMen
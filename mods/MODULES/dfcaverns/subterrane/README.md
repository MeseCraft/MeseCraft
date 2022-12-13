# subterrane

This mod was based off of Caverealms by HeroOfTheWinds, which was in turn based off of Subterrain by Paramat.

It is intended as a utility mod for other mods to use when creating a more interesting underground experience in Minetest, primarily through the creation of enormous underground "natural" caverns with hooks to add custom decorations. Installing this mod by itself will not do anything. This mod depends in turn on the [mapgen_helper](https://github.com/minetest-mods/mapgen_helper) mod.

The API has the following methods:

# Cavern registration 

## subterrane:register_cave_layer(cave_layer_def)

cave_layer_def is a table of the form:

```
{
	name = -- optional, defaults to the string "y_min to y_max" (with actual values inserted in place of y_min and y_max). Used for logging.
	y_max = -- required, the highest elevation this cave layer will be generated in. Upper boundaries for cavern depths are most efficient when they fit the formula (x*80-32)-1 where x is an integer, that way you don't generate map blocks that straddle two cavern layers. The "-1" keeps them from intruding on the map block above.
	y_min = -- required, the lowest elevation this cave layer will be generated in. Lower boundaries are most efficient when they fit (x*80-32).
	cave_threshold = -- optional, Cave threshold. Defaults to 0.5. 1 = small rare caves, 0 = 1/2 ground volume
	warren_region_threshold = -- optional, defaults to 0.25. Used to determine how much volume warrens take up around caverns. Set it to be equal to or greater than the cave threshold to disable warrens entirely.
	warren_region_variability_threshold = -- optional, defaults to 0.25. Used to determine how much of the region contained within the warren_region_threshold actually has warrens in it.
	warren_threshold = -- Optional, defaults to 0.25. Determines how "spongey" warrens are, lower numbers make tighter, less-connected warren passages.
	boundary_blend_range = -- optional, range near ymin and ymax over which caves diminish to nothing. Defaults to 128.
	perlin_cave = -- optional, a 3D perlin noise definition table to define the shape of the caves
	perlin_wave = -- optional, a 3D perlin noise definition table that's averaged with the cave noise to add more horizontal surfaces (squash its spread on the y axis relative to perlin_cave to accomplish this)
	perlin_warren_area = -- optional, a 3D perlin noise definition table for defining what places warrens form in
	perlin_warrens = -- optional, a 3D perlin noise definition table for defining the warrens
	solidify_lava = -- when set to true, lava near the edges of caverns is converted into obsidian to prevent it from spilling in.
	columns = -- optional, a column_def table for producing truly enormous dripstone formations. See below for definition. Set to nil to disable columns.
	double_frequency = -- when set to true, uses the absolute value of the cavern field to determine where to place caverns instead. This effectively doubles the number of large non-connected caverns.
	on_decorate = -- optional, a function that is given a table of indices and a variety of other mapgen information so that it can place custom decorations on floors and ceilings. It is given the parameters (minp, maxp, seed, vm, cavern_data, area, data). See below for the cavern_data table's member definitions.
	is_ground_content = -- optional, a function that takes a content_id and returns true if caverns should be carved through that node type. If not provided it defaults to a "is_ground_content" test.
}
```

The column_def table is of the form:

```
{
	maximum_radius = -- Maximum radius for individual columns, defaults to 10
	minimum_radius = -- Minimum radius for individual columns, defaults to 4 (going lower that this can increase the likelihood of "intermittent" columns with floating sections)
	node = -- node name to build columns out of. Defaults to default:stone
	warren_node = -- node name to build columns out of in warren areas. If not set, the nodes that would be columns in warrens will be left as original ground contents
	weight = -- a floating point value (usually in the range of 0.5-1) to modify how strongly the column is affected by the surrounding cave. Lower values create a more variable, tapered stalactite/stalagmite combination whereas a value of 1 produces a roughly cylindrical column. Defaults to 0.25
	maximum_count = -- The maximum number of columns placed in any given column region (each region being a square 4 times the length and width of a map chunk). Defaults to 50
	minimum_count = -- The minimum number of columns placed in a column region. The actual number placed will be randomly selected between this range. Defaults to 0.
}
```


This causes large caverns to be hollowed out during map generation. By default these caverns are just featureless cavities, but you can add extra subterrane-specific properties to biomes and the mapgen code will use them to add features of your choice using the "on_decorate" callback. The callback is passed a data table with the following information:

```
{
	cavern_floor_nodes = {} -- List of data indexes for nodes that are part of cavern floors. *Note:* Use ipairs() when iterating this, not pairs()
	cavern_floor_count = 0 -- the count of nodes in the preceeding list.
	cavern_ceiling_nodes = {} -- List of data indexes for nodes that are part of cavern ceilings. *Note:* Use ipairs() when iterating this, not pairs()
	cavern_ceiling_count = 0 -- the count of nodes in the preceeding list.
	warren_floor_nodes = {} -- List of data indexes for nodes that are part of warren floors. *Note:* Use ipairs() when iterating this, not pairs()
	warren_floor_count = 0 -- the count of nodes in the preceeding list.
	warren_ceiling_nodes = {} -- List of data indexes for nodes that are part of warren floors. *Note:* Use ipairs() when iterating this, not pairs()
	warren_ceiling_count = 0 -- the count of nodes in the preceeding list.
	tunnel_floor_nodes = {} -- List of data indexes for nodes that are part of floors in pre-existing tunnels (anything generated before this mapgen runs). *Note:* Use ipairs() when iterating this, not pairs()
	tunnel_floor_count = 0 -- the count of nodes in the preceeding list.
	tunnel_ceiling_nodes = {}  -- List of data indexes for nodes that are part of ceiling in pre-existing tunnels (anything generated before this mapgen runs). *Note:* Use ipairs() when iterating this, not pairs()
	tunnel_ceiling_count = 0 -- the count of nodes in the preceeding list.
	column_nodes = {} -- Nodes that belong to columns. Note that if the warren_node was not set in the column definition these might not have been replaced by anything yet. This list contains *all* column nodes, not just ones on the outer surface of the column.
	column_count = 0 -- the count of nodes in the preceeding list.

	contains_cavern = false -- Use this if you want a quick check if the generated map chunk has any cavern volume in it. Don't rely on the node counts above, if the map chunk doesn't intersect the floor or ceiling those could be 0 even if a cavern is present.
	contains_warren = false -- Ditto for contains_cavern, but for warrens instead of caverns.
	nvals_cave = nvals_cave -- The noise array used to generate the cavern.
	cave_area = cave_area -- a VoxelArea for indexing nvals_cave
	cavern_def = cave_layer_def -- a reference to the cave layer def.
}
```

# Common cavern features

Subterrane has a number of functions bundled with it for generating some basic features commonly found in caverns, both realistic and fantastical.

* `subterrane.register_stalagmite_nodes(base_name, base_node_def, drop_base_name)`
	* This registers a set of four standardized stalactite/stalagmite nodes that can be used with the subterrane.stalagmite function below. "base name" is a string that forms the prefix of the names of the nodes defined, for example the coolcaves mod might use "coolcaves:crystal_stal" and the resulting nodes registered would be "coolcaves:crystal_stal_1" through "coolcaves:crystal_stal_4". "base_node_def" is a node definition table much like is used with the usual node registration function. register_stalagmite_nodes will amend or substitute properties in this definition as needed, so the simplest base_node_def might just define the textures used. "drop_base_name" is an optional string that will substitute the node drops with stalagmites created by another use of register_stalagmite_nodes, for example if you wrote
		* `subterrane.register_stalagmite_nodes("coolcaves:dry_stal", base_dry_node_def)`
		* `subterrane.register_stalagmite_nodes("coolcaves:wet_stal", base_wet_node_def, "coolcaves:dry_stal")`
	* then when the player mines a dry stalactite they'll get a dry stalactite node and if they mine a wet stalactite they'll get a corresponding dry stalactite node as the drop instead.
	* This method returns a table consisting of the content IDs for the four stalactite nodes, which can be used directly in the following methods:

* `subterrane.stalagmite(vi, area, data, param2_data, param2, height, stalagmite_id)`
* `subterrane.stalactite(vi, area, data, param2_data, param2, height, stalagmite_id)`
	* These methods can be used to create a small stalactite or stalagmite, generally no more than 5 nodes tall. Use a negative height to generate a stalactite. The parameter stalagmite_id is a table of four content IDs for the stalagmite nodes, in order from thinnest ("_1") to thickest ("_4"). The register_stalagmite_nodes method returns a table that can be used for this directly.

* `subterrane.big_stalagmite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)`
* `subterrane.big_stalactite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)`
	* Generates a very large multi-node stalagmite or stalactite three nodes in diameter (with a five-node-diameter "root").

* `subterrane.giant_mushroom(vi, area, data, stem_material, cap_material, gill_material, stem_height, cap_radius)`
	* Generates an enormous mushroom. Cap radius works well in the range of around 2-6, larger or smaller than that may look odd.

# Player spawn

## subterrane:register_cave_spawn(cave_layer_def, start_depth)

When the player spawns (or respawns due to death), this method will tell Minetest to attempt to locate a subterrane-generated cavern to place the player in. cave_layer_def is the same format as the cave definition above. Start_depth is the depth at which the game will start searching for a location to place the player. If the game doesn't find a location immediately it may wind up restarting the search for a spawn location at the top of the cave definition, so start_depth is not a guarantee that the player will start at least that deep; he could spawn anywhere within the cave layer's depth range.
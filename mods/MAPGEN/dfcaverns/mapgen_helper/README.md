Mapgen Helper
=============

This mod provides a library of methods intended for use with other Minetest mapgen mods, automating routine tasks and giving tools to more easily perform mapgen operations. It's a bit of a random grab-bag, I put methods in here when I find that I use them frequently in other mods or when I just did a bunch of work solving a specific problem that could potentially be reused in future mods.

Part of the purpose of this mod is to make sure these methods are as efficient as possible, allowing them to be used in mapgens or ABMs or other such contexts where speed is of the essence or where the code will be executed many millions of times. Several of these methods may seem trivial to accomplish already by using a combination of existing methods (for example `VoxelArea:get_y(vi)` can already be accomplished with `VoxelArea:position(i).y`) but in this mod they've been written to eliminate unnecessary intermediate steps and unused calculations.

## Voxel Manipulator methods

*  `mapgen_helper.mapgen_vm_data()`
	* returns vm, data, area
	* Almost every mapgen mod does this operation first. This method retrieves the Voxel Manipulator for the generated map block, the voxel data array (automatically using a buffer internal to mapgen_helper to store it), and a VoxelArea for indexing the data array.
	* Note that you still need to write the data array to the voxel manipulator at the end of map generation.

* `mapgen_helper.mapgen_vm_data_param2()`
	* returns vm, data, param2_data, area
	* Almost identical to the previous method, this one also returns the param2 data array.

# VoxelArea methods

These methods are added to the existing VoxelArea LUA class.

* `VoxelArea:iterp_xyz(minp, maxp)`
	* Returns an iterator that gives not just the voxel index (vi), but also the x, y and z coordinates it represents. This lets you perform actions in your mapgen loop based on x, y and z coordinates without having to look them up from the voxel index. For example:  
		`for vi, x, y, z in area:iterp_xyz(minp, maxp) do`

* `VoxelArea:iter_xyz(minx, miny, minz, maxx, maxy, maxz)`
	* The same as above, but takes individual coordinate arguments instead of points.
	
* `VoxelArea:iterp_yxz(minp, maxp)`
	* Similar to the above, but the order of iteration is changed. Using this iterator, indices are visited in the +y direction along "columns". This is handy for mapgens that want to build stuff based on the nodes that are "below" the current node, for example if you're scanning through the map block looking for a walkable surface to place something on.

* `VoxelArea:iter_yxz(minx, miny, minz, maxx, maxy, maxz)`
	* Same as above, but takes individual coordinate arguments instead of points.
	
* `VoxelArea:get_y(vi)`
	* Returns the absolute y coordinate of the index provided. Useful for mapgens that want to do something at a specific elevation.

* `VoxelArea:transform(area, vi)`
	* Takes a VoxelArea and an index into that VoxelArea as parameters returns an index into its own VoxelArea, or nil if it's not in the voxelarea. This is useful when you've got two 3d data arrays that cover different volumes and would like to "map" values from one into the other. For example, if you've generated a 3d noise array using the mapgen's minp and maxp and want to map it onto the voxelmanipulator's emin and emax data array.
	
## Biomes

* `mapgen_helper.get_biome_def(biome_id)`
	* Given an id from the biome map, returns a biome definition. Normally translating a biome_id into a biome definition requires several steps and lookups, this method caches the intermediate results internal to mapgen_helper to speed up the operation.

* `mapgen_helper.get_biome_def_i(biomemap, minp, maxp, area, vi)`
	* When iterating through a voxelmanip's data array it is common to want to check what biome a given index belongs to. This method automates that lookup. Give it the biomemap that was provided by get_mapgen_object("biomemap"), the minp and maxp parameters from register_on_generated, the VoxelArea representing the generated map chunk, and the voxel index, and this method returns the biome_def that that voxel index lies inside.

## Node definitions

* `mapgen_helper.buildable_to(c_node)`
	*Given a node id, returns whether that node's definition is "buildable_to"

* `mapgen_helper.is_ground_content(c_node)`
	* Given a node id, returns whether that node's definition is "ground_content"

## Noise manager

* `mapgen_helper.perlin3d(name, minp, maxp, perlin_params)`
	* Returns nvals_perlin, area
	* Efficient generation and use of 3d perlin noise requires a bunch of steps that this method automates. It uses the "name" parameter to allocate buffers and generator objects in a table stored internally by mapgen_helper, if you're using multiple different noise fields in the same scope make sure to give them different names.
	* The perlin_params argument is actually optional if you've already made a call to this method (or used the 'mapgen_helper.register_perlin' method below), the perlin parameters are stored when provided and can be looked back up again by mapgen_helper.
	* The second return value is a VoxelArea for minp, maxp.

* `mapgen_helper.perlin2d(name, minp, maxp, perlin_params)`
	* Similar to the above method but for generating 2d noise. This method only returns the data array, it does not return a VoxelArea.

* `mapgen_helper.register_perlin(name, perlin_params)`
	* Pre-registering a perlin_params table is optional, any call to one of the above perlin methods with perlin_params provided will override the parameters registered here.

## 2D array indexing

* `mapgen_helper.index2d(minp, maxp, x, z)`
	* Returns an index for getting values out of 2d arrays (such as heightmap, biomemap, heatmap, arrays generated by perlin2d, etc) given x and z coordinates.
	* minp and maxp must be provided, these are the extents that were used when generating the 2d array.

* `mapgen_helper.index2dp(minp, maxp, pos)`
	* Version of the above that takes a pos instead of separate coordinates. pos.y is ignored.

* `mapgen_helper.index2di(minp, maxp, area, vi)`
	* Version of the above that indexes a 2d array based on the index in a 3d array.

## Schematics

*NOTE:* These methods operate on the LUA table format of schematic. To convert a .mts file into its lua representation, use `minetest.deserialize(minetest.serialize_schematic(schematic, "lua"))` to convert an .mts into a lua table.

* `mapgen_helper.get_schematic_bounding_box(pos, schematic, rotation, flags)`
	* Returns the minpos and maxpos of the bounding box that this schematic will be placed in given the rotation and flag parameters. Useful for testing whether a schematic will fit in a place before actually writing it to the data.

* `mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)`
	* Takes a lua-format schematic and applies it to the data and param2_data arrays produced by vmanip instead of being applied to the vmanip directly. Useful in a mapgen loop that's doing other things with the data before and after applying schematics. A VoxelArea for the data also needs to be provided.
	* *NOTE:* As of the writing of this documentation, this method is still somewhat of a work-in-progress. It only supports the table version of the `flags` parameter (eg, `{["place_center_x"] = true}`), and doesn't support rotating nodes of paramtype2 `wallmounted`, `colorfacedir`, or `colorwallmounted`. Support is planned in the near future.
	
	* This method has some additional features that the existing minetest schematic-placement API doesn't support:
		* node defs can have a "`place_on_condition(c_node)`" property defined. This is a function that is given the node content ID of the node the schematic is about to replace  and returns true to indicate the schematic should replace it or false to indicate it should not. Useful, for example, in a schematic that should replace water but not earth (placing decorations on the bottom of the ocean), or a schematic that replaces all buildable_to nodes (to prevent tufts of grass from knocking holes in foundations).
		* The schematic can have a "`center_pos`" position defined relative to the schematic's minpos that will be treated as the rotation and placement origin, unless overridden by the flags parameter.
	* Returns true if the schematic was entirely contained within the given voxelarea, false otherwise.
	
## Bounding boxes

* `mapgen_helper.is_within_distance_box(pos1, pos2, distance)`
	* A very cheap nearness test using Manhattan distance, useful as a fast first-pass check to see whether a more math-heavy test is needed.

* `mapgen_helper.intersect(minpos1, maxpos1, minpos2, maxpos2)`
	* Given two bounding boxes, returns a pair of points representing the minpos and maxpos of the intersection between them. If no intersection exists it returns nil.

* `mapgen_helper.intersect_exists(minpos1, maxpos1, minpos2, maxpos2)`
	* A cheaper version of the above method that only returns a true/false indication that an intersection exists.

* `mapgen_helper.intersect_exists_xz(minpos1, maxpos1, minpos2, maxpos2)`
	* An _even cheaper_ version of the above method that returns true/false based on whether the two bounding boxes overlap on the x-z plane.

## Lines

* `mapgen_helper.distance_to_segment(pos, start, end)`
	* Returns the minimum distance from the point "pos" to any point along the line segment defined by the points "start" and "end"

* `mapgen_helper.distance_to_path(pos, path)`
	* Similar to the above, but "path" is a list of points forming a continuous series of line segments. Distance returned is the shortest distance to any segment in the list.
	
## Random values

* `mapgen_helper.get_random_points(minp, maxp, min_output_size, max_output_size)`
	* Returns a consistent list of random points within a volume. Each call to this method will give the same set of points if the same parameters are provided, making this useful for placing things that extend outside of the currently-generated map chunk - for example, minp and maxp could be kilometers apart and the points designate the locations where mountains are to be placed.

* `mapgen_helper.xz_consistent_randomp(pos)'
	* Returns a random value based on the x and z coordinates of pos. The random value is always the same for the same x and z.

* `mapgen_helper.xz_consistent_randomi(area, vi)`
	* Same as above, but takes a VoxelArea and a voxel index as parameters.
	
## Region tiling

These methods are useful with things like `mapgen_helper.get_random_points`, allowing you to seamlessly place items that cross mapchunk boundaries by generating sets of random points for all adjacent regions.

* `mapgen_helper.get_region_minp_xz(pos_xz, mapblocks)`
	* Returns a consistent large region that doesn't cross mapgen block boundaries. Regions are `mapblocks * chunksize` nodes in width and depth. Ignores the y coordinate.

* `mapgen_helper.get_nearest_regions(pos_xz, gridscale)`
	
	* Given a position and a region scale, returns the minp corners of the four regions that the player is closest to.
	* For example, if we have a region scale of 6 and the parameter position is at "*", the four points marked "R" would be returned:

			|-----|-----|-----|      |-----|-----|-----|      |-----|-----|-----|
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|-----|-----|-----|      |-----|-----|-----|      |-----R-----R-----|
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |    *|     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     | *   |     |      |     |    *|     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			R-----R-----|-----|      |-----R-----R-----|      |-----R-----R-----|
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			|     |     |     |      |     |     |     |      |     |     |     |
			R-----R-----|-----|      |-----R-----R-----|      |-----|-----|-----|

* `mapgen_helper.get_adjacent_regions(pos_xz, gridscale)`
	* Similar to the above, but this method returns all adjacent regions and not just the nearest ones:
			
			|---|---|---|
			|   |   |   |
			|   |   |   |
			R---R---R---|
			|   |   |   |
			|   |  *|   |
			R---R---R---|
			|   |   |   |
			|   |   |   |
			R---R---R---|

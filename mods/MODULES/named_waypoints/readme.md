## API

This mod is intended as a library for other mods to make use of. As such it has no effect on a game when installed on its own. It provides a set of API functions and an administrative interface.

### named_waypoints.register_named_waypoints(waypoints_type, waypoints_def)

A waypoint type needs to be registered before the other methods in this mod can be used. ``waypoints_type`` is a unique string that will be used to reference this type of waypoint, and waypoints_def is a table with the following possible properties (all of which are optional):

	waypoints_def = {
		default_name = , -- a string that's used as the waypoint's label if a waypoint's data doesn't have a "name" property
		default_color = , -- label text color if waypoint_data doesn't have a "color" property.
					-- If not defined defaults to 0xFFFFFFFF (opaque white)

		visibility_volume_radius = , -- The radius within which a player will see the waypoint
					-- marked on their HUD. If not defined then HUD markers will not be shown.
		visibility_volume_height = , -- if defined, visibility check is done in a cylindrical
					-- volume rather than a sphere. Height extends both upward and downward from player position.

		visibility_requires_item = , -- item string or "group:groupname", the player needs to have an item
					-- that matches this in their inventory to see waypoints on their HUD.
					-- If not defined then there's no requirement to see waypoints on the HUD.
		visibility_item_location = , -- "inventory", "hotbar", or "wielded" are valid options here(defaults to inventory if not defined)

		discovery_volume_radius = , -- radius within which a waypoint can be auto-discovered by a player.
					-- "discovered_by" property is used in waypoint_data to store discovery info. If this
					-- is not defined then discovery is not required - waypoints will always be visible
					-- dwhen within visible range.
		discovery_volume_height = , -- if defined, then discovery check is done in a cylindrical volume rather than a sphere.

		discovery_requires_item = ,-- item string or "group:groupname", an item matching this is needed
					-- in player inventory for a waypoint within range to be marked as "discovered" for that player
		discovery_item_location = ,-- "inventory", "hotbar", "wielded" (defaults to inventory if not defined)

		on_discovery = function(player, pos, waypoint_data, waypoints_def) -- If defined, this method
					-- will be called when a player first discovers a particular waypoint. Set it to
					-- "named_waypoints.default_discovery_popup" for a generic discovery notification
					-- popup and audible chime.
	}

### named_waypoints.add_waypoint(waypoints_type, pos, waypoint_data)

Adds a new waypoint at pos. Fails if there's already a waypoint of that type at that location. Returns true on success, false on failure.

waypoint_data is a freeform table you can put whatever you want into (though it will be stored as a serialized string so don't get fancy if you can avoid it). There are three properties on waypoint_data with special meaning:

	name = a string that will be used as the label for this waypoint 
		-- if not defined, named_waypoints will fall back to the "default_name" property of the waypoint definition
	
	color = a hex integer that defines the colour of this waypoint
		-- if not defined, named_waypoints will fall back to the "default_color" property of the waypoint definition
		-- which itself falls back to 0xFFFFFFFF - opaque white

	discovered_by = a set containing the names of players that have discovered this waypoint
		-- provided discovery_volume_radius was defined for this waypoint type

### named_waypoints.update_waypoint(waypoints_type, pos, waypoint_data)

The same as add_waypoint, but if there's already a waypoint at pos then the values of any fields in waypoint_data will replace the corresponding fields in the existing waypoint.

### named_waypoints.get_waypoint(waypoints_type, pos)

Returns the waypoint_data of the waypoint at pos, or nil if there isn't one at that location.

### named_waypoints.get_waypoints_in_area(waypoints_type, minp, maxp)

Returns a table with values of ``{pos = pos, data = waypoint_data}`` for all waypoints in the region specified.

### named_waypoints.remove_waypoint(waypoints_type, pos)

Deletes the waypoint at pos, if there is one. Returns true on success and false on failure.

## Server admin interface

The "``/named_waypoints``" chat command brings up an interface for use by server admins to view and edit waypoints:

![](screenshot.png)

Select a waypoint type from the dropdown and all waypoints of that type will be listed in the table, sorted by increasing distance from your current location. Select a waypoint from the table and its location and serialized data will be shown below. Clicking the "save" button will save any changes you've made to the waypoint's position or serialized data (provided the serialized data has valid syntax). There's also a "name" field for more convenient renaming than editing the serialized data manually. You can also teleport to the selected waypoint or delete it.

The "New" button creates a new waypoint at your current location with empty waypoint data.

Caution: This interface lets you access the guts of the data stored for each waypoint, only make edits if you know what you're doing. You can disrupt other mods that may be using waypoint data to store information. In the pictured example the "settlement_type" property is specific to the mod that is using named_waypoints, so changing or removing this value will cause undefined behaviour.

### Other commands

"``/named_waypoints_discover_all <waypoints_type>``" and "``/named_waypoints_undiscover_all <waypoints_type>``" will set all existing waypoints of the provided type to be either discovered or not discovered by you. It can be useful for a server administrator to "know all and see all" as it were. Note that visibility item and range limitations still apply.

## License

This mod is released under the MIT license.
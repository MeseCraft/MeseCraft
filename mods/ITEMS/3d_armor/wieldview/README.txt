[mod] visible wielded items [wieldview]
=======================================

Depends on: 3d_armor

Makes hand wielded items visible to other players.

default settings: [minetest.conf]

# Set number of seconds between visible wielded item updates.
wieldview_update_time = 2

# Show nodes as tiles, disabled by default
wieldview_node_tiles = false


Info for modders
################

Wield image transformation: To apply a simple transformation to the item in
hand, add the group “wieldview_transform” to the item definition. The group
rating equals one of the numbers used for the [transform texture modifier
of the Lua API.

Disabling the feature in-game: If you want to hide the wielded item
you can add an INT metadata to the player called "show_wielded_item" and set
it to 2 (any other value will show the wielded item again).

# Signs_lib API

In this text, common terms such as `pos`, `node`, or `placer`/`digger` will not be explained unless they have a different meaning than what's usually used in Minetest mods.  See [minetest/doc/lua_api.txt](https://github.com/minetest/minetest/blob/master/doc/lua_api.txt) for details on these and other common terms, if necessary.  Similarly, common shorthand such as `int`, `float`, etc. should require no explanation.

## Registering a sign

* `signs_lib.register_sign(nodename, def)`

  To put it simply, where you'd have used `minetest.register_node()` before, just replace it with this call.  The syntax is identical, and in general, all settings/items allowed there are allowed here as well.  Anything that `signs_lib` doesn't need to override or alter will be passed straight through to `register_node()`, unchanged (such as `description`, `tiles`, or `inventory_image`).

  The supplied node name will be prepended with ":", so that any mod can register signs under any other mod's namespace, if desired.

  Many items have default settings applied when omitted, most of which would produce something equivalent to "default:sign_wall_wood" if enough other node defintion settings were to be included.

  * `drawtype = "string"`

    Default: "mesh"

  * `tiles = {table}`

    Since this is a sign-specific library, this parameter behaves rather different from what you would normally use in `minetest.register_node()`.  The first two entries are mandatory.  The third, fourth and fifth entries are optional, depending on which mounting styles are enabled for a given node.

    * entry 1: the front and back of the sign.
    * entry 2: the sides/edges
    * entry 3: texture for the pole mount.  If unspecified, the standard pole mount image is used, if needed.
    * entry 4: texture for the hanging part.  If unspecified, the standard hanging chains image is used, if needed.
    * entry 5: texture for the yard sign stick.  If unspecified, "default_wood.png" is used, if needed.
    * entry 6: ignored.

  * `mesh = "string"`

    Default: "signs_lib_standard_wall_sign.obj".

  * `paramtype = "string"`

    Default: "light"

  * `paramtype2 = "string"`

    As with any other node, this determines how param2 is interpreted.  Since these are signs, only two modes make sense: "wallmounted" and "facedir".  Any other string is the same as "facedir".

    Default: "wallmounted"

  * `wield_image = "string"`

    Default: whatever the `inventory_image` is set to (if anything).

  * `selection_box = {table}`

    Works the same as usual.  A helper function exists to create boxes by specifying only and X/Y size and offset:
    `signs_lib.make_selection_boxes()` (see below).

  * `groups = {table}`

    Sets the sign's groups, as usual.  In addition to whatever arbitrary groups you may have in mind, there are two presets available (both of which have `attached_node` removed, and `sign = 1` added):

    * `signs_lib.standard_wood_groups`, inherited from "default:sign_wall_wood"
    * `signs_lib.standard_steel_groups`, inherited from "default:sign_wall_steel"

    Default: `signs_lib.standard_wood_groups`

  * `sounds = something`

    Sets the sign's sound profile, as usual.  In addition to whatever sound profile you may have in mind, there are two presets available:

    * `signs_lib.standard_wood_sign_sounds`, inherited from "default:sign_wall_wood"
    * `signs_lib.standard_steel_sign_sounds`, inherited from "default:sign_wall_steel"

    Default: `signs_lib.standard_wood_sign_sounds`

  * `drop = something`

    Default: inherited from the `nodename` argument given to `signs_lib.register_sign()`

  * `after_place_node = function(pos, placer, itemstack, pointed_thing, locked)`

    See below under "Main functions".

    Default: `signs_lib.after_place_node`

  * `on_rightclick = function(pos)`

    See below under "Main functions".

    Default: `signs_lib.construct_sign`

  * `on_construct = function(pos)`

    See below under "Main functions".

    Default: `signs_lib.construct_sign`

  * `on_destruct = function(pos)`

    See below under "Main functions".

    Default: `signs_lib.destruct_sign`

  * `on_receive_fields = function(pos, formname, fields, sender)`

    See below under "Main functions".

    Default: `signs_lib.receive_fields`

  * `on_punch = function(pos)`

    See below under "Main functions".

    Default: `signs_lib.update_sign`

  * `onpole_mesh = "string"`
  * `hanging_mesh = "string"`
  * `yard_mesh = "string"`

    If your node needs a custom model for its on-pole, hanging, and/or yard variants, specify them here, as needed.  The materials and textures behave the same on these as on other sign models.  All sign model filenames are still derived from the base sign model, when not overridden here (so these can be totally arbitrary filenames).

    Defaults: the normal "_onpole", "_hanging", or "_yard" version of the model specified by `mesh`.

  * `selection_box = {table}`
  * `node_box = {table}`

  As usual, the former sets the sign's selection box, while the latter sets its collision information (since signs use model meshes).  At the very least, you'll want to specify `selection_box`.  If the sign node is in "wallmounted" mode, this must contain proper `wall_top`, `wall_side`, and `wall_bottom` entries, as one normally uses with such nodes.  Signs that use "facedir" mode just need the usual `fixed` setting.

  Defaults:  `selection_box` is a box that fits the standard wall sign, if not specified.  `node_box` takes on the value given to `selection_box`, if not specified (or the standard wall sign setting, if neither is present).

  * `onpole_selection_box = {table}`
  * `hanging_selection_box = {table}`
  * `yard_selection_box = {table}`
  * `onpole_node_box = {table}`
  * `hanging_node_box = {table}`
  * `yard_node_box = {table}`

    If your node needs special handling for its onpole-, hanging-, or yard-mode selection boxes or for their collision info (which `signs_lib` always uses the node's `node_box` item for), you can specify them here.  Same syntax as the regular `selection_box` setting.

    Defaults:  whatever the `selection_box` and `node_box` entries are set to.

  * `default_color = "string"`

    Sets the default text color for this sign, in hexadecimal (one digit, lowercase), from the standard Linux/IRC/CGA color palette.  Same as the colors shown in the sign's formspec.

    Default: "0" (black)

  * `number_of_lines = int`

    Just what it says on the tin.  How many lines you can fit will vary with overall sign node size, font size, scaling, line spacing, etc.

    Default: 6

  * `horiz_scaling = float`
  * `vert_scaling = float`

    Scaling factor applied to the entity texture horizontal or vertical resolution.  Larger values increase the resolution.  Since a given sign's entity is always displayed at a fixed visual scale, increasing these squeezes more pixels into the same space, making the text appear narrower or shorter.  Increasing `vert_scaling` also increases the number of lines of text the sign will hold.

    Defaults: 1.0 for both

  * `line_spacing = int`

    Number of blank pixels to add between lines.

    Default: 1

  * `font_size = int`

    Selects which font to use, either 15 or 31 (pixel height).  This setting directly affects the sign's vertical resolution.

    Default: 15

  * `x_offset = int`
  * `y_offset = int`

    Starting X and Y position in pixels, relative to the text entity UV map upper-left corner.

    Defaults: 4 for X, 0 for Y

  * `chars_per_line = int`

    Approximate number of characters that should fit on a line.  This, the selected font's average character width, and the `horiz_scaling` together set the horizontal resolution of the text entity's texture.

    Default: 35

  * `entity_info = something`

    Describes the entity model and yaw table to use.  May be one of:

    * A table specifying the two settings directly, such as:

        ```lua
        entity_info = {
          mesh = "signs_lib_standard_wall_sign_entity.obj",
          yaw = signs_lib.wallmounted_yaw
        }
        ```
      * `signs_lib.standard_yaw` is also available as a yaw preset, if desired.

    * a string reading "standard", which tells `signs_lib` to use the standard wood/steel sign model, in wallmounted mode.  Equivalent to the example above.
    * nothing at all: if omitted, the sign will not have a formspec, basically all text-related settings will be ignored and/or omitted entirely, and no entity will be spawned for this sign, thus the sign will not be writable.  This is the default, and is of course what one would want for any sign that's just an image wrapped around a model, as in most of the signs in [my street signs mod](https://forum.minetest.net/viewtopic.php?t=20866).

    Default:  **nil**

  * `allow_hanging = bool`
  * `allow_onpole = bool`
  * `allow_onpole_horizontal = bool`
  * `allow_yard = bool`


    If **true**, these allow the registration function to create versions of the initial, base sign node that either hang from the ceiling, are mounted on a vertical pole/post, are mounted on a horizontal pole, or are free-standing, on a small stick.  Their node names will be the same as the base wall sign node, except with "_hanging", "_onpole", "_onpole_horiz", or "_yard", respectively, appended to the end of the node name.  If the base node name has "_wall" in it, that bit is deleted before appending the above.

    These options are independent of one another.

    Defaults: all **nil**

  * `allow_widefont = bool`

    Just what it says on the tin.  If enabled, the formspec will have a little "on/off switch" left of the "Write" button, to select the font width.

    Default: **nil**

  * `locked = bool`

    Sets this sign to be locked/owned, like the original default steel wall sign.

    Default: **nil**

### Example sign definition:

```lua
signs_lib.register_sign("basic_signs:sign_wall_glass", {
	description = S("Glass Sign"),
	yard_mesh = "signs_lib_standard_sign_yard_two_sticks.obj",
	tiles = {
		{ name = "basic_signs_sign_wall_glass.png", backface_culling = true},
		"basic_signs_sign_wall_glass_edges.png",
		"basic_signs_pole_mount_glass.png",
		nil,
		nil,
		"default_steel_block.png" -- the sticks on back of the yard sign model
	},
	inventory_image = "basic_signs_sign_wall_glass_inv.png",
	default_color = "c",
	locked = true,
	entity_info = "standard",
	sounds = default.node_sound_glass_defaults(),
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	allow_hanging = true,
	allow_widefont = true,
	allow_onpole = true,
	allow_onpole_horizontal = true,
	allow_yard = true,
	use_texture_alpha = true,
})
```

### Main functions used within a sign definition

* `signs_lib.after_place_node(pos, placer, itemstack, pointed_thing, locked)`

  Determines if the `pointed_thing` is a wall, floor, ceiling, or pole/post, and swaps the placed sign for the correct model.

  * `locked`: if set to **true**, the sign's meta will be tweaked to indicate its ownership by the `placer`.

* `signs_lib.construct_sign(pos)`

  Sets up the sign's formspec and infotext overlay.

* `signs_lib.destruct_sign(pos)`

  Deletes the sign's entity, if any, when the sign is dug.

* `signs_lib.receive_fields(pos, formname, fields, sender)`

  This handles the text input and wide font on/off switch, logging any actions the user takes.  Bails-out silently if the user is not allowed to edit the sign.  See the standard Minetest lua_api.txt for details.

* `signs_lib.update_sign(pos, fields)`

  If the sign's writable, this deletes any sign-related entities in the sign's node space, spawns a new one, and renders whatever text is in the sign's meta.

* `signs_lib.can_modify(pos, player)`

  Returns **true** if the player is allowed to dig, edit, or change the font width of the sign.

* `signs_lib.handle_rotation(pos, node, player, mode)`

  Just what it says on the tin.  Limits the sign's rotation as needed (for example, a sign on a horizontal pole can only flip from one side to the other).

  * `mode`: the screwdriver's mode, as passed from the screwdriver mod.

  Returns **false** if the user tried to right-click with the screwdriver, **true** otherwise.

* `signs_lib.make_selection_boxes(x_size, y_size, foo, x_offset, y_offset, z_offset, is_facedir)`

  * `x_size`/`y_size`: dimensions in inches.  One node is 39.37 inches on a side.  This function uses inches instead of metric because it started out as a selection box maker for [MUTCD-2009](https://mutcd.fhwa.dot.gov/pdfs/2009r1r2/mutcd2009r1r2edition.pdf)-compliant signs, which are measured in inches.
  * `x_offset`/`y_offset`/`z_offset`: shift the selection box (inches, defaults to centered, with the back face flush with the back of the node).
  * `is_facedir`: if unset, the selection boxes will be created with the assumption that `paramtype2 = "wallmounted"` mode is set on the node the box will be used on.  Any other value creates a selection box for "facedir" mode.
  * `foo` is ignored (leftover from an argument that's long since been rendered obsolete.

  Returns a table suitable for the `selection_box` node definition entry.

#### Helper functions

You probably won't need to call any of these directly.

* `signs_lib.read_image_size(filename)`

  Returns width and height of the indicated PNG file (return values will be gibberish if it isn't a PNG).

* `signs_lib.split_lines_and_words(text)`

  Just what it says on the tin.

  Returns a table of lines, each line entry being a table of words.

* `signs_lib.delete_objects(pos)`

  Deletes all entities within the node space given by `pos`.

* `signs_lib.spawn_entity(pos, texture)`

  Spawns a new text entity at the given position and assigns the supplied `texture` to it, if any.

* `signs_lib.check_for_pole(pos, pointed_thing)`

  Attempts to determine if the `pointed_thing` qualifies as a vertical pole or post of some kind.

  Returns **true** if a suitable pole/post is found

* `signs_lib.check_for_horizontal_pole(pos, pointed_thing)`

  Same idea, but for horizontal poles/posts.

  Returns **true** if a suitable pole/post is found.

* `signs_lib.check_for_ceiling(pointed_thing)`

  Returns **true** if the `pointed_thing` appears to be the bottom of a node.

* `signs_lib.check_for_floor(pointed_thing)`

  Returns **true** if the `pointed_thing` appears to be the top of a node.

* `signs_lib.set_obj_text(pos, text)`

  Cooks the supplied `text` as needed and passes it to the entity rendering code.  Essentially, this is where rendering text into an image starts.

## Options for pole/post nodes

Occasionally, you'll run into a node that either looks like a pole/post, or has one in the middle of its node space (with room to fit a sign in there), but which isn't detected as a pole/post by the standard sign placement code.  In these situations, some kind of special check is needed.

Supplying one or both of the following in the pole/post node's definition will cause `signs_lib` to skip its usual pole/post detection code, in favor of the supplied function(s).

  * `check_for_pole = function(pos, node, def, pole_pos, pole_node, pole_def)`

    If supplied, this function will be run when the mod is looking for a normal vertical pole/post.  Useful if the target node's orientation and/or shape determine what sides a sign can attach to.  For example, [Pipeworks](https://forum.minetest.net/viewtopic.php?pid=27794) uses this to figure out if a sign can be attached to a tube or pipe, depending on the tube's/pipe's number of junctions, and on its orientation and that of the placed sign.

    * `def`: the placed sign's node defintion
    * `pole_pos`: the target node's position 
    * `pole_node`: the target node itself
    * `pole_def`: its node definition

    Your code must return **true** if the sign should attach to the target node.

    If desired, this entry may simply be set to `check_for_pole = true` if a sign can always attach to this node regardless of facing direction (for example, [Home Decor](https://forum.minetest.net/viewtopic.php?pid=26061) has a round brass pole/post, which always stands vertical, and [Cottages](https://forum.minetest.net/viewtopic.php?id=5120) has a simple table that's basically a fencepost with a platform on top).

  * `check_for_horiz_pole = function(pos, node, def, pole_pos, pole_node, pole_def)`

    If supplied, this does the same thing for horizontal poles.

    Your code must return **true** if the sign should attach to the target node.

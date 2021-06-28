# Display API
This document describes Display API. Display API allows to add a dynamic display on a node. Display API limits node rotations. For wallmounted, only vertical positionning is available. For facedir, only first four position are availabel (those with default axis).

## Provided methods
### update\_entities
**display\_api.update\_entities(pos)**

This method triggers entities update for the display node at pos. Actual entity update is made by `on_display_update` callback associated to the entity.

`pos`: Position of the node
### register\_display\_entity
**display\_api.register\_display\_entity(entity_name)**

This is a helper to register entities used for display.

`entity_name`: Name of the entity to register.

## Provided callback implementations
### on_place
**display\_api.on\_place(itemstack, placer, pointed\_thing)**

`on_place` node callback implementation. Display nodes should have this callback (avoid placement of horizontal display node).
### on_construct
**display\_api.on\_construct(pos)**

`on_construct` node callback implementation. Display nodes should have this callback (creates, places and updates display entities on node construction).
### on_destruct
**display\_api.on_destruct(pos)**

`on_destruct` node callback implementation. Display nodes should have this callback (removes display entities on node destruction).
### on_rotate
**display\_api.on\_rotate(pos, node, user, mode, new_param2)**

`on_rotate` node callback implementation. Display nodes should have this callback (restricts rotations and rotates display entities associated with node).
### on_activate
**display\_api.on_activate(entity, staticdata)**

`On_activate` entity callback implementation for display entities. No need of this method if display entities have been registered using `register_display_entity` (callback is already set).

## Howto register a display node
* Register display entities with `register_display_entity`

* Register node with :
  - `on_place`, `on_construct`, `on_destruct` and `on_rotate` callbacks using display_api callbacks.\
  - `display_api` group. This will make this node have their entities updated as soon as the mapblock is loaded (Useful after /clearobjects).\
  - a `display_entities` field in node definition containing a entity name indexed table. See below for description of each display_entities fields.\

### Display_entities fields
`on_display_update` is a callback in charge of setting up entity texture. If not set, entity will have no texture and will be displayed as unknown item.\
`depth`, `right` and `top`: Entity position regarding to node facedir/wallmounted main axis.\
Values for these fields can be any number between -1.5 and 1.5 (default value is 0). Position 0,0,0 is the center of the node.\
`depth` goes from front (-0.5) to rear (0.5), `top` goes from bottom (-0.5) to top (0.5) and `right` goes from left (-0.5) to right (0.5).\
`yaw`: Entity yaw in radians, regarding to main axis. Default is 0, aligned to node face.

In order to avoid flickering text, it's better to have text a little behind node surface. A good spacing value is given by `display_api.entity_spacing` variable.

### Example

	display_api.register_display_entity("mymod:entity1")
	display_api.register_display_entity("mymod:entity2")

	function my_display_update1(pos, objref)
		objref:set_properties({ textures= {"mytexture1.png"},
		                        visual_size = {x=1, y=1} })
	end

	function my_display_update2(pos, objref)
		objref:set_properties({ textures= {"mytexture2.png"},
		                        visual_size = {x=1, y=1} })
	end

	minetest.register_node("mymod:test_display_node", {
		...
		paramtype2 = "facedir",
		...
		groups = { display_api = 1, ... },
		...
		display_entities = {
			["mymod:entity1"] = {
				depth = 0.3,
				on_display_update = my_display_update1 },
			["mymod:entity1"] = {
				depth = 0.2, top = 0.1,
				on_display_update = my_display_update2 },
			},
		...
		on_place = display_api.on_place,
		on_construct = display_api.on_construct,
		on_destruct = display_api.on_destruct,
		on_rotate = display_api.on_rotate,
		...
	})

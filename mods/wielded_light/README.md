# wielded_light mod for Minetest

Idea taken from torches_wieldlight in https://github.com/minetest-mods/torches, but written from scratch and usable for all shining items.

![Screenshot](https://github.com/bell07/minetest-wielded_light/raw/master/screenshot.png)

All bright nodes with light value > 2 lighten the player environment if wielded, with value fewer by 2. (Torch 13->11 for example)

Dependencies: none

License: [GPL-3](https://github.com/bell07/minetest-wielded_light/blob/master/LICENSE)


Shining API:

`function wielded_light.update_light(pos, light_level)`
Enable or update the shining at pos with light_level for 0.6 seconds. Can be used in any on_step call to get other entitys shining for example


`wielded_light.register_item_light(itemname, light_level)`
Override or set custom light level to an item. This does not change the item/node definition, just the lighting in this mod.

`function wielded_light.update_light_by_item(stack, pos)`
Update light at pos using item shining settings -from registered item_light or from item definition

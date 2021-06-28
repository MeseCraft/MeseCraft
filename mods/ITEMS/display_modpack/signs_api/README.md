# Signs API

This mod provides various helper functions for registereing signs with text display. Text is locked if area is protected.
No actual signs get registered by this mod, the signs are defined in the sign submod.

For more information, see the [forum topic](https://forum.minetest.net/viewtopic.php?t=19365) at the Minetest forums.

**Dependancies**: default, display\_lib, font\_lib

**License**: Code under LGPL, Textures and models under CC-BY-SA

## API Functions
### `signs_api.set_display_text(pos, text)`
Sets the text of a sign. Usually called in `on_receive_fields`.

### `signs_api.set_formspec(pos)`
Usually called in `on_construct` to set the formspec.

### `signs_api.on_receive_fields(pos, formname, fields, player)`
Helper function for `on_receive_fields`. Sets the display text and checks for protection.

### `signs_api.on_place_direction(itemstack, placer, pointed_thing)`
On place callback for direction signs (chooses which sign according to look direction).

### `signs_api.on_rotate(pos, node, player, mode, new_param2)`
Handles screwdriver rotation. Direction is affected for direction signs.

### `signs_api.register_sign(mod, name, model)`
A method to quickly register signs.

## Changelog
### 2019-03-14
- __sign_api__: Screwdriver behavior changed. Now, left click rotates and changes direction.

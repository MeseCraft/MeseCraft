# Display API

This library's purpose is to ease creation of nodes with one or more displays on sides. For example, signs and clocks. Display can be dynamic and/or different for each node instance.

**Limitations**: This lib uses entities to draw display. This means display has to be vertical (and "upside up") on Minetest before version 5.0.

**Dependancies**:default

**License**: LGPLv2

**API**: See [API.md](https://github.com/pyrollo/display_modpack/blob/master/display_api/API.md) document please.

For more information, see the [forum topic](https://forum.minetest.net/viewtopic.php?t=19365) at the Minetest forums.

## Deprecation notice (for modders)

### December 2018
Following objects are deprecated, shows a warning in log when used:
* `display_modpack_node` group (use `display_api` group instead);
* `display_lib_node` group (use `display_api` group instead);
* `display_lib` global table (use `display_api` global table instead);

These objects will be removed in the future.

## Change log
### 2019-03-14
- __dispay_api__: Display API now detects automatically whenr rotation restrictions have to be applied.

### 2019-03-09
- __display_api__: Display nodes can be rotated in every directions (if running Minetest 5 or above).
- __display_api__: New setting to restrict rotations to Minetest 0.4 abilities (restriction enabled by default).

### 2018-12-14
- __display_api__: New `yaw` attributes, entities can now have different angles with node.

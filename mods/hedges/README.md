Hedges
======
Hedges mod for Minetest by Shara RedCat which adds hedges that automatically connect to each other when placed and that can be crafted from leaves. Hedges connect both horizontally and vertically, making it possible to build hedge mazes a player cannot jump over.


API
---
All leaves from trees and bushes in Minetest Game are already included. Hedges for other kinds of leaves can be registered by using the Hedges API.

For example, the simplest definition would need you to provide a name, texture, groups and material the hedge is crafted from:

```
hedges.register_hedge("mod_name:hedge_name", {
	texture = "texture.png",
	material = "mod_name:material_name",	
})

```

You can also include the following in the definition:

- description: "Hedge" if not defined.
- groups: must include "hedge = 1". Will be {snappy = 3, flammable = 2, leaves = 1, hedge = 1} if not defined.
- sounds: "default.node_sound_leaves_defaults()" if not defined.
- light_source: 0 if not defined.


Licenses and Attribution 
-----------------------

Code for this mod is released under MIT (https://opensource.org/licenses/MIT).

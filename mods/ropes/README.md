# Ropes

This mod adds "rope boxes", blocks that when placed in world will automatically lower a rope at 1 meter per second until it reaches a fixed maximum length. The basic rope box produces 50m of rope by default and there are up to eight additional rope box types that produce multiples of that rope length - 100m, 150m, and so forth up to 450m. The number of rope boxes and the length of a standard rope length can be configured via the settings menu.

The rope stops lowering if it reaches an obstruction. Ropes can be cut using an axe or other choppy tool at any location and when they're cut the bottom half of the rope will disappear, dropping any climbers. The same happens to the entire rope if the rope box at the top of the rope is removed. Cutting the rope doesn't reduce the maximum length of rope the rope box will produce if it's removed and rebuilt again. Ropes are flammable. They respect protection settings - if the player that placed the rope box isn't permitted to build in an area then the rope descending from that box will treat it as an obstruction.

Also included is a rope ladder that behaves similarly, though it only comes in one standard maximum length - 50m by default, again changeable in settings.

This mod will also enhance default wood ladders and steel ladders to make them "extendable", capable of building upward independent of support to a setting-defined limit (defaulting to 5 nodes for wood and 15 nodes for steel ladders). This can be disabled if undesired.

This mod retains optional backward compatibility with the crafting items from the vines mod (anything with group "vines" can be used to make rope boxes and rope ladders). Ropes can also be made from cotton, available via an optional dependency on the farming mod.

In-game documentation is provided via an optional dependency on the doc mod.
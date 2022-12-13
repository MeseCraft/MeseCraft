# item_drop
By [PilzAdam](https://github.com/PilzAdam),
[texmex](https://github.com/tacotexmex/), [hybriddog](https://github.com/hybriddog/).

## Description
A highly configurable mod providing item magnet and in-world node drops

## Licensing
LGPLv2.1/CC BY-SA 3.0. Particle code from WCILA mod by Aurailus, originally licensed MIT.

## Notes
item_drop can be played with Minetest 0.4.16 or above. It was originally
developed by [PilzAdam](https://github.com/PilzAdam/item_drop).

## List of features
* All settings may be configured from within the game itself.
  (Settings tab > Advanced settings > Mods > item_drop)
* Drops nodes as in-world items on dig if `item_drop.enable_item_drop` is
  `true` (true by default) It does nothing in creative mode.
* Puts dropped items to the player's inventory if `item_drop.enable_item_pickup`
  is `true` (true by default)
  * Multiple items are picked in a quick succession instead of all at once which
    is indicated by the pickup sound.
  * It uses a node radius set in `item_drop.pickup_radius` (default 0.75),
    if items are within this radius around the player's belt, they're picked.
  * If `item_drop.pickup_age` is something positive, items dropped by players
    are ignored for this time to avoid instantly picking up when dropping.
  * If `item_drop.pickup_age` is `-1`, items are only picked when they don't
    move, it's another fix for instant item picking.
  * If `item_drop.magnet_radius` is bigger than `item_drop.pickup_radius`,
    items between these radii are flying to the player for
    `item_drop.magnet_time` seconds, after this time, they're picked or stop
    flying.
  * Enable manual item pickups by mouse only if `item_drop.mouse_pickup` is
    `true` (true by default)
* Plays a sound when the items are picked up with the gain level set to
  `item_drop.pickup_sound_gain` (default 0.2)
* Requires a key to be pressed in order to pick items if
  `item_drop.enable_pickup_key` is `true` (true by default)
  * The keytypes to choose from by setting `item_pickup_keytype` are:
    * Use key (`Use`)
    * Sneak key (`Sneak`)
    * Left and Right keys combined (`LeftAndRight`)
    * Right mouse button (`RMB`)
    * Sneak key and right mouse button combined (`SneakAndRMB`)
  * If `item_drop.pickup_keyinvert` is `true`, items are
    collected when the key is not pressed instead of when it's pressed.
* Displays a particle of the picked item above the player if
  `item_drop.pickup_particle` is `true` (true by default)


## Known issues

## Bug reports and suggestions
You can report bugs or suggest ideas by
[filing an issue](http://github.com/minetest-mods/item_drop/issues/new).

## Links
* [Download ZIP](https://github.com/minetest-mods/item_drop/archive/master.zip)
* [Source](https://github.com/minetest-mods/item_drop/)
* [Forum thread](https://forum.minetest.net/viewtopic.php?t=16913)

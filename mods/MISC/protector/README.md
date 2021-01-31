Protector Redo mod [protect]

Protector redo for minetest is a mod that protects a players builds by placing
a block that stops other players from digging or placing blocks in that area.

based on glomie's mod, remade by Zeg9 and rewritten by TenPlus1.

https://forum.minetest.net/viewtopic.php?f=11&t=9376

Change log:

- 0.1 - Initial release
- 0.2 - Texture update
- 0.3 - Added Protection Logo to blend in with player builds
- 0.4 - Code tweak for 0.4.10+
- 0.5 - Added protector.radius variable in init.lua (default: 5)
- 0.6 - Added Protected Doors (wood and steel) and Protected Chest
- 0.7 - Protected Chests now have "To Chest" and "To Inventory" buttons to copy
      contents across, also chests can be named
- 0.8 - Updated to work with Minetest 0.4.12, simplified textures
- 0.9 - Tweaked code
- 1.0 - Only owner can remove protector
- 1.1 - Set 'protector_pvp = true' in minetest.conf to disable pvp in protected
      areas except your own, also setting protector_pvp_spawn higher than 0 will
      disable pvp around spawn area with the radius you entered
- 1.2 - Shift and click support added with Minetest 0.4.13 to quickly copy stacks
      to and from protected chest
- 1.3 - Moved protector on_place into node itself, protector zone display changed
      from 10 to 5 seconds, general code tidy
- 1.4 - Changed protector recipes to give single item instead of 4, added + button
      to interface, tweaked and tidied code, added admin command /delprot to remove
      protectors in bulk from banned/old players
- 1.5 - Added much requested protected trapdoor
- 1.6 - Added protector_drop (true or false) and protector_hurt (hurt by this num)
      variables to minetest.conf settings to stop players breaking protected
      areas by dropping tools and hurting player.
- 1.7 - Included an edited version of WTFPL doors mod since protected doors didn't
      work with the doors mod in the latest daily build... Now it's fine :)
      added support for "protection_bypass" privelage.
- 1.8 - Added 'protector_flip' setting to stop players using lag to grief into
      another players house, it flips them around to stop them digging.
- 1.9 - Renamed 'protector_pvp_spawn' setting to 'protector_spawn' which protects
      an area around static spawnpoint and disables pvp if active.
      (note: previous name can still be used)
- 2.0 - Added protector placement tool (thanks to Shara) so that players can easily
      stand on a protector, face in a direction and it places a new one at a set
      distance to cover protection radius.  Added /protector_show command (thanks agaran)
      Protectors and chest cannot be moved by mesecon pistons or machines.
- 2.1 - Added 'protector_night_pvp' setting so night-time becomes a free for all and
      players can hurt one another even inside protected areas (not spawn protected)
- 2.2 - Updated protector tool so that player only needs to stand nearby (2 block radius)
      It can also place vertically (up and down) as well.  New protector recipe added.
- 2.3 - Localise many of the protector functions and tidy code.
- 2.4 - Update to newer functions, Minetest 0.4.16 needed to run now.
- 2.5 - Added HUD text to show when player is inside a protected area (updates every 5 seconds)
- 2.6 - Add protection against CSM tampering, updated Intllib support (thanks codexp), tweaked block textures
- 2.7 - Remove protection field entity when protector has been dug
- 2.8 - Added 'protector_show_interval' setting to minetest.conf [default is 5], make protection field glow in dark.
- 2.9 - Added MineClone2 recipes for protection block but no official support as yet
- 3.0 - Added PlayerFactions support, 'protector_hud_interval' setting and listing in advanced settings for mod values.
- 3.1 - Ability to hide protection blocks using /protector_hide and /protector_show , italian local added (thanks Hamlet)
- 3.2 - Defaults to Minetest translation if found, otherwise intllib fallback if loaded, locale files updated for both.  Added 'protector_msg' setting for player text.
- 3.3 - Added support for playerfactions new api (thanks louisroyer), added limiter to protection radius of 22.

Lucky Blocks: 10


Usage: (requires server privelage)

list names to remove

	/protector_remove

remove specific user names

	/protector_remove name1 name2

remove all names from list

	/protector_remove -

Whenever a player is near any protectors with name1 or name2 then it will be
replaced by an air block.


show owner name to replace

	/protector_replace

replace owner with new name

	/protector_replace owner new_owner

reset name list

	/protector_replace -


show protected areas of your nearby protectors (max of 5)
	/protector_show_area


A players own protection blocks can be hidden and shown using the following:
	/protector_hide
	/protector_show


The following lines can be added to your minetest.conf file to configure specific features of the mod:

protector_radius = 5
- Sets the area around each protection node so that other players cannot dig, place or enter through protected doors or chests.

protector_pvp = true
- true or false this setting disabled pvp inside of protected areas for all players apart from those listed on the protector node.

protector_night_pvp = false
- when true this setting enables pvp at night time only, even inside protected areas, requires protector_pvp to be active to work.

protector_spawn = 10
- Sets an area 10 nodes around static spawnpoint that is protected.

protector_hurt = 2
- When set to above 0, players digging in protected areas will be hurt by 2 health points (or whichever number it's set to)

protector_flip = true
- When true players who dig inside a protected area will flipped around to stop them using lag to grief into someone else's build

protector_show_interval
- Number of seconds the protection field is visible, defaults to 5 seconds.

protector_recipe = true
- When true allows players to craft protection blocks

protector_msg = true
- When true shows protection messages in players chat when trying to interact in someone else's area


Protector Tool

Can be crafted with a protector surrounded by steel ingots and is used to place new protectors at a set distance of protector.radius in all directions including up and down simply by looking in a direction.

Use by standing near an existing protector, looking in a direction and using as a tool, hold sneak/shift to place new protector containing member list from inside nearest one.

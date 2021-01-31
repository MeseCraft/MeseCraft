# lootchests_modpack
Modpack adding various loot containers across the world to be found and providing an API, resources and integrations for other mods.

![Screenshot](screenshot.png)

## Requirements

- Minetest 5.0.0+
- Minetest_game 5.0.0+
- [magic_materials](https://github.com/ClockGen/magic_materials) (optional)

## Recommended mods
- [decorations_sea](https://github.com/ClockGen/decorations_sea) (Provides decorations when looking for ocean chests)
- [shipwrecks](https://github.com/ClockGen/shipwrecks) (Shipwrecks depend on lootchests_modpack to spawn lootchests in shipwrecks)

## Integrations
lootchests_default adds loot from following mods, if they are installed:

- 3d_armor
- Bonemeal
- farming_redo
- gadgets_modpack
- moreores
- moretrees


## Contents
Default lootchest pack provides:

- Baskets, spawning in caves from 0 to -128, containing various organic items (food, seeds, saplings, etc)
- Urns, spawning in caves from 0 to -128, containing various low-grade craftitems and tools (stone tools, ores up to iron, sticks, etc)
- Ocean chests, spawning in seabed and also very rare in caves, containing many precious materials and tools
- Ancient chests, spawning from -128 to -4096 in solid rock and also very rare in caverns, containing very expensive loot

Magic_materials pack provides:
- Rune urn, spawning in caves from -64 to -4096, containing low grade magic items from magic_materials
- rune chest, spawning from -64 to -4096 in solid rock and very rare in caverns, contains high grade items from magic_materials

## Making your own lootchests
Process of making your own lootchests is described in [documentation](lootchests/documentation.txt)

## License
All code is licensed under GPLv3 [link to the license](https://www.gnu.org/licenses/gpl-3.0.en.html)  
All resources are licensed under CC BY 4.0 [link to the license](https://creativecommons.org/licenses/by/4.0/legalcode)  
 

# Minetest Mod Storage Drawers

[![ContentDB](https://content.minetest.net/packages/LNJ/drawers/shields/downloads/)](https://content.minetest.net/packages/LNJ/drawers/)
![](https://github.com/minetest-mods/drawers/workflows/luacheck/badge.svg)

Version 0.6.5, License: MIT

## Description
This mod adds simple item storages showing the item's inventory image in the
front. By left- or right-clicking the image you can take or add stacks. If you
also hold the shift-key only a single item will be removed/added.

There's also a 'Drawer Controller' which can insert items automatically into a
network of drawers. Just place the drawers next to each other, so they are
connected and the drawer controller will sort the items automatically. If you
want to connect drawers, but you don't want to place another drawer, just use
the 'Drawer Trim'.

Do you have too many cobblestones for one drawer? No problem, just add some
drawer upgrades to your drawer! They are available in different sizes and are
crafted by steel, gold, obsidian, diamonds or mithril.

## Notes
This mod requires Minetest 0.4.14 or later. The `default` mod from MTG or the
MineClone 2 mods are only optional dependencies for crafting recipes.

## To-Do
- [x] Add usable 1x1 drawer
- [x] Add a drawer controller for auto-sorting items into a drawer-network
- [ ] Add half-sized drawers
- [x] Add 2x2 and 1x2 drawers
- [ ] Add compacting drawers for auto-crafting blocks/ingots/fragments
- [ ] Add a key (or something similar) for locking the item (so the item is
      also displayed at count 0)
- [ ] Add duct tape to transport drawers
- [x] Support pipeworks
- [ ] Support hoppers (needs hoppers mod change)
- [x] Make drawers upgradable
- [x] Add drawers in all wood types
- [x] Make them digilines compatible

## Bug reports and suggestions
You can report bugs and suggest ideas on [GitHub](http://github.com/lnj2/drawers/issues/new),
alternatively you can also [email](mailto:git@lnj.li) me.

## Credits
#### Thanks to:
* Justin Aquadro ([@jaquadro](http://github.com/jaquadro)) — Textures and Ideas
* Mango Tango <<mtango688@gmail.com>> ([@mtango688](http://github.com/mtango688)),
	creator of the Minetest Mod ["Caches"](https://github.com/mtango688/caches/)
	— I reused some code by you. :)

## Links
* [Minetest Forums](https://forum.minetest.net/viewtopic.php?f=9&t=17134)
* [Minetest Wiki](http://wiki.minetest.net/Mods/Storage_Drawers)
* [Weblate](https://hosted.weblate.org/projects/minetest/mod-storage-drawers/)
* [GitHub](http://github.com/minetest-mods/drawers/)

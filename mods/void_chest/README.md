saras_simple_survival mod: void_chest
=====================================
Copyright (2020) freegamers.org


Description
-------------------------------------
A chest that uses the mysterious power of the void to store your items remotely. All void chests appear to have the same inventory. Void chests can also be mined and picked up, even when they appear to have stuff in them. Lastly, as everyone gets their own void chest account, the items you see in the void chest are not the same items that other players see. This chest's properties make it nice for keeping secrets, as well as essentially almost doubling your inventory space, if you choose to carry one with you!


Recipe
-------------------------------------
if the magic_materials mod is installed:

{'default:steelblock','magic_materials:void_rune','default:steelblock'},
{'magic_materials:void_rune','default:chest_locked','magic_materials:void_rune'},
{'default:steelblock','magic_materials:void_rune','default:steelblock'}

if no magic_materials mod is present then we can just use materials from default:

{'default:steelblock','default:obsidian_block','default:steelblock'},
{'default:obsidian_block','default:chest_locked','default:obsidian_block'},
{'default:steelblock','default:obsidian_block','default:steelblock'}


License of source code
-------------------------------------
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.
https://www.gnu.org/licenses/agpl-3.0.en.html


License of textures
-------------------------------------
void_chest_front.png, void_chest_side.png, void_chest_top.png by PixelBox Reloaded (WTFPL)
void_chest_void_particle.png by MisterE (CC-BY 4.0) 
https://creativecommons.org/licenses/by/4.0/


Credits and Ackowledgements
-------------------------------------
This mod is a fork of morechests, which itself is a fork of 0gb.us's mod called chests_0gb_us.
https://forum.minetest.net/viewtopic.php?f=11&t=4366

The textures used for void chests are from jp's "xdecor" mod, which in turn are from the PixelBOX Reloaded texture pack for Minetest.
https://github.com/minetest-mods/xdecor
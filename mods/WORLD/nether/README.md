# Nether Mod for Minetest, with Portals API.

Allows Nether portals to be constructed, opening a gateway between the surface
realm and one of lava and netherrack, with rumors of a passageway through the
netherrack to a great magma ocean.

To view the options provided by this mod, see settingtypes.txt or
go to "Settings"->"All Settings"->"Mods"->"nether" in the game.

A Nether portal is built as a rectangular vertical frame of obsidian, 4 blocks
wide and 5 blocks high. Once constructed, a Mese crystal fragment can be
right-click/used on the frame to activate it.


## Modders and game designers

See portal_api.txt for how to create custom portals to your own realms.

This mod provides Nether basalts (natural, hewn, and chiseled) as nodes which
require a player to journey to the magma ocean to obtain, so these can be used
for gating progression through a game. For example, a portal to another realm
might need to be constructed from basalt, thus requiring a journey through
the nether first, or basalt might be a crafting ingredient required to reach
a particular branch of the tech-tree.

Netherbrick tools are provided (pick, shovel, axe, & sword), see tools.lua

Nether Portals can allow surface fast-travel.


## License of source code:

Copyright (C) 2013 PilzAdam

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted, provided that the
above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

## License and attribution of media (textures and sounds)

### [Public Domain Dedication (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/)

 * `nether_portal_teleport.ogg` is a timing adjusted version of "teleport" by [outroelison](https://freesound.org/people/outroelison), used under CC0 1.0

### [Attribution 3.0 Unported (CC BY 3.0)](https://creativecommons.org/licenses/by/3.0/)

 * `nether_portal_ambient.ogg` & `nether_portal_ambient.0.ogg` are extractions from "Deep Cinematic Rumble Stereo" by [Patrick Lieberkind](http://www.lieberkindvisuals.dk), used under CC BY 3.0
 * `nether_portal_extinguish.ogg` is an extraction from "Tight Laser Weapon Hit Scifi" by [damjancd](https://freesound.org/people/damjancd), used under CC BY 3.0
 * `nether_portal_ignite.ogg` is a derivative of "Flame Ignition" by [hykenfreak](https://freesound.org/people/hykenfreak), used under CC BY 3.0. "Nether Portal ignite" is licensed under CC BY 3.0 by Treer.

### [Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/)
 * `nether_basalt`* (files starting with "nether_basalt"): Treer, 2020
 * `nether_book_`* (files starting with "nether_book"): Treer, 2019-2020
 * `nether_fumarole.ogg`: Treer, 2020
 * `nether_lava_bubble`* (files starting with "nether_lava_bubble"): Treer, 2020
 * `nether_lava_crust_animated.png`: Treer, 2019-2020
 * `nether_particle_anim`* (files starting with "nether_particle_anim"): Treer, 2019
 * `nether_portal_ignition_failure.ogg`: Treer, 2019
 * `nether_smoke_puff.png`: Treer, 2020

### [Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)](http://creativecommons.org/licenses/by-sa/3.0/)
 * `nether_glowstone`* (files starting with "nether_glowstone"): BlockMen
 * `nether_nether_ingot.png` & `nether_nether_lump.png`: color adjusted versions from "[default](https://github.com/minetest/minetest_game/tree/master/mods/default)" mod, originally by Gambit
 * `nether_portal.png`: [Extex101](https://github.com/Extex101), 2020
 * `nether_rack`* (files starting with "nether_rack"): Zeg9
 * `nether_tool_`* (files starting with "nether_tool_"): color adjusted versions from "[default](https://github.com/minetest/minetest_game/tree/master/mods/default)" mod, originals by BlockMen

All other media: Copyright © 2013 PilzAdam, licensed under CC BY-SA 3.0 by PilzAdam.
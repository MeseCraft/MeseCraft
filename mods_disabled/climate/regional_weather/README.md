# Regional Weather
A weather pack for [__Climate API__](https://github.com/t-affeldt/climate_api) by Till Affeldt (TestificateMods)

![](https://raw.githubusercontent.com/t-affeldt/regional_weather/master/screenshot.webp)

Not every biome is the same and neither should their weather be.
Regional Weather controls its effects with the local climate in mind.
Experience the humid air of the rain forest and harsh desert sandstorms.

## Troubleshooting
Regional Weather depends on [Climate API](https://github.com/t-affeldt/climate_api) in order to function. Generally speaking, most mods should be compatible to it.

If you notice __odd movement speeds__ or jump heights of players, you should check for mods that also modify player physics. Use a compatibility mod like [player_monoids](https://github.com/minetest-mods/player_monoids) or [playerphysics](https://forum.minetest.net/viewtopic.php?t=22172) to get rid of this problem. This requires the conflicting mod to also support the chosen compatibility layer.

Mods that __modify the sky__ (including skybox, moon, sun, stars and clouds) are sadly not fully compatible because they conflict with Climate API's sky system. You should deactivate the sky features in either mod. You can do this in Climate API's settings using the ``Override the skybox`` option. If you're a mod maker then you can also optionally depend on climate_api and use ``climate_api.skybox.add_layer(playername, layer_name, options)`` to register your skybox change in a compatible way. Note that you need __at least Minetest v5.2.0__ for skybox changes to have any effect.

Conflicting skybox changes include the ``weather`` mod included in vanilla __Minetest Game__. You will want to disable that mod in order to use the more advanced cloud system introduced by Climate API. Head to ``Settings → All Settings → Games → Minetest Game`` and set ``Enable weather`` to ``Disabled``. This setting will only exist if you are using Minetest Game v5.2.0 or higher.

If you experience __performance issues__, the *Performance* section of Climate API's configuration section is a great place to start looking for a solution.

The following mods are recommended to be installed alongside Regional Weather:
- [Climate API](https://github.com/t-affeldt/climate_api) (required): The necessary weather engine that this mod is built upon
- [Moon Phases](https://github.com/t-affeldt/minetest_moon_phase): Complements weather effects with dynamic sky changes and a full moon cycle
- [Sailing Kit](https://github.com/t-affeldt/sailing_kit) (Fork): Uses Climate API's new wind system to sail across the sea.
- [Lightning](https://github.com/minetest-mods/lightning): Adds to heavy rain by enabling additional lightning effects
- [Farming](https://github.com/minetest/minetest_game/tree/master/mods/farming) (as part of MTG) or [Farming Redo](https://forum.minetest.net/viewtopic.php?t=9019): Add farmland and crops to grow food. Farmland wil turn wet during rain effects.
- [Fire](https://github.com/minetest/minetest_game/tree/master/mods/fire) (as part of MTG): Adds fires that can be caused by lightning strikes and other effects and will be extinguished during rain effects.
- [Pedology](https://forum.minetest.net/viewtopic.php?f=11&t=9429) Adds a lot of nodes with dynamic wetness and dryness states.
- [Ambience](https://notabug.org/TenPlus1/ambience): Plays some nice ambient sound effects based on where you are.

For easier installation, you can get a lot of these mods as part of my [Climate Modpack](https://github.com/t-affeldt/climate).

## Configuration Options
You can find all mod configuration options in your Minetest launcher.
Go to ``Settings → All Settings → Mods → regional_weather`` to change them.
Also check out the options inside the ``climate_api`` section for additional configuration options, including performance tweaks and feature switches.

### Features
- ``Place snow layers`` (default true):
	If set to true, snow layers will stack up during snowy weather.
- ``Freeze river water`` (default true):
	If set to true, river water sources will freeze at low temperatures and melt when it gets warmer again.
	This process does not affect regular ice blocks because it adds its own temporary ones.
- ``Place rain puddles`` (default true):
	If set to true, water puddles will form during rain or when snow layers have melted.
- ``Hydrate farmland`` (default true):
	If set to true, rain will cause dry farmland to turn wet.
	Requires *farming* or *farming_redo* mod.
- ``Extinguish fire`` (bool true):
	If set to true, fires will be extinguished during rain showers.
	Requires *fire* mod.
- ``Wetten pedology nodes`` (default true):
	If set to true, rain will wetten or dry nodes from pedology mod.
	Requires *pedology* mod.

### World Configuration
- ``Maximum height of weather effects`` (default 120):
	No visual effects will be applied above this height.
	This value defaults to normal cloud height (120 nodes above sea level).
- ``Minimum height of weather effects`` (default -50):
	No visual effects will be applied below this height.
	This will prevent unwanted visuals within large underground caves.
- ``Cloud height`` (default 120)
	Average height of cloud bases
- ``Cloud height variation`` (default 40)
	Maxmial variation of cloud height from base value

## License information
### Source Code
Unless otherwise stated, this source code is written entirely by myself.
You are free to use it under a GNU Lesser General Public License version 3.
You can find respective rights and conditions in the attached [LICENSE](https://github.com/t-affeldt/regional_weather/blob/master/LICENSE.md) file.
The entire source code is available on [Github](https://github.com/t-affeldt/regional_weather).

### Particles
- Hail textures: *CC BY-SA (3.0)* made by me
- Snow flake textures: *CC BY-SA (3.0)* by paramat, found in snowdrift mod at https://github.com/paramat/snowdrift
- Snow composite texture: *CC BY-SA (3.0)* by Cap, created from aforementioned snow flakes by paramat (please credit original artist as well)
- Rain textures: *CC BY-SA (3.0)* by Cap (an original design for this mod)

### Block Textures
- Puddle textures: *CC BY-SA (3.0)* by Cap
- Snow layers and ice block using textures from *default* (not included)

### Sounds
- Heavy Rain sounds: *CC0* by Q.K., taken from mymonths at https://github.com/minetest-mods/mymonths/tree/master/sounds
- Light Rain sounds: *CC BY 3.0* by Arctura from https://freesound.org/people/Arctura/sounds/34065/
- Wind sound: *CC BY (3.0)* by InspectorJ from https://freesound.org/people/InspectorJ/sounds/376415/
- Hail sound: *CC0* by ikayuka from https://freesound.org/people/ikayuka/sounds/240742/
- Puddle footstep sound: *CC0* by swordofkings128 from https://freesound.org/people/swordofkings128/sounds/398032/

### HUD Overlays
- Frost HUD: *CC BY-SA (3.0)* by Cap
- Original texture for sand storm HUD: *CC0* from https://freestocktextures.com/texture/dirty-baking-paper,1202.html, edits by me under *CC0* as well

### Assets in screenshots
- Screenshots and editing: *CC BY-SA (3.0)* by me
- Logos and artwork: *CC BY-SA (3.0)* by Cap
- Lato Font (for the Logo): *OFL* by Łukasz Dziedzic from http://www.latofonts.com/lato-free-fonts/
- Source Sans Pro (for the subtitles): *OFL*, see https://fonts.google.com/specimen/Source+Sans+Pro
- Used texture pack: Polygonia (128px edition) *CC BY-SA (4.0)* by Lokrates. See https://forum.minetest.net/viewtopic.php?f=4&t=19043

### Full License Conditions
- [GNU Lesser General Public License version 4](https://github.com/t-affeldt/regional_weather/blob/master/LICENSE.md)
- [Creative Commons Licenses](https://creativecommons.org/licenses/)
- [SIL Open Font License](https://opensource.org/licenses/OFL-1.1)
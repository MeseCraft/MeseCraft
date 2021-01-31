# Climate API
A powerful engine for weather presets and visual effects.
Requires a weather pack like [Regional Weather](https://github.com/t-affeldt/regional_weather).

![](https://raw.githubusercontent.com/t-affeldt/climate_api/master/screenshot.png)

Use the regional climate to set up different effects for different regions.
Control where your effects are activated based on temperature, humidity, wind,
position, light level or a completely custom activator.
Climate API provides temperature and humidity values on a block-per-block basis
that follow the seasons, day / night cycle and random changes.
Make it rain, change the sky or poison the player - it's up to you.

## Troubleshooting
Generally speaking, most mods should be compatible.

If you notice __odd movement speeds__ or jump heights of players, you should check for mods that also modify player physics. Use a compatibility mod like [player_monoids](https://github.com/minetest-mods/player_monoids) or [playerphysics](https://forum.minetest.net/viewtopic.php?t=22172) to get rid of this problem. This requires the conflicting mod to also support the chosen compatibility layer.

Mods that __modify the sky__ (including skybox, moon, sun, stars and clouds) are sadly not fully compatible because they conflict with Climate API's sky system. You should deactivate the sky features in either mod. You can do this here using the ``Override the skybox`` setting. If you're a mod maker then you can also optionally depend on climate_api and use ``climate_api.skybox.add_layer(playername, layer_name, options)`` to register your skybox change in a compatible way. Note that you need __at least Minetest v5.2.0__ for skybox changes to have any effect.

__Important__: Conflicting skybox changes include the ``weather`` mod included in vanilla __Minetest Game__. You will want to disable that mod in order to use the more advanced cloud system introduced by Climate API. Head to ``Settings → All Settings → Games → Minetest Game`` and set ``Enable weather`` to ``Disabled``. This setting will only exist if you are using Minetest Game v5.2.0 or higher.

The following mods have been created specifically with Climate API in mind:
- [Regional Weather](https://github.com/t-affeldt/regional_weather): My own weather pack for climate based weather effects
- [Moon Phases](https://github.com/t-affeldt/minetest_moon_phase): Complements weather effects with dynamic sky changes and a full moon cycle
- [Sailing Kit](https://github.com/t-affeldt/sailing_kit) (Fork): Uses Climate API's new wind system to sail across the sea.

The following mods complement Climate API particularly well:
- [Lightning](https://github.com/minetest-mods/lightning): Adds to heavy rain by enabling additional lightning effects
- [Ambience](https://notabug.org/TenPlus1/ambience): Plays some nice ambient sound effects based on where you are.

## Chat Commands
- ``/weather``: Display information on current weather effects. This command will show you current temperature and humidity, active weather presets and currently playing effects
- ``/weather_settings``: Display current mod configuration in the chat
- ``/weather_influences``: Display all different factors and how they affect you in this moment.
- ``/weather_status``: Display a list of all installed weather presets and whether they have been forced on, turned off, or are running normally (auto). If no weather presets are listed here then you need to install a weather mod like Regional Weather.
- ``/grant <playername> weather``: Enable a specified player to modify the current weather.
- ``/set_heat <value>``: Override global heat levels with given value.
- ``/set_base_heat <value>``: Override the base heat value used to calculate local climate. Positive numbers will increase temperature by X degrees Fahrenheit, whereas negative values will lower it.
- ``/set_humidity <value>``: Override global humidity levels with given value.
- ``/set_base_humidity <value>``: Override the base humidity value used to calculate local climate. Positive numbers will increase humidity by X percent, whereas negative values will lower it.
- ``/set_wind <x> <z>``: Override wind speed and direction. Higher absolute values result in stronger wind. The sign indicates direction.
- ``/set_weather <weather> <on|off|auto>``: Set a weather preset to always be applied (on), disable it completely (off), or reset it to be applied automatically (auto). Turning presets on manually might result in partially missing effects (like no sound if you enable sandstorms but no storms). Use ``/weather_status`` for a full list of installed weather presets. The prefix is important.

## Configuration Options
You can find all mod configuration options in your Minetest launcher.
Go to ``Settings → All Settings → Mods → climate_api`` to change them.
Individual weather packs may provide additional configuration options in their respective mod configuration section.

### Performance
- ``Update speed of weather effects`` (default 1.0):
This value regulates how often weather presets are recalculated.
Higher values will result in smoother transitions between effects as well as faster response times to traveling players.
Lower values will significantly increase overall performance at the cost of rougher looking effects.
- ``Multiplicator for used particles`` (default 1.0):
This value regulates how many particles will be spawned.
A value of 1 will use the recommended amount of particles.
Lower values can possible increase performance.
- ``Dynamically modify nodes`` (default true):
If set to true, weather packs are allowed to register node update handlers.
These can be used to dynamically place snow layers, melt ice, or hydrate soil.
- ``Include wind speed in damage checks`` (default true):
If set to true, Climate API will factor in wind speed and obstacles to determine damage sources.
If set to false, a simple check will be used whether the player is outside.

### Weather Effects
- ``Cause player damage`` (default true):
If set to true, dangerous weather presets will damage affected players over time.
- ``Show particle effects`` (default true):
If set to true, weather effects (like rain) are allowed to render particles.
Deactivating this feature will prevent some presets from being visible.
For performance considerations it is recommended to decrease the amount of particles instead.
- ``Override the skybox`` (default true):
If set to true, weather effects are allowed to modify a player's sky.
This includes skybox, sun, moon, and clouds (also used for fog effects).
Running this mod on Minetest 5.1.2 or earlier versions will automatically disable this feature.
- ``Display HUD overlays`` (default true):
If set to true, weather effects are allowed to render an image on top of the gameplay.
This is usually an optional effect used to increase immersion (like a frozen-over camera in a snow storm).

### Environment
- ``Global base temperature`` (default 0):
This value will be added to all biome's base temperatures before applying random modifiers.
Every unit here will increase the global base heat by one degree Fahrenheit.
Negative values will cool down global base heat respectively.
- ``Global base humidity`` (default 0):
This value will be added to all biome's base humidity before applying random modifiers.
Every unit here will increase the global base humidity by one percent.
Negative values will dry up global base humidity respectively.
- ``Time rate of weather changes`` (default 1.0):
This value regulates how quickly environment factors like heat, humidity and wind are changing.
A value of 2 will double the speed at which weather presets change.
A value of 0.5 will half the speed respectively.

### Preferences
- ``Show degrees in Fahrenheit instead of Celsius`` (default false):
If set to true, temperature information in */weather* command will be displayed in Fahrenheit.
- ``Play ambient sound loops`` (default true):
If set to true, weather effects are allowed to play sound loops.
Note that you can also adjust sound levels instead of deactivating this feature completely.
- ``Volume of sound effects`` (default 1.0):
This value regulates overall sound volume.
A value of 2 will double the volume whereas a value of 0.5 will reduce the volume by half.

## Modding Information
Check the [api_doc.md](https://github.com/t-affeldt/climate_api/blob/master/api_doc.md) for a (currently incomplete) documentation on how to register new weather presets and visual effects. Use my weather [presets](https://github.com/t-affeldt/regional_weather/tree/master/ca_weathers) and [effects](https://github.com/t-affeldt/regional_weather/tree/master/ca_effects) as an example. Ask in the [forum](https://forum.minetest.net/viewtopic.php?t=24569) or open an [issue](https://github.com/t-affeldt/climate_api/issues) if you run into problems. Also check the source code of predefined weather effects because they include usage documentation at the top of each file.

## License
- Source Code: *GNU LGPL v3* by me
- Sun and moon textures: *CC BY-SA (3.0)* by Cap

## Assets in screenshots
- Screenshots and editing by me: *CC BY-SA (3.0)*
- Logos and artwork: *CC BY-SA (3.0)* by Cap
- Lato Font (for the Logo): *OFL* by Łukasz Dziedzic from http://www.latofonts.com/lato-free-fonts/
- Source Sans Pro (for the subtitles): *OFL*, see https://fonts.google.com/specimen/Source+Sans+Pro
- Used texture pack: Polygonia (128px edition) *CC BY-SA (4.0)* by Lokrates. See https://forum.minetest.net/viewtopic.php?f=4&t=19043
# Climate Modpack
Not every biome is the same and neither should their weather be.
The complete weather bundle for any Minetest game.

![](https://raw.githubusercontent.com/t-affeldt/regional_weather/master/screenshot.webp)

Source & Information on [Github](https://github.com/t-affeldt/climate) and the [Forum](https://forum.minetest.net/viewtopic.php?t=24569).

## Included Mods
- Climate API: The heart and core of this pack. This mod provides a vast weather and effect engine
- Regional Weather: What you will see on the screen. A bundle of weather presets and environment effects with beautiful visuals
- Moon Phases: Makes your sky dynamic by cycling through eight different phases
- Lightning by Auke Kok (sofar): Adds random lightning strikes during rainstorms

## Recommended Mods
- [Sailing Kit](https://github.com/t-affeldt/sailing_kit): A fork of [Termos' sailboat](https://forum.minetest.net/viewtopic.php?t=23520) to support the new wind system.

## Cloning Instructions
This modpack uses submodules to always be up-to-date.
Downloading the repository as a ZIP file leaves the mod folders empty, so you will have to download them manually. If you are using git commands then make sure you set the *recursive* flag instead: ``git clone https://github.com/t-affeldt/climate.git --recursive``. If you forget to set this flag, then the mod folders will be empty. You will also need to run ``git pull`` from within every mod folder in order to update the modpack.
Check out the [Git SCM guide on submodules](https://git-scm.com/book/de/v2/Git-Tools-Submodule) for more information.

## Troubleshooting
Generally speaking, most mods should be compatible.

If you notice __odd movement speeds__ or jump heights of players, you should check for mods that also modify player physics. Use a compatibility mod like [player_monoids](https://github.com/minetest-mods/player_monoids) or [playerphysics](https://forum.minetest.net/viewtopic.php?t=22172) to get rid of this problem. This requires the conflicting mod to also support the chosen compatibility layer.

Mods that __modify the sky__ (including skybox, moon, sun, stars and clouds) are sadly not fully compatible because they conflict with Climate API's sky system. You should deactivate the sky features in either mod. You can do this in the climate_api mod configuration using the ``Override the skybox`` setting. If you're a mod maker then you can also optionally depend on climate_api and use ``climate_api.skybox.add_layer(playername, layer_name, options)`` to register your skybox change in a compatible way. Note that you need __at least Minetest v5.2.0__ for skybox changes to have any effect.

Conflicting skybox changes include the ``weather`` mod included in vanilla __Minetest Game__. You will want to disable that mod in order to use the more advanced cloud system introduced by Climate API. Head to ``Settings → All Settings → Games → Minetest Game`` and set ``Enable weather`` to ``Disabled``. This setting will only exist if you are using Minetest Game v5.2.0 or higher.

If you experience __performance issues__, the *Performance* section of Climate API's configuration section is a great place to start looking for a solution.

## Chat Commands
### Climate API
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

### Moon Phases
This mod comes with two commands to print or change the current moon phase.
- Use ``/moonphase`` to view the currently active phase.
- Use ``/set_moonphase <phase>`` to change it. ``<phase>`` has to be a full number between 1 and 8.
- Use ``/set_moonstyle <style>`` to choose a texture preset. ``classic`` will result in a quadratic moon
	inspired by default Minetest. ``realistic`` will result in 256x images of the real moon.

In order to change the phase, you will need the corresponding privilege.
Use ``/grant <player> moonphase`` to grant it.

## Configuration Options
The individual mods offer a lot of customization options. Make sure to check the respective README files for more information.

## Modding Information
Check the [api_doc.md](https://github.com/t-affeldt/climate_api/blob/master/api_doc.md) for a (currently incomplete) documentation on how to register new weather presets and visual effects. Use my weather [presets](https://github.com/t-affeldt/regional_weather/tree/master/ca_weathers) and [effects](https://github.com/t-affeldt/regional_weather/tree/master/ca_effects) as an example. Ask in the [forum](https://forum.minetest.net/viewtopic.php?t=24569) or open an [issue](https://github.com/t-affeldt/climate_api/issues) if you run into problems. Also check the source code of predefined weather effects because they include usage documentation at the top of each file.

## License
All parts of this modpack are using free software licenses.
Check the individual README and LICENSE files of each mod for information.

### Assets in screenshots
- Screenshots and editing: *CC BY-SA (3.0)* by me
- Logos and artwork: *CC BY-SA (3.0)* by Cap
- Lato Font (for the Logo): *OFL* by Łukasz Dziedzic from http://www.latofonts.com/lato-free-fonts/
- Source Sans Pro (for the subtitles): *OFL*, see https://fonts.google.com/specimen/Source+Sans+Pro
- Used texture pack: Polygonia (128px edition) *CC BY-SA (4.0)* by Lokrates. See https://forum.minetest.net/viewtopic.php?f=4&t=19043
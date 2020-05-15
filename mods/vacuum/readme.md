Minetest vacuum
======

Vacuum implementation and blocks for pumping and detection of vacuum and air

* Github: [https://github.com/thomasrudin-mt/vacuum](https://github.com/thomasrudin-mt/vacuum)
* Forum topic: [https://forum.minetest.net/viewtopic.php?f=9&t=20195](https://forum.minetest.net/viewtopic.php?f=9&t=20195)

# Operation

The space/vacuum starts at 1000 blocks in the y axis (hardcoded in init.lua)

The mod defines an airlike **vacuum:vacuum** block which suffocates the player (with drowning=1).
An [spacesuit](https://git.rudin.io/minetest/spacesuit) or similar would help to survive in space.

Air can be pumped in to any closed structure with an airpump (vacuum:airpump).
the airpump needs air-bottles to work in vaccum. Air-bottles can be filled with an airpump on the ground.
Just place empty steel bottles in an airpump on the ground, enable it and it produces an airbottle every few seconds.

## Vacuum propagation

The vacuum sucks air out of every structure if there are leaky nodes (doors, wool, wood, etc; defined in abm.lua)

A vacuum node in a pressurized area can suck out the whole structure.

## Other nodes in space

Vacuum exposure on nodes:
* Dirt converts to gravel
* All plants convert to dry shrubs
* Leaves disappear
* Water evaporates
* Torches and ladders drop (to prevent air bubbles/cheating)

# Compatibility

Optional dependencies:
* Mesecon interaction (enable/disable airpump)
* Pipeworks

Tested mods:
* digtron
* technic (quarry, solar)

# Crafting

TODO

# Screenshots

Air pump:

![](screenshots/screenshot_20180524_204035.png?raw=true)

Hole in the structure (leaking air):

![](screenshots/screenshot_20180524_204042.png?raw=true)

Hole from outside:

![](screenshots/screenshot_20180524_204132.png?raw=true)

# Attributions
* textures/vacuum_airpump* by ManElevation MIT (https://github.com/ManElevation/oxygenerators5.2)

# History

## Version 0.1
* Initial release



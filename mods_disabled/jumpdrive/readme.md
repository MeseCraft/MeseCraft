Minetest jumpdrive
======

![](https://github.com/mt-mods/jumpdrive/workflows/luacheck/badge.svg)
![](https://github.com/mt-mods/jumpdrive/workflows/integration-test/badge.svg)


A simple [Jumpdrive](https://en.wikipedia.org/wiki/Jump_drive) for minetest

Take your buildings with you on your journey

* Github: [https://github.com/thomasrudin-mt/jumpdrive](https://github.com/thomasrudin-mt/jumpdrive)
* Forum topic: [https://forum.minetest.net/viewtopic.php?f=9&t=20073](https://forum.minetest.net/viewtopic.php?f=9&t=20073)

# Operation

* Place a 'jumpdrive:engine' into the center of your creation.
* Connect the engine to a technic HV network
* Let the engine charge
* Choose your target coordinates (should be air or ignore blocks)
* Select your cube-radius
* Click "show" and check the green (source) and red (target) destination markers if everything is in range
* Click "jump"

# Compatibility

Optional dependencies:
* Mesecon interaction (execute jump on signal)
* Technic rechargeable (HV)
* Travelnet box (gets rewired after jump)
* Elevator (on_place gets called after jump)
* Locator (gets removed and added after each jump)
* Pipeworks teleport tubes (with a patch to pipeworks)
* Beds (thx to @tuedel)
* Ropes (thx to @tuedel)
* Mission-wand as coordinate bookmark (thx to @SwissalpS)
* Areas
* Drawers

# Fuel

The engine can be connected to a technic HV network or fuelled with power items.
Power items are one of the following
* `default:mese_crystal_fragment`
* `default:mese_crystal`
* `default:mese`

# Energy requirements

The energy requirements formula looks like this: **10 x radius x distance**

For example:
* Distance: 100 blocks
* Radius: 5 blocks
* Required energy: 10 x 5 x 100 = 5000

# Upgrades

If the `technic` mod is installed the following items can be used in the upgrade slot:
* `technic:red_energy_crystal` increases power storage
* `technic:green_energy_crystal` increases power storage
* `technic:blue_energy_crystal` increases power storage
* `technic:control_logic_unit` increases power recharge rate

# Protection

The source and destination areas are checked for protection so you can't remove and jump into someone else's buildings.


# Screenshots

Interface:

![](screenshots/screenshot_20180507_200309.png?raw=true)

Example:

![](screenshots/screenshot_20180507_200203.png?raw=true)

# Advanced operation

## Coordinate bookmarking

You can place empty books into the drive inventory and write the coordinates to it with the "Write to book" button
The "Read from book" reads the coordinates from the next book in the inventory

## Diglines

* See: [Digilines](doc/digiline.md)

# Settings

Settings in minetest.conf:

* **jumpdrive.max_radius** max radius of the jumpdrive (default: *15*)
* **jumpdrive.max_area_radius** max radius of the area jumpdrive (default: *25*)
* **jumpdrive.powerstorage** power storage of the drive (default: *1000000*)
* **jumpdrive.power_requirement** power requirement for chargin (default: *2500*)

# Lua api

## Preflight check

The preflight check can be overriden to execute additional checks:

```lua
jumpdrive.preflight_check = function(source, destination, radius, player)
	-- check for height limit, only space travel allowed
	if destination.y < 1000 then
		return { success=false, message="Atmospheric travel not allowed!" }
	end

	-- everything ok
	return { success=true }
end
```

## Fuel calc

The default fuel calc can be overwritten by a depending mod:

```lua
-- calculates the power requirements for a jump
jumpdrive.calculate_power = function(radius, distance, sourcePos, targetPos)
	return 10 * distance * radius
end
```

# Sources

* jumprive_engine.ogg: https://freesound.org/people/kaboose102/sounds/340257/

# Contributors

* @tuedel
* @SwissalpS
* @Panquesito7
* @OgelGames
* @S-S-X

# History

## Next
* optional technic mod
* upgrade slots

## 2.0

* various fixes and optimizations
* Fleetcontroller
* Digiline interface
* mod.conf (minetest >= 5.0)
* Beds,ropes,missions compatibility
* calculate_power() override
* overlap check
* No fuel consumption if creative
* Protection checks for source and destination
* preflight check with custom override
* Settings in minetest.conf
* vacuum compatibility (jump into vacuum with air filled vessel)

## 1.1

* improved performance
* Documentation
* Removed complicated cascade function

## 1.0

* Initial version
* Cascade operation (with issues)

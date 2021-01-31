API documentation for Mana mod
==============================

## Introduction
The API of the Mana mod allows you to set and receive
the current and maxiumum mana reserves of a player,
and to subtract and add mana.

## The basic rules
For integrity reasons, this mod will ensure that the following assumptions
are true at all times for all players:

* Current and maximum mana can never be smaller than 0
* The current value must not be greater than the maximum value
* Only integer numbers are permitted for mana values

It should be not possible to break these rules using this API alone.
If you somehow manage to break one ofthe rules, please report a bug.

If a real number is used as input for a value, it will be rounded
(“round up half” rule).

## Functions
Of not specified otherwise, all functions return `nil`.
`playername` always refers to the name of a player, as string.
`value` always refers to a number and for most functions it must always be equal to or greater than 0.


### `mana.set(playername, value)`
Sets the mana reserve of the specified player to `value`.
If `value` is smaller than 0, the mana will be set to 0.
If `value` is greater than the maximum, the mana will be set to the maximum.


### `mana.setmax(playername, value)`
Sets the maximum of the player to `value`.

If the new maximum would become smaller than the current value,
the current value will automatically be set to
the new maximum.

### `mana.setregen(playername, value)`
Sets the mana regeneration per mana tick of the player to `value`.
Floating-point numbers are also permitted, in which the generation
of 1 mana takes longer than 1 mana tick. I.e. `0.5`. means
that 1 mana is generated every 2 mana ticks. A negative value means the
player loses mana.


The length of one “mana tick” is specified as the server-wide setting
`mana_default_regen` in seconds.


### `mana.get(playername)`
Returns the current mana of the specified player as number.


### `mana.getmax(playername)`
Returns the current maximum mana of the specified player as number.


### `mana.getregen(playername)`
Returns the current mana regneration per mana tick of the specified
player as number.
The length of one “mana tick” is specified as the server-wide setting
`mana_default_regen` in seconds.


### `mana.add(playername, value)`
Adds the specified non-negative amount of mana to the player, but only
if the sum would not be greater than the maximum,

#### Return value
* `true` on success, all mana has been added
* `false` on failure, no mana has been added


### `mana.subtract(playername, value)`
Subtracts the specified non-negative amount of mana from the player,
but only if the player has sufficient mana reservers.

#### Return value
* `true` on success, all mana has been subtracted
* `false` on failure, no mana has been subtraceed


### `mana.add_up_to(playername, value)`
Adds the specified non-negative amount of mana to the player, but it will
be capped at the maximum. 

#### Return value
* `true, excess` on success, where `excess` is the amount of Mana which could not be added because it would have exceeded the maximum. `excess` equals `0` if all mana has been added
* `false` on failure (mana could not be added)


### `mana.subtract_up_to(playername, value)`
Subtracts the specified non-negative amount of mana from the player, 
but if the difference is smaller than 0, the mana will be set to 0.

#### Return value
* `true, missing` on success, where `missing` is the amount of Mana which could not be subtracted because it would have exceeded 0. `missing` equals `0` if all mana has been subtracted 
* `false` on failure (mana could not be subtracted)


## Appendix
### General recommendations
If you want your mod to be portable, it is recommended that you balance your mod in such a way that it assumes
that every player starts with the following default mana values:

* Max. mana: 200
* Mana regeneration: 1 mana every 0.2 seconds

Also assume that the max. mana never changes.
This should (hopefully) ensure that multiple independent mana-using mods are more or less balanced when using
the default settings.

Also, to make life easier for subgame makers, define custom minetest.conf settings for your mod in order to
overwrite the mana costs (and other relevant values) used by your mod. That way, subgame makers only have to edit
minetest.conf, and not your mod.

You do not have to bother about default values if you want to directly integrate your mod in a subgame and do
not plan to release the mod independently.

The best way to reliable balance the mana values used by several mods is to create a standalone subgame. It is
highly recommended that you tweak the mana values of the mods to fit the subgame's needs.

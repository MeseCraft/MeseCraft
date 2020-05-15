# Bweapons modpack
Bweapons aims at providing a full progression of ranged weapons, from primitive bows to sci-fi rifles or magic staves and spellbooks. Modpack also provides an API to easily make your own weapons.  
Content packs are split into separate mods, so if you don't like something (for example you only want to leave magic), you can simply disable them.  

## Requirements
**Minetest 5.0.0+**  
**Minetest_game 5.0.0+**  

Full list of requirements:

- default, tnt (parts of minetest_game, default)
- [technic](https://github.com/minetest-mods/technic) (optional, but strongly recommended)
- [mana](https://repo.or.cz/minetest_mana.git) (optional, but strongly recommended)
- [magic_materials](https://github.com/ClockGen/magic_materials) (dependency for bweapons_magic_pack)
- [basic_materials](https://gitlab.com/VanessaE/basic_materials) (dependency of technic, and also for bweapons_firearms_pack)

## Recommended mods
- [gadgets_modpack](https://github.com/ClockGen/gadgets_modpack) (Together with gadgets_modpack forms a single combat, status effect and magic system)
- [craftguide](https://github.com/minetest-mods/craftguide) (explore crafting recipes of the new items)

# List of mods in modpack
- ### bweapons_api

    API, implementing all of bweapons functionality and required by actual weapon packs

    **Requires** : default, [technic](https://github.com/minetest-mods/technic)  (optional), [mana](https://repo.or.cz/minetest_mana.git) (optional)

- ### bweapons_firearms_pack

    Pack of weapons, consisting of:

    - Pump-action shotgun
    - Double-barreled shotgun
    - Pistol
    - Rifle
    - Grenade launcher

    **Requires** : default, tnt, [basic_materials](https://gitlab.com/VanessaE/basic_materials), [technic](https://github.com/minetest-mods/technic) 

- ### bweapons_bows_pack

    Pack of weapons, consisting of:

    - Wooden bow
    - Crossbow

    **Requires** : default

- ### bweapons_hitech_pack

    Pack of weapons, consisting of:

    - Particle Blaster
    - Laser Gun
    - Plasma Gun
    - Rail Gun
    - Rocket Launcher

    **Requires** : default, tnt, [basic_materials](https://gitlab.com/VanessaE/basic_materials), [technic](https://github.com/minetest-mods/technic) 

- ### bweapons_magic_pack

    Pack of weapons, consisting of:

    - Tome Of Fireball
    - Tome Of Ice Shard
    - Tome Of Electrosphere
    - Staff Of Light
    - Staff Of Magic
    - Staff Of Void

    **requires**: default, [magic_materials](https://github.com/ClockGen/magic_materials) 

- ### bweapons_utility_pack

    Pack of utilities, consisting of:

    - Torch bow

    **Requires** : default

## Tips
Magic weapons have following world interactions:

- Fireball will set some nodes on fire, if server fire is enabled
- Ice shard will freeze water and cool down lava sources into obsidian and flowing lava into stone
- Electrosphere will turn sand into glass
- Void staff will destroy a single node it hits

All interactions respect area protection

Railgun, apart from requiring ammo also needs to be charged with technic EUs.  

Magic tomes use mana and don't wear down, wear bar of staves represent their "charge", and they can be recharged by combining them with februm crystals on the crafting grid.

## Settingtypes
Modpack provides some settings, accessible via "Settings->All Settings->Mods->bweapons_api  
You can also put these settings directly to your minetest.conf

```
bweapons_combine_velocity = false
Combines current player velocity with projectile velocity. Disabled by default since it modifies
projectile speed and can potentionally decrease collision detection effectivenes (if it's too fast).

bweapons_damage_multiplier = 1
Global weapon damage multiplier.

bweapons_projectile_raycast_distance = 0.5
Length of a projectile raycast, performed on each server step, used for collision detection.
Bigger values means better detection, but also the projectile would stop further from the
actual target.
```

## Making your own weapons
To define weapons in your own mod you need to call `bweapons.register_weapon(def)`
where `def` is a definition table. To see a complete list of possible definition options (with comments)
refer to **[this document](bweapons_api/documentation.txt)**.

Although not required, but bweapons_api provides a second function, for
convenient ammo registration `bweapons.register_ammo(def)`. List of available definition
options can be found in the documentation mentioned above.

Also, you can see already defined weapon packs for reference, however, keep in mind, they don't contain all possible options.

## Limitations
Collision detection for projectiles is not perfect. It's much better than it was before (prior to minetest 5.0.0 it was very hacky, now it uses raycasting), however keep in mind to not make projectiles too fast, otherwise they might go through objects and nodes.  
If you still want to make projectiles fast, there's a settingtypes.txt option that you can put in your minetest.conf, to increase length of the raycast ray that's used for collision detection in projectiles:
```
bweapons_projectile_raycast_distance = 0.5
```

## License
All code is GPLv3 [link to the license](https://www.gnu.org/licenses/gpl-3.0.en.html)  
All resources not covered in the "credits" section are licensed under CC BY 4.0 [link to the license](https://creativecommons.org/licenses/by/4.0/legalcode)  

## Credits
Sounds from following users of freesound.org were mixed, cut, edited and used to produce sounds in this modpack:

- firestorm185 - energy hum sound
- qubodup - explosion
- kastenfrosch - cannonball
- qubodup - cannon shot
- panxozerok - instant chill
- selector - rocket launch
- florianreichelt - huge explosion
- wcoltd - laser4
- adrimb96 - fairy sound
- mattiagiovanetti - laser gun shots iii
- tjcason - shortlasersound
- nettimatto - mini crossbow foley
- qubodup - launching shooting propelled grenade
- saturdaysoundguy - longbow release 1
- kinoton - whoosh 1
- drmaysta - cartoon arrow hit
- arcandio - razorback archery
- lensflare8642 - shotgun sounds
- nioczkus - 1911 reload
- lemudcrab - grenade launcher
- nioczkus - browning hi power
- nioczkus - darkscape 1911 a1
- qubodup - fire-spell
- samararaine - bonfire being lit
- midimagician - fire burning loop
- qubodup - tree burns down
- qubodup - fire magic spell sound effect
- spookymodem - magicsmite
- lamamakesmusic - step ice break 01
- steffcaffrey - chimes
- spookymodem - hitting wall
- adrimb86 - fairy sound
- terminallynerdy - timestop
- slugzilla - phoenixscreech1
- bajko - sfx thunder blast
- joelaudio - electric zap 001
- dave-welsh - thunder-clap-owb-ky-441x16
- quaker540 - supernatural-explosion
- northern87 - barbecue-fire-northern87
- cyberkineticfilms - strange-teleport-sound
- slugzilla - phoenixscreech1
- zenithinfinitivestudios - fantasy-ui-button-1
- 221beimesche - glass-shattering-and-falling
- sclolex - tunneldrone

All sounds listed above were licensed as CC0. Produced sounds are licensed under CC BY 4.0 [link to the license](https://creativecommons.org/licenses/by/4.0/legalcode)
# gadgets_modpack
gadgets_modpack aims at providing a full progression of magic and technology based tools and consumables that add various player status effects and do other useful functions. Modpack also provides an API to easily make your own "gadgets".  
Content packs are split into separate mods, so if you don't like something (for example you only want to leave magic), you can simply disable them.  

## Requirements:

**Minetest 5.0.0+**  
**Minetest_game 5.0.0+**  

Full list of requirements:

- default, vessels, farming, bucket, flowers (parts of minetest_game, installed by default)
- [playereffects](https://repo.or.cz/minetest_playereffects.git) (Main framework for status effect handling)
- [player_monoids](https://github.com/minetest-mods/player_monoids) (Dependency of gadgets_default_effects, library for handling monoidal player values)
- [technic](https://github.com/minetest-mods/technic) (optional, but strongly recommended)
- [mana](https://repo.or.cz/minetest_mana.git) (optional, but strongly recommended)
- [magic_materials](https://github.com/ClockGen/magic_materials) (dependency for gadgets_consumables and gadgets_magic)
- [basic_materials](https://gitlab.com/VanessaE/basic_materials) (dependency of technic)

## Recommended mods

- [bweapons_modpack](https://github.com/ClockGen/bweapons_modpack) (Together with gadgets_modpack forms a single combat, status effect and magic system)
- [sprint_lite](https://github.com/ClockGen/sprint_lite) (If present, gadgets_consumables provide a stamina potion)
- [craftguide](https://github.com/minetest-mods/craftguide) (explore crafting recipes of the new items)

## List of mods in modpack
- ### gadgets_api

    API and main code for defining and handling status effect tools and consumables

    **Requires:** [playereffects](https://repo.or.cz/minetest_playereffects.git), [technic](https://github.com/minetest-mods/technic) (optional), [mana](https://repo.or.cz/minetest_mana.git) (optional)

- ### gadgets_default_effects

    Library providing default gadgets_modpack effects to other parts of gadgets_modpack

    Effects:

    - Increased Speed
    - Increased Jump Height
    - Lowered Gravity
    - Health Regeneration
    - Stamina Regeneration (if sprint_lite is present)
    - Mana Regeneration (if mana is present)
    - Water Breathing
    - Fire Shield (Damages mobs around you)

    Some effects have their second, stronger version (see according potions and crafting recipes)

    **Requires:** gadgets_api, [player_monoids](https://github.com/minetest-mods/player_monoids)

- ### gadgets_consumables

    Provides various magic-related consumables and potions

    Items:

    - Water Bottle
    - Potion Of Speed
    - Potion Of Jump
    - Potion Of Gravity
    - Potion Of Water Breathing
    - Potion Of Fire Shield
    - Potion Of Health Regeneration
    - Potion Of Stamina Regeneration (if sprint_lite is present)
    - Potion Of Mana Regeneration (if mana is present)
    - Dispel potion (removes all active status effects)
    - Teleport potion (teleports to a random location you can fit in, in specified range)

    **Requires:** default, vessels, farming, bucket, flowers (parts of minetest_game, installed by default), gadgets_api, gadgets_default_effects, [mana](https://repo.or.cz/minetest_mana.git) (optional, provides mana potion), [sprint_lite](https://github.com/ClockGen/sprint_lite) (optional, provides stamina potion)

- ### gadgets_magic

    Provides various magic-based spellbooks and staves

    Items:

    - Tome Of Gravity
    - Tome Of Speed
    - Tome Of Jump
    - Tome Of Blink (instantly teleports to the point you're looking, in limited range)
    - Tome Of Magic Bridge (creates a temporary magical bridge in front of you)
    - Staff Of Earth (Technic's drill counterpart, allows for fast mining)
    - Druid's Staff (Allows to perform a chain of transmutations on stone, from stone to dirt with grass)

    **Requires:** gadgets_api, gadgets_default_effects, [magic_materials](https://github.com/ClockGen/magic_materials)

## Tips

All interactions respect area protection

Magic tomes use mana and don't wear down, wear bar of staves represent their "charge", and they can be recharged by combining them with februm crystals on the crafting grid.

## Settingtypes
Modpack provides some settings, accessible via "Settings->All Settings->Mods->bweapons_api  
You can also put these settings directly to your minetest.conf

```
enable_gadgets_effects = true, bool, should status effect visuals spawn

effect_interval = 0.5, float, interval at which status effect visuals spawn
```

## Making your own gadgets
To define gadgets in your own mod you need to call `gadgets.register_gadget(def)`
where `def` is a definition table. To see a complete list of possible definition options (with comments)
refer to **[this document](gadgets_api/documentation.txt)**.

To register new effects you need to call `gadgets.register_effect(def)`, where `def`` is an effect definition table. Refer to the document above for details.

## License
All code is GPLv3 [link to the license](https://www.gnu.org/licenses/gpl-3.0.en.html)  
All resources not covered in the "credits" section are licensed under CC BY 4.0 [link to the license](https://creativecommons.org/licenses/by/4.0/legalcode)  

## Credits
Sounds from following users of freesound.org were mixed, cut, edited and used to produce sounds in this modpack:

- prozaciswack - digging
- alcinov - staircase-metal-rumble
- breviceps - ethereal-teleport
- spookymodem - hitting_wall
- ktinquelal - rayo-laser
- lamamakesmusic - step-ice-break
- northern87 - barbecue-fire-northern87
- midimagician - fire-burning-loop.2
- smararaine - bonfire-being-lit
- steffcaffrey - chimes
- quaker540 - supernatural-explosion
- cyberkineticfilms - strange-teleport-sound
- slugzilla - phoenixscreech1
- qubodup - fire-spell
- zenithinfinitivestudios - fantasy-ui-button-1
- adrimb86 - fairy-sound

All sounds listed above were licensed as CC0. Produced sounds are licensed under CC BY 4.0 [link to the license](https://creativecommons.org/licenses/by/4.0/legalcode)
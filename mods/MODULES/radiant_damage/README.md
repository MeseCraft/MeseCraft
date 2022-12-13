# radiant_damage

This mod allows registered nodes to damage a player if the player is simply near them, rather than having to be immersed in them directly. For example, in real life simply being close to lava would burn you. Or perhaps being near a highly radioactive material would be damaging.

This mod comes with a set of predefined radiant damage types, all of which can be enabled and disabled independently, and allows other mods to make use of its system to register their own.

## Configurable Presets

**Important note:** none of these predefined radiant damage types are enabled by default. This is because one of this mod's intended uses is as a library for other mods to use to enable their own radiant damage types. There is no way to de-register a globalstep callback (the mechanism used by this mod to deliver damage) once it has been registered, so to keep the mod maximally flexible nothing is registered by default.

Set one or more of the following types to enabled if you want this mod to have an effect out-of-the-box.

The following settings exist for predefined radiant damage types:

    radiant_damage_enable_heat_damage (Enable radiant heat damage) bool false
    radiant_damage_lava_damage (Damage dealt per second when standing directly adjacent to one lava node) int 8
    radiant_damage_fire_damage (Damage dealt per second when standing directly adjacent to one fire node) int 2
    
    radiant_damage_enable_mese_damage (Enable mese ore radiation damage) bool false
    radiant_damage_mese_interval (Number of seconds between mese radiation damage checks) int 5
    radiant_damage_mese_damage (Damage dealt per second when standing directly adjacent to one mese ore node) int 2

Mese radiation is attenuated by a factor of 0.9 when passing through most materials, by 0.5 when passing through anything with group:stone, by 0.1 when passing through anything with group:mese_radiation_shield (all default metal blocks are given this group), and is _amplified_ by a factor of 4 when passing through nodes with group:mese_radiation_amplifier (default coal and diamond blocks). Note that these fine-grained attenuation factors only work in Minetest 0.5 and higher, for 0.4.16 any non-air node will block all damage.
	
## API

### Registering a damage type

Call:

```
	radiant_damage.register_radiant_damage(damage_name, damage_def)
```

where damage_name is a string used to identify this damage type and damage_def is a table such as:

```
{
	interval = 1, -- number of seconds between each damage check. Defaults to 1 when undefined.
	range = 3, -- range of the damage. Can be omitted if inverse_square_falloff is true,
		-- in that case it defaults to the range at which 0.125 points of damage is done
		-- by the most damaging emitter node type.
	emitted_by = {}, -- nodes that emit this damage. At least one emission node type
		-- and damage value pair is required.
	attenuated_by = {} -- This allows certain intervening node types to modify the damage
		-- that radiates through it. This parameter is optional.
		-- Note: Only works in Minetest version 0.5 and above.
	default_attenuation = 1, -- the amount the damage is multiplied by when passing 
		-- through any other non-air nodes. Defaults to 0 when undefined. Note that
		-- in versions before Minetest 0.5 any value other than 1 will result in total
		-- occlusion (ie, any non-air node will block all damage)
	inverse_square_falloff = true, -- if true, damage falls off with the inverse square
		-- of the distance. If false, damage is constant within the range. Defaults to
		-- true when undefined.
	above_only = false, -- if true, damage only propagates directly upward. Useful for
		-- when you want to damage players only when they stand on the node.
		-- Defaults to false when undefined.
	on_damage = function(player_object, damage_value, pos), -- An optional callback to allow mods
		-- to do custom behaviour. If this is set to non-nil then the default damage will
		-- *not* be done to the player, it's up to the callback to handle that. If it's left
		-- undefined then damage_value is dealt to the player.
}
```

emitted_by has the following format:
```
	{["default:stone_with_mese"] = 2, ["default:mese"] = 9}
```
where the value associated with each entry is the amount of damage dealt. Groups are permitted. Note that negative damage represents "healing" radiation.

attenuated_by has the following similar format:

```
	{["group:stone"] = 0.25, ["default:steelblock"] = 0}
```

where the value is a multiplier that is applied to the damage passing through it. Groups are permitted. Note that you can use values greater than one to make a node type magnify damage instead of attenuating it.

### Updating/overriding a registered damage type

To modify or add new parameters to an existing already-registered damage type use the following function:

```
	radiant_damage.override_radiant_damage(damage_name, damage_def)
```

Where damage_def is a table as above but which only includes the new information. For example, a mod could add a new type of mese radiation emitter with the following:

```
	radiant_damage.override_radiant_damage("mese", {
		emitted_by = {
			["dfcaverns:glow_mese"] = radiant_damage.config.mese_damage * 12,
		},
	})
```

To remove an emission source set its emitted damage to 0.

To remove an attenuation node type, set its attenuation factor to equal the default attenuation factor.

If you wish to "disable" a registered damage type, use this override function to set its range to 1 and its interval to an enormous value (millions of seconds) to neutralize the damage type's global callback most efficiently.

## Further reading

These wiki pages may be of interest regarding the principles behind some of this mods' functions:

* [Inverse-square law](https://en.wikipedia.org/wiki/Inverse-square_law)
* [Half-value layer](https://en.wikipedia.org/wiki/Half-value_layer)
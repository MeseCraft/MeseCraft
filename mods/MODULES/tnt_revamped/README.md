# TNT
Fork of [TNT](https://github.com/minetest/minetest_game/tree/master/mods/tnt) mod

This mod will also override the default TNT mod.

water flow code copied from TenPlus1's builtin_item mod [builtin_item](https://notabug.org/TenPlus1/builtin_item)

# Features 

1. TNT is always entity on ignite.

2. Ignited TNT entities flow in water.

3. TNT jumps on ignite.

4. TNT blinks on ignite.

4. It is possible to make TNT cannons with this mod.

5. TNT does not damage nodes if it blows up in water. (This can be changed in config)

6. TNT does not damage players or entities if it blows up in water. (This can be changed in config)

7. TNT expands just before blowing up.

8. Players and other entities get knocked back by the explosion.

# api

``` lua
tnt.register_tnt({
    -- Mod name : TNT name
    name = "tnt:tnt",
    -- Description of TNT node
    description = "TNT",
    -- TNT Blast radius.
    radius = tnt_radius,
    -- Strength of blast (explosions mod only).
    strength = 1000,
    -- explosion delay in seconds.
    time = 4,
    -- On ignite the TNT will jump upwards based on the jump value.
    jump = 3,
    -- Ignite sound effect.
    ignite_sound = {name = "tnt_ignite"},
    -- The explosion sound effect.
    boom_sound = {name = "tnt_explode", def = {gain = 2.5, max_hear_distance = 128}}
})
```

# Config

The size of the default tnt blast.

``` lua
tnt_radius = 3
```

The number to multiply how much knock back on another TNT entity.

``` lua
tnt_revamped.tnt_entity_velocity_mul = 2
```

The number to multiply how much knock back on a player.

``` lua
tnt_revamped.player_velocity_mul = 10
```

The number to multiply how much knock back on a entity.

``` lua
tnt_revamped.entity_velocity_mul = 10
```

The explosion api to use.

Use default for the built-in explosions.

Use explosions for ryvnf's explosions mod.

``` lua
tnt_revamped.explosion = "default"
```

**In Water**

If true TNT blast will be able to damage nodes even if it is in water.

``` lua
tnt_revamped.damage_nodes = false
```

If true TNT blast will be able to damage entities even if it is in water.

``` lua
tnt_revamped.damage_entities = false
```

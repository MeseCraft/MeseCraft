This mapgen mod modifies how lava is distributed and how lava interacts with neighboring nodes in a variety of ways. Its various features can be enabled or disabled independently via configuration settings.

This mod makes magma more sparsely distributed across the map, but where it is found it will be available in massive quantities. Using this mod in conjunction with the dynamic_liquid mod can result in !!fun!! lava flows when caves intersect with magma conduits.

## Lava interaction with adjacent nodes

This mod provides an ABM that causes some types of nodes adjacent to lava to slowly convert into glowing "hot" forms, and then back to cool forms again if the lava goes away. Stone is converted into hot cobble and obsidian converts to a glowing red form.

Other mods can hook into this ABM by adding the following to node definitions:

```
group:lava_heatable
_magma_conduits_heats_to = hot node name
```

and

```
group:lava_heated
_magma_conduits_cools_to = cool node name
```

so for example default:stone is added to the lava_heatable group and given _magma_conduits_heats_to = "magma_conduits:hot_cobble" and magma_conduits:hot_cobble is in the lava_heated group and is given _magma_conduits_cools_to = "default:cobble".

Also included is an ABM that causes soil adjacent to lava to be cooked into barren sand.

## Magma veins

Magma veins are magma-filled conduits that thread through the ground somewhat like a cave system. The veins have a bias toward vertical orientation but can curve and twist in any direction.

Magma veins can be optionally be lined with a layer of obsidian. The density of vein generation is configurable.

## Volcanoes

Volcanoes are large cone-shaped mountains formed from magma that rises through a central vertical pipe. This mod can scatter randomly sized and shaped volcanoes across the map, with configurable spacing and probability. Volcanoes come in "extinct", "dormant" and "active" forms, and tall volcanoes can have a mantle of snow clinging to their peaks.

If a player has the "findvolcano" priviledge he can use the "findvolcano" console command to locate nearby volcanoes.

### Namegen and named_waypoint support

If the mods [namegen](https://github.com/FaceDeer/namegen) and [named_waypoints](https://github.com/FaceDeer/named_waypoints) are installed, then names and HUD markers will be automatically generated for volcanoes.
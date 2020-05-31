## Crops - more farming crops mod for minetest

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

This minetest mod expands the basic set of farming-related crops that
`minetest_game` offers. A list of crops/crafts is below.

## Configuration

A default configuration file, `crops_settings.txt` will be added
to your world folder that contains suggested `easy`, `normal` (the
default) and `difficult` settings for this mod. You can currently tune
the ABM interval/chance, and required light level for plant growth.

## Hydration mechanic

This feature is disabled in the `easy` setting.

Plants need water. Plants need more water when they grow. This mod
implements mechanics of plant hydration and what happens when you
over-water or not water your plants properly: Plants may wither or
soak, and if they wither/soak too much, the plant will get damaged.

You can see that plants are under stress visually. When a plant
withers, there will be particles that are steam/smoke-like floating
upwards from the plant. When a plant is over-watered, water bubbles
can be seen at the plant base. These are implemented as particles.

In the default difficulty settings, plants don't accrue enough damage
to kill the plant. But at difficult settings, withering will end up
resulting in plant death, or the loss of crop entirely. At default
settings, plants will yield significantly less harvest if not taken
care of! So if you do decide to not water your plants, make sure you
don't let them sit around for days and harvest them as soon as they
are ripe to limit the effects.

Environment factors can influence hydration: nearby water, night time
moisture. And of course, the watering can. The watering can holds
20 watering charges, and it takes 3-4 charges to water a plant from
completely dry to maximum wetness. Some plants will want more water,
some will do better with less, so make sure you use a hydrometer to
measure plant humidity. Recipes for the watering can and hydrometer
are listed below.

## Plants

1. Melons and pumpkins

Melon plants grow from melon seeds. Once a plant is mature (there
are 5 stages) it will spawn a melon block adjacent to the plant.
The melon block can be harvested by punching, and yields 3-5
melon slices. The melon slice can be crafted to a melon seed.

Pumpkins grow from pumpkin seeds, and are harvested to yield a
pumpkin block. Each block can be cooked to yield one or more
roast pumpkin chunks, which can be eaten. You can also craft
the blocks to seeds. A pumpkin plant will only yield limited amounts
of pumpkins. After a while they automatically wither.

2. Corn.

Corn plants are 2 blocks high, and yield corn cobs. These can be
cooked to corn-on-the-cob, or processed to make corn seed (corn
kernels, basically).

Digging a mature plant yields the corn cob. A harvested corn plant
"wilts", and needs to be dug away to make the land usable, or can
be left as ornamental 2-block plant. Digging either top or bottom
block works in all cases.

3. Tomatoes.

Tomatoes appear to work simple enough, until you harvest them
the first time: The plant stays! However, after the 3rd to 5th
harvest, the plant wilts and needs to be removed, since no more
tomatoes will grow on the plant. Per harvest you can get 1-2
tomatoes only. You can craft the tomatoes to tomato seeds, as
expected.

4. Potatoes.

The plants themselves don't drop anything. Only if the plant matures
can you dig potatoes from the soil. If you can reach the soil from the
side you can save yourself one dig by digging the soil as that will
remove the plant from the top, but otherwise you need to dig twice:
once to remove the plant, once to dig out the potatoes.

You get 3-5 potatoes. Each potato gives one (set of) "potato eyes"
which are the clones that can grow back to potatoes. Be careful not
to dig the plant when there's flowers! You have to wait until the soil
below shows potatoes. It's fairly easy to see the difference, though.

5. Green Beans

These green beans are unnaturally green, but there's so many
of them that grow on a vine! Sadly, these beans don't grow beans
unsupported, so you stick some sticks together to make a beanpole,
something like this way:

empty empty empty
stick empty stick
stick empty stick

There, that should help the viney bean plant to grow to 2 meters
high. It has remarkable purple flowers, that pop all over the plant
just before the beans grow.

Sadly, once the beans are picked, this plant turns into an unusable
mess that makes it hard for the next plant to grow on the beanpole,
so you salvage the beanpole's sticks after harvesting in order to
make more beanpoles again. It's a bit of work, but worth it, these
beans are delicious!


## Cooking / Crafting

The corn cobs can be cooked directly to make Corn-on-the-Cob.

This mod includes a bowl recipe. The bowl is made from clay lumps,
which results in an unbaked clay bowl that needs to be baked in an
oven to be usable:

empty     empty     empty
clay_lump empty     clay_lump
empty     clay_lump empty

Pumpkin blocks can be cooked whole, and yield roasted pumpkin. It's
okay as food, but it takes a lot of work.

You can fill these bowls (or any group:food_bowl) with vegetables to
craft an uncooked vegetable stew:

empty       empty     empty
grean_beans potato    tomato
empty       clay_bowl empty

The uncooked vegetable stew obviously needs to be cooked as well in
an oven. The resulting Vegetable Stew bowl gives a lot of hears back,
which is worth the effort.

The watering can can be made as follows:

steel_ingot empty       empty
steel_ingot empty       steel_ingot
empty       steel_ingot empty

To fill the watering can, left click any block of water. To use,
left click a plant. The damage bar on the icon indicates the fill
level of the watering can.

The hydrometer can be crafted like this:

mese_crystal_fragment empty         empty
empty                 steel_ingot   empty
empty                 empty         steel_ingot

Left-click any plant with the hydrometer, and the charge bar indicates
the humidity level of the plant: a dry plant will have 0% humidity
and be a small red bar or no bar at all, and a soaked plant will
have a full green bar. Be careful though! Some plants prefer to be
at mid-level (yellow) instead of full wetness!


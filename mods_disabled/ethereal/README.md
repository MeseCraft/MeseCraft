# ethereal

Ethereal Mapgen mod for Minetest (works on all except v6)

## Forum Topic
- https://forum.minetest.net/viewtopic.php?f=11&t=14638

## Lucky Blocks
42

## Changelog

### 1.27

 - Added Etherium ore and dust
 - Added sparse decoration of dry grass and shrub to caves biome
 - Added sponges that spawn near coral, dry sponge in furnace to soak up water
 - Added new savanna dirt and decorations
 - Use default grass abms

### 1.26

 - Added Sakura biome, pink sakura trees and saplings
 - 1 in 10 chance of sakura sapling growing into white sakura
 - Bamboo grows in higher elevation while sakura grows in lower
 - Added sakura wood, stairs, fence, gate and door
 - Added 5.0 checks to add new biomes and decorations
 - Fixed water abm for dry dirt and added check for minetest 5.1 dry dirt also

### 1.25

 - Converted .mts files into schematic tables for easier editing
 - Added firethorn shrub in glacier areas (can be crafted into jelly)
 - Tweaked mapgen decorations
 - Added more lucky blocks
 - Added igloo to glacier biome
 - 2x2 bamboo = bamboo floor, 3x3 bamboo or 2x bamboo floor = bamboo block, blocks can be made into sticks, bamboo stairs need blocks to craft

### 1.24

 - Updating code to newer functions, requires Minetest 0.4.16 and above
 - Added food groups to be more compatible with other food mods
 - Bonemeal removed (use Bonemeal mod to replace https://forum.minetest.net/viewtopic.php?f=9&t=16446 )
 - Crystal Ingot recipe requires a bucket of water, unless you are using builtin_item mod where you can mix ingredients by dropping in a pool of water instead

### 1.23

 - Added bonemeal support for bush sapling and acacia bush sapling
 - Added support for [toolranks] mod if found
 - Reworked Crystal Shovel so it acts more like a normal shovel with soft touch

### 1.22

 - Added coral and silver sand to mapgen (0.4.15 only)
 - Replaced ethereal:green_dirt with default:dirt_with_grass for mortrees compatibility
 - Mesa biomes are now topped with dirt with dry grass (redwood saplings grow on dry grass)
 - Added bonemeal support for moretree's saplings
 - Added settings.conf file example so that settings remain after mod update
 - Added support for Real Torch so that torches near water drop an unlit torch
 - Added support for new leafdecay functions (0.4.15 dev)
 - Mapgen will use dirt_with_rainforest_litter for jungles if found
 - Added bushes to mapgen

### 1.21

 - Saplings need clear space above to grow (depending on height of tree)
 - Bonemeal changes to suit new sapling growth
 - Fixes and tweaks
 - Added default Abm overrides
 - Added 4 new plants from baked clay mod to mapgen
 - Added swamp biome to outskirts of bamboo areas

### 1.20

- Tweaked Ethereal to work with new features and nodes in Minetest 0.4.14
- Added bones found in dirt and bonemeal to make tree's and crops grow quicker
- Tree's follow default rules where saplings need light to grow
- Using default schematics for apple, pine, acacia and jungle tree's
- Tidied and split code into separate files
- Redid coloured grass spread function to run better
- Added support for moreblock's stairsplus feature

### 1.19

- Added new biome routine to help restructure biomes
- Tweaked biome values so that they are more spread out (no more huge bamboo biome)
- Tweaked biome plant and tree decorations
- Fixed farming compatibility when using hoe on ethereal dirt
- Dirt with dry grass turns into green grass when near water
- Ice or snow above sea level melts into river water
- Disabling ethereal biomes no longer shows error messages
- Fire Flowers re-generate, can also be made into Fire Dust and both are fuel
- Optimize and tidy code

### 1.18

- Added Birch tree, also stairs; fence and gate
- Added Fire flower to fiery biomes (careful, it hurts)
- Tweaked biomes and decoration slightly
- Added tree_tool for admin to quickly grow tree's
- Cobble to Mossycobble when near water has been toned down a bit

### 1.17

- Added new Glacier biome filled with snow and ice
- Changed Mesa biome to have more coloured clay patterns
- Changed Bamboo biome to have tall tree-like stalks with leaves that give
- Bamboo sprouts are now saplings to grow new stalks
- Removed farmed mushrooms and replaced with default game mushrooms with spores

### 1.16

- Added new tree schematics that change when placed with random leaves, fruit and height
- Changed frost dirt so that it no longer freezes water (saves lag)
- Torches cannot be placed next to water, otherwise they drop as items
- Added latest farming redo Bean Bushes to mapgen
- Code tidy (thanks HybridDog) and bug fix
- Banana, Orange and Apple fruits now drop when tree has been removed.

### 1.15

- Added Staff of Light (thanks Xanthin), crafted from illumishrooms and can turn stone into glostone and back again
- Changed how Crystal Spikes reproduce
- Crystal Ingots now require 2x mese crystal and 2x crystal spikes to craft
- Removed obsidian brick & stairs now they are in default game, also removed pine wood stairs for same reason
- Tidied code and optimized a few routines


### 1.14

- Changed Ethereal to work with Minetest 0.4.11 update and new mapgen features
- Changed Pine tree's to use default pine wood
- Added pine wood fence, gate and stairs
- Crystal Spikes now re-generate in crystal biomes
- Removed layer mapgen, keeping spread as default


### 1.13

- Changed melting feature to work with 0.4.11 pre-release now that group:hot and group:melt have been removed


### 1.12

- Added ability to disable biomes in the init.lua file by setting to 1 (enable) or 0 (disable)
- Supports Framing Redo 1.10 foods


### 1.11

- Added Stairs for Ethereal wood types, mushroom, dry dirt, obsidian brick and clay
- Added Green Coral which can be used as green dye
- Craft 5x Ice in X pattern to give 5x Snow
- Added Snow and Ice Bricks with their own stairs and slabs which melt when near heat


### 1.10

- Added Stone Ladders (another use for cobble)
- Craft 5x Gravel in X pattern to give 5 dirt, and 5x dirt in X pattern for 5 sand
- Added Acacia tree's to desert biome (a nice pink wood to build with, thanks to VanessaE for textures)
- Added Acacia fences and gates
- Added Vines, craftable with 2x3 leaves


### 1.09

- Fixed Quicksand bug where player see's only black when sinking instead of yellow effect, note this will only work on new maps or newly generated areas of map containing quicksand
- Hot nodes will melt ice and snow in a better way
- Few spelling errors sorted for sapling and wood names


### 1.08

- Saplings produce better placed tree's when grown, routines have been redone
- Orange tree's now spawn in prairie biomes
- The usual code tidy and few bug fixes along the way

### 1.07

- If Farming Redo mod detected then it's growing routines will be used for Ethereal plantlife instead of default
Leaftype and Mapstyle settings can be changed within init.lua file, new layered style maps are being tested
Changed crafting recipe for Fences, they tie in with Gates a little better

### 1.06

- Added support for Farming Redo mod, all plants spawn on newly generated areas:
 - https://forum.minetest.net/viewtopic.php?id=9019

### 1.05b

- Added Gates for each of the fence types (thanks to Blockmen for gate model)
- Players can no longer jump over fences unless they wear crystal boots < REMOVED

### 1.04

- Farming of Mushrooms, Wild Onions and Strawberries now use minetest 0.4.10 functions
- Strawberries can be grown by using actual fruit, seeds no longer needed
- Tree leaves are no longer walkable, player can go through them
- Saplings now fall if block underneath disturbed

### 1.03

- Changed Fence recipe's so it doesn't interfere with 3d armor's wooden boots
- Tweaked textures to bring down file sizes
- Flowers, Sprouts and Ferns now spread over ALL grassland

### 1.02

- Fences added for each type of wood in Ethereal
- Changes to biome settings, less artifacts

### 1.01

- Quicksand generates throughout world near sandy water
- Bamboo as well as Papyrus now grow on dirt near water
- Fixed Coral textures and light

### 1.00

- Seaweed now spawns in deep water and can grow up to 10 high
- Coral also spawns in deep water and glows slightly (orange, pink and blue)
- Above items can be crafted into dye, also Seaweed is edible
- So long as sand isn't disturbed under the ocean, sealife will re-generate
- Fixed Leaves inventory images and Mushroom selection box (thanks Wuzzy)

### 0.0.9
#### 0.0.9p

- Willow Trees now spawn in grey biome instead of tiny grey trees (model by Phiwari123)
- Redwood Trees now spawn in Mesa biome (model by Wes42033)
- BakedClay mod no longer required for Mesa biome but used if found
- Paper Wall added

#### 0.0.9o

- Added Obsidian Brick craft for building
- Changed Illumishroom cave levels
- Changed *is_ground_content* to false for ethereal dirt so mapgen doesn't carve it up with caves

#### 0.0.9n

- New textures for farming mushrooms and spores
- Illumi-shrooms spawn in caves to brighten things up a little
- Crafting a wooden sign now gives 4 instead of 1

#### 0.0.9m

- Changed Bamboo biome slightly, Bamboo Sprout has new image
- Abm timings changed and a few bugs fixed
- Crystal Gilly Staff has to be used (left-click) to replenish air while underwater
- Crystal Shovel now works with protection mods
- Tidied code and changed ladder recipe's to double output

#### 0.0.9L

- Scorched Tree's are now different sizes
- Crystal Shovel with soft touch can now be used to dig up sand and gravel
- Bamboo and Papyrus drop entire stalk when bottom node dug
- Crystal Spikes require steel pick or better to dig and fall when dirt below is removed
- Few changes to mapgen and water functions

#### 0.0.9k

- Fixed bug in charcoal lumps (no more placing as unknown nodes)
- Added Crystal Shovel with soft touch, can be used to dig up dirt with grass intact
- Fixed bug in Crystal Shovel, now works with dirt_with_snow and has sounds
- Tweaked Fiery Biomes slightly, smaller craters on outside, large in hotter areas

#### 0.0.9i

- Cleaned up mapgen_v7.lua file, maps now generate a little faster
- Removed cactus.mts, no longer required
- Removed mushroomtwo.mts, no longer required
- Removed bamboo.mts, no longer required
- Removed deadtree.mts, no longer required
- Few new textures added
- Papyrus also spawns on jungle dirt near water
- Replaced dead tree's with scorched tree's
- Each scorched tree trunk crafts into 2x charcoal Lumps (fixed)
- Torches can also be crafted from Charcoal

#### 0.0.9h

- Added Strawberry farming, Strawberry Seeds and new Textures
- Tidied up mapgen_v7.lua for better spawning of plants and trees
- Player can no longer walk through Bamboo Stalks

#### 0.0.9g

- Changed Ethereal's growing routine for Saplings, it now uses 1 single abm to grow all tree's

#### 0.0.9f

- Added Fishing to Ethereal, Fishing Rod, Worms, Fish and Cooked Fish (Left-click the water with a Baited Rod in the hope of landing your prize)

#### 0.0.9e

- Changed textures for Bowl, Mushroom Soup, Crystal Spike, Banana Loaf, Strawberry & Bush
- Added Hearty Stew Recipes
- If BakedClay mod is installed, Mesa Biome will be added to the mix

#### 0.0.9d

- Added Bamboo Grove and Bamboo Sprouts )
- Craft Bamboo into Paper and Bamboo Flooring
- Cactus is now edible when crafted beside empty bucket

#### 0.0.9c

- Code re-worked so mod now uses sections for each function (easier to read and edit)
- New textures for Strawberry Bush and Crystal Spikes

#### 0.0.9b

- Pine Tree Leaves have new texture and sometimes give Pine Nuts
- Jungle Tree's now use default Jungle Wood as texture

#### 0.0.9

- Prairie, Grove, Jungle and Snowy biomes have their own dirt
- Saplings will only grow in the biomes they were taken from
- Mapgen tweaks and code changes for new dirt added

### 0.0.8 Changes
#### 0.0.8m

- Added Banana Trunk and Wood
- Added Boston Ferns to Grove biome
- Added edible Fern Tubers
- Mushroom Biome now has different sized mushrooms
- Changed Pine Needles texture

#### 0.0.8k

- Added Desert Sand biome
- Added Alpine biome with Pine Trees and Snow
- Added Grove biome with Banana Tree's (saplings only grow in that temperate area)
- Added Bananas, Banana Dough and Banana Bread
- Changed biome generation to be more like real-world environs (e.g. shrooms like hot & humid so that's where they spawn)
- Tidied up code and removed redundant lines

#### 0.0.8e

- New Plains biome added between Fiery and Green areas to hopefully stop forest fires, these have dry dirt and dead trees
- Placing water near Dry Dirt turns it into normal dirt, cooking normal dirt changes it into Dry Dirt

Note: if your Ethereal world does have a few forest fires appearing you can always add this line to your minetest.conf file:

disable_fire = true

#### 0.0.8

- Healing Tree (grows on high snowy peaks, leaves are edible and golden apples heal all hearts)
- Added some new images for Cooked Mushroom Soup, Mushroom Spores and Palm Trees
- 2D leaves or 3D leaves option, both wave in wind if enabled
- All new saplings can grow on their native dirt, and palm tree's on sand
- Crystal Spike or Crystal Dirt freezes nearby water, Heat can also melt ice
- Wild Mushrooms now give Spores, plant these to grow edible mushrooms
- Cobble in water turns mossy
- Palm Leaves can be cooked into Palm Wax and made into Candles

### 0.0.7c

- Gravel can be found under lake biomes (or craft 5 cobble in X pattern)
- Papyrus is found and grows on dirt near water (also craft 2x3 string for paper)
- Mushroom Heads have a chance of giving Mushroom Sapling (craft 1 head = 4x Mushrooms ready for Planting)
- Trees and Mushrooms have a chance of giving Saplings
- Frost Trunk and Mushroom Trunk are rotatable (craft 1 Mushroom Trunk = 4x White Dye)
- Desert areas have Dry Shrubs added
- Crystal Spikes added to Crystal Biome (watch out they hurt)
- Crystal Ingots added to make Sword and Pick
- New Pine Tree model added to snowy biome which adds Pine leaves and drops Pine Saplings
- Fixed GrassyTwo biome so that BigTree now spawns and grows from sapling
- Added Crystal Gilly Staff to allow breathing underwater (so long as it's in hand)
- Added Palm Trees, Trunk, Wood, Sapling, Coconuts, Coconut Slice (to eat)
- Thanks to VanessaE's for the Palm textures

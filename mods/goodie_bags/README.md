# Minetest Mod - Floating Factories Goodie Bags

Version 1.0.0  
Requires Minetest 0.4.16 or higher  
(It may work on older Minetest versions, but they're not a priority.)  

## Description
A mod for Minetest that is mostly meant for a sub game I'm working on, Floating Factories, but was segmented to allow easier use outside of the sub game. Doing this will hopefully encourage more people to use it, report bugs, and help fix code.

There are 4 goodie bag colors and 5 item pools. 1 pool is a general pool that all bags can select items from. It's generally the largest. The 4 other pools are exclusive to each goodie bag color. The general pool must always have minimum 1 item or no items will be given. This is to ensure each bag has at least 1 item to give. The other pools have no minimum.

Each bag randomly picks 1 - 3 items from the item pools. Each of those items randomly picks 1 - 10 items for each stack. There is a 1 in 15 chance that item selected will be from the bag's exclusive item pool otherwise the general item pool is used.

## Crafting Recipes
By default, there are no crafting recipes for the goodie bags as they would be way overpowered. This mod is meant for server admins, sub games, or players looking to create their own Minetest experience by adding items that can be selected and choosing how the goodie bags can be obtained, such as killing hostile mobs.

## Licensing
The pixel font used in the "Goodie Bag Contents" texture is called Battlenet. The battlenet font is made by Tom Israels. It's posted on http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=125 which is a website where you can make pixel fonts. It's licensed as public domain. The font itself is not distributed with this mod, but some people may want to know what font was used and any licensing restrictions it may have.

The sound named "ff_goodie_bags_Coin01.ogg" is licensed as CC0 by wobbleboxx (wobbleboxx.com) on opengamart.org. https://opengameart.org/content/level-up-power-up-coin-get-13-sounds

All other code and textures are created by isaiah658.
The code is licensed as WTFPL or MIT. You may choose either license that fits best when adapting code into your project.
The textures are licensed as Creative Commons Zero (CC0).

## Installation
After downloading, rename the folder to ff_goodie_bags.

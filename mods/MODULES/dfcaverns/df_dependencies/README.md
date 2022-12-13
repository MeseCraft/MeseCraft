The DF_Caverns modpack was originally written based on the minetest_game. It made extensive use of various nodes and helper functions that came from minetest_game's constituent mods.

When Mineclone games rose in popularity, the task of making it compatible was a daunting one - there were dependencies on minetest_game's mods scattered everywhere. To make the task manageable, I created this mod to serve as a central location where analogous objects could be taken from those games to be referenced in a generic way.

This requires abusing the "dependencies" system of Minetest, unfortunately. This mod is an enormous collection of either/or dependencies - things that can come from either mod A or mod B, but must come from one of them.
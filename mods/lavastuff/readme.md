# Lavastuff

[![](https://github.com/minetest-mods/lavastuff/workflows/Check%20&%20Release/badge.svg)](https://github.com/minetest-mods/lavastuff/actions)

Adds lava armor, tools, and blocks

## **API**
* **lavastuff.burn_drops("tool:itemstring")** - Cooks all of the nodes that **tool:itemstring** digs
* **lavastuff.enable_tool_fire** - Enable/Disable the lava tool fire feature
* **lavastuff.blacklisted_items** - Prevent lava tools from smelting certain nodes. See code for how to add an item to the list
* **lavastuff.cook_limit** - Prevent lava tools from smelting dug nodes if cooktime is too high
* **lavastuff.tool_fire_func** - The function used by lavastuff tools to place fire

## **Language support**
*  **Spanish** - (Thanks to **runs** & **xenonca**)
*  **French** - (Thanks to **Brian Gaucher** and **louisroyer**)
* **German** - (Thanks to **xenonca**)
* **Italian** - (Thanks to **xenonca**)

## **Special Features**
*  **Tool Fire** - Lights flammable nodes on fire when rightclicked. If node has set on_ignite then that function will be run instead of the fire being placed
*  **Autosmelt** - All nodes dug with a lava tool will be automatically smelted before being added to your inventory
*  **Buurn** - If the fire_plus mod is enabled players will catch on fire when hit with a lava tool

Most features can be disabled. If I don't have a setting to disable something you want to disable: Just ask!

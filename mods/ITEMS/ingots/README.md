Ingots
======
A small mod that makes it possible to place ore ingots in the world.

Options
=======
Toggle 'is_big' in conf.lua to make ingots apear bigger.
You can make an individual per ingot type choice in init.lua

API
===
You can ragister your own ingots.
Call "ingots.register_ingots(ingot_item, texture, is_big)"
ingot_item 	- The item which will be consumed to place an ingot. ex.: "default:steel_ingot"
texture 	- Name of texture used on ingot mesh. ex.: "ingot_steel.png"
is_big 		- Boolean which determines which ingot variant will be used.

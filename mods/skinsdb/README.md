# skinsdb

This Minetest mod offers changeable player skins with a graphical interface for multiple inventory mods.

## Features

- Flexible skins API to manage the database
- [character_creator](https://github.com/minetest-mods/character_creator) support for custom skins
- Skin change menu for sfinv (in minetest_game) and [unified_inventory](https://forum.minetest.net/viewtopic.php?t=12767)
- Skins change menu and command line using chat command /skinsdb (set | show | list | list private | list public | ui)
- Supported by [smart_inventory](https://forum.minetest.net/viewtopic.php?t=16597) for the skin selection
- Skin previews supported in selection
- Additional information for each skin
- Support for different skins lists: public and a per-player list are currently implemented
- Full [3d_armor](https://forum.minetest.net/viewtopic.php?t=4654) support
- Compatible to 1.0 and 1.8 Minecraft skins format


## Installing skins

### Download from the database

1) Get Minetest 5.1.0-dev-cb00632 or newer
2) Start your world
3) Run `/skinsdb_download_skins <skindb start page> <amount of pages>`
4) Wait for the Minetest server to shut down
5) Start the server again

You might want to run `minetest` in a Terminal/Console window to check the log output instantly.

### Manual addition

1) Copy your skin textures to `textures` as documented in `textures/readme.txt`
2) Create `meta/character_<name>.txt` with the following fields (separated by new lines):
    * Skin name
    * Author
    * Skin license


## License:
- GPLv3
- skin texture licenses: See "meta" folder

### Credits

- RealBadAngel (unified_inventory)
- Zeg9 (skinsdb)
- cornernote (source code)
- Krock (source code)
- bell07 (source code)
- stujones11 (player models)

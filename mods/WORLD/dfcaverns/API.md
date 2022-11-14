# Chat commands

There are not many chat commands provided by this modpack since it's primarily a mapgen mod. Only one is available to non-server-admins:

`mute_df_ambience`: Mutes or unmutes ambient sounds in deep caverns. This muted state is saved per-player, so players that are bothered by ambient sounds can disable them for themselves.

The following are only available for server admins:

`find_pit`: Finds the nearest glowing pit in the Underworld layer.

`mapgen_helper_loc` and `mapgen_helper_tour`: only available if the `mapgen_helper_log_locations` setting has been set to true. mapgen_helper will then record the locations of various types of mapgen feature as they are generated, and these commands will teleport the server admin to them.

`find_pit_caves`: Lists the locations of nearby vertical shaft caverns, including the top and bottom elevations.
	
# APIs

Not all APIs are listed here, this list focuses on APIs that modders may wish to use in sub-mods that modify DF Caverns' functionality in the existing context of this modpack.

## bones_loot

This mod populates the bones in the underworld with loot.

`bones_loot.register_loot`

Uses same table format as dungeon_loot from the default minetest_game. eg, {{name = "bucket:bucket_water", chance = 0.45, types = {"sandstone", "desert"}},

if dungeon_loot is installed it uses dungeon_loot's registration function directly.

## chasms

`chasms.register_ignore(node_name)`: Use this to set node types to be left alone by chasm-carving

`chasms.is_in_chasm(pos)`: returns true if pos is inside a chasm.

## df_ambience

`df_ambience.add_set(def)`: adds a sound set to the ambience mod. See soundsets.lua for a bunch of examples of what can go in the `def` table.

This mod has a lot of similarities to the [https://notabug.org/TenPlus1/ambience](ambience) mod, but after struggling to get that mod to "play nice" with df_caverns' needs it turned out to be easier to just re-implement the specific parts of the mod that were needed here.

## df_caverns

`df_caverns.get_biome(pos)`: returns the string name of the df_cavern biome that pos is located in, or nil if it's outside of any of df_caverns' cavern layers. df_caverns uses a homebrew biome system rather than the built-in biome registration system.

`df_caverns.is_ground_content(node_id)`: used by subterrane's mapgen to avoid removing nodes placed by df_caverns' mapgen. If you're adding new map features inside dfcavern's hollow spaces and they're being chopped in half at mapblock boundaries then you may be able to solve this by overriding this method with one that recognizes the nodes you're adding.

This was never really expected to be something that someone would need to do, though, so this is a little clunky. If you're having trouble with this please file an issue.

`df_caverns.populate_puzzle_chest(pos)`: When a "puzzle chest" is generated in the Underworld ruins this method gets called to populate its contents. If you wish to override the contents of the puzzle chest then you can override this method. Place items in the "main" inventory at the pos parameter's location.

## looped_node_sound

`looped_node_sound.register(def)`: A simple mod for making nodes emit a looped sound when the player is nearby.

  def = {
    node_list = {"df_trees:torchspine_1_lit"},
    sound = "dfcaverns_torchspine_loop",
    max_gain = 0.5,
    gain_per_node = 0.05,
  }

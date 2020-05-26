# Skinsdb Interface

## skins.get_player_skin(player)
Return the skin object assigned to the player. Returns default if nothing assigned

## skins.assign_player_skin(player, skin)
Check if allowed and assign the skin for the player without visual updates. The "skin" parameter could be the skin key or the skin object
Returns false if skin is not valid or applicable to player

## skins.update_player_skin(player)
Update selected skin visuals on player

## skins.set_player_skin(player, skin)
Function for external usage on skin selection. This function assign the skin, call the skin:set_skin(player) hook to update dynamic skins, then update the visuals

## skins.get_skin_format(file)
Returns the skin format version ("1.0" or "1.8"). File is an open file handle to the texture file


## skins.get_skinlist(assignment, select_unassigned)
Obsolete - use get_skinlist_for_player() or get_skinlist_with_meta() instead

## skins.get_skinlist_for_player(playername)
Get all allowed skins for player. All public and all player's private skins. If playername not given only public skins returned

## skins.get_skinlist_with_meta(key, value)
Get all skins with metadata key is set to value. Example:
skins.get_skinlist_with_meta("playername", playername) - Get all private skins (w.o. public) for playername


## skins.new(key, object)
Create and register a new skin object for given key
  - key: Unique skins key, like "character_1"
  - object: Optional. Could be a prepared object with redefinitions

## skins.get(key)
Get existing skin object

HINT: During build-up phase maybe the next statement is usefull
```
local skin = skins.get(name) or skins.new(name)
```


# Skin object

## skin:get_key()
Get the unique skin key

## skin:set_texture(texture)
Set the skin texture - usually at the init time only

## skin:get_texture()
Get the skin texture for any reason. Note to apply them the skin:set_skin() should be used

Could be redefined for dynamic texture generation

## skin:set_preview(texture)
Set the skin preview - usually at the init time only

## skin:get_preview()
Get the skin preview

Could be redefined for dynamic preview texture generation

## skin:set_skin(player)
Hook for dynamic skins updates on select. Is called in skins.set_player_skin()
In skinsdb the default implementation for this function is empty.

skin:apply_skin_to_player(player)
Apply the skin to the player. Called in skins.update_player_skin() to update visuals

## skin:set_meta(key, value)
Add a meta information to the skin object

Note: the information is not stored, therefore should be filled each time during skins registration

## skin:get_meta(key)
The next metadata keys are filled or/and used interally in skinsdb framework
  - name - A name for the skin
  - author - The skin author
  - license - THe skin texture license
  - assignment - (obsolete) is "player:playername" in case the skin is assigned to be privat for a player
  - playername - Player assignment for private skin. Set false for skins not usable by all players (like NPC-Skins), true or nothing for all player skins
  - in_inventory_list - If set to false the skin is not visible in inventory skins selection but can be still applied to the player
  - _sort_id - Thi skins lists are sorted by this field for output (internal key)

## skin:get_meta_string(key)
Same as get_meta() but does return "" instead of nil if the meta key does not exists

## skin:is_applicable_for_player(playername)
Returns whether this skin is applicable for player "playername" or not, like private skins

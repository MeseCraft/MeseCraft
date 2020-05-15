# fire_plus

## API

* `fire_plus.burnplayer(player)`
	Sets `player` on fire
	* player - player object

* `fire_plus.get_burn_dmg(player)`
	Returns how much damage `player` should take from fire
	default is 1
	* `player` - player object

* `fire_plus.tnt_explode_radius`
	How close to a TNT node a player has to be to detonate it

* `fire_plus.ignition_nodes`
	Nodes that set player on fire. Example:
	* `table.insert(fire_plus.ignition_nodes, "fire")`
		All nodes with `fire` in their itemstring will set a player on fire

* `fire_plus.put_outs`
	Nodes that put out burning players. Example:
	* `table.insert(fire_plus.ignition_nodes, "water")`
		All nodes with `water` in their itemstring will put out a burning player

* `Fire tools`
	Allows modders to make tools set any players they hit on fire.
	Just set `tool_capabilities.damage_groups.burn = 1`
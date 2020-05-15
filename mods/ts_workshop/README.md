# ts_workshop

This mod made by Thomas-S adds an API for workshops.

For license information see the file `LICENSE`.

```lua
workshop.register_workshop("example", "workshop", {
	enough_supply = function(pos, selection)
	end,
	remove_supply = function(pos, selection)
	end,
	update_formspec = function(pos)
	end,
	update_inventory = function(pos)
	end,
	on_receive_fields = function(pos)
	end,
	on_construct = function(pos)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	end,
	can_dig = function(pos, player)
	end,
	
	-- everything else is simply passed to minetest.register_node()
})
```
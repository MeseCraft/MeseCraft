
Hopper API
----------

This API is kept simple by adding a single command which allows mods to add
containers like chests and furnaces to the hopper check list.


Command Usage
-------------

Make sure any mods using this function has 'hopper' in the depends.txt file.

hopper:add_container({ {"where_from", "node_name", "inventory_name"} })

  'where_from' is a string telling the api that items are coming from either
               the 'top' node into a hopper below, going into the 'bottom' node
               from the hopper above or coming from a 'side' hopper into the
               node next door.

  'node_name"  is the name of the container itself (e.g. "default:chest")

  'inventory_name' is the name of the container inventory that is affected.

e.g.

hopper:add_container({
	{"top", "default:furnace", "dst"}, -- take cooked items from above into hopper below
	{"bottom", "default:furnace", "src"}, -- insert items below to be cooked from hopper above
	{"side", "default:furnace", "fuel"}, -- replenish furnace fuel from hopper at side
})

You can also register hopper interaction targets by group, or by a group and a specific group
value. For example:

hopper:add_container({
	{"top", "group:loot_chest", "loot"},
	{"bottom", "group:loot_chest", "loot"},
	{"side", "group:loot_chest", "loot"},
})

Would cause hoppers to interact with the "loot" inventory of all nodes belonging to the group
"loot_chest", and

hopper:add_container({
	{"top", "group:protected_container=1", "main"},
	{"bottom", "group:protected_container=1", "main"},
	{"side", "group:protected_container=1", "main"},
})

Would cause hoppers to interact with the "main" inventory of nodes belonging to the group
"protected_container" provided they had a value of 1 in that group. Hoppers prioritize the most
specific definition first; they check for registrations for a specific node name, then
for registrations that apply to a node's group and group value, and then for registrations
applying to a node's group in general.

Note that if multiple group registrations apply to the same node it's undefined which group
will take priority. Using the above examples, if there were a node that belonged to *both*
the groups "loot_chest" and "protected_container=1" there's no way of knowing ahead of time
whether hoppers would interact with the "loot" or "main" inventories. Try to avoid this situation.

The hopper mod already have support for the wine barrel inside of the Wine mod and protected
chests inside of Protector Redo, as well as default chests, furnaces and hoppers
themselves.

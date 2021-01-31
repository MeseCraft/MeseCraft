hopper.doc = {}

if not minetest.get_modpath("doc") then
	return
end

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

hopper.doc.hopper_long_desc = S("Hopper to transfer items between neighboring blocks' inventories.")
hopper.doc.hopper_usage = S("Items are transfered from the block at the wide end of the hopper to the block at the narrow end of the hopper at a rate of one per second. Items can also be placed directly into the hopper's inventory, or they can be dropped into the space above a hopper and will be sucked into the hopper's inventory automatically.\n\n")
if hopper.config.single_craftable_item then
	hopper.doc.hopper_usage = hopper.doc.hopper_usage .. S("Hopper blocks come in both 'vertical' and 'side' forms, but when in a player's inventory both are represented by a single generic item. The type of hopper block that will be placed when the player uses this item depends on what is pointed at - when the hopper item is pointed at the top or bottom face of a block a vertical hopper is placed, when aimed at the side of a block a side hopper is produced that connects to the clicked-on side.\n\n")
else
	hopper.doc.hopper_usage = hopper.doc.hopper_usage .. S("Hopper blocks come in both 'vertical' and 'side' forms. They can be interconverted between the two forms via the crafting grid.\n\n")
end
hopper.doc.hopper_usage = hopper.doc.hopper_usage .. S("When used with furnaces, hoppers inject items into the furnace's \"raw material\" inventory slot when the narrow end is attached to the top or bottom and inject items into the furnace's \"fuel\" inventory slot when attached to the furnace's side.\n\nItems that cannot be placed in a target block's inventory will remain in the hopper.\n\nHoppers have the same permissions as the player that placed them. Hoppers placed by you are allowed to take items from or put items into locked chests that you own, but hoppers placed by other players will be unable to do so. A hopper's own inventory is not not owner-locked, though, so you can use this as a way to allow other players to deposit items into your locked chests.")

hopper.doc.chute_long_desc = S("A chute to transfer items over longer distances.")
hopper.doc.chute_usage = S("Chutes operate much like hoppers but do not have their own intake capability. Items can only be inserted into a chute manually or by a hopper connected to a chute. They transfer items in the direction indicated by the arrow on their narrow segment at a rate of one item per second. They have a small buffer capacity, and any items that can't be placed into the target block's inventory will remain lodged in the chute's buffer until manually removed or their destination becomes available.")

hopper.doc.sorter_long_desc = S("A sorter to redirect certain items to an alternate target.")
hopper.doc.sorter_usage = S("This is similar to a chute but has a secondary output that is used to shunt specific items to an alternate destination. There is a set of inventory slots labeled \"Filter\" at the top of this block's inventory display, if you place an item into one of these slots the sorter will record the item's type (without actually taking it from you). Then when items come through the sorter's inventory that match one of the items in the filter list it will first attempt to send it in the direction marked with an arrow on the sorter's sides.\n\nIf the item doesn't match the filter list, or the secondary output is unable to take the item for whatever reason, the sorter will try to send the item out the other output instead.\n\nIn addition, there is a button labeled \"Filter All\" that will tell the sorter to not use the filter list and instead first attempt to shunt all items out of the filter, only sending items along the non-filter path if the target cannot accept it for whatever reason. This feature is useful for handling \"overflow\" (when the target's inventory fills up) or for dealing with targets that are selective about what they accept (for example, a furnace's fuel slot).")
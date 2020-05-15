more_chests
===========

More Chests

This mod is a fork of 0gb.us's chests_0gb_us https://forum.minetest.net/viewtopic.php?f=11&t=4366

Megaf's more_chests fixes several bugs, uses new textures and adds compatibility with [VanessaE's Pipeworks] (https://github.com/VanessaE/pipeworks) mod.

The following text was writen by 0gb.us
```
Cobble Chest:
{'default:wood','default:cobble','default:wood'},
{'default:cobble','default:steel_ingot','default:cobble'},
{'default:wood','default:cobble','default:wood'}

This locked chest looks like cobblestone, and has no info text. Great for hiding things in. However, unlike real cobblestone, this chest is breakable by hand. If you suspect there is one hiding, Hold the left mouse button, ant run your hand along the walls. When cracks appear, you've found the chest.

Drop Box:
{'default:wood','','default:wood'},
{'default:wood','default:steel_ingot','default:wood'},
{'default:wood','default:wood','default:wood'}

Anyone can put things in, but only the chest's placer can remove items.

Secret Chest:
{'default:wood','default:cobble','default:wood'},
{'default:wood','default:steel_ingot','default:wood'},
{'default:wood','default:wood','default:wood'}

As long as you remember to click “close” before you leave the chest, no one can see what the chest contains. Only the chest's owner can click “open” and “close” on the chest's formspec, revealing and hiding the chest's contents.

Shared Chest:
{'default:wood','default:leaves','default:wood'},
{'default:wood','default:steel_ingot','default:wood'},
{'default:wood','default:wood','default:wood'}

Exactly what it sounds like. The chest's placer can add people to the chest's shared list using the chest's formspec. Warning: anyone you add may empty the chest. When the chest is empty, it can be mined by anyone, just like a regular locked chest.

Wifi Chest

{'default:wood','default:mese','default:wood'},
{'default:wood','default:steel_ingot','default:wood'},
{'default:wood','default:wood','default:wood'}

A wacky chest that doesn't store it's items in the usual way, but instead, stores them remotely. For that reason, all wifi chests appear to have the same inventory. Due to not actually having an inventory, wifi chests can also be mined, even when they appear to have stuff in them. Lastly, as everyone gets their own wifi account, the items you see in the wifi chest are not the same items anyone else sees. This chest's properties make it nice for keeping secrets, as well as essentially almost doubling your inventory space, if you choose to carry one with you.
```

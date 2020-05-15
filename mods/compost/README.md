Compost Mod v0.0.3
==================
Compost bins turn organic matter like leaves, flowers, grass etc into soil. The
bin is operated by punching or right-clicking.

Punching
--------
On punching (left-clicking) a compost bin, the pointed_thing is inserted into
the bin and dirt is transferred back. If pointed_thing is compostable and there
is a free slot for it, it disappears inside the bin. After that, if hand is
empty and there is soil in the bin, it appears in the hand.

Menu
----
Right-clicking the bin opens its menu. 8 (2 rows by 4 cols) slots for intputs,
one slot for output.

Once there are at least 8 pieces of acceptable inputs are inserted (stacks
OK), a timer starts. Every 30 seconds it adds 10% to the composting progress, so
it takes 5 minutes to create a block of soil.

Once 100% is reached, 8 pieces of input disappear and one block of soil is
added to output. The progress counter is reset to 0. Optionally, wear-out is
computed.

If there are not enough inputs, the timer (if it was set) is stopped (and it
works like a small chest).

Inputs
------
Acceptable inputs are group:flora (flowers and grasses) and group:leaves. Other
inputs are rejected. Food is rejected on esthetical grounds :-)

Nodebox
-------
If there is nothing in the bin, it looks empty when viewed from top (node
"compost:wood_barrel_empty"). If there's anything in it (inputs or soil), it
looks full of dirt (node "compost:wood_barrel").

Internationalization
--------------------
The mod is compatible with intllib. Currently available translations:
* French
* Portuguese
* Romanian
* Russian

License
-------
see LICENSE.txt

Crafting
--------
Wood barrel:

| W |   | W |
|---|---|---|
| W |   | W |
| W | S | W |

W : wood
S : wood slab

Bugs
----
Report bugs on the forum topic or open a issue on GitHub.

Authors
-------
* Original Work: cd2 (cdqwertz) - cdqwertz.github.io
* Modified Work: Vitalie Ciubotaru <vitalie at ciubotaru dot tk>

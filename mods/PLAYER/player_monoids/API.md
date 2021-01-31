#Player Monoids

The idea behind this library is that global player state (physics overrides,
armor values, etc.) changes from multiple mods should mesh nicely with each
other. This means they must be combinable in a sane way.

Monoids
=======
A player monoid covers a single kind of player state a mod might want to change.
These can be built-in player state, like speed multipliers or fly permissions,
or could be custom state introduced by mods, such as corruption or reputation
level. When you make a player monoid, you must choose some type of value to
represent state changes - for example, numbers for speed multipliers, or vectors
for "lucky direction". Each mod can contribute different changes, represented
by this type of value, and they are all combined together. This combined value
is interpreted and converted into actual effects on the player's state.
Privileges could be set, physics overrides would be used to effect speed
changes, and a mod might change some value to match the monoid.

Definition
----------
A player monoid definition is a table with the following:

  * ```combine(elem1, elem2)``` - An associative binary operation
  * ```fold({elems})``` - Equivalent to combining a whole list with ```combine```
  * ```identity``` - An identity element for ```combine```
  * ```apply(value, player)``` - Apply the effect represented by ```value```
  to ```player```
  * ```on_change(val1, val2, player)``` - Do something when the value on a
  player changes. (optional)

Additionally, you should document what values are valid representatives of
your monoid's effects. When something says that a value is "in a monoid", it
means that value is a valid representative of your monoid's effects.

combine and fold
----------------
```combine``` should take two values in your monoid and produce a third value in
your monoid. It should also be an associative operation. ```fold`` should take a
table containing elements of your monoid as input and combine them together in
key order. It should be equivalent to using ```combine``` to combine all the
values together. For example, ```combine``` could multiply two speed multipliers
together, and ```fold``` could multiply every value together.

identity
--------
```identity```, when combined with any other value, should result in the other
value. It also represents the "default" or "neutral" state of the player, and
will be used when there are no status effects active for a particular monoid.
For example, the identity of a speed monoid could be the multiplier ```1```.

apply
-----
```apply``` is the function that interprets a value in your monoid to do
something to the player's state. For example, you could set a speed multiplier
as the speed physics override for the player.

Functions
=========
```player_monoids.make_monoid(monoid_def)``` - Creates a new monoid that can be
used to make changes to the player state. Returns a monoid.

Monoid Methods
--------------
```monoid:add_change(player, value[, "id"])``` - Applies the change represented
by ```value``` to ```player```. Returns an ID for the change. If the optional
string argument ```"id"``` is supplied, that is used as the ID instead, and any
existing change with that ID is removed. IDs are only guaranteed to be unique
per-player. Conversely, you are allowed to make multiple changes with the same
ID as long as they are all on different players.

```monoid:del_change(player, id)``` - Removes the change with the given ID, from
the given player, if it exists.

```monoid:value(player)``` - The current combined value of the monoid for the
given player.

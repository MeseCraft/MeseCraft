# Player Monoids

This is a small library for managing global player state, so that changes made
from different mods do not result in unexpected behavior. The README gives an
introduction to the mod, but you might want to reference API.md along the way.
This mod, combined with playereffects, deprecates monoidal_effects.

Global Player State
===================
Players have behavior-affecting state that can be modified through mods. A couple
examples are physics overrides and armor groups. If more than one mod tries to
change them, it can result in unexpected results.

For example, a player could be
under a speed boost effect from a playereffects effect, and then sleep in a bed.
The bed sets the player's speed to 0, and sets it back to 1 when they get out.
Because the beds mod had no way of knowing that the player was supposed to have
a speed boost, it effectively removed it. One hack to "fix" it would be to save
the player's speed and restore it on wakeup, but this would have its own problems
if the effect wears off in bed. The beds mod would restore the boosted speed,
which wouldn't be removed, since the effect already went away. Thus an exploit
allowing a permanent (until log out) speed boost is introduced.

Player Monoids manages this by creating layers (monoids) on top of player state,
which can keep track of different changes and combine them usefully.

Monoids
=======

Creation
--------
A monoid in Player Monoids is an interface to one piece of player state. For
example, you could have one monoid covering physics overrides, and another
covering fly privilege. You could define a speed monoids like this:
```
-- The values in my speed monoid must be speed multipliers (numbers).
mymod.speed_monoid = player_monoids.make_monoid({
	combine = function(speed1, speed2)
		return speed1 * speed2
	end,
	fold = function(tab)
		local res = 1
	     	for _, speed in pairs(tab) do
			res = res * speed
	     	end
	end,
	identity = 1,
	apply = function(speed, player)
		local override = player:get_physics_override()
		override.speed = speed
		player:set_physics_override(override)
	end,
	on_change = function() return end,
})
```

This says that two speed multipliers can be combined by multiplication, that
1 can be used as a neutral element, and that the "interpretation" of the speed
multiplier is to set the player's speed physics override to that value. It also
says that nothing in particular needs to happen when the speed changes, other
than applying the new speed multiplier.

Use
---
To add or remove change through a monoid, you must use the ```add_change```
and ```del_change``` methods. For example, you could speed the player up
temporarily like this:
```
-- Zoom!
local zoom_id = mymod.speed_monoid:add_change(some_player, 10)

minetest.after(5,function() mymod.speed_monoid:del_change(some_player, zoom_id) end)
```
You could also specify a string ID to use, instead of the numerical one that
is automatically provided:
```
-- Zoom Mk. II
mymod.speed_monoid:add_change(some_player, 10, "mymod:zoom")

minetest.after(5,function() mymod.speed_monoid:del_change(some_player, "mymod:zoom") end)
```

Reading Values
--------------
You can use ```monoid:value(player)``` to read the current value of the monoid,
for that player. This could be useful if it doesn't just represent built-in
player state. For example, it could represent gardening skill, and you might use
it to calculate the chance of success when harvesting spices.

Nesting Monoids
---------------
You may have already noticed one limitation of this design. That is, for each
kind of player state, you can only combine state changes in one way. If the
standard speed monoid combines speed multipliers by multiplication, you cannot
change it to instead choose the highest speed multiplier. Unfortunately, there
is currently no way change this - you will have to hope that the given monoid
combines in a useful way. However, it is possible to manage a subset of the
values in a custom way.

Suppose that a speed monoid (```mymod.speed_monoid```) already exists, using
multiplication, but you want to write a mod with speed boosts, and only apply
the strongest boost. Most of it could be done the same way:
```
-- My speed boosts monoid takes speed multipliers (numbers) that are at least 1.
newmod.speed_boosts = player_monoids.make_monoid({
	combine = function(speed1, speed2)
		return math.max(speed1, speed2)
	end,
	fold = function(tab)
		local res = 1
	     	for _, speed in pairs(tab) do
			res = math.max(res, speed)
	     	end
	end,
	identity = 1,
	apply = ???
	on_change = function() return end,
})
```
But we cannot just change the player speed in ```apply```, otherwise we will
break compatibility with the original speed monoid! The trick here is to use
the original monoid as a proxy for our effects.
```
apply = function(speed, player)
      mymod.speed_monoid:add_change(player, speed, "newmod:speed_boosts")
end
```
This means the speed boosts we control can be limited to the strongest boost, but
the resulting boost will still play nice with speed effects from other mods.
You could even add another "nested monoid" just for speed maluses, that takes
the worst speed drain and applies it as a multiplier.

Standard Monoids
================
In the spirit of compatibility, this mod provides some canonical monoids for
commonly used player state. They combine values in a way that should allow
different mods to affect player state fairly. If you make another monoid handling
the same state as one of these, you will break compatibility with any mods using
the standard monoid.

Physics Overrides
-----------------
These monoids set the multiplier of the override they are named after. All three
take non-negative numbers as values and combine them with multiplication. They
are:
 * ```player_monoids.speed```
 * ```player_monoids.jump```
 * ```player_monoids.gravity```

Privileges
----------
These monoids set privileges that affect the player's ordinary gameplay. They
take booleans as input and combine them with logical or. They are:
 * ```player_monoids.fly```
 * ```player_monoids.noclip```

Other
-----
 * ```player_monoids.collisionbox``` - Sets the player's collisionbox. Values are
 3D multiplier vectors, which are combined with component-wise multiplication.
 * ```player_monoids.visual_size``` - Sets the player's collisionbox. Values are
 2D multiplier vectors (x and y), which are combined with component-wise
 multiplication.

Use with playereffects
======================
Player Monoids does not provide anything special for persistent effects with
limited lifetime. By using monoids with Wuzzy's playereffects, you can easily
create temporary effects that stack with each other. As an example, an effect
that gives the player 2x speed:
```
local speed = player_monoids.speed

local function apply(player)
  speed:add_change(player, 2, "mymod:2x_speed")
end

local function cancel(player)
  speed:del_change(player, "mymod:2x_speed")
end

local groups = { "mymod:2x_speed" }

playereffects.register_effect_type("mymod:2x_speed", "2x Speed", groups, apply, cancel)
```

Note that this effect does NOT use the "speed" effect group. As long as other
speed effects use the speed monoid, we do not want them to be cancelled, since
the goal is to combine the effects together. It does use a singleton group to
prevent multiple instances of the same effect. I think that playereffects require
effects to belong to at least one group, but I am not sure.

Caveats
=======
* If the global state managed by a monoid is modified by something other than
the monoid, you will have the same problem as when two mods both independently
try to modify global state without going through a monoid.
 * This includes playereffects effects that affect global player state without
going through a monoid.
* You will also get problems if you use multiple monoids to manage the same
global state.
* The order that different effects get combined together is based on key order,
which may not be predictable. So you should try to make your monoids commutative
in addition to associative, or at least not care if the order of two changes
is swapped.
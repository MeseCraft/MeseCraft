-- Standard effect monoids, to provide canonicity.

local function mult(x, y) return x * y end

local function mult_fold(elems)
	local tot = 1

	for _, v in pairs(elems) do
		tot = tot * v
	end

	return tot
end

local function v_mult(v1, v2)
	local res = {}

	for k, v in pairs(v1) do
		res[k] = v * v2[k]
	end

	return res
end

local function v_mult_fold(identity)
	return function(elems)
		local tot = identity

		for _, v in pairs(elems) do
			tot = v_mult(tot, v)
		end

		return tot
	end
end

local monoid = player_monoids.make_monoid

-- Speed monoid. Effect values are speed multipliers. Must be nonnegative
-- numbers.
player_monoids.speed = monoid({
	combine = mult,
	fold = mult_fold,
	identity = 1,
	apply = function(multiplier, player)
		local ov = player:get_physics_override()
		ov.speed = multiplier
		player:set_physics_override(ov)
	end,
})


-- Jump monoid. Effect values are jump multipliers. Must be nonnegative
-- numbers.
player_monoids.jump = monoid({
	combine = mult,
	fold = mult_fold,
	identity = 1,
	apply = function(multiplier, player)
		local ov = player:get_physics_override()
		ov.jump = multiplier
		player:set_physics_override(ov)
	end,
})

-- Gravity monoid. Effect values are gravity multipliers.
player_monoids.gravity = monoid({
	combine = mult,
	fold = mult_fold,
	identity = 1,
	apply = function(multiplier, player)
		local ov = player:get_physics_override()
		ov.gravity = multiplier
		player:set_physics_override(ov)
	end,
})

-- Fly ability monoid. The values are booleans, which are combined by or. A true
-- value indicates having the ability to fly.
player_monoids.fly = monoid({
	combine = function(p, q) return p or q end,
	fold = function(elems)
		for _, v in pairs(elems) do
			if v then return true end
		end

		return false
	end,
	identity = false,
	apply = function(can_fly, player)
		local p_name = player:get_player_name()
		local privs = minetest.get_player_privs(p_name)

		if can_fly then
			privs.fly = true
		else
			privs.fly = nil
		end

		minetest.set_player_privs(p_name, privs)

	end,
})

-- Noclip ability monoid. Works the same as fly monoid.
player_monoids.noclip = monoid({
	combine = function(p, q) return p or q end,
	fold = function(elems)
		for _, v in pairs(elems) do
			if v then return true end
		end

		return false
	end,
	identity = false,
	apply = function(can_noclip, player)
		local p_name = player:get_player_name()
		local privs = minetest.get_player_privs(p_name)

		if can_noclip then
			privs.noclip = true
		else
			privs.noclip = nil
		end

		minetest.set_player_privs(p_name, privs)

	end,
})

local def_col_scale = { x=0.3, y=1, z=0.3 }

-- Collisionbox scaling factor. Values are a vector of x, y, z multipliers.
player_monoids.collisionbox = monoid({
	combine = v_mult,
	fold = v_mult_fold({x=1, y=1, z=1}),
	identity = {x=1, y=1, z=1},
	apply = function(multiplier, player)
		local v = vector.multiply(def_col_scale, multiplier)

		player:set_properties({
			collisionbox = { -v.x, -v.y, -v.z, v.z, v.y, v.z }
		})
	end,
})

player_monoids.visual_size = monoid({
	combine = v_mult,
	fold = v_mult_fold({x=1, y=1}),
	identity = {x=1, y=1},
	apply = function(multiplier, player)
		player:set_properties({
			visual_size = multiplier
		})
	end,
})

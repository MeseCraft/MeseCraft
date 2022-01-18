local mod_player_monoids = minetest.get_modpath("player_monoids") ~= nil
local mod_playerphysics = minetest.get_modpath("playerphysics") ~= nil
local mod_pova = minetest.get_modpath("pova") ~= nil

local utility = {}

function utility.rangelim(value, min, max)
	return math.min(math.max(value, min), max)
end

-- from https://stackoverflow.com/a/29133654
-- merges two tables together
-- if in conflict, b will override values of a
function utility.merge_tables(a, b)
	if type(a) == "table" and type(b) == "table" then
		for k,v in pairs(b) do
			if type(v)=="table" and type(a[k] or false)=="table" then
				utility.merge_tables(a[k],v)
			else a[k]=v end
		end
	end
	return a
end

-- see https://en.wikipedia.org/wiki/Logistic_function
function utility.sigmoid(value, max, growth, midpoint)
	return max / (1 + math.exp(-growth * (value - midpoint)))
end

-- generates a wave of cycle length 1
-- maps parameters to values between 0 and 1
-- 0 is mapped to 0 and 0.5 to 1
function utility.normalized_cycle(value)
	return math.cos((2 * value + 1) * math.pi) / 2 + 0.5
end


return utility

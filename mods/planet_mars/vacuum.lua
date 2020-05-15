local has_vacuum_mod = minetest.get_modpath("vacuum")

local y_start = planet_mars.y_start
local y_height = planet_mars.y_height


if has_vacuum_mod then

	local old_is_pos_in_space = vacuum.is_pos_in_space
	vacuum.is_pos_in_space = function(pos)

		if pos.y < y_start or pos.y > (y_start + (y_height * 0.95)) then
			-- not on mars
			return old_is_pos_in_space(pos)
		end

		-- atmosphere in mars caves
		return false
	end


end

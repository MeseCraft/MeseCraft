

vacuum.air_bottle_image = "vessels_steel_bottle.png^[colorize:#0000FFAA"

-- space pos checker
vacuum.is_pos_in_space = function(pos)
	return pos.y > vacuum.space_height
end

-- (cheaper) space check, gets called more often than `is_pos_in_space`
vacuum.no_vacuum_abm = function(pos)
	return pos.y > vacuum.space_height - 40 and pos.y < vacuum.space_height + 40
end

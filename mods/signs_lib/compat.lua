
local default_fences = {
	"default:fence_wood",
	"default:fence_acacia_wood",
	"default:fence_aspen_wood",
	"default:fence_junglewood",
	"default:fence_pine_wood"
}

for _, n in ipairs(default_fences) do
	minetest.override_item(n, {
		check_for_pole = true
	})
end

if minetest.get_modpath("cottages") then
	local cbox = table.copy(minetest.registered_items["cottages:table"].node_box)
	minetest.override_item("cottages:table", {
		check_for_pole = true,
		selection_box = cbox
	})
end

if minetest.get_modpath("prefab_redo") then
	minetest.override_item("prefab_redo:concrete_railing", {
		check_for_pole = true,
		selection_box = {
			type = "connected",
			connect_right = { -0.125, -0.5, -0.125, 0.5,   0.375, 0.125 },
			connect_left  = { -0.5,   -0.5, -0.125, 0.125, 0.375, 0.125 },
			connect_back  = { -0.125, -0.5, -0.125, 0.125, 0.375, 0.5   },
			connect_front = { -0.125, -0.5, -0.5,   0.125, 0.375, 0.125 },
			disconnected  = { -0.125, -0.5, -0.125, 0.125, 0.25,  0.125 },
			fixed = {}
		}
	})
end

if minetest.get_modpath("streetspoles") then

	local htj_north = {
		[1] = true,
		[3] = true,
		[9] = true,
		[11] = true,
		[21] = true,
		[23] = true
	}

	local htj_east = {
		[0] = true,
		[2] = true,
		[16] = true,
		[18] = true,
		[20] = true,
		[22] = true
	}

	local htj_south = {
		[1] = true,
		[3] = true,
		[5] = true,
		[7] = true,
		[21] = true,
		[23] = true
	}

	local htj_west = {
		[0] = true,
		[2] = true,
		[12] = true,
		[14] = true,
		[20] = true,
		[22] = true
	}

	local vtj_north = {
		[8] = true,
		[10] = true,
		[13] = true,
		[15] = true,
		[17] = true,
		[19] = true
	}

	local vtj_east = {
		[4] = true,
		[6] = true,
		[8] = true,
		[10] = true,
		[17] = true,
		[19] = true
	}

	local vtj_south = {
		[4] = true,
		[6] = true,
		[13] = true,
		[15] = true,
		[17] = true,
		[10] = true
	}

	local vtj_west = {
		[4] = true,
		[6] = true,
		[8] = true,
		[10] = true,
		[13] = true,
		[15] = true
	}

	minetest.override_item("streets:bigpole", {
		check_for_pole = function(pos, node, def, ppos, pnode, pdef)
			if pnode.param2 < 4
			  or (pnode.param2 > 19 and pnode.param2 < 24)
			  and (pos.x ~= ppos.x or pos.z ~= ppos.z) then
				return true
			end
		end,

		check_for_horiz_pole = function(pos, node, def, ppos, pnode, pdef)
			if pnode.param2 > 3 and pnode.param2 < 12 then
				if def.paramtype2 == "wallmounted" then
					if node.param2 == 2 or node.param2 == 3 -- E/W
						then return true
					end
				else
					if node.param2 == 1 or node.param2 == 3 -- E/W
						then return true
					end
				end
			elseif pnode.param2 > 11 and pnode.param2 < 20 then
				if def.paramtype2 == "wallmounted" then
					if node.param2 == 4 or node.param2 == 5 then
						return true
					end
				else
					if node.param2 == 0 or node.param2 == 2 then
						return true
					end
				end
			end
		end
	})

	minetest.override_item("streets:bigpole_tjunction", {
		check_for_pole = function(pos, node, def, ppos, pnode, pdef)
			if def.paramtype2 == "wallmounted" then
				if   (node.param2 == 4 and vtj_north[pnode.param2])
				  or (node.param2 == 2 and vtj_east[pnode.param2])
				  or (node.param2 == 5 and vtj_south[pnode.param2])
				  or (node.param2 == 3 and vtj_west[pnode.param2]) then
					return true
				end
			else
				if   (node.param2 == 0 and vtj_north[pnode.param2])
				  or (node.param2 == 1 and vtj_east[pnode.param2])
				  or (node.param2 == 2 and vtj_south[pnode.param2])
				  or (node.param2 == 3 and vtj_west[pnode.param2]) then
					return true
				end
			end
		end,

		check_for_horiz_pole = function(pos, node, def, ppos, pnode, pdef)
			if def.paramtype2 == "wallmounted" then
				if   (node.param2 == 4 and htj_north[pnode.param2])
				  or (node.param2 == 2 and htj_east[pnode.param2])
				  or (node.param2 == 5 and htj_south[pnode.param2])
				  or (node.param2 == 3 and htj_west[pnode.param2]) then
					return true
				end
			else
				if   (node.param2 == 0 and htj_north[pnode.param2])
				  or (node.param2 == 1 and htj_east[pnode.param2])
				  or (node.param2 == 2 and htj_south[pnode.param2])
				  or (node.param2 == 3 and htj_west[pnode.param2]) then
					return true
				end
			end
		end
	})

end

if minetest.get_modpath("streetlamps") then
	minetest.override_item("streets:streetlamp_basic_top_on", {
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.3,-0.4,-0.3,0.3,0.5,0.3},
				{-0.15,-0.4,-0.15,0.15,-1.55,0.15},
				{-0.18,-1.55,-0.18,0.18,-2.5,0.18},
			}
		},
		check_for_pole = true
	})
end

-- Returns the greatest numeric key in a table.
function xdecor.maxn(T)
	local n = 0
	for k in pairs(T) do
		if k > n then n = k end
	end
	return n
end

-- Returns the length of an hash table.
function xdecor.tablelen(T)
	local n = 0
	for _ in pairs(T) do n = n + 1 end
	return n
end

-- Deep copy of a table. Borrowed from mesecons mod (https://github.com/Jeija/minetest-mod-mesecons).
function xdecor.tablecopy(T)
	if type(T) ~= "table" then return T end -- No need to copy.
	local new = {}

	for k, v in pairs(T) do
		if type(v) == "table" then
			new[k] = xdecor.tablecopy(v)
		else
			new[k] = v
		end
	end
	return new
end

function xdecor.stairs_valid_def(def)
	return (def.drawtype == "normal" or def.drawtype:sub(1,5) == "glass") and
	       (def.groups.cracky or def.groups.choppy) and
		not def.on_construct and
		not def.after_place_node and
		not def.on_rightclick and
		not def.on_blast and
		not def.allow_metadata_inventory_take and
		not (def.groups.not_in_creative_inventory == 1) and
		not (def.groups.not_cuttable == 1) and
		not def.groups.wool and
		(def.tiles and type(def.tiles[1]) == "string" and not
		def.tiles[1]:find("default_mineral")) and
		not def.mesecons and
		def.description and
		def.description ~= "" and
		def.light_source == 0
end

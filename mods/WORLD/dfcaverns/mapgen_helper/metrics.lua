if not minetest.settings:get_bool("mapgen_helper_record_time", false) then
	mapgen_helper.record_time = function()
		return
	end
	return
end

local worldpath = minetest.get_worldpath()

local persist = minetest.settings:get_bool("mapgen_helper_persist_recorded_time", false)
local filename = "mapgen_helper_metrics.lua"
local filename_old = "mapgen_helper_metrics_old.lua"

local resolution = minetest.settings:get("mapgen_helper_record_time_resolution") or 0.1

local data = {}
data.times = {}

if persist then
	local read_data = loadfile(worldpath.."/"..filename)
	if read_data then
		data = read_data()
	end	
end

if data.resolution ~= nil and data.resolution ~= resolution then
	minetest.log("error", "[mapgen_helper] resolution of recorded metrics doesn't match saved metrics. Moving the old saved metrics to " .. filename_old)
	local file, e = io.open(worldpath.."/"..filename_old, "w");
	if not file then
		return error(e);
	end
	file:write(minetest.serialize(data))
	file:close()
	data = {}
	data.times = {}
end

data.resolution = resolution
local times = data.times

mapgen_helper.record_time = function(label, time)
	local time_slot = math.ceil(time/resolution)
	local label_data = times[label] or {}
	local counts = label_data.counts or {}
	local existing_count = counts[time_slot] or 0
	local total_time = label_data.total_time or 0
	
	counts[time_slot] = existing_count + 1
	total_time = total_time + time
	label_data.total_time = total_time
	label_data.counts = counts
	times[label] = label_data
end

minetest.register_on_shutdown(function()
	if next(times) == nil then
		return
	end	
	minetest.log("warning", "[mapgen_helper] Average chunk generation times:")
	for name, label_data in pairs(times) do
		minetest.log("warning", string.rep("-", 40))
		
		local min_slot
		local max_slot
		local highest_slot_count = 0
		local total_count = 0
		local max_digits

		for slot, count in pairs(label_data.counts) do
			if (not min_slot) or (slot < min_slot) then
				min_slot = slot
			end
			if (not max_slot) or (slot > max_slot) then
				max_slot = slot
			end
			if (not max_digits) or (#tostring(slot*resolution) > max_digits) then
				max_digits = #tostring(slot*resolution)
			end
			total_count = total_count + count
			highest_slot_count = math.max(highest_slot_count, count)			
		end
		
		local average = label_data.total_time / total_count
				
		minetest.log("warning", "For " .. name .. ":")
		if min_slot == max_slot then
			minetest.log("warning", "All chunks took between " .. (min_slot-1)*resolution .. " and " .. min_slot*resolution .. " seconds.")
		else
			for i = min_slot, max_slot do
				local count = label_data.counts[i] or 0
				local spacing = max_digits - #tostring(i*resolution)
				local count_string = ""
				if count > 0 then
					count_string = " " .. count
				end
				minetest.log("warning", i*resolution .. "s" .. string.rep(" ", spacing) .. ": " ..
					string.rep("=", math.ceil((count / highest_slot_count) * 40)) .. count_string)
			end
		end
		
		minetest.log("warning", "Total number of chunks: " .. total_count .. ". Average time per chunk: " .. average .. " seconds.")
	end
	minetest.log("warning", string.rep("-", 40))
	
	if persist then
		local file, e = io.open(worldpath.."/"..filename, "w");
		if not file then
			return error(e);
		end
		file:write(minetest.serialize(data))
		file:close()
	end
end)

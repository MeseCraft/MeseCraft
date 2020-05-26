local metric_mapgen_events_count


if minetest.get_modpath("monitoring") then
	metric_mapgen_events_count = monitoring.gauge(
		"jumpdrive_mapgen_events_count",
		"number of events in the mapgen cache"
	)
end

local events = {} -- list of {minp, maxp, time}
jumpdrive.mapgen = {}

jumpdrive.mapgen.reset = function()
	events = {}
end

-- update last mapgen event time
minetest.register_on_generated(function(minp, maxp, seed)
	table.insert(events, {
		minp = minp,
		maxp = maxp,
		time = minetest.get_us_time()
	})
end)


-- cleanup
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	local time = minetest.get_us_time()
	local delay_seconds = 20

	local copied_events = events
	events = {}

	local count = 0
	for _, event in ipairs(copied_events) do
		if event.time > (time - (delay_seconds * 1000000)) then
			-- still recent
			table.insert(events, event)
			count = count + 1
		end
	end

	if metric_mapgen_events_count then
		metric_mapgen_events_count.set(count)
	end

end)


-- true = mapgen recently active in that area
jumpdrive.check_mapgen = function(pos)
	for _, event in ipairs(events) do
		if vector.distance(pos, event.minp) < 200 then
			return true
		end
	end

	return false
end

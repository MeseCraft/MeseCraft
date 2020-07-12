--[[ 
Part of the Ignore mod
Last Modification : 01/18/16 @ 9:09PM UTC+1
This file contains all methods/namespaces to manage the queue
--]]

ignore.queue = {}
ignore.queue.data = {}

function ignore.queue.add(action)
	if not action.type then
		minetest.log("error", "[Ignore] Tried to register action without a type")
		return false, "notype"
	end

	for _, a in pairs(ignore.queue.data) do
		if a == action then
			minetest.log("action", "[Ignore] Will not enqueue same action of type " .. action.type)
			return false, "dejavu"
		end
	end

	if not ignore.queue.data[action.type] then
		ignore.queue.data[action.type] = {}
	end
	table.insert(ignore.queue.data[action.type], action)

	minetest.log("action", "[Ignore] Enqueued action of type " .. action.type .. " (queue size : " .. #ignore.queue.data[action.type] .. ")")
	return true
end

function ignore.queue.workall()
	for ty, _ in pairs(ignore.queue.data) do
		ignore.queue.work(ty)
	end
end

function ignore.queue.work(queuetype)
	if not ignore.queue.data[queuetype] then
		minetest.log("error", "[Ignore] No such queue to work on : " .. queuetype)
		return false, "nosuchqueue"
	end

	if table.getn(ignore.queue.data[queuetype]) == 0 then
		return false, "emptyqueue"
	end

	local action = ignore.queue.data[queuetype][1] -- front
	table.remove(ignore.queue.data[queuetype], 1) -- pop

	--[[if not action.type then
		minetest.log("error", "[Ignore] Invalid action treated")
		return false, "notype"
	end]]

	if action.type == "save" then
		if not action.target then
			minetest.log("action", "[Ignore] Save action with no target")
			return false, "notarget"
		else
			local res, err = ignore.save(action.target)
			if not res then
				minetest.log("error", "[Ignore] In 'save' type queue action : " .. err or "unidentified error")
			end
		end
	end	

	minetest.log("action", "[Ignore] Successfully treated 1 item in queue of type " .. queuetype)
	return true
end

function ignore.queue.flush()
	for ty, _ in pairs(ignore.queue.data) do
		while #(ignore.queue.data[ty] or {}) > 0 do
			ignore.queue.work(ty)
		end
		minetest.log("action", "[Ignore] Queue of type " .. ty .. " emptied")
	end
	minetest.log("action", "[Ignore] Queues flushed")
	return true
end	

local function tick()
	ignore.queue.workall()
	minetest.after(ignore.config.queue_interval, tick)
end

minetest.after(0, tick)

minetest.register_on_shutdown(ignore.queue.flush)

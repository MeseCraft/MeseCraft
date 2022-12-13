

minetest.register_on_dignode(function(pos, oldnode, digger)
	if oldnode.name and string.sub(oldnode.name, 0, 7) == "digtron" then
		-- skip digtron moved nodes
		return;
	end

	local np = minetest.find_node_near(pos, 1,{"vacuum:vacuum"})
	if np ~= nil then
		minetest.set_node(pos, {name = "vacuum:vacuum"})
		return
	end
end)

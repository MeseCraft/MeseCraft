
skybox.register = function(def)
	print("[skybox] registering " .. def.name)
	table.insert(skybox.list, def)
end

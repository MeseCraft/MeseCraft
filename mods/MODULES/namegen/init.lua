local modpath = minetest.get_modpath(minetest.get_current_modname())

namegen = dofile(modpath.."/namegen.lua")

--namegen.parse_lines(io.lines(modpath.."/data/books.cfg"))
--namegen.parse_lines(io.lines(modpath.."/data/creatures.cfg"))
--namegen.parse_lines(io.lines(modpath.."/data/inns.cfg"))
--namegen.parse_lines(io.lines(modpath.."/data/potions.cfg"))
--namegen.parse_lines(io.lines(modpath.."/data/towns.cfg"))

local generate_examples = function()
	for _, set in ipairs(namegen.get_sets()) do
		minetest.debug("set: " .. set)
		local examples = "examples: "
		for i = 1, 30 do
			examples = examples .. namegen.generate(set)
			if i < 30 then
				examples = examples .. ", "
			end
		end
		minetest.debug(examples)
	end
end

--generate_examples()
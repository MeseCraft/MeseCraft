--[[
# Lightning Effect
Use this effect to cause lightning strikes.
Requires lightning mod in order to function. Uses default lightning configuration.
Expects an integer indicating a chance (between 0 and 1) for lightning to strike (per cycle and player).
]]

if not minetest.get_modpath("lightning") then return end
if regional_weather.settings.lightning == 0 then return end

local EFFECT_NAME = "regional_weather:lightning"

lightning.auto = false

local rng = PcgRandom(82492402425)

-- simplified position chooser by Auke Kok (sofar) taken from lightning mod itself
-- see https://github.com/minetest-mods/lightning/blob/master/init.lua#L53-L91
-- "lightning" is licensed under GNU Lesser Public License 2.1 or any later revision
local function choose_pos(pos)
	pos.x = math.floor(pos.x - (lightning.range_h / 2) + rng:next(1, lightning.range_h))
	pos.y = pos.y + (lightning.range_v / 2)
	pos.z = math.floor(pos.z - (lightning.range_h / 2) + rng:next(1, lightning.range_h))

	local b, pos2 = minetest.line_of_sight(pos, {x = pos.x, y = pos.y - lightning.range_v, z = pos.z}, 1)

	-- nothing but air found
	if b then
		return nil
	end

	local n = minetest.get_node({x = pos2.x, y = pos2.y - 1/2, z = pos2.z})
	if n.name == "air" or n.name == "ignore" then
		return nil
	end

	return pos2
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local chance = 0
		for weather, value in pairs(data) do
			if type(value) ~= "number" then
				value = 1/20
			end
			chance = chance + value - (chance * value)
		end
		local random = math.random()
		if random <= chance * regional_weather.settings.lightning then
			local player = minetest.get_player_by_name(playername)
			local ppos = player:get_pos()
			local position = choose_pos(ppos)
			if position ~= nil then
				lightning.strike(position)
			end
		end
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.set_effect_cycle(EFFECT_NAME, climate_api.LONG_CYCLE)
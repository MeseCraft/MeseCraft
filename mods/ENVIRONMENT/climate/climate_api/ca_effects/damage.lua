--[[
# Player Damage Effect
Use this effect to damage a player during dangerous weather events.
Expects a table as the parameter containing the following values:
- value <int> [1]: The amount of damage to be applied per successful roll.
- rarity <int> [1]: Defines a 1/x chance per cycle for the player to get damaged. Higher values result in less frequent damage.
- check <table> [nil]: Use an additional outdoors check before applying damage. Consists of the following values:
	- type <"light"|"raycast"> ["light"] (Whether the light level should be used a raycast should be performed)
	- height <number> [0] (Height offset of weather origin from the player. Only used for raycasts)
	- velocity <number> [1] (Velocity of damaging particles. Only used for raycasts)
	- use_wind <bool> [true] (Whether the wind should be factored in. Only used for raycasts)
]]

if not minetest.is_yes(minetest.settings:get_bool("enable_damage"))
or not climate_mod.settings.damage then return end

local EFFECT_NAME = "climate_api:damage"

local rng = PcgRandom(7819792)

local function check_hit(player, ray)
	local ppos = vector.add(player:get_pos(), {x=0, y=1, z=0})
	if ray.type ~= nil and ray.type ~= "light" and ray.type ~= "raycast" then
		minetest.log("warning", "[Climate API] Invalid damage check configuration")
		return false
	end

	-- use light level if specified or in performance mode
	if ray.type == nil
	or ray.type == "light"
	or not climate_mod.settings.raycast then
		return minetest.get_node_light(ppos, 0.5) == 15
	end

	-- use raycating to factor in wind speed
	local origin = vector.add(ppos, {x = 0, y = ray.height or 0, z = 0 })
	if ray.use_wind ~= false then
		local wind = climate_api.environment.get_wind(origin)
		local velocity = ray.velocity or 1
		local windpos = vector.multiply(
			vector.normalize(vector.add({ x = 0, y = -velocity, z = 0 }, wind)),
			-vector.length(wind)
		)
		origin = vector.add(origin, windpos)
	end
	local ray = minetest.raycast(origin, ppos)
	local obj = ray:next()
	-- found nothing
	if obj == nil then return false end
	-- found node
	if obj.type ~= "object" then return false end
	-- found different entity
	if not obj.ref:is_player() then return false end
	 -- found another player
	if obj.ref:get_player_name() ~= player:get_player_name() then return false end
	return true
end

local function calc_damage(player, dmg)
	if dmg.value == nil then dmg.value = 1 end
	if dmg.rarity == nil then dmg.rarity = 1 end
	-- check if damage should be applied
	if rng:next(1, dmg.rarity) ~= 1 then return 0 end
	if dmg.check ~= nil then
		-- check for obstacles in the way
		if not check_hit(player, dmg.check) then return 0 end
	end
	return dmg.value
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		local hp = player:get_hp()
		for weather, dmg in pairs(data) do
			hp = hp - calc_damage(player, dmg)
		end
		-- deal damage to player
		player:set_hp(hp, "weather damage")
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")

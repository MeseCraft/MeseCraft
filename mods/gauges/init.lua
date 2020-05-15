-- gauges: Adds health/breath bars above players
--
-- Copyright © 2014-2020 4aiman, Hugo Locurcio and contributors - MIT License
-- See `LICENSE.md` included in the source distribution for details.

if minetest.settings:get_bool("health_bars") == false or
		not minetest.settings:get_bool("enable_damage")
then return end

-- Localize the vector distance function for better performance, as it's called
-- on every step
local vector_distance = vector.distance

minetest.register_entity("gauges:hp_bar", {
	visual = "sprite",
	visual_size = {x=1, y=1/16, z=1},
	-- The texture is changed later in the code
	textures = {"blank.png"},
	collisionbox = {0},
	physical = false,

	on_step = function(self)
		local player = self.wielder
		local gauge = self.object

		if not player or
				not minetest.is_player(player) or
				vector_distance(player:get_pos(), gauge:get_pos()) > 3
		then
			gauge:remove()
			return
		end

		local hp = player:get_hp() <= 20 and player:get_hp() or 20
		local breath = player:get_breath() <= 10 and player:get_breath() or 11

		if self.hp ~= hp or self.breath ~= breath then
			gauge:set_properties({
				textures = {
					"health_"..tostring(hp)..".png^"..
					"breath_"..tostring(breath)..".png"
				}
			})
			self.hp = hp
			self.breath = breath
		end
	end
})

local function add_gauge(player)
	if player and minetest.is_player(player) then
		local entity = minetest.add_entity(player:get_pos(), "gauges:hp_bar")
		-- check for minetest_game 0.4.*
		local height = minetest.get_modpath("player_api") and 19 or 9

		entity:set_attach(player, "", {x=0, y=height, z=0}, {x=0, y=0, z=0})
		entity:get_luaentity().wielder = player
	end
end

minetest.register_on_joinplayer(function(player)
	minetest.after(1, add_gauge, player)
end)

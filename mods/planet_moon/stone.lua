
minetest.register_node("planet_moon:radioactive_stone", {
	description = "Stone (radioactive)",
	tiles = {"default_stone.png^[colorize:#000055:100"},
	groups = {cracky = 3, stone = 1, radioactive = 4},
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
})

-- Add radiant_damage mod support.
if minetest.get_modpath("radiant_damage") and radiant_damage.override_radiant_damage and radiant_damage.config.enable_mese_damage then
        radiant_damage.override_radiant_damage("mese", {
                emitted_by = {
                        ["planet_moon:radioactive_stone"] = radiant_damage.config.mese_damage*9,
                }
        })
end


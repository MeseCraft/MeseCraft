-- Rat by PilzAdam (B3D model by sirrobzeroone)
--TODO SOUND
mobs:register_mob("mobs_creatures:rat", {
	stepheight = 0.6,
	type = "animal",
	passive = true,
	hp_min = 1,
	hp_max = 4,
	armor = 200,
	collisionbox = {-0.2, -1, -0.2, 0.2, -0.8, 0.2},
	visual = "mesh",
        visual_size = {x=1,y=1},
	mesh = "mobs_creatures_rat.b3d",
	textures = {
		{"mobs_creatures_rat.png"},
		{"mobs_creatures_rat2.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_creatures_rat_random",
	},
	walk_velocity = 1,
	run_velocity = 2,
	runaway = true,
        runaway_from = {"player"},
	jump = true,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 2,
	on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 50, 90, 0, true, "mobs_creatures:rat")
	end,
})


local function rat_spawn(self, pos)
	self = self:get_luaentity()
	print (self.name, pos.x, pos.y, pos.z)
	self.hp_max = 100
	self.health = 100
end

mobs:spawn({
	name = "mobs_creatures:rat",
	nodes = {"default:stone"},
	min_light = 3,
	max_light = 16,
	interval = 60,
	chance = 4000,
	max_height = 0,
--	on_spawn = rat_spawn,
})


mobs:register_egg("mobs_creatures:rat", "Rat", "wool_grey.png", 1)

-- cooked rat, yummy!
minetest.register_craftitem("mobs_creatures:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_creatures_items_rat_cooked.png",
	on_use = minetest.item_eat(3),
	groups = {food_rat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs_creatures:rat_cooked",
	recipe = "mobs_creatures:rat",
	cooktime = 5,
})


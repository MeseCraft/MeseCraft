-- Node registration

-- Register default gramophone (music player)
gramophone.register_player("gramophone", {
	description = "Gramophone",
	tiles = {
		"gramophone_inside2.png", "speaker_side.png",
		"gramophone_side3.png", "gramophone_side4.png",
		"gramophone_front.png", "gramophone_front.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375, -0.4375}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.4375, -0.375, 0.5}, -- NodeBox2
			{0.4375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox3
			{-0.5, -0.5, 0.4375, 0.5, -0.375, 0.5}, -- NodeBox4
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, -- NodeBox5
			{-0.0625, -0.5, 0.3125, 0.0625, -0.375, 0.4375}, -- NodeBox6
			{-0.125, -0.375, 0.1875, 0.125, -0.25, 0.4375}, -- NodeBox7
		}
	},
	groups = {cracky = 2}
})

-- Speaker node
minetest.register_node("gramophone:speaker", {
	description = "Speaker",
	tiles = {
		"speaker_top.png", "speaker_side.png",
		"speaker_side.png", "speaker_side.png",
		"speaker_side.png", "speaker_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2}
})

-- Entity disc when placed on gramophone
minetest.register_entity("gramophone:vinyl_disc", {
	hp_max = 1,
	visual = "cube",
	--mesh = "vinyl_disc.obj",
	visual_size={x = 1, y = 0, z = 1},
	collisionbox = {0, 0, 0, 0, 0, 0},
	physical = false,
	textures = {"vinyl_disc.png", "air", "air", "air", "air", "air"},
	on_activate = function(self, staticdata)
		minetest.log("static data: "..dump(staticdata))
		if gramophone.temp.disc_texture ~= nil then
			-- Set texture from temp
			self.disc_texture = gramophone.temp.disc_texture
			gramophone.temp.disc_texture = nil
		elseif staticdata ~= nil and staticdata ~= "" then
			-- Set texture from static data
			local data = staticdata
			if data then
				self.disc_texture = data
			end
		end
		-- Set texture if available
		if self.disc_texture ~= nil then
			self.textures = {self.disc_texture, "air", "air", "air", "air", "air"}
			self.object:set_properties(self)
		end
	end,
	get_staticdata = function(self)
		if self.disc_texture ~= nil then
			return self.disc_texture
		end
		return ""
	end,
})

-- Entity for shelf
minetest.register_entity("gramophone:vinyl_disc_vertical", {
	hp_max = 1,
	visual = "wielditem",
	visual_size = {x = 0.45, y = 0.45, z = 0.0625},
	collisionbox = {0,0,0, 0,0,0},
	physical = false,
	textures = {"vinyl_disc.png"},
	wield_item = "gramophone:vinyl_disc1"
})

--Crafts
--gramophone:speaker
minetest.register_craft({
	output = "gramophone:speaker",
	recipe = {
		{"default:wood", "default:wood", "default:wood"},
		{"default:wood", "default:copperblock", "default:wood"},
		{"default:wood", "default:wood", "default:wood"}
	}
})
--gramophone:gramophone
minetest.register_craft({
        output = "gramophone:gramophone",
        recipe = {
                {"default:wood", "default:obsidian_shard", "default:wood"},
                {"default:stone", "default:wood", "default:stone"},
                {"default:wood", "default:wood", "default:wood"}
        }
})
--gramophone:vinyl_disc[1..9] have just mobs drop them.

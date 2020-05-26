skins.meta = {}

local skin_class = {}
skin_class.__index = skin_class
skins.skin_class = skin_class
-----------------------
-- Class methods
-----------------------
-- constructor
function skins.new(key, object)
	assert(key, 'Unique skins key required, like "character_1"')
	local self = object or {}
	setmetatable(self, skin_class)
	self.__index = skin_class

	self._key = key
	self._sort_id = 0
	skins.meta[key] = self
	return self
end

-- getter
function skins.get(key)
	return skins.meta[key]
end

-- Skin methods
-- In this implementation it is just access to attrubutes wrapped
-- but this way allow to redefine the functionality for more complex skins provider
function skin_class:get_key()
	return self._key
end

function skin_class:set_meta(key, value)
	self[key] = value
end

function skin_class:get_meta(key)
	return self[key]
end

function skin_class:get_meta_string(key)
	return tostring(self:get_meta(key) or "")
end

function skin_class:set_texture(value)
	self._texture = value
end

function skin_class:get_texture()
	return self._texture
end

function skin_class:set_preview(value)
	self._preview = value
end

function skin_class:get_preview()
	if self._preview then
		return self._preview
	end

	local player_skin = "("..self:get_texture()..")"
	local skin = ""

	-- Consistent on both sizes:
	--Chest
	skin = skin .. "([combine:16x32:-16,-12=" .. player_skin .. "^[mask:skindb_mask_chest.png)^"
	--Head
	skin = skin .. "([combine:16x32:-4,-8=" .. player_skin .. "^[mask:skindb_mask_head.png)^"
	--Hat
	skin = skin .. "([combine:16x32:-36,-8=" .. player_skin .. "^[mask:skindb_mask_head.png)^"
	--Right Arm
	skin = skin .. "([combine:16x32:-44,-12=" .. player_skin .. "^[mask:skindb_mask_rarm.png)^"
	--Right Leg
	skin = skin .. "([combine:16x32:0,0=" .. player_skin .. "^[mask:skindb_mask_rleg.png)^"

	-- 64x skins have non-mirrored arms and legs
	local left_arm
	local left_leg

	if self:get_meta("format") == "1.8" then
		left_arm = "([combine:16x32:-24,-44=" .. player_skin .. "^[mask:(skindb_mask_rarm.png^[transformFX))^"
		left_leg = "([combine:16x32:-12,-32=" .. player_skin .. "^[mask:(skindb_mask_rleg.png^[transformFX))^"
	else
		left_arm = "([combine:16x32:-44,-12=" .. player_skin .. "^[mask:skindb_mask_rarm.png^[transformFX)^"
		left_leg = "([combine:16x32:0,0=" .. player_skin .. "^[mask:skindb_mask_rleg.png^[transformFX)^"
	end

	-- Left Arm
	skin = skin .. left_arm
	--Left Leg
	skin = skin .. left_leg

	-- Add overlays for 64x skins. these wont appear if skin is 32x because it will be cropped out
	--Chest Overlay
	skin = skin .. "([combine:16x32:-16,-28=" .. player_skin .. "^[mask:skindb_mask_chest.png)^"
	--Right Arm Overlay
	skin = skin .. "([combine:16x32:-44,-28=" .. player_skin .. "^[mask:skindb_mask_rarm.png)^"
	--Right Leg Overlay
	skin = skin .. "([combine:16x32:0,-16=" .. player_skin .. "^[mask:skindb_mask_rleg.png)^"
	--Left Arm Overlay
	skin = skin .. "([combine:16x32:-40,-44=" .. player_skin .. "^[mask:(skindb_mask_rarm.png^[transformFX))^"
	--Left Leg Overlay
	skin = skin .. "([combine:16x32:4,-32=" .. player_skin .. "^[mask:(skindb_mask_rleg.png^[transformFX))"

	-- Full Preview
	skin = "(((" .. skin .. ")^[resize:64x128)^[mask:skindb_transform.png)"

	return skin
end

function skin_class:apply_skin_to_player(player)

	local function concat_texture(base, ext)
		if base == "blank.png" then
			return ext
		elseif ext == "blank.png" then
			return base
		else
			return	base .. "^" .. ext
		end
	end

	local playername = player:get_player_name()
	local ver = self:get_meta("format") or "1.0"

	player_api.set_model(player, "skinsdb_3d_armor_character_5.b3d")

	local v10_texture = "blank.png"
	local v18_texture = "blank.png"
	local armor_texture = "blank.png"
	local wielditem_texture = "blank.png"

	if ver == "1.8" then
		v18_texture = self:get_texture()
	else
		v10_texture = self:get_texture()
	end

	-- Support for clothing
	if skins.clothing_loaded and clothing.player_textures[playername] then
		local cape = clothing.player_textures[playername].cape
		local layers = {}
		for k, v in pairs(clothing.player_textures[playername]) do
			if k ~= "skin" and k ~= "cape" then
				table.insert(layers, v)
			end
		end
		local overlay = table.concat(layers, "^")
		v10_texture = concat_texture(v10_texture, cape)
		v18_texture = concat_texture(v18_texture, overlay)
	end

	-- Support for armor
	if skins.armor_loaded then
		local armor_textures = armor.textures[playername]
		if armor_textures then
			armor_texture = concat_texture(armor_texture, armor_textures.armor)
			wielditem_texture = concat_texture(wielditem_texture, armor_textures.wielditem)
		end
	end

	player_api.set_textures(player, {
			v10_texture,
			v18_texture,
			armor_texture,
			wielditem_texture,
		})

	player:set_properties({
		visual_size = {
			x = self:get_meta("visual_size_x") or 1,
			y = self:get_meta("visual_size_y") or 1
		}
	})
end

function skin_class:set_skin(player)
	-- The set_skin is used on skins selection
	-- This means the method could be redefined to start an furmslec
	-- See character_creator for example
end

function skin_class:is_applicable_for_player(playername)
	local assigned_player = self:get_meta("playername")
	return minetest.check_player_privs(playername, {server=true}) or assigned_player == nil or assigned_player == true or
			(assigned_player:lower() == playername:lower())
end

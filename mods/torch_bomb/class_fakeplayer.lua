-- The purpose of this class is to have something that can be passed into callbacks that
-- demand a "Player" object as a parameter and hopefully prevent the mods that have
-- registered with those callbacks from crashing on a nil dereference or bad function
-- call. This is not supposed to be a remotely functional thing, it's just supposed
-- to provide dummy methods and return values of the correct data type for anything that 
-- might ignore the false "is_player()" return and go ahead and try to use this thing
-- anyway.

-- I'm trying to patch holes in bad mod programming, essentially. If a mod is so badly
-- programmed that it crashes anyway there's not a lot else I can do on my end of things.

local FakePlayer = {}
FakePlayer.__index = FakePlayer

local function return_value(x)
	return (function() return x end)
end

local function return_nil()
	return nil
end

local function return_empty_string()
	return ""
end

local function return_zero()
	return 0
end

local function return_empty_table()
	return {}
end

function FakePlayer.update(self, pos, player_name)
	self.is_fake_player = player_name
	self.get_pos = return_value(pos)
end

function FakePlayer.create(pos, player_name)
	local self = {}
	setmetatable(self, FakePlayer)
	
	self.is_fake_player = player_name

	-- ObjectRef	
	self.get_pos = return_value(pos)
	self.set_pos = return_nil
	self.move_to = return_nil
	self.punch = return_nil
	self.right_click = return_nil
	self.get_hp = return_value(10)
	self.set_hp = return_nil
	self.get_inventory = return_nil -- returns an `InvRef`
	self.get_wield_list = return_empty_string
	self.get_wield_index = return_value(1)
	self.get_wielded_item = return_value(ItemStack(nil))
	self.set_wielded_item = return_value(false)
	self.set_armor_groups = return_nil
	self.get_armor_groups = return_empty_table
	self.set_animation = return_nil
	self.get_animation = return_nil -- a set of values, maybe important?
	self.set_attach = return_nil
	self.get_attach = return_nil
	self.set_detach = return_nil
	self.set_bone_position = return_nil
	self.get_bone_position = return_nil
	self.set_properties = return_nil
	self.get_properties = return_empty_table

	self.is_player = return_value(false)

	self.get_nametag_attributes = return_empty_table
	self.set_nametag_attributes = return_nil

	--LuaEntitySAO
	self.set_velocity = return_nil
	self.get_velocity = return_value({x=0,y=0,z=0})
	self.set_acceleration = return_nil
	self.get_acceleration = return_value({x=0,y=0,z=0})
	self.set_yaw = return_nil
	self.get_yaw = return_zero
	self.set_texture_mod = return_nil
	self.get_texture_mod = return_nil -- maybe important?
	self.set_sprite = return_nil
	--self.get_entity_name` (**Deprecated**: Will be removed in a future version)
	self.get_luaentity = return_nil

	-- Player object
	
	self.get_player_name = return_empty_string
	self.get_player_velocity = return_nil
	self.get_look_dir = return_value({x=0,y=1,z=0})
	self.get_look_horizontal = return_zero
	self.set_look_horizontal = return_nil
	self.get_look_vertical = return_zero
	self.set_look_vertical = return_nil

	--self.get_look_pitch`: pitch in radians - Deprecated as broken. Use `get_look_vertical`
	--self.get_look_yaw`: yaw in radians - Deprecated as broken. Use `get_look_horizontal`
	--self.set_look_pitch(radians)`: sets look pitch - Deprecated. Use `set_look_vertical`.
	--self.set_look_yaw(radians)`: sets look yaw - Deprecated. Use `set_look_horizontal`.
	self.get_breath = return_value(10)
	self.set_breath = return_nil
	self.get_attribute = return_nil
	self.set_attribute = return_nil

	self.set_inventory_formspec = return_nil
	self.get_inventory_formspec = return_empty_string
	self.get_player_control = return_value({jump=false, right=false, left=false, LMB=false, RMB=false, sneak=false, aux1=false, down=false, up=false} )
    self.get_player_control_bits = return_zero

	self.set_physics_override = return_nil
	self.get_physics_override = return_value({speed = 1, jump = 1, gravity = 1, sneak = true, sneak_glitch = false, new_move = true,})
	
	
	self.hud_add = return_nil
	self.hud_remove = return_nil
	self.hud_change = return_nil
	self.hud_get = return_nil -- possibly important return value?
	self.hud_set_flags = return_nil	
	self.hud_get_flags = return_value({ hotbar=true, healthbar=true, crosshair=true, wielditem=true, breathbar=true, minimap=true })
	self.hud_set_hotbar_itemcount = return_nil
	self.hud_get_hotbar_itemcount = return_zero
	self.hud_set_hotbar_image = return_nil
	self.hud_get_hotbar_image = return_empty_string
	self.hud_set_hotbar_selected_image = return_nil
	self.hud_get_hotbar_selected_image = return_empty_string
	self.set_sky = return_nil
	self.get_sky = return_empty_table -- may need members on this table
	
	self.set_clouds = return_nil
	self.get_clouds = return_value({density = 0, color = "#fff0f0e5", ambient = "#000000", height = 120, thickness = 16, speed = {x=0, y=-2}})
	
	self.override_day_night_ratio = return_nil
	self.get_day_night_ratio = return_nil
	
	self.set_local_animation = return_nil
	self.get_local_animation = return_empty_table
	
	self.set_eye_offset = return_nil
	self.get_eye_offset = return_value({x=0,y=0,z=0},{x=0,y=0,z=0})
	
	return self
end

return FakePlayer
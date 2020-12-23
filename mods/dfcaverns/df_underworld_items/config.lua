local CONFIG_FILE_PREFIX = "dfcaverns_"

df_underworld_items.config = {}

local print_settingtypes = false

local function setting(stype, name, default, description)
	local value
	if stype == "bool" then
		value = minetest.settings:get_bool(CONFIG_FILE_PREFIX..name, default)
	elseif stype == "string" then
		value = minetest.settings:get(CONFIG_FILE_PREFIX..name)
	elseif stype == "int" or stype == "float" then
		value = tonumber(minetest.setting:get(CONFIG_FILE_PREFIX..name))
	end
	if value == nil then
		value = default
	end
	df_underworld_items.config[name] = value
	
	if print_settingtypes then
		minetest.debug(CONFIG_FILE_PREFIX..name.." ("..description..") "..stype.." "..tostring(default))
	end	
end

setting("bool", "invulnerable_slade", true, "Slade is invulnerable to players")
setting("bool", "destructive_pit_plasma", true, "Pit plasma destroys adjacent nodes")
setting("bool", "underworld_hunter_statues", true, "Enable hunter statues in the underworld")
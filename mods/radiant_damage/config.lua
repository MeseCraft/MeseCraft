local CONFIG_FILE_PREFIX = "radiant_damage_"

radiant_damage.config = {}

local print_settingtypes = false

local function setting(stype, name, default, description)
	local value
	if stype == "bool" then
		value = minetest.settings:get_bool(CONFIG_FILE_PREFIX..name, default)
	elseif stype == "string" then
		value = minetest.settings:get(CONFIG_FILE_PREFIX..name)
	elseif stype == "int" or stype == "float" then
		value = tonumber(minetest.settings:get(CONFIG_FILE_PREFIX..name))
	end
	if value == nil then
		value = default
	end
	radiant_damage.config[name] = value
	
	if print_settingtypes then
		minetest.debug(CONFIG_FILE_PREFIX..name.." ("..description..") "..stype.." "..tostring(default))
	end	
end

setting("bool", "enable_heat_damage", false, "Enable radiant lava damage")
setting("int", "lava_damage", 8, "Damage dealt per second when standing directly adjacent to one lava node")
setting("int", "fire_damage", 2, "Damage dealt per second when standing directly adjacent to one fire node")

setting("bool", "enable_mese_damage", false, "Enable mese ore radiation damage")
setting("int", "mese_interval", 5, "Number of seconds between mese radiation damage checks")
setting("int", "mese_damage", 2, "Damage dealt per interval when standing directly adjacent to one mese ore node")

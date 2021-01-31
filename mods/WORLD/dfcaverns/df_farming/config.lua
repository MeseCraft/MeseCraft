local CONFIG_FILE_PREFIX = "dfcaverns_"

df_farming.config = {}

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
	df_farming.config[name] = value
	
	if print_settingtypes then
		minetest.debug(CONFIG_FILE_PREFIX..name.." ("..description..") "..stype.." "..tostring(default))
	end	
end

local plants = {
	{name="cave_wheat", delay_multiplier=1},
	{name="dimple_cup", delay_multiplier=3},
	{name="pig_tail", delay_multiplier=1},
	{name="plump_helmet", delay_multiplier=3},
	{name="quarry_bush", delay_multiplier=2},
	{name="sweet_pod", delay_multiplier=2},
}

--Plants

setting("int", "plant_growth_time", 3600, "Base plant growth time") -- 60 minutes

for _, plant in pairs(plants) do
	setting("float", plant.name.."_delay_multiplier", plant.delay_multiplier, plant.name.." growth delay multiplier")
end

setting("bool", "light_kills_fungus", true, "Light kills fungus")
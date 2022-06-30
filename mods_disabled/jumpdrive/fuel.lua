
local fuel_list = {}

jumpdrive.fuel = {}

jumpdrive.fuel.register = function(item_name, value)
  fuel_list[item_name] = value
end

jumpdrive.fuel.get_value = function(item_name)
  if not item_name then
    return 0
  end
  return fuel_list[item_name] or 0
end

if minetest.get_modpath("default") then
  jumpdrive.fuel.register("default:mese_crystal_fragment", 100)
  jumpdrive.fuel.register("default:mese_crystal", 900)
  jumpdrive.fuel.register("default:mese", 8100)
end

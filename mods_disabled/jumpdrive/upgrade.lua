
jumpdrive.upgrade = {}

local upgrades = {}

jumpdrive.upgrade.register = function(item_name, def)
  upgrades[item_name] = def
end

jumpdrive.upgrade.calculate = function(pos)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local size = inv:get_size("upgrade")

  -- reset values
  meta:set_int("power_requirement", jumpdrive.config.powerrequirement)
  meta:set_int("max_powerstorage", jumpdrive.config.powerstorage)

  for i=1,size do
    local stack = inv:get_stack("upgrade", i)
    if not stack:is_empty() then
      local upgrade_def = upgrades[stack:get_name()]
      if upgrade_def then
        upgrade_def(meta)
      end
    end
  end

end

if minetest.get_modpath("technic") then
  jumpdrive.upgrade.register("technic:red_energy_crystal", function(meta)
    meta:set_int("max_powerstorage", meta:get_int("max_powerstorage") + jumpdrive.config.powerstorage*0.1)
  end)

  jumpdrive.upgrade.register("technic:green_energy_crystal", function(meta)
    meta:set_int("max_powerstorage", meta:get_int("max_powerstorage") + jumpdrive.config.powerstorage*0.2)
  end)

  jumpdrive.upgrade.register("technic:blue_energy_crystal", function(meta)
    meta:set_int("max_powerstorage", meta:get_int("max_powerstorage") + jumpdrive.config.powerstorage*0.5)
  end)

  jumpdrive.upgrade.register("technic:control_logic_unit", function(meta)
    meta:set_int("power_requirement", meta:get_int("power_requirement") + jumpdrive.config.powerrequirement)
  end)
end

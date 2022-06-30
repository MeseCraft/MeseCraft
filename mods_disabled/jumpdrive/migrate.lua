

jumpdrive.migrate_engine_meta = function(pos, meta)

  -- previous version had no such variable in the metadata
  local max_store = meta:get_int("max_powerstorage")
  if max_store == 0 then
    meta:set_int("max_powerstorage", jumpdrive.config.powerstorage)
  end

  local power_requirement = meta:get_int("power_requirement")
  if power_requirement == 0 then
    meta:set_int("power_requirement", jumpdrive.config.powerrequirement)
  end

  -- start nodetimer if not started
  local timer = minetest.get_node_timer(pos)
  if not timer:is_started() then
    timer:start(2)
  end

  -- inventories
  local inv = meta:get_inventory()
  inv:set_size("main", 8)
  inv:set_size("upgrade", 4)

end


jumpdrive.textline_compat = function(target_pos1, target_pos2)
  local textline_def = minetest.registered_nodes["textline:lcd"]

  if not textline_def then
    return
  end

  local nodes = minetest.find_nodes_in_area(target_pos1, target_pos2, {"textline:lcd"})
  if nodes then
    for _, pos in ipairs(nodes) do
      -- https://github.com/gbl08ma/textline/blob/636c776446c3fc831376335b72bb48281fb6ab11/init.lua#L103
      -- invoke prepare_writing() function through place_node callback
      textline_def.after_place_node(pos)
    end
  end
end

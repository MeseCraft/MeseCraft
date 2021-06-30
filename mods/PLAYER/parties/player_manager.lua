minetest.register_on_leaveplayer(function(player)

  local p_name = player:get_player_name()

  if parties.is_player_in_party(p_name) then
    parties.leave(p_name)
  end

  if parties.is_player_invited(p_name) then
    parties.cancel_invites(p_name)
  end
end)

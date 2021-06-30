parties = {}

local function add_party_prefix() end
local function format_party_message() end

local S = minetest.get_translator("parties")
local current_parties = {}                  -- KEY party_leader; VALUE: {members (party_leader included)}
local players_in_parties = {}               -- KEY p_name; VALUE: party_leader
local players_invited = {}                  -- KEY p_name; VALUE: {inviter(s)}





function parties.invite(sender, p_name)

  -- se si è in un gruppo ma non si è il capo gruppo
  if players_in_parties[sender] and not current_parties[sender] then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] Only the party leader can perform this action!")))
    return end

  -- se si invita se stessi
  if sender == p_name then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] You can't invite yourself!")))
    return end

  -- se il giocatore non è online
  if not minetest.get_player_by_name(p_name) then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] This player is not online!")))
    return end

  -- se è già in un gruppo
  if players_in_parties[p_name] then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] This player is already in a party!")))
    return end

  -- se è già stato invitato dalla stessa persona
  if players_invited[p_name] then
    for _, inviter in pairs(players_invited[p_name]) do
      if inviter == sender then
        minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] You've already invited this player!")))
        return end
    end
  end

  -- se non può essere invitato (callback)
  for _, callback in ipairs(parties.registered_on_pre_party_invite) do
    if not callback(sender, p_name) then return end
  end

  minetest.sound_play("parties_invite", { to_player = p_name })
  minetest.chat_send_player(sender, add_party_prefix(S("Invite to @1 successfully sent", p_name)))
  minetest.chat_send_player(p_name, add_party_prefix(S("@1 has invited you to a party, would you like to join? (/party join, or /party join @2)", sender, sender)))

  if players_invited[p_name] then
    table.insert(players_invited[p_name], sender)
  else
    players_invited[p_name] = {sender}
  end

  -- eventuali callback
  for _, callback in ipairs(parties.registered_on_party_invite) do
    callback(sender, p_name)
  end

  -- se non ha accettato dopo 15 secondi, annullo l'invito
  minetest.after(15, function()

    if not players_invited[p_name] then return end

    for _, inviter in pairs(players_invited[p_name]) do
      if inviter == sender then

        if #players_invited[p_name] == 1 then
          players_invited[p_name] = nil
        end

        if minetest.get_player_by_name(sender) then
          minetest.chat_send_player(sender, add_party_prefix(minetest.colorize("#ededed", S("No answer from @1...", p_name))))
        end

      end
    end
  end)
end



function parties.join(p_name, inviter)

  -- se non ha nesssun invito
  if not players_invited[p_name] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You have no pending invites!")))
    return end

  -- se chi lo ha invitato è specificato ma non esiste come giocatore
  if inviter then
    local is_inviter_legit = false
    for _, p_leader in pairs(players_invited[p_name]) do
       if p_leader == inviter then
         is_inviter_legit = true
         break
       end
    end

    if not is_inviter_legit then
     minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You have no pending invites from this player!")))
     return end
  end

  local party_leader

  -- ottenimento capo gruppo
  if not inviter then
    party_leader = players_invited[p_name][table.maxn(players_invited[p_name])]
  else
    party_leader = inviter
  end

  -- se il capo gruppo si è disconnesso nei 15 secondi
  if not minetest.get_player_by_name(party_leader) then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] The party leader has disconnected!")))

    if #players_invited[p_name] == 1 then
      players_invited[p_name] = nil
    else
      table.remove(players_invited[p_name], party_leader)
    end

    return
  end

  -- se non può accettare (callback)
  for _, callback in ipairs(parties.registered_on_pre_party_join) do
    if not callback(party_leader, p_name) then return end
  end

  -- se non esisteva un gruppo, lo creo
  if players_in_parties[party_leader] == nil then
    current_parties[party_leader] = {party_leader}
    players_in_parties[party_leader] = party_leader
  end

  -- riproduzione suono
  for _, pl_name in pairs(current_parties[party_leader]) do
    minetest.sound_play("parties_join", { to_player = pl_name })
  end

  parties.chat_send_party(party_leader, S("@1 has joined the party", p_name), true)

  for _, old_inviter in pairs(players_invited[p_name]) do
    if old_inviter ~= party_leader and minetest.get_player_by_name(old_inviter) then
      minetest.chat_send_player(old_inviter, add_party_prefix(minetest.colorize("#ededed", S("@1 has joined another party", p_name))))
    end
  end

  players_invited[p_name] = nil
  players_in_parties[p_name] = party_leader

  table.insert(current_parties[party_leader], p_name)
  minetest.chat_send_player(p_name, add_party_prefix(S("You've joined @1's party", party_leader)))

  -- eventuali callback
  for _, callback in ipairs(parties.registered_on_party_join) do
    callback(party_leader, p_name)
  end

end



function parties.leave(p_name)

  -- se non si è in un gruppo
  if not players_in_parties[p_name] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You must enter a party first!")))
    return end

  local party_leader = players_in_parties[p_name]

  -- riproduzione suono
  for _, pl_name in pairs(current_parties[party_leader]) do
    minetest.sound_play("parties_leave", { to_player = pl_name })
  end

  -- rimuovo dal gruppo
  for k, pl_name in pairs(current_parties[party_leader]) do
    if pl_name == p_name then
      table.remove(current_parties[party_leader], k)
      break
    end
  end

  players_in_parties[p_name] = nil
  minetest.chat_send_player(p_name, add_party_prefix(S("You've left the party")), true)

  -- eventuali callback
  for _, callback in ipairs(parties.registered_on_party_leave) do
    callback(party_leader, p_name)
  end

  -- se ad abbandonare è stato il capo gruppo, lo cambio
  if p_name == party_leader then

    local new_leader = current_parties[party_leader][1]

    parties.chat_send_party(new_leader, S("@1 has left the party", p_name), true)
    parties.change_party_leader(p_name, new_leader)

    -- ...sciolgo se sono rimasti in 2
    if #current_parties[new_leader] == 1 then
      parties.disband(new_leader)
    end

  else
    parties.chat_send_party(party_leader, S("@1 has left the party", p_name), true)

    if #current_parties[party_leader] == 1 then
      parties.disband(party_leader)
    end
  end

end



function parties.disband(p_name)

  -- se non si è in un gruppo
  if not players_in_parties[p_name] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You must enter a party first!")))
    return end

  -- se si è in un gruppo ma non si è il capo gruppo
  if players_in_parties[p_name] and not current_parties[p_name] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] Only the party leader can perform this action!")))
    return end

  -- riproduzione suono
  for _, pl_name in pairs(current_parties[p_name]) do
    minetest.sound_play("parties_leave", { p_name = pl_name })
  end

  parties.chat_send_party(p_name, S("The party has been disbanded"), true)

  -- eventuali callback
  for _, callback in ipairs(parties.registered_on_party_disband) do
    callback(p_name)
  end

  for _, pl_name in pairs(current_parties[p_name]) do
    players_in_parties[pl_name] = nil
  end

  current_parties[p_name] = nil
end





----------------------------------------------
--------------------UTILS---------------------
----------------------------------------------

function parties.is_player_invited(p_name)
  if players_invited[p_name] then return true
  else return false end
end



function parties.is_player_in_party(p_name)
  if players_in_parties[p_name] then return true
  else return false end
end



function parties.is_player_party_leader(p_name)
  if current_parties[p_name] then return true
  else return false end
end



function parties.chat_send_party(p_name, msg, as_broadcast)

  if not players_in_parties[p_name] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You must enter a party first!")))
    return end

  local party_leader = players_in_parties[p_name]

  if as_broadcast then
    for _, pl_name in pairs(current_parties[party_leader]) do
      minetest.chat_send_player(pl_name, add_party_prefix(msg))
    end
  else
    for _, pl_name in pairs(current_parties[party_leader]) do
      minetest.chat_send_player(pl_name,  add_party_prefix(format_party_message(p_name, msg)))
    end
  end

end



function parties.change_party_leader(old_leader, new_leader)

  current_parties[new_leader] = {}

  for k, v in pairs(current_parties[old_leader]) do
    current_parties[new_leader][k] = v
    players_in_parties[v] = new_leader
  end

  current_parties[old_leader] = nil

  if #current_parties[new_leader] > 1 then
    parties.chat_send_party(new_leader, S("@1 is the new party leader", new_leader), true)
  end

end



function parties.cancel_invite(p_name, inviter)

  for _, p_leader in pairs(players_invited[p_name]) do
    if p_leader == inviter then
      table.remove(players_invited[p_name], inviter)
      return
    end
  end

  minetest.log("warning", "[PARTIES] There was an attempt to cancel an invite from " .. inviter .. " to " .. p_name .. " but there is none")
end



function parties.cancel_invites(p_name)
 players_invited[p_name] = nil
end




----------------------------------------------
-----------------GETTERS----------------------
----------------------------------------------

function parties.get_inviters(p_name)
  return players_invited[p_name]
end



function parties.get_party_leader(p_name)
  return players_in_parties[p_name]
end



function parties.get_party_members(party_leader)
  return current_parties[party_leader]
end





----------------------------------------------
---------------FUNZIONI LOCALI----------------
----------------------------------------------

function add_party_prefix(msg)
  return minetest.colorize("#ddffdd", "[" .. S("Party") .. "] " .. msg)
end



function format_party_message(p_name, msg)
  local msg_format = minetest.settings:get("chat_message_format")

  return minetest.colorize("#ddffdd", msg_format:gsub("@name", p_name):gsub("@message", msg))
end
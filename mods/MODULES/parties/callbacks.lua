-- I had no idea how to do it, so, uhm... this is how Minetest handles callbacks
local function make_registration()
  local t = {}
  local registerfunc = function(func)
    t[#t+1] = func
  end
  return t, registerfunc
end

parties.registered_on_pre_party_invite, parties.register_on_pre_party_invite = make_registration()
parties.registered_on_party_invite, parties.register_on_party_invite = make_registration()
parties.registered_on_pre_party_join, parties.register_on_pre_party_join = make_registration()
parties.registered_on_party_join, parties.register_on_party_join = make_registration()
parties.registered_on_party_leave, parties.register_on_party_leave = make_registration()
parties.registered_on_party_disband, parties.register_on_party_disband = make_registration()

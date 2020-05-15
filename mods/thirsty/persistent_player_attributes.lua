--[[

Persistent player attributes

]]

-- change this to inject into other module
local M = thirsty

M.persistent_player_attributes = {}
local PPA = M.persistent_player_attributes

--[[
Helper functions that take care of the conversions *and* the
clamping for us
]]

local function _count_for_val(value, def)
    local count = math.floor((value - def.min) / (def.max - def.min) * 65535)
    if count < 0 then count = 0 end
    if count > 65535 then count = 65535 end
    return count
end
local function _val_for_count(count, def)
    local value = count / 65535 * (def.max - def.min) + def.min
    if value < def.min then value = def.min end
    if value > def.max then value = def.max end
    return value
end
-- end helper functions

-- the stash of registered attributes

PPA.defs = {--[[
    name = {
        name = "mymod_attr1",
        min = 0,
        max = 10,
        default = 5,
    },
]]}

PPA.read_cache = {--[[
    player_name = {
        attr1 = value1,
        attr2 = value2,
    },
]]}

--[[
How to register a new attribute, with named parameters:
    PPA.register({ name = "mymod_attr1", min = 0, ... })
]]

PPA.register = function(def)
    PPA.defs[def.name] = {
        name = def.name,
        min = def.min or 0.0,
        max = def.max or 1.0,
        default = def.default or def.min or 0.0,
    }
end

-- The on_joinplayer handler

PPA.on_joinplayer = function(player)
    local inv = player:get_inventory()
    local player_name = player:get_player_name()
    PPA.read_cache[player_name] = {}
    for name, def in pairs(PPA.defs) do
        inv:set_size(name, 1)
        if inv:is_empty(name) then
            -- set default value
            inv:set_stack(name, 1, ItemStack({ name = ":", count = _count_for_val(def.default, def) }))
            -- cache default value
            PPA.read_cache[player_name][name] = def.default
        end
    end
end

minetest.register_on_joinplayer(PPA.on_joinplayer)


--[[ get an attribute, procedural style:
    local attr1 = PPA.get_value(player, "mymod_attr1")
]]

PPA.get_value = function(player, name)
    local player_name = player:get_player_name()
    if PPA.read_cache[player_name][name] == nil then
        local def = PPA.defs[name]
        local inv = player:get_inventory()
        local count = inv:get_stack(name, 1):get_count()
        PPA.read_cache[player_name][name] = _val_for_count(count, def)
    end
    return PPA.read_cache[player_name][name]
end

--[[ set an attribute, procedural style:
    PPA.set_value(player, "mymod_attr1", attr1)
]]

PPA.set_value = function(player, name, value)
    local def = PPA.defs[name]
    local inv = player:get_inventory()
    local player_name = player:get_player_name()
    if value > def.max then value = def.max end
    if value < def.min then value = def.min end
    PPA.read_cache[player_name][name] = value
    inv:set_stack(name, 1, ItemStack({ name = ":", count = _count_for_val(value, def) }))
end

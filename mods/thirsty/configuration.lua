--[[

Configuration from default, moddir and worlddir, in that order.

See init.lua for license.

]]

-- change these for other mods
local M = thirsty
local modname = 'thirsty'
local fileroot = modname

-- make sure config exists; keep constant reference to it
local C = M.config or {}
M.config = C

local function try_config_file(filename)
    --print("Config from "..filename)
    local file, err = io.open(filename, 'r')
    if file then
        file:close() -- was just for checking existance
        local confcode, err = loadfile(filename)
        if confcode then
            confcode()
            if C ~= M.config then
                -- M.config was overriden, merge
                for key, value in pairs(M.config) do
                    if type(value) == 'table' and type(C[key]) == 'table' and not value.CLEAR then
                        for k, v in pairs(value) do
                            C[key][k] = value[k]
                        end
                    else
                        -- copy (not a table, or asked to clear)
                        C[key] = value
                    end
                end
            else
                -- no override? Empty, or file knows what it is doing.
            end
        else
            minetest.log("error", "Could not load " .. filename .. ": " .. err)
        end
    end
end

-- read starting configuration from <modname>.default.conf
try_config_file(minetest.get_modpath(modname) .. "/" .. fileroot .. ".default.conf")

-- next, install-specific copy in modpath
try_config_file(minetest.get_modpath(modname) .. "/" .. fileroot .. ".conf")

-- last, world-specific copy in worldpath
try_config_file(minetest.get_worldpath() .. "/" .. fileroot .. ".conf")

-- remove any special keys from tables
for key, value in pairs(C) do
    if type(value) == 'table' then
        value.CLEAR = nil
    end
end

-- write back
M.config = C

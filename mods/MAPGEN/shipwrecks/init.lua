local path = minetest.get_modpath("shipwrecks")
local schems = {}
for _,v in pairs({"oak", "jungle", "pine"}) do
    for i = 1, 6 do
        table.insert(schems, path .. "/schematics/shipwreck_" .. v .. "_0" .. i .. ".mts")
    end
end

local chance = tonumber(minetest.settings:get("shipwrecks_chance")) or 15
local disp = tonumber(minetest.settings:get("shipwrecks_horizontal_displacement")) or 16
local v_disp = tonumber(minetest.settings:get("shipwrecks_vertical_displacement")) or 5
local global_seed = tonumber(minetest.settings:get("shipwrecks_seed")) or 0

local rotations = {"0", "90", "180", "270"}

minetest.register_on_generated(function(minp, maxp, seed)

    if minp.y < -64 or maxp.y > 64 then return end
    local rand = PcgRandom(seed + global_seed)
    if rand:next(0,100) > chance then return end

    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    local data = vm:get_data()
    local sidelength = maxp.x - minp.x + 1

    local c_sand  = minetest.get_content_id("default:sand")
    local c_water = minetest.get_content_id("default:water_source")

    local x_disp = rand:next(0, disp)
    local z_disp = rand:next(0, disp)
    local y_disp = rand:next(-v_disp, -1)

    for y = minp.y, maxp.y do
        local vi = area:index(minp.x + sidelength/2 + x_disp, y, minp.z + sidelength/2 + z_disp)
        if y < -2 and data[vi] == c_sand and data[vi + area.ystride] == c_water then
            local schem = schems[rand:next(1, #schems)]
            local rotation = rotations[rand:next(1, #rotations)]
            local s_pos = area:position(vi)
            minetest.place_schematic_on_vmanip(
                vm,
                {x = s_pos.x, y = s_pos.y + y_disp, z = s_pos.z},
                schem,
                rotation,
                nil,
                true,
                "place_center_x, place_center_z"
            )
        end
    end

    vm:write_to_map(true)

end)

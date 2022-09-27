
if minetest.get_modpath("travelnet") then
    old_allow_travel = travelnet.allow_travel
    if old_allow_travel then
        travelnet.allow_travel = function(player_name, ...)
            minetest.after(0.1, function()
                -- update player after using a travelnet
                local player = minetest.get_player_by_name(player_name)
                if player then
                    skybox.update_skybox(player)
                end
            end)

            return old_allow_travel(player_name, ...)
        end
    end
end
helicopter.gravity = tonumber(minetest.settings:get("movement_gravity")) or 9.8
helicopter.vector_up = vector.new(0, 1, 0)

function helicopter.get_hipotenuse_value(point1, point2)
    return math.sqrt((point1.x - point2.x) ^ 2 + (point1.y - point2.y) ^ 2 + (point1.z - point2.z) ^ 2)
end

--painting
function helicopter.paint(self, colstr)
    if colstr then
        self.color = colstr
        local l_textures = self.initial_properties.textures
        for _, texture in ipairs(l_textures) do
            local i,indx = texture:find('helicopter_painting.png')
            if indx then
                l_textures[_] = "helicopter_painting.png^[multiply:".. colstr
            end
            local i,indx = texture:find('helicopter_colective.png')
            if indx then
                l_textures[_] = "helicopter_colective.png^[multiply:".. colstr
            end
        end
	    self.object:set_properties({textures=l_textures})
    end
end

function helicopter.setText(self)
    local properties = self.object:get_properties()
    local formatted = string.format(
       "%.2f", self.hp_max
    )
    if properties then
        properties.infotext = "Nice helicopter of " .. self.owner .. ". Current hp: " .. formatted
        self.object:set_properties(properties)
    end
end

-- attach player
function helicopter.attach(self, player)
    local name = player:get_player_name()
    self.driver_name = name

    -- sound and animation
    self.sound_handle = minetest.sound_play({name = "helicopter_motor"},
            {object = self.object, gain = 2.0, max_hear_distance = 32, loop = true,})
    self.object:set_animation_frame_speed(60)

    -- attach the driver
    player:set_attach(self.pilot_seat_base, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    player:set_eye_offset({x = 0, y = -4, z = 1}, {x = 0, y = 8, z = -30})
    player_api.player_attached[name] = true
    -- make the driver sit
    minetest.after(0.2, function()
        local player = minetest.get_player_by_name(name)
        if player then
	        player_api.set_animation(player, "sit")
            update_heli_hud(player)
        end
    end)
    -- disable gravity
    self.object:set_acceleration(vector.new())
end

-- dettach player
function helicopter.dettach(self, player)
    local name = self.driver_name
    helicopter.setText(self)

    -- driver clicked the object => driver gets off the vehicle
    self.driver_name = nil

    -- sound and animation
    if self.sound_handle then
        minetest.sound_stop(self.sound_handle)
        self.sound_handle = nil
    end
    
    self.object:set_animation_frame_speed(0)

    -- detach the player
    player:set_detach()
    player_api.player_attached[name] = nil
    player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
    player_api.set_animation(player, "stand")
    self.object:set_acceleration(vector.multiply(helicopter.vector_up, -helicopter.gravity))

    --remove hud
    if player then remove_heli_hud(player) end
end

-- attach passenger
function helicopter.attach_pax(self, player)
    local name = player:get_player_name()
    self._passenger = name
    -- attach the passenger
    player:set_attach(self.passenger_seat_base, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    player:set_eye_offset({x = 0, y = -4, z = 1}, {x = 0, y = 8, z = -5})
    player_api.player_attached[name] = true
    -- make the driver sit
    minetest.after(0.2, function()
        local player = minetest.get_player_by_name(name)
        if player then
            player_api.set_animation(player, "sit")
        end
    end)
end

-- dettach passenger
function helicopter.dettach_pax(self, player)
    local name = self._passenger

    -- passenger clicked the object => driver gets off the vehicle
    self._passenger = nil

    -- detach the player
    player:set_detach()
    player_api.player_attached[name] = nil
    player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
    player_api.set_animation(player, "stand")
end

-- destroy the helicopter
function helicopter.destroy(self, puncher)
    if self.sound_handle then
        minetest.sound_stop(self.sound_handle)
        self.sound_handle = nil
    end

    if self.driver_name then
        -- detach the driver first (puncher must be driver)
        puncher:set_detach()
        puncher:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
        player_api.player_attached[name] = nil
        -- player should stand again
        player_api.set_animation(puncher, "stand")
        self.driver_name = nil
    end

    local pos = self.object:get_pos()
    if self.pointer then self.pointer:remove() end
    if self.pilot_seat_base then self.pilot_seat_base:remove() end
    if self.passenger_seat_base then self.passenger_seat_base:remove() end

    self.object:remove()

    pos.y=pos.y+2
    for i=1,2 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'basic_materials:gear_steel')
        end
    end
    
    for i=1,4 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'basic_materials:steel_bar')
        end
    end

    
    for i=1,12 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:steel_ingot')
        end
    end
    
    
    for i=1,6 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:copper_ingot')
        end
    end

    for i=1,4 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'basic_materials:plastic_sheet')
        end
    end

    for i=1,5 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:wood')
        end
    end

    for i=1,1 do
        if math.random(0,1) == 1 then 
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:glass')
        end
    end


end

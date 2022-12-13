--
-- entity
--

minetest.register_entity('helicopter:seat_base',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "seat_base.b3d",
    textures = {"helicopter_black.png",},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity("helicopter:heli", {
	initial_properties = {
		physical = true,
		collide_with_objects = true,
		collisionbox = {-1,0,-1, 1,0.3,1},
		selectionbox = {-1,0,-1, 1,0.3,1},
		visual = "mesh",
		mesh = "helicopter_heli.b3d",
        backface_culling = false,
        textures = {"helicopter_interior_black.png", "helicopter_metal.png", "helicopter_strips.png",
                "helicopter_painting.png", "helicopter_black.png", "helicopter_aluminum.png", "helicopter_glass.png",
                "helicopter_interior.png", "helicopter_panel.png", "helicopter_colective.png", "helicopter_painting.png",
                "helicopter_rotors.png", "helicopter_interior_black.png",},
	},

	driver_name = nil,
	sound_handle = nil,
	tilting = vector.new(),
    energy = 0.001,
    owner = "",
    static_save = true,
    infotext = "A nice helicopter",
    last_vel = vector.new(),
    hp_max = 50,
    color = "#0063b0",
    _passenger = nil,
    _by_mouse = false,

    get_staticdata = function(self) -- unloaded/unloads ... is now saved
        return minetest.serialize({
            stored_energy = self.energy,
            stored_owner = self.owner,
            stored_hp = self.hp_max,
            stored_color = self.color,
            stored_driver_name = self.driver_name,
        })
    end,

	on_activate = function(self, staticdata, dtime_s)
        if staticdata ~= "" and staticdata ~= nil then
            local data = minetest.deserialize(staticdata) or {}
            self.energy = data.stored_energy
            self.owner = data.stored_owner
            self.hp_max = data.stored_hp
            self.color = data.stored_color
            self.driver_name = data.stored_driver_name
            --minetest.debug("loaded: ", self.energy)
            local properties = self.object:get_properties()
            properties.infotext = data.stored_owner .. " nice helicopter"
            self.object:set_properties(properties)
        end

        helicopter.paint(self, self.color)
        local pos = self.object:get_pos()
	    local pointer=minetest.add_entity(pos,'helicopter:pointer')
        local energy_indicator_angle = ((self.energy * 18) - 90) * -1
	    pointer:set_attach(self.object,'',{x=0,y=11.26,z=9.37},{x=0,y=0,z=energy_indicator_angle})
	    self.pointer = pointer

        local pilot_seat_base=minetest.add_entity(pos,'helicopter:seat_base')
        pilot_seat_base:set_attach(self.object,'',{x=4.2,y=10,z=2},{x=0,y=0,z=0})
	    self.pilot_seat_base = pilot_seat_base

        local passenger_seat_base=minetest.add_entity(pos,'helicopter:seat_base')
        passenger_seat_base:set_attach(self.object,'',{x=-4.2,y=10,z=2},{x=0,y=0,z=0})
	    self.passenger_seat_base = passenger_seat_base

		-- set the animation once and later only change the speed
		self.object:set_animation({x = 0, y = 11}, 0, 0, true)

		self.object:set_armor_groups({immortal=1})

        local vector_up = vector.new(0, 1, 0)
		self.object:set_acceleration(vector.multiply(vector_up, -helicopter.gravity))
	end,

	on_step = function(self, dtime)
        helicopter.helicopter_last_time_command = helicopter.helicopter_last_time_command + dtime
        if helicopter.helicopter_last_time_command > 1 then helicopter.helicopter_last_time_command = 1 end
		local touching_ground, liquid_below

		local vel = self.object:get_velocity()

		touching_ground, liquid_below = helicopter.check_node_below(self.object)
		vel = helicopter.heli_control(self, dtime, touching_ground, liquid_below, vel) or vel

		if vel.x == 0 and vel.y == 0 and vel.z == 0 then
			return
		end

		if touching_ground == nil then
			touching_ground, liquid_below = helicopter.check_node_below(self.object)
		end

		-- quadratic and constant deceleration
		local speedsq = helicopter.vector_length_sq(vel)
		local fq, fc
		if touching_ground then
			fq, fc = helicopter.friction_land_quadratic, helicopter.friction_land_constant
		elseif liquid_below then
			fq, fc = helicopter.friction_water_quadratic, helicopter.friction_water_constant
		else
			fq, fc = helicopter.friction_air_quadratic, helicopter.friction_air_constant
		end
		vel = vector.apply(vel, function(a)
			local s = math.sign(a)
			a = math.abs(a)
			a = math.max(0, a - fq * dtime * speedsq - fc * dtime)
			return a * s
		end)

        --[[
            collision detection
            using velocity vector as virtually a point on space, we compare
            if last velocity has a great distance difference (virtually 5) from current velocity
            using some trigonometry (get_hipotenuse_value). If yes, we have an abrupt collision
        ]]--

        local is_attached = false
        if self.owner then
            local player = minetest.get_player_by_name(self.owner)
            
            if player then
                local player_attach = player:get_attach()
                if player_attach then
                    --XXXXXXXX
                    if player_attach == self.pilot_seat_base then is_attached = true end
                    --XXXXXXXX
                end
            end
        end

        if is_attached then
            local impact = helicopter.get_hipotenuse_value(vel, self.last_vel)
            if impact > 5 then
                --self.damage = self.damage + impact --sum the impact value directly to damage meter
                local curr_pos = self.object:get_pos()
                minetest.sound_play("collision", {
                    to_player = self.driver_name,
	                --pos = curr_pos,
	                --max_hear_distance = 5,
	                gain = 1.0,
                    fade = 0.0,
                    pitch = 1.0,
                })
                --[[if self.damage > 100 then --if acumulated damage is greater than 100, adieu
                    helicopter.destroy(self, player)   
                end]]--
            end

            --update hud
            local player = minetest.get_player_by_name(self.driver_name)
            if helicopter.helicopter_last_time_command > 0.3 then
                helicopter.helicopter_last_time_command = 0
                update_heli_hud(player)
            end
        else
            -- for some error the player can be detached from the helicopter, so lets set him attached again
            local can_stop = true
            if self.owner and self.driver_name and touching_ground == false then
                -- attach the driver again
                local player = minetest.get_player_by_name(self.owner)
                if player then
                    helicopter.attach(self, player)
                    can_stop = false
                end
            end

            if can_stop then
                --detach player
                if self.sound_handle ~= nil then
	                minetest.sound_stop(self.sound_handle)
	                self.sound_handle = nil

                    --why its here? cause if the sound is attached, player must so
                    local player_owner = minetest.get_player_by_name(self.owner)
                    if player_owner then remove_heli_hud(player_owner) end
                end
            end
        end
        self.last_vel = vel --saves velocity for collision comparation
        -- end collision detection

		self.object:set_velocity(vel)
	end,

	on_punch = function(self, puncher, ttime, toolcaps, dir, damage)
		if not puncher or not puncher:is_player() then
			return
		end
		local name = puncher:get_player_name()
        if self.owner and self.owner ~= name and self.owner ~= "" then return end
        if self.owner == nil then
            self.owner = name
        end
        	
        if self.driver_name and self.driver_name ~= name then
			-- do not allow other players to remove the object while there is a driver
			return
		end

        local touching_ground, liquid_below = helicopter.check_node_below(self.object)
        
        --XXXXXXXX
        local is_attached = false
        if puncher:get_attach() == self.pilot_seat_base then is_attached = true end
        --XXXXXXXX

        local itmstck=puncher:get_wielded_item()
        local item_name = ""
        if itmstck then item_name = itmstck:get_name() end

        if is_attached == false then
            if touching_ground then
                if helicopter.loadFuel(self, self.owner) then return end
            end
            -- deal with painting or destroying
		    if itmstck then
			    local _,indx = item_name:find('dye:')
			    if indx then

                    --lets paint!!!!
				    local color = item_name:sub(indx+1)
				    local colstr = helicopter.colors[color]
                    --minetest.chat_send_all(color ..' '.. dump(colstr))
				    if colstr then
                        helicopter.paint(self, colstr)
					    itmstck:set_count(itmstck:get_count()-1)
					    puncher:set_wielded_item(itmstck)
				    end
                    -- end painting

			    else -- deal damage
				    if not self.driver and toolcaps and toolcaps.damage_groups and toolcaps.damage_groups.fleshy then
					    --mobkit.hurt(self,toolcaps.damage_groups.fleshy - 1)
					    --mobkit.make_sound(self,'hit')
                        self.hp_max = self.hp_max - 10
                        minetest.sound_play("collision", {
	                        object = self.object,
	                        max_hear_distance = 5,
	                        gain = 1.0,
                            fade = 0.0,
                            pitch = 1.0,
                        })
				    end
			    end
            end

            if self.hp_max <= 0 then
                helicopter.destroy(self, puncher)
            end

        end
        
	end,

	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end

		local name = clicker:get_player_name()

        if self.owner == "" then
            self.owner = name
        end

        if self.owner == name then
		    if name == self.driver_name then
			    -- driver clicked the object => driver gets off the vehicle
                helicopter.dettach(self, clicker)
                if self._passenger then
                    local passenger = minetest.get_player_by_name(self._passenger)
                    if passenger then
                        helicopter.dettach_pax(self, passenger)
                    end
                end
		    elseif not self.driver_name then
                local is_under_water = helicopter.check_is_under_water(self.object)
                if is_under_water then return end
                -- temporary------
                self.hp_max = 50 -- why? cause I can desist from destroy
                ------------------

                helicopter.attach(self, clicker)
		    end
        else
            --passenger section
            --only can enter when the pilot is inside
            if self.driver_name then
                if self._passenger == nil then
                    helicopter.attach_pax(self, clicker)
                else
                    helicopter.dettach_pax(self, clicker)
                end
            else
                if self._passenger then
                    helicopter.dettach_pax(self, clicker)
                end
            end
        end
	end,
})

portalgun_power={}
portalgun_power_tmp_power=0

function portalgun_gravity(itemstack, user, pointed_thing)
	local ob=pointed_thing.ref
	local at = ob:get_attach()
	if at and at:get_luaentity() and at:get_luaentity().portalgun_power then
		ob:set_detach()
		local target = at:get_luaentity().target
		if target and target:get_luaentity() and (target:get_luaentity().itemstring or target:get_luaentity().wsc) then
			target:set_velocity({x=0, y=-1, z=0})
			target:set_acceleration({x=0, y=-8, z=0})
		end
		return  itemstack
	end
	if not ob:get_attach() and (ob:is_player() or (ob:get_luaentity() and ob:get_luaentity().powerball~=1)) then
		portalgun_power.user=user
		portalgun_power.target=ob
		if ob:is_player() then portalgun_power.player=1 end
		local m=minetest.add_entity(ob:get_pos(), "portalgun:power")
		ob:set_attach(m, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
		return  itemstack
	end







	return itemstack
end

minetest.register_entity("portalgun:power",{
	hp_max = 100,
	physical = false,
	weight = 0,
	collisionbox = {-0.2,-0.2,-0.2, 0.2,0.2,0.2},
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"portalgun_gravity.png"},
	spritediv = {x=1, y=1},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = false,
	timer=0,
	time=0.1,
	portalgun_power=1,
	portalgun=1,
	lifelime=100,
on_activate=function(self, staticdata)
		if portalgun_power.user then
			self.user=portalgun_power.user
			self.target=portalgun_power.target
			self.player=portalgun_power.player
			portalgun_power={}
		else
			self.object:remove()
		end
	end,
on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if self.target and self.target:get_attach() then
			self.target:set_detach()
			self.target:set_hp(0)
			self.target:punch(self.object, {full_punch_interval=1.0,damage_groups={fleshy=4}}, "default:bronze_pick", nil)
		end

end,
on_step= function(self, dtime)
		self.timer=self.timer+dtime
		if self.timer<self.time then return self end
		self.timer=0
		if self.target==nil or (not self.target:get_attach()) then
			self.object:set_hp(0)
			self.object:punch(self.object, {full_punch_interval=1.0,damage_groups={fleshy=4}}, "default:bronze_pick", nil)
			if self.sound then minetest.sound_stop(self.sound) end
		end
		if self.player then
			self.lifelime=self.lifelime-1
			if self.lifelime<0 then
				self.target:set_detach()
				return self
			end
		end
		local pos = self.user:get_pos()
		if pos==nil then return self end
		pos.y=pos.y+1.6
		local dir = self.user:get_look_dir()
		local npos={x=pos.x+(dir.x*2), y=pos.y+(dir.y*2), z=pos.z+(dir.z*2)}
		if minetest.registered_nodes[minetest.get_node(npos).name].walkable then
			return self
		end
		self.object:move_to(npos)
		return self
	end,
})

minetest.register_entity("portalgun:power2",{
	hp_max = 100,
	physical = true,
	weight = 10,
	collisionbox = {-0.35,0,-0.35, 0.35,1,0.35},
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"portalgun_gravity.png"},
	spritediv = {x=1, y=1},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = false,
	timer=0,
	time=0.025,
	portalgun_power=1,
	portalgun=1,
	lifelime=1000,
	v=0.3,
	ltime=0,
on_activate=function(self, staticdata)
		if portalgun_power.user then
			self.user=portalgun_power.user
			self.target=portalgun_power.target
			self.ltime=portalgun_power_tmp_power
			portalgun_power={}
		else
			self.object:remove()
		end
	end,
on_step= function(self, dtime)
		local pos=self.object:get_pos()
		local v=self.object:get_velocity()
		local v2={x=v.x-self.v,y=(v.y-self.v)*0.99,z=v.z-self.v}

		if v2.x<0.5 and v2.x>-0.5 then v2.x=0 end
		if v2.y<0.5 and v2.y>-0.5 then v2.y=0 end
		if v2.z<0.5 and v2.z>-0.5 then v2.z=0 end

		self.object:set_velocity(v2)
		self.ltime=self.ltime-self.v

		if self.ltime<self.v or (v2.x+v2.y+v2.z==0) then
			self.lifelime=-1
		end

		local nexpos={x=pos.x+(v.x*0.05),y=pos.y+(v.y*0.05)+1,z=pos.z+(v.z*0.05)}
		if minetest.registered_nodes[minetest.get_node(nexpos).name].walkable then
			self.lifelime=-1
		end

		self.lifelime=self.lifelime-1
		if self.lifelime<0 then
			self.target:set_detach()
		end

		if self.target==nil or (not self.target:get_attach()) then
			self.object:set_hp(0)
			self.object:punch(self.object, {full_punch_interval=1.0,damage_groups={fleshy=4}}, "default:bronze_pick", nil)
			return self
		end
		return self
	end,
})

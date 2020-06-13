disable_portal_stuff=false

portalgun={new=0,checkpoints={}}
dofile(minetest.get_modpath("portalgun") .. "/gravityuse.lua") -- the gravity part of portalgun
dofile(minetest.get_modpath("portalgun") .. "/craft.lua")
if disable_portal_stuff==false and minetest.get_modpath("mesecons")~=nil then
dofile(minetest.get_modpath("portalgun") .. "/other.lua")
end

portalgun_portal={}
portalgun_portal_tmp_user_abort=0
portalgun_portal_tmp_user=""
local portalgun_timer=1.2
local portalgun_time=0
portalgun_lifelime=1200		--deletes portals that not used after a while
portalgun_max_rage=100
portalgun_max_use_per_secund_time=4	--destroys the portal if excessive used 
portalgun_max_use_per_secund=25		--4 & 25 is default = teleported (teleported 25 times in 4 sec)

function portalgun_param2(pos,param2,r)
	local pos2={x=pos.x,y=pos.y,z=pos.z}
	if r then
		if param2==0 then
		pos2.x=pos2.x-1
		elseif param2==1 then pos2.z=pos2.z+1
		elseif param2==2 then pos2.x=pos2.x+1
		elseif param2==3 then pos2.z=pos2.z-1
		end
	else
		if param2==0 then
		pos2.x=pos2.x+1
		elseif param2==1 then pos2.z=pos2.z-1
		elseif param2==2 then pos2.x=pos2.x-1
		elseif param2==3 then pos2.z=pos2.z+1
		end
	end
	return pos2
end


local function portalgun_getLength(a)-- get length of an array / table
	local count = 0
	for _ in pairs(a) do count = count + 1 end
	return count
end

function portal_delete(name,n)	-- using set_hp & :punch instand of :remove ... no risk for crash if something attach it
	if portalgun_portal[name]==nil then return end
	if (n==1 or n==0) and portalgun_portal[name].portal1~=nil then
		if n==0 then 
			local pos=portalgun_portal[name].portal1:get_pos()
			if pos~=nil then minetest.sound_play("portalgun_closeportals", {pos=pos,max_hear_distance = 20, gain = 1}) end
		end
		portalgun_portal[name].portal1_active=false
		portalgun_portal[name].portal1:set_hp(0)
		portalgun_portal[name].portal1:punch(portalgun_portal[name].portal1, {full_punch_interval=1.0,damage_groups={fleshy=9000}}, "default:bronze_pick", nil)
	end
	if (n==2 or n==0) and portalgun_portal[name].portal2~=nil then
		if n==0 then 
			local pos=portalgun_portal[name].portal2:get_pos()
			if pos~=nil then minetest.sound_play("portalgun_closeportals", {pos=pos,max_hear_distance = 20, gain = 1}) end
		end
		portalgun_portal[name].portal2_active=false
		portalgun_portal[name].portal2:set_hp(0)
		portalgun_portal[name].portal2:punch(portalgun_portal[name].portal2, {full_punch_interval=1.0,damage_groups={fleshy=9000}}, "default:bronze_pick", nil)
	end
	if n==0 then portalgun_portal[name]=nil end
end

minetest.register_on_leaveplayer(function(player)-- 	deletes user the profile (saveing memory)
	local name=player:get_player_name()
	portal_delete(name,0)
	portalgun_portal[name]=nil
end)
minetest.register_on_dieplayer(function(player)
	local name=player:get_player_name()
	portal_delete(name,0)
	portalgun_portal[name]=nil
end)


portalgun_on_step=function(self, dtime)
	local name=self.user

	if portalgun_portal[self.user]==nil then
		self.object:remove()
		return self
	end

	if (self.project==1 and self.use~=portalgun_portal[self.user].portal1_use)
	or (self.project==2 and self.use~=portalgun_portal[self.user].portal2_use) then
		self.object:remove()
		return self
	end

	if portalgun_portal[name].lifelime<0 then
		portal_delete(name,0)
		return self
	end

	if portalgun_portal[name].portal1_active and portalgun_portal[name].portal2_active then -- makes lifetime equal when both is acive, or it will be half
		portalgun_portal[name].lifelime=portalgun_portal[name].lifelime-0.5
	else
		portalgun_portal[name].lifelime=portalgun_portal[name].lifelime-1
		return self						-- abort when only 1 is active (saves cpu)
	end

	if portalgun_portal[name].timer>0 then				-- makes teleported stuff wont move back at same time (bug fix)
		portalgun_portal[name].timer=portalgun_portal[name].timer-dtime
		return self
	end


	if self.portal_max_use>0 then				-- makes teleported stuff wont move back at same time (bug fix)
		self.portal_max_use_time=self.portal_max_use_time+dtime
		if self.portal_max_use>=portalgun_max_use_per_secund then
			portal_delete(name,self.project)
			return self
		elseif self.portal_max_use_time>=portalgun_max_use_per_secund_time then
			self.portal_max_use_time=0
			self.portal_max_use=0
		end
	end

	local pos1=0
	local pos2=0
	local d1=0
	local d2=0
	if self.project==1 then
		pos1=portalgun_portal[name].portal1_pos
		pos2=portalgun_portal[name].portal2_pos
		d1=portalgun_portal[name].portal1_dir
		d2=portalgun_portal[name].portal2_dir
	else
		pos1=portalgun_portal[name].portal2_pos
		pos2=portalgun_portal[name].portal1_pos
		d1=portalgun_portal[name].portal2_dir
		d2=portalgun_portal[name].portal1_dir
	end

-- portalgun_front_of_field should fix teleport through walls, but is not working in all directions
-- waiting with this issue



	if pos2~=0 and pos1~=0 then
		for ii, ob in pairs(minetest.get_objects_inside_radius(pos1, self.area)) do
			if pos2~=0 then 		--and portalgun_front_of_field(self.object,ob) 
				if (ob:is_player() ) or (ob:get_luaentity() and ob:get_luaentity().portalgun~=1 and ob:get_luaentity().name:find(":text",4)==nil) then

				
				if ob:get_attach() then
					ob:set_detach()
					ob:set_acceleration({x=0, y=-10, z=0})
				end
						--set velocity then teleport
				local p=pos2
				local x=0
				local y=0
				local z=0
				local dis=2
				if p==nil or p.x==nil then
					return self
				end


				if ob:is_player() then
					local v=ob:get_player_velocity()
					local player_name=ob:get_player_name()
					portalgun_power.user=player_name
					portalgun_power.target=ob
					local vv={x=v.x,y=v.y,z=v.z}
									-- get the highest velocity
					dis=2
					if vv.x+vv.y+vv.z<=0.3 then
						if self.small==true then
						vv.x=1.4
					else
						vv.x=2
						end
					end
					if vv.x+vv.y+vv.z==0 then vv.x=2 end
					if vv.x<0 then vv.x=vv.x*-1 end
					if vv.y<0 then vv.y=vv.y*-1 end
					if vv.z<0 then vv.z=vv.z*-1 end
					if vv.x>vv.z then vv.a=vv.x else vv.a=vv.z end
					if vv.a<vv.y then vv.a=vv.y end
					portalgun_power_tmp_power=vv.a
					local m=minetest.add_entity(ob:get_pos(), "portalgun:power2")
					ob:set_attach(m, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
					m:set_velocity(v)
					m:set_acceleration({x=0,y=-10,z=0})
					ob=m
					
				end

				if ob:is_player()==false then
					local v=ob:get_velocity() 
					if v.x<0 then v.x=v.x*-1 end
					if v.y<0 then v.y=v.y*-1 end
					if v.z<0 then v.z=v.z*-1 end

					local vv=0		-- get the highest velocity
					if v.x>v.z then vv=v.x else vv=v.z end
					if vv<v.y then vv=v.y end
					v.x=0
					v.y=0
					v.z=0
					if d2=="x+" then v.x=vv end
					if d2=="x-" then v.x=vv*-1 end
					if d2=="y+" then v.y=vv end
					if d2=="y-" then v.y=vv*-1 end
					if d2=="z+" then v.z=vv end
					if d2=="z-" then v.z=vv*-1 end
					ob:set_velocity({x=v.x, y=v.y, z=v.z})
				end
					if d2=="x+" then x=2
					elseif d2=="x-" then x=-dis
					elseif d2=="y+" then y=dis
					elseif d2=="y-" then y=-dis
					elseif d2=="z+" then z=dis
					elseif d2=="z-" then z=-dis
					end
				local obpos={x=p.x+x,y=p.y+y,z=p.z+z}
				portalgun_portal[name].timer=0.2
				self.portal_max_use=self.portal_max_use+1
				ob:set_pos(obpos,false)
				portalgun_portal[name].lifelime=portalgun_lifelime
				minetest.sound_play("portalgun_teleport", {pos=portalgun_portal[name].portal1_pos,max_hear_distance = 10, gain = 30})
				minetest.sound_play("portalgun_teleport", {pos=portalgun_portal[name].portal2_pos,max_hear_distance = 10, gain = 30})
				end		--end of set velocity part then teleport
			end
		end
	end
end

minetest.register_entity("portalgun:portal",{		-- the portals
	hp_max=10000,
	visual = "mesh",
	mesh = "portalgun_portal_xp.obj",
	physical = false,
	textures ={"portalgun_blue.png"},
	visual_size = {x=1, y=1},
	spritediv = {x=7, y=0},
	collisionbox = {0,0,0,0,0,0},
	timer=0,
	user="",
	project=1,
	portalgun=1,
	portal_max_use=0,
	portal_max_use_time=0,
	area=2,
	small=false,
get_staticdata = function(self)
                return minetest.serialize({
		user= self.user,
		project=self.project,
		use=self.use
                })
        end,
on_activate= function(self, staticdata)
	local data=minetest.deserialize(staticdata)
	if data and type(data) == "table" then
		self.user = data.user
		self.project = data.project
		self.use=data.use
		if portalgun_portal[self.user]==nil then
			self.object:remove()
			return self
		end
		if (self.project==1 and self.use~=portalgun_portal[self.user].portal1_use)
		or (self.project==2 and self.use~=portalgun_portal[self.user].portal2_use) then 
			self.object:remove()
			return self
		end
	elseif portalgun_portal_tmp_user~="" then
		self.user=portalgun_portal_tmp_user
		portalgun_portal_tmp_user=""
		self.project=portalgun_portal[self.user].project

		if self.project==1 then-- if inactivated then activated and another portal is created: remove
			self.use=portalgun_portal[self.user].portal1_use
		else
			self.use=portalgun_portal[self.user].portal2_use
		end

	else
		self.object:remove()
		return self
	end

	if portalgun_portal[self.user]==nil then
		self.object:remove()
		return self
	end

	local d=""
	if self.project==1 then
		d=portalgun_portal[self.user].portal1_dir
		self.object:set_properties({textures = {"portalgun_blue.png"}})
	else
		d=portalgun_portal[self.user].portal2_dir
		self.object:set_properties({textures = {"portalgun_orange.png"}})
	end
	if d=="x+" then self.object:set_yaw(math.pi * 0)
	elseif d=="x-" then self.object:set_yaw(math.pi * 1)
	elseif d=="y+" then self.object:set_properties({mesh = "portalgun_portal_yp.obj",}) -- becaouse there is no "setpitch"
	elseif d=="y-" then self.object:set_properties({mesh = "portalgun_portal_ym.obj",}) -- becaouse there is no "setpitch"
	elseif d=="z+" then self.object:set_yaw(math.pi * 0.5) 
	elseif d=="z-" then self.object:set_yaw(math.pi * 1.5)
	end
	if d=="y+" then
		local pos1={}
		if self.project==1 then
			pos1=portalgun_portal[self.user].portal1_pos
		else
			pos1=portalgun_portal[self.user].portal2_pos
		end
		if portalgun_portal[self.user].y>8 then
			pos1.y=pos1.y+1
		end
		if portalgun_portal[self.user].y>12 then
			pos1.y=pos1.y+1
		end
		if self.project==1 then
			portalgun_portal[self.user].portal1_pos=pos1
		else
			portalgun_portal[self.user].portal2_pos=pos1
		end
	elseif string.find(d,"y",1)==nil and (portalgun_portal[self.user].x+portalgun_portal[self.user].z<2.5) then
		self.area=1.2
		self.small=true
		self.object:set_properties({visual_size = {x=0.7, y=0.7},})
	end
	end,
on_step=portalgun_on_step,
})


minetest.register_node("portalgun:gun1", {
	description = "Portalgun (blue)",
	range = 5,
	tiles={"portalgun_gun1.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun_wearing.obj",
	groups = {not_in_creative_inventory=1},
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
on_place=function(itemstack, user, pointed_thing)
	portalgun_mode(itemstack, user, pointed_thing)
	return itemstack
end,
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})
minetest.register_node("portalgun:gun2", {
	description = "Portalgun (orange)",
	range = 5,
	tiles={"portalgun_gun2.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun_wearing.obj",
	groups = {not_in_creative_inventory=1},
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
on_place=function(itemstack, user, pointed_thing)
	portalgun_mode(itemstack, user, pointed_thing)
	return itemstack
end,
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})

minetest.register_node("portalgun:gun", {
	description = "Portalgun",
	range = 5,
	tiles={"portalgun_gun0.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun_wearing.obj",
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
on_place=function(itemstack, user, pointed_thing)
	portalgun_mode(itemstack, user, pointed_thing)
	return itemstack
end,
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})

minetest.register_node("portalgun:gun1_placed", {
	description = "Portalgun (blue)",
	range = 5,
	tiles={"portalgun_gun1.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun.obj",
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
	visual_scale=0.4,
	groups = {not_in_creative_inventory=1,dig_immediate = 3},
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})
minetest.register_node("portalgun:gun2_placed", {
	description = "Portalgun (orange)",
	range = 5,
	tiles={"portalgun_gun2.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun.obj",
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
	visual_scale=0.4,
	groups = {not_in_creative_inventory=1,dig_immediate = 3},
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})

minetest.register_node("portalgun:gun_placed", {
	description = "Portalgun",
	range = 5,
	tiles={"portalgun_gun0.png"},
		selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, -0.1,0.3},
		}
	},
	drawtype="mesh",
	mesh="portalgun_gun.obj",
	sunlight_propagates = true,
	paramtype="light",
	paramtype2="facedir",
	visual_scale=0.4,
	groups = {not_in_creative_inventory=1,dig_immediate = 3},
on_use = function(itemstack, user, pointed_thing)
	portalgun_onuse(itemstack, user, pointed_thing)
	return itemstack
end
})






function portalgun_mode(itemstack, user, pointed_thing)	-- change modes
	local item=itemstack:to_table()
	local meta=minetest.deserialize(item["metadata"])
	local mode=0
	if meta==nil then
		meta={}
		mode=1
		minetest.chat_send_player(user:get_player_name(), "<Portalgun> PLACE to change portal mode (or LEFT+RIGHTCLICK to use the other)")
		minetest.chat_send_player(user:get_player_name(), "<Portalgun> LEFTCLICK on an object to carry it, CLICK AGAIN to release")
		minetest.chat_send_player(user:get_player_name(), "<Portalgun> SHIFT+LEFTCLICK to close both portals (or wait 40sec until it removes it self)")
	end
	if meta.mode==nil then meta.mode=2 end
	mode=(meta.mode)
	if mode==1 then
		mode=2
	else
		mode=1
	end
	meta.mode=mode
	item.name="portalgun:gun"..mode
	item.metadata=minetest.serialize(meta)
	itemstack:replace(item)
	minetest.sound_play("portalgun_mode", {pos=user:get_pos(),max_hear_distance = 5, gain = 1})
end


local function rnd(r)
return math.floor(r+ 0.5)
end

function portalgun_onuse(itemstack, user, pointed_thing) -- using the gun

		if pointed_thing.type=="object" then
			portalgun_gravity(itemstack, user, pointed_thing)
			return itemstack
		end

		local pos = user:get_pos()
		local dir = user:get_look_dir()
		local key = user:get_player_control()
		local name=user:get_player_name()
		local exist=0

		local item=itemstack:to_table()
		local mode=minetest.deserialize(item["metadata"])
		if mode==nil then
			portalgun_mode(itemstack, user, pointed_thing) 
			return itemstack
		else
			mode=mode.mode
		end

		local ob={}
		ob.project=1
		ob.lifelime=portalgun_lifelime
		ob.portal1=0
		ob.portal2=0
		ob.portal1_dir=0
		ob.portal2_dir=0
		ob.portal2_pos=0
		ob.portal1_pos=0
		ob.user = user:get_player_name()

		if portalgun_portal[name]==nil then	--	new portal profile
			portalgun_portal[name]={lifelime=portalgun_lifelime,project=1,timer=0,portal1_active=false,portal2_active=false,portal1_use=0,portal2_use=0}
		end

		if key.RMB and mode==2 then -- hold rmbutton to use the other one (like diplazer)
			mode=1
		elseif key.RMB and mode==1 then
			mode=2
		end

		if key.sneak then
			portal_delete(name,0)
			return itemstack
		end

		pos.y=pos.y+1.5

-- the project

	for i=1, portalgun_max_rage,0.5 do
		local nname=minetest.get_node({x=pos.x+(dir.x*i), y=pos.y+(dir.y*i), z=pos.z+(dir.z*i)}).name
		if minetest.registered_nodes[nname].walkable then
			portalgun_portal[name].lifelime=portalgun_lifelime


			
			if minetest.get_node_group(nname, "antiportal")>0 then
				minetest.sound_play("portalgun_error", {pos=pos,max_hear_distance = 5, gain = 3})
				return itemstack
			end

			if minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i)), y=rnd(pos.y+(dir.y*i)+1), z=rnd(pos.z+(dir.z*i))}).name].walkable==false and rnd(user:get_pos().y)>rnd(pos.y+(dir.y*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"y+")
				return itemstack
			elseif minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i)), y=rnd(pos.y+(dir.y*i)-1), z=rnd(pos.z+(dir.z*i))}).name].walkable==false and rnd(user:get_pos().y)<rnd(pos.y+(dir.y*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"y-")
				return itemstack
			elseif minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i)-1), y=rnd(pos.y+(dir.y*i)), z=rnd(pos.z+(dir.z*i))}).name].walkable==false  and rnd(user:get_pos().x)<rnd(pos.x+(dir.x*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"x-")
				return itemstack
			elseif minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i))+1, y=rnd(pos.y+(dir.y*i)), z=rnd(pos.z+(dir.z*i))}).name].walkable==false and rnd(user:get_pos().x)>rnd(pos.x+(dir.x*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"x+")
				return itemstack
			elseif minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i)), y=rnd(pos.y+(dir.y*i)), z=rnd(pos.z+(dir.z*i)-1)}).name].walkable==false and rnd(user:get_pos().z)<rnd(pos.z+(dir.z*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"z-")
				return itemstack
			elseif minetest.registered_nodes[minetest.get_node({x=rnd(pos.x+(dir.x*i)), y=rnd(pos.y+(dir.y*i)), z=rnd(pos.z+(dir.z*i)+1)}).name].walkable==false and rnd(user:get_pos().z)>rnd(pos.z+(dir.z*i)) then
				portalgun_setportal(pos,name,dir,i,mode,"z+")
				return itemstack
			end
			minetest.sound_play("portalgun_error", {pos=pos,max_hear_distance = 20, gain = 3})
			return itemstack
		end
	end
	return itemstack
end



function portalgun_setportal(pos,name,dir,i,mode,portal_dir)
	local lpos={x=pos.x+(dir.x*(i-1)), y=pos.y+(dir.y*(i-1)), z=pos.z+(dir.z*(i-1))}	-- last pos
	local cpos={x=pos.x+(dir.x*i), y=pos.y+(dir.y*i), z=pos.z+(dir.z*i)}		-- corrent poss
	if portal_dir=="y+" then
		cpos.y=(math.floor(cpos.y+ 0.5))+0.524
	elseif portal_dir=="y-" then
		cpos.y=(math.floor(cpos.y+ 0.5))-0.524
	elseif portal_dir=="z+" then
		cpos.z=(math.floor(cpos.z+ 0.5))+0.524
	elseif portal_dir=="z-" then
		cpos.z=(math.floor(cpos.z+ 0.5))-0.524
	elseif portal_dir=="x+" then
		cpos.x=(math.floor(cpos.x+ 0.5))+0.524
	elseif portal_dir=="x-" then
		cpos.x=(math.floor(cpos.x+ 0.5))-0.524
	end

	if portal_dir=="x+" or portal_dir=="x-" then -- auto correct (place in center)
		cpos.y=(math.floor(cpos.y+ 0.5))
		cpos.z=(math.floor(cpos.z+ 0.5))
	elseif portal_dir=="y+" or portal_dir=="y-" then
		cpos.x=(math.floor(cpos.x+ 0.5))
		cpos.z=(math.floor(cpos.z+ 0.5))
	elseif portal_dir=="z+" or portal_dir=="z-" then
		cpos.x=(math.floor(cpos.x+ 0.5))
		cpos.y=(math.floor(cpos.y+ 0.5))
	end

	if minetest.registered_nodes[minetest.get_node(cpos).name].walkable then
		minetest.sound_play("portalgun_error", {pos=pos,max_hear_distance = 5, gain = 3})
		return false
	end

	if string.find(portal_dir,"x",1) or string.find(portal_dir,"z",1) then-- auto correct (move from bottom / top)
		local testpos1={x=cpos.x,y=cpos.y-1,z=cpos.z}
		local testpos2={x=cpos.x,y=cpos.y+1,z=cpos.z}
		if minetest.registered_nodes[minetest.get_node(testpos1).name].walkable 
		and minetest.registered_nodes[minetest.get_node(testpos2).name].walkable==false then
		cpos.y=cpos.y+0.5
		elseif minetest.registered_nodes[minetest.get_node(testpos2).name].walkable 
		and minetest.registered_nodes[minetest.get_node(testpos1).name].walkable==false then
			cpos.y=cpos.y-0.5
		end
	end

	portalgun_portal_tmp_user=name
	portalgun_portal[name].x=pos.x-lpos.x
	portalgun_portal[name].y=pos.y-lpos.y
	portalgun_portal[name].z=pos.z-lpos.z 
	portalgun_portal[name].project=mode

	if portalgun_portal[name].x<0 then
		portalgun_portal[name].x=portalgun_portal[name].x*-1
	end
	if portalgun_portal[name].z<0 then
		portalgun_portal[name].z=portalgun_portal[name].z*-1
	end






	if mode==1 then
		portal_delete(name,1)
		portalgun_portal[name].portal1_use=portalgun_portal[name].portal1_use+1
		portalgun_portal[name].portal1_dir=portal_dir
		portalgun_portal[name].portal1_pos=cpos
		portalgun_portal[name].portal1=minetest.add_entity(cpos, "portalgun:portal")
		portalgun_portal[name].portal1_active=true
		minetest.sound_play("portalgun_portalblue", {pos=cpos, max_hear_distance = 20, gain = 1})
	else
		portal_delete(name,2)
		portalgun_portal[name].portal2_use=portalgun_portal[name].portal2_use+1
		portalgun_portal[name].portal2_dir=portal_dir
		portalgun_portal[name].portal2_pos=cpos
		portalgun_portal[name].portal2=minetest.add_entity(cpos, "portalgun:portal")
		portalgun_portal[name].portal2_active=true
		minetest.sound_play("portalgun_portalorange", {pos=cpos,max_hear_distance = 20, gain = 1})
	end
end

portalgun_front_of_field=function(ob,ob2)
	local pos2=ob2:get_pos()
	return vector.distance(ob:get_pos(),pos2)>vector.distance(portalgun_pointat(ob),pos2)
end

portalgun_pointat=function(ob)
	local pos=ob:get_pos()
	local yaw=ob:get_yaw()
	if yaw ~= yaw or type(yaw)~="number" then
		yaw=0
	end
	local z =math.sin(yaw) * -0.1
	local x =math.cos(yaw) * 0.1
	return {x=pos.x+x,y=pos.y,z=pos.z+z}
end
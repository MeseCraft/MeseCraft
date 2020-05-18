smartshop={user={},tmp={},add_storage={},max_wifi_distance=30,
mesecon=minetest.get_modpath("mesecons")~=nil,
dir={{x=0,y=0,z=-1},{x=-1,y=0,z=0},{x=0,y=0,z=1},{x=1,y=0,z=0}},
dpos={
{{x=0.2,y=0.2,z=0},{x=-0.2,y=0.2,z=0},{x=0.2,y=-0.2,z=0},{x=-0.2,y=-0.2,z=0}},
{{x=0,y=0.2,z=0.2},{x=0,y=0.2,z=-0.2},{x=0,y=-0.2,z=0.2},{x=0,y=-0.2,z=-0.2}},
{{x=-0.2,y=0.2,z=0},{x=0.2,y=0.2,z=0},{x=-0.2,y=-0.2,z=0},{x=0.2,y=-0.2,z=0}},
{{x=0,y=0.2,z=-0.2},{x=0,y=0.2,z=0.2},{x=0,y=-0.2,z=-0.2},{x=0,y=-0.2,z=0.2}}}
}

minetest.register_craft({
	output = "smartshop:shop",
	recipe = {
		{"default:chest_locked", "default:chest_locked", "default:chest_locked"},
		{"signs:sign", "default:chest_locked", "signs:sign"},
		{"default:gold_ingot", "default:torch", "default:gold_ingot"},
	}
})

minetest.register_craft({
	output = "smartshop:wifistorage",
	recipe = {
		{"default:mese_crystal", "default:chest_locked", "default:mese_crystal"},
		{"default:mese_crystal", "default:chest_locked", "default:mese_crystal"},
		{"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"},
	}
})

smartshop.strpos=function(str,spl)
	if str==nil then return "" end
	if spl then
		local c=","
		if string.find(str," ") then c=" " end
		local s=str.split(str,c)
			if s[3]==nil then
				return nil
			else
				local p={x=tonumber(s[1]),y=tonumber(s[2]),z=tonumber(s[3])}
				if not (p and p.x and p.y and p.z) then return nil end
				return p
			end
	else	if str and str.x and str.y and str.z then
			return str.x .."," .. str.y .."," .. str.z
		else
			return nil
		end
	end
end

smartshop.send_mesecon=function(pos)
	if smartshop.mesecon then
		mesecon.receptor_on(pos)
		minetest.get_node_timer(pos):start(1)
	end
end

smartshop.use_offer=function(pos,player,n)
	local pressed={}
	pressed["buy" .. n]=true
	smartshop.user[player:get_player_name()]=pos
	smartshop.receive_fields(player,pressed)
	smartshop.user[player:get_player_name()]=nil
	smartshop.update(pos)
end

smartshop.get_offer=function(pos)
	if not pos or not minetest.get_node(pos) then return end
	if minetest.get_node(pos).name~="smartshop:shop" then return end
	local meta=minetest.get_meta(pos)
	local inv=meta:get_inventory()
	local offer={}
	for i=1,4,1 do
		offer[i]={
		give=inv:get_stack("give" .. i,1):get_name(),
		give_count=inv:get_stack("give" .. i,1):get_count(),
		pay=inv:get_stack("pay" .. i,1):get_name(),
		pay_count=inv:get_stack("pay" .. i,1):get_count(),
		}
	end
	return offer
end

smartshop.receive_fields=function(player,pressed)
		local pname=player:get_player_name()
		local pos=smartshop.user[pname]
		if not pos then
			return
		elseif pressed.tsend then
			smartshop.add_storage[pname]={send=true,pos=pos}
			minetest.after(30, function(pname)
				if smartshop.add_storage[pname] then
					minetest.chat_send_player(pname, "Time expired (30s)")
					smartshop.add_storage[pname]=nil
				end
			end, pname)
			minetest.chat_send_player(pname, "Open a storage owned by you")
		return
		elseif pressed.trefill then
			smartshop.add_storage[pname]={refill=true,pos=pos}
			minetest.after(30, function(pname)
				if smartshop.add_storage[pname] then
					minetest.chat_send_player(pname, "Time expired (30s)")
					smartshop.add_storage[pname]=nil
				end
			end, pname)
			minetest.chat_send_player(pname, "Open a storage owned by you")
		return
		elseif pressed.customer then
			return smartshop.showform(pos,player,true)
		elseif pressed.sellall then
			local meta=minetest.get_meta(pos)
			local pname=player:get_player_name()
			if meta:get_int("sellall")==0 then
				meta:set_int("sellall",1)
				minetest.chat_send_player(pname, "Sell your stock and give line")
			else
				meta:set_int("sellall",0)
				minetest.chat_send_player(pname, "Sell your stock only")
			end
		elseif pressed.toogleee then
			local meta=minetest.get_meta(pos)
			local pname=player:get_player_name()
			if meta:get_int("type")==0 then
				meta:set_int("type",1)
				minetest.chat_send_player(pname, "Your stock is limited")
			else
				meta:set_int("type",0)
				minetest.chat_send_player(pname, "Your stock is unlimited")
			end
		elseif not pressed.quit then
			local n=1
			for i=1,4,1 do
				n=i
				if pressed["buy" .. i] then break end
			end
			local meta=minetest.get_meta(pos)
			local type=meta:get_int("type")
			local sellall=meta:get_int("sellall")
			local inv=meta:get_inventory()
			local pinv=player:get_inventory()
			local pname=player:get_player_name()
			local check_storage
			if pressed["buy" .. n] then
				local name=inv:get_stack("give" .. n,1):get_name()
				local stack=name .." ".. inv:get_stack("give" .. n,1):get_count()
				local pay=inv:get_stack("pay" .. n,1):get_name() .." ".. inv:get_stack("pay" .. n,1):get_count()
				local stack_to_use="main"
				if name~="" then
--fast checks
					if not pinv:room_for_item("main", stack) then
						minetest.chat_send_player(pname, "Error: Your inventory is full, exchange aborted.")
						return
					elseif not pinv:contains_item("main", pay) then
						minetest.chat_send_player(pname, "Error: You dont have enough in your inventory to buy this, exchange aborted.")
						return
					elseif type==1 and inv:room_for_item("main", pay)==false then
						minetest.chat_send_player(pname, "Error: The owners stock is full, cant receive, exchange aborted.")
					else
						if inv:contains_item("main", stack) then
						elseif sellall==1 and inv:contains_item("give" .. n, stack) then
							stack_to_use="give" .. n
						else
							minetest.chat_send_player(pname, "Error: The owners stock is end.")
							check_storage=1
						end
						if not check_storage then
							for i=0,32,1 do
								if pinv:get_stack("main", i):get_name()==inv:get_stack("pay" .. n,1):get_name() and pinv:get_stack("main",i):get_wear()>0 then
									minetest.chat_send_player(pname, "Error: your item is used")
									return
								end
							end
							local rastack=inv:remove_item(stack_to_use, stack)
							pinv:remove_item("main", pay)
							pinv:add_item("main",rastack)
							if type==1 then inv:add_item("main",pay) end
							if type==0 then inv:add_item("main", rastack) end
						end
					end
-- send to / refill from wifi storage
					if type==1 then
						local tsend=smartshop.strpos(meta:get_string("item_send"),1)
						local trefill=smartshop.strpos(meta:get_string("item_refill"),1)
						if tsend then
							local m=minetest.get_meta(tsend)
							local inv2=m:get_inventory()
							local mes=m:get_int("mesein")
							for i=1,10,1 do
								if inv2:room_for_item("main", pay) and inv:contains_item("main", pay) then
									inv2:add_item("main",pay)
									inv:remove_item("main", pay)
									if mes==1 or mes==3 then
										smartshop.send_mesecon(tsend)
									end
								else
									break
								end
							end
						end
						if trefill then
							local m=minetest.get_meta(trefill)
							local inv2=m:get_inventory()
							local mes=m:get_int("mesein")

							local space=0
--check if its room for other items, else the shop will stuck
							for i=1,32,1 do
								if inv:get_stack("main",i):get_count()==0 then
									space=space+1
								end
							end
							for i=1,space,1 do
								if i<space and inv2:contains_item("main", stack) and inv:room_for_item("main", stack) then
									local rstack=inv2:remove_item("main", stack)
									inv:add_item("main",rstack)
									if mes==2 or mes==3 then
										smartshop.send_mesecon(trefill)
									end
									if check_storage then
										check_storage=nil
										minetest.chat_send_player(pname, "Try again, stock just refilled")
									end
								else
									break
								end
							end
						end
					end
					smartshop.send_mesecon(pos)
				end
			end
		else
			smartshop.update_info(pos)
			smartshop.update(pos,"update")
			smartshop.user[player:get_player_name()]=nil
		end
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="smartshop.showform" then
		smartshop.receive_fields(player,pressed)
	elseif form=="smartshop.showform2" then
		smartshop.receive_fields2(player,pressed)
	end
end)

smartshop.update_info=function(pos)
	local meta=minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local owner=meta:get_string("owner")
	local gve=0
	if meta:get_int("sellall")==1 then gve=1 end
	if meta:get_int("type")==0 then
		meta:set_string("infotext","(Smartshop by " .. owner ..") Stock is unlimited")
		return false
	end
	local name=""
	local count=0
	local stuff={}
	for i=1,4,1 do
		stuff["count" ..i]=inv:get_stack("give" .. i,1):get_count()
		stuff["name" ..i]=inv:get_stack("give" .. i,1):get_name()
		stuff["stock" ..i]=gve*stuff["count" ..i]
		stuff["buy" ..i]=0
		for ii=1,32,1 do
			name=inv:get_stack("main",ii):get_name()
			count=inv:get_stack("main",ii):get_count()
			if name==stuff["name" ..i] then
				stuff["stock" ..i]=stuff["stock" ..i]+count
			end
		end
		local nstr=(stuff["stock" ..i]/stuff["count" ..i]) ..""
		nstr=nstr.split(nstr, ".")
		stuff["buy" ..i]=tonumber(nstr[1])

		if stuff["name" ..i]=="" or stuff["buy" ..i]==0 then
			stuff["buy" ..i]=""
			stuff["name" ..i]=""
		else
			if string.find(stuff["name" ..i],":")~=nil then
				stuff["name" ..i]=stuff["name" ..i].split(stuff["name" ..i],":")[2]
			end
			stuff["buy" ..i]="(" ..stuff["buy" ..i] ..") "
			stuff["name" ..i]=stuff["name" ..i] .."\n"
		end
	end
		meta:set_string("infotext",
		"(Smartshop by " .. owner ..") Purchases left:\n"
		.. stuff.buy1 ..  stuff.name1
		.. stuff.buy2 ..  stuff.name2
		.. stuff.buy3 ..  stuff.name3
		.. stuff.buy4 ..  stuff.name4
		)
end

smartshop.update=function(pos,stat)
--clear
	local spos=minetest.pos_to_string(pos)
	for _, ob in ipairs(minetest.get_objects_inside_radius(pos, 2)) do
		if ob and ob:get_luaentity() and ob:get_luaentity().smartshop and ob:get_luaentity().pos==spos then
			ob:remove()	
		end
	end
	if stat=="clear" then return end
--update
	local meta=minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local node=minetest.get_node(pos)
	local dp = smartshop.dir[node.param2+1]
	if not dp then return end
	pos.x = pos.x + dp.x*0.01
	pos.y = pos.y + dp.y*6.5/16
	pos.z = pos.z + dp.z*0.01
	for i=1,4,1 do
		local item=inv:get_stack("give" .. i,1):get_name()
		local pos2=smartshop.dpos[node.param2+1][i]
		if item~="" then
			smartshop.tmp.item=item
			smartshop.tmp.pos=spos
			local e = minetest.add_entity({x=pos.x+pos2.x,y=pos.y+pos2.y,z=pos.z+pos2.z},"smartshop:item")
			e:set_yaw(math.pi*2 - node.param2 * math.pi/2)
		end
	end
end


minetest.register_entity("smartshop:item",{
	hp_max = 1,
	visual="wielditem",
	visual_size={x=.20,y=.20},
	collisionbox = {0,0,0,0,0,0},
	physical=false,
	textures={"air"},
	smartshop=true,
	type="",
	on_activate = function(self, staticdata)
		if smartshop.tmp.item ~= nil then
			self.item=smartshop.tmp.item
			self.pos=smartshop.tmp.pos
			smartshop.tmp={}
		else
			if staticdata ~= nil and staticdata ~= "" then
				local data = staticdata:split(';')
				if data and data[1] and data[2] then
					self.item = data[1]
					self.pos = data[2]
				end
			end
		end
		if self.item ~= nil then
			self.object:set_properties({textures={self.item}})
		else
			self.object:remove()
		end
	end,
	get_staticdata = function(self)
		if self.item ~= nil and self.pos ~= nil then
			return self.item .. ';' ..  self.pos
		end
		return ""
	end,
})


smartshop.showform=function(pos,player,re)
	local meta=minetest.get_meta(pos)
	local creative=meta:get_int("creative")
	local inv = meta:get_inventory()
	local gui=""
	local spos=pos.x .. "," .. pos.y .. "," .. pos.z
	local uname=player:get_player_name()
	local owner=meta:get_string("owner")==uname
	if minetest.check_player_privs(uname, {protection_bypass=true}) then owner=true end
	if re then owner=false end
	smartshop.user[uname]=pos
	if owner then
		if meta:get_int("type")==0 and not (minetest.check_player_privs(uname, {creative=true}) or minetest.check_player_privs(uname, {give=true})) then
			meta:set_int("creative",0)
			meta:set_int("type",1)
			creative=0
		end

		gui=""
		.."size[8,10]"

		.."button_exit[6,0;1.5,1;customer;Customer]"
		.."button[7.2,0;1,1;sellall;All]"
		.."label[0,0.2;Item:]"
		.."label[0,1.2;Price:]"
		.."list[nodemeta:" .. spos .. ";give1;1,0;1,1;]"
		.."list[nodemeta:" .. spos .. ";pay1;1,1;1,1;]"
		.."list[nodemeta:" .. spos .. ";give2;2,0;1,1;]"
		.."list[nodemeta:" .. spos .. ";pay2;2,1;1,1;]"
		.."list[nodemeta:" .. spos .. ";give3;3,0;1,1;]"
		.."list[nodemeta:" .. spos .. ";pay3;3,1;1,1;]"
		.."list[nodemeta:" .. spos .. ";give4;4,0;1,1;]"
		.."list[nodemeta:" .. spos .. ";pay4;4,1;1,1;]"

		.."button_exit[5,0;1,1;tsend;Send]"
		.."button_exit[5,1;1,1;trefill;Refill]"

		local tsend=smartshop.strpos(meta:get_string("item_send"),1)
		local trefill=smartshop.strpos(meta:get_string("item_refill"),1)

		if tsend then
			local m=minetest.get_meta(tsend)
			local title=m:get_string("title")
			if title=="" or m:get_string("owner")~=meta:get_string("owner") then
				meta:set_string("item_send","")
				title="error"
			end
			gui=gui .."tooltip[tsend;Send payments to " ..  title .."]"
		else
			gui=gui .."tooltip[tsend;Send payments to storage]"
			
		end

		if trefill then
			local m=minetest.get_meta(trefill)
			local title=m:get_string("title")
			if title=="" or m:get_string("owner")~=meta:get_string("owner") then
				meta:set_string("item_refill","")
				title="error"
			end
			gui=gui .."tooltip[trefill;Refil from " .. title  .."]"
		else
			gui=gui .."tooltip[trefill;Refil from storage]"
		end


		if creative==1 then
			gui=gui .."label[0.5,-0.4;Your stock is unlimited becaouse you have creative or give]"
			.."button[6,1;2.2,1;tooglelime;Toggle Limit]"
		end
		gui=gui
		.."list[nodemeta:" .. spos .. ";main;0,2;8,4;]"
		.."list[current_player;main;0,6.2;8,4;]"
		.."listring[nodemeta:" .. spos .. ";main]"
		.."listring[current_player;main]"
	else
		gui=""
		.."size[8,6]"
		.."list[current_player;main;0,2.2;8,4;]"
		.."label[0,0.2;Selling:]"
		.."label[0,1.2;Price:]"
		.."list[nodemeta:" .. spos .. ";give1;2,0;1,1;]"
		.."item_image_button[2,1;1,1;".. inv:get_stack("pay1",1):get_name() ..";buy1;\n\n\b\b\b\b\b" .. inv:get_stack("pay1",1):get_count() .."]"
		.."list[nodemeta:" .. spos .. ";give2;3,0;1,1;]"
		.."item_image_button[3,1;1,1;".. inv:get_stack("pay2",1):get_name() ..";buy2;\n\n\b\b\b\b\b" .. inv:get_stack("pay2",1):get_count() .."]"
		.."list[nodemeta:" .. spos .. ";give3;4,0;1,1;]"
		.."item_image_button[4,1;1,1;".. inv:get_stack("pay3",1):get_name() ..";buy3;\n\n\b\b\b\b\b" .. inv:get_stack("pay3",1):get_count() .."]"
		.."list[nodemeta:" .. spos .. ";give4;5,0;1,1;]"
		.."item_image_button[5,1;1,1;".. inv:get_stack("pay4",1):get_name() ..";buy4;\n\n\b\b\b\b\b" .. inv:get_stack("pay4",1):get_count() .."]"
	end
	minetest.after((0.1), function(gui)
		return minetest.show_formspec(player:get_player_name(), "smartshop.showform",gui)
	end, gui)
end

minetest.register_node("smartshop:shop", {
	description = "Smartshop",
	tiles = {"default_chest_top.png^[colorize:#ffffff77^default_obsidian_glass.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1,tubedevice = 1, tubedevice_receiver = 1,mesecon=2},
	drawtype="nodebox",
	node_box = {type="fixed",fixed={-0.5,-0.5,-0.0,0.5,0.5,0.5}},
	paramtype2="facedir",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 10,
	on_timer = function (pos, elapsed)
		if smartshop.mesecon then
			mesecon.receptor_off(pos)
		end
		return false
	end,
	tube = {insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local added = inv:add_item("main", stack)
			return added
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, front = 1, back = 1, top = 1, bottom = 1}},
after_place_node = function(pos, placer)
		local meta=minetest.get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext", "Shop by: " .. placer:get_player_name())
		meta:set_int("type",1)
		meta:set_int("sellall",1)
		if minetest.check_player_privs(placer:get_player_name(), {creative=true}) or minetest.check_player_privs(placer:get_player_name(), {give=true}) then
			meta:set_int("creative",1)
			meta:set_int("type",0)
			meta:set_int("sellall",0)
		end
	end,
on_construct = function(pos)
		local meta=minetest.get_meta(pos)
		meta:set_int("state", 0)
		meta:get_inventory():set_size("main", 32)
		meta:get_inventory():set_size("give1", 1)
		meta:get_inventory():set_size("pay1", 1)
		meta:get_inventory():set_size("give2", 1)
		meta:get_inventory():set_size("pay2", 1)
		meta:get_inventory():set_size("give3", 1)
		meta:get_inventory():set_size("pay3", 1)
		meta:get_inventory():set_size("give4", 1)
		meta:get_inventory():set_size("pay4", 1)
	end,
on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		smartshop.showform(pos,player)
	end,
allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if stack:get_wear()==0 and (minetest.get_meta(pos):get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true})) then
		return stack:get_count()
		end
		return 0
	end,
allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.get_meta(pos):get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true}) then
		return stack:get_count()
		end
		return 0
	end,
allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if minetest.get_meta(pos):get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true}) then
		return count
		end
		return 0
	end,
can_dig = function(pos, player)
		local meta=minetest.get_meta(pos)
		local inv=meta:get_inventory()
		if ((meta:get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true})) and inv:is_empty("main") and inv:is_empty("pay1") and inv:is_empty("pay2") and inv:is_empty("pay3") and inv:is_empty("pay4") and inv:is_empty("give1") and inv:is_empty("give2") and inv:is_empty("give3") and inv:is_empty("give4")) or meta:get_string("owner")=="" then
			smartshop.update(pos,"clear")
			return true
		end
	end,
})

smartshop.receive_fields2=function(player,pressed)
	local pname=player:get_player_name()
	local pos=smartshop.user[pname]
	if not pos then
		return
	end
	local meta=minetest.get_meta(pos)

	if pressed.mesesin then
		local m=meta:get_int("mesein")
		if m<=2 then
			m=m+1
		else
			m=0
		end
		meta:set_int("mesein",m)
		smartshop.showform2(pos,player)
		return
	elseif pressed.save then
		local t=pressed.title
		if t=="" then t="wifi" .. math.random(1,9999) end
		meta:set_string("title",t)
	end
	smartshop.user[pname]=nil
end

smartshop.showform2=function(pos,player)
	local meta=minetest.get_meta(pos)
	local uname=player:get_player_name()
	if meta:get_string("owner")~=uname and not minetest.check_player_privs(uname, {protection_bypass=true}) then return end
	local inv = meta:get_inventory()
	local spos=pos.x .. "," .. pos.y .. "," .. pos.z
	local title=meta:get_string("title")

	smartshop.user[uname]=pos

	local gui="size[12,9]"

	if title=="" then
		title="wifi" .. math.random(1,999)
	end

	if smartshop.mesecon then
		local m=meta:get_int("mesein")
		if m==0 then
			gui=gui .. "button[0,7;2,1;mesesin;Don't send]"
		elseif m==1 then
			gui=gui .. "button[0,7;2,1;mesesin;Incoming]"
		elseif m==2 then
			gui=gui .. "button[0,7;2,1;mesesin;Outcoming]"
		elseif m==3 then
			gui=gui .. "button[0,7;2,1;mesesin;Both]"
		end
		gui=gui.."tooltip[mesesin;Send mesecon signal when items from shops does:]"
	end

	gui=gui .. ""

	.."field[0.3,5.3;2,1;title;;" .. title .."]"
	gui=gui
	.."tooltip[title;Used with connected smartshops]"
	.."button_exit[0,6;2,1;save;Save]"

	.."list[nodemeta:" .. spos .. ";main;0,0;12,5;]"
	.."list[current_player;main;2,5;8,4;]"
	.."listring[nodemeta:" .. spos .. ";main]"
	.."listring[current_player;main]"
	minetest.after((0.1), function(gui)
		return minetest.show_formspec(uname, "smartshop.showform2",gui)
	end, gui)

	local a=smartshop.add_storage[uname]
	if a then
		if not a.pos then return end
		if vector.distance(a.pos, pos)>smartshop.max_wifi_distance then
			minetest.chat_send_player(uname, "Too far, max distance " .. smartshop.max_wifi_distance)
		end
		local meta=minetest.get_meta(a.pos)
		local p=smartshop.strpos(pos)
		if a.send and p then
			meta:set_string("item_send",p)
		elseif a.refill and p then
			meta:set_string("item_refill",p)
		end
		minetest.chat_send_player(uname, "smartshop connected")
		smartshop.add_storage[uname]=nil
	end
end

minetest.register_node("smartshop:wifistorage", {
	description = "WiFi Storage for SmartShop",
	tiles = {"default_chest_top.png^[colorize:#ffffff77^default_obsidian_glass.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1,tubedevice = 1, tubedevice_receiver = 1,mesecon=2},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 10,
	on_timer = function (pos, elapsed)
		if smartshop.mesecon then
			mesecon.receptor_off(pos)
		end
		return false
	end,
	tube = {insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local added = inv:add_item("main", stack)
			return added
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, front = 1, back = 1, top = 1, bottom = 1}},
after_place_node = function(pos, placer)
		local meta=minetest.get_meta(pos)
		local name=placer:get_player_name()
		meta:set_string("owner",name)
		meta:set_string("infotext", "Wifi storage by: " .. name)
	end,
on_construct = function(pos)
		local meta=minetest.get_meta(pos)
		meta:get_inventory():set_size("main", 60)
		meta:set_int("mesein",0)
		meta:set_string("title","wifi" .. math.random(1,999))
	end,
on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		smartshop.showform2(pos,player)
	end,
allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if stack:get_wear()==0 and (minetest.get_meta(pos):get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true})) then
		return stack:get_count()
		end
		return 0
	end,
allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.get_meta(pos):get_string("owner")==player:get_player_name() or minetest.check_player_privs(player:get_player_name(), {protection_bypass=true}) then
		return stack:get_count()
		end
		return 0
	end,
can_dig = function(pos, player)
		local meta=minetest.get_meta(pos)
		local inv=meta:get_inventory()
		local p=player:get_player_name()
		if (meta:get_string("owner")==p or minetest.check_player_privs(p, {protection_bypass=true})) and inv:is_empty("main") or meta:get_string("owner")=="" then
			return true
		end
	end,
})


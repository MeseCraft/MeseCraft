--
-- fuel
--
helicopter.fuel = {['oil:oil_bucket'] = 4}
helicopter.returns = "mesecraft_bucket:bucket_empty"

minetest.register_entity('helicopter:pointer',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "pointer.b3d",
	textures = {"clay.png"},
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

function helicopter.get_gauge_angle(value)
    local angle = value * 18
    angle = angle - 90
    angle = angle * -1
	return angle
end

function helicopter.contains(table, val)
    for k,v in pairs(table) do
        if k == val then
            return v
        end
    end
    return false
end

function helicopter.loadFuel(self, player_name)
    local player = minetest.get_player_by_name(player_name)
    local inv = player:get_inventory()

    local itmstck=player:get_wielded_item()
    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end

    local stack = nil
    local fuel = helicopter.contains(helicopter.fuel, item_name)
    if fuel then
        stack = ItemStack(item_name .. " 1")

        if self.energy < 10 then
            local taken = inv:remove_item("main", stack)
            if helicopter.returns then
                local ret_stack = ItemStack(helicopter.returns)
                if inv:room_for_item("main", ret_stack ) then
                    inv:add_item("main", ret_stack)
                else
                    minetest.add_item(player:get_pos(), ret_stack)
                end
            end
            self.energy = self.energy + fuel
            if self.energy > 10 then self.energy = 10 end

            local energy_indicator_angle = helicopter.get_gauge_angle(self.energy)
            self.pointer:set_attach(self.object,'',{x=0,y=11.26,z=9.37},{x=0,y=0,z=energy_indicator_angle})
        end
        
        return true
    end

    return false
end



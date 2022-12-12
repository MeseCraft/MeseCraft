item_entity.lua replacement

edited by TenPlus1

Features:
- Items are destroyed by lava
- Items are pushed along by flowing water (thanks to QwertyMine3 and Gustavo6046)
- Items are removed after 900 seconds or the time that is specified by
   remove_items in minetest.conf (-1 disables it)
- Particle effects added
- Dropped items slide on nodes with {slippery} groups
- Items stuck inside solid nodes move to nearest empty space
- Can use new on_pickup() function if available
- Added 'dropped_step(self, pos, dtime, moveresult)' custom on_step for dropped items
   'self.node_inside' contains node table that item is inside
   'self.def_inside' contains node definition for above
   'self.node_under' contains node table that is below item
   'self.def_under' contains node definition for above
   'self.age' holds age of dropped item in seconds
   'self.itemstring' contains itemstring e.g. "default:dirt", "default:ice 20"
   'self.is_moving' true if dropped item is moving
   'pos' holds position of dropped item
   'dtime' used for timers
   'moveresult' table containing collision info

   return false to skip further checks by builtin_item

License: LGPLv2.1+


dropped_step() examples:

-- if gunpowder dropped on burning tnt or gunpowder then remove

if minetest.registered_items["tnt:gunpowder"] then

	minetest.override_item("tnt:gunpowder", {

		dropped_step = function(self, pos)

			if (self.node_inside
			and self.node_inside.name == "tnt:gunpowder_burning")
			or (self.node_under
			and self.node_under.name == "tnt:tnt_burning") then

				minetest.sound_play("builtin_item_lava", {
					pos = pos,
					max_hear_distance = 6,
					gain = 0.5
				})

				self.itemstring = ""
				self.object:remove()

				return false -- return with no further action
			end
		end
	})
end


-- if 2x mese crystal and 2x crystal spike dropped in pool of water_source
-- then merge into a single crystal_ingot.

if minetest.registered_items["ethereal:crystal_spike"] then

	minetest.override_item("ethereal:crystal_spike", {

		dropped_step = function(self, pos, dtime)

			self.ctimer = (self.ctimer or 0) + dtime
			if self.ctimer < 5.0 then return end
			self.ctimer = 0

			if self.node_inside
			and self.node_inside.name ~= "default:water_source" then
				return
			end

			local objs = core.get_objects_inside_radius(pos, 0.8)

			if not objs or #objs ~= 2 then return end

			local crystal, mese, ent = nil, nil, nil

			for k, obj in pairs(objs) do

				ent = obj:get_luaentity()

				if ent and ent.name == "__builtin:item" then

					if ent.itemstring == "default:mese_crystal 2"
					and not mese then

						mese = obj

					elseif ent.itemstring == "ethereal:crystal_spike 2"
					and not crystal then

						crystal = obj
					end
				end
			end

			if mese and crystal then

				mese:remove()
				crystal:remove()

				core.add_item(pos, "ethereal:crystal_ingot")

				return false -- return with no further action
			end
		end
	})
end

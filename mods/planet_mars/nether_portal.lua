local MARS_LEVEL    = 20900

nether.register_portal("martian_portal", {
		shape               = nether.PortalShape_Circular,
		frame_node_name     = "default:bronzeblock",
		wormhole_node_color = 5, -- 5 is red
		particle_texture    = {
			name      = "nether_particle_anim1.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 7,
				aspect_h = 7,
				length = 1,
			},
			scale = 1.5
		},
		title = "Martian Portal",
		book_of_portals_pagetext = [[Requiring 16 blocks of bronze, and constructed in the shape of a circle. A finished circle is 7 blocks high, and 7 blocks wide.
This portal is big! Upon setting foot in the portal we found ourselves on a new planet! It was red, with lots of sand across the planet and in the wind. There were giant red mountains. Bring a space suit. We couldn't breathe and had to turn back!]],

		is_within_realm = function(pos) -- return true if pos is inside the Nether
			return pos.y > MARS_LEVEL - 200
		end,

		find_realm_anchorPos = function(surface_anchorPos)
			-- TODO: Once paramat finishes adjusting the floatlands, implement a surface algorithm that finds land
			local destination_pos = {x = surface_anchorPos.x ,y = MARS_LEVEL + 2, z = surface_anchorPos.z}

			-- a y_factor of 0 makes the search ignore the altitude of the portals (as long as they are in the Floatlands)
			local existing_portal_location, existing_portal_orientation = nether.find_nearest_working_portal("martian_portal", destination_pos, 10, 0)
			if existing_portal_location ~= nil then
				return existing_portal_location, existing_portal_orientation
			else
				return destination_pos
			end
		end
	})

local bg = "bg_emoji.png"

local form = "size[10,7.8] bgcolor[#333444cc; false] image_button_exit[0,0;2,2;"..bg.."^1_emoji.png;1_emoji;] image_button_exit[2,0;2,2;"..bg.."^2_emoji.png;2_emoji;] image_button_exit[4,0;2,2;"..bg.."^3_emoji.png;3_emoji;] image_button_exit[6,0;2,2;"..bg.."^4_emoji.png;4_emoji;] image_button_exit[8,0;2,2;"..bg.."^5_emoji.png;5_emoji;] image_button_exit[0,2;2,2;"..bg.."^6_emoji.png;6_emoji;] image_button_exit[2,2;2,2;"..bg.."^7_emoji.png;7_emoji;] image_button_exit[4,2;2,2;"..bg.."^8_emoji.png;8_emoji;] image_button_exit[6,2;2,2;"..bg.."^9_emoji.png;9_emoji;] image_button_exit[8,2;2,2;"..bg.."^10_emoji.png;10_emoji;] image_button_exit[0,4;2,2;"..bg.."^11_emoji.png;11_emoji;] image_button_exit[2,4;2,2;"..bg.."^12_emoji.png;12_emoji;] image_button_exit[4,4;2,2;"..bg.."^13_emoji.png;13_emoji;] image_button_exit[6,4;2,2;"..bg.."^14_emoji.png;14_emoji;] image_button_exit[8,4;2,2;"..bg.."^15_emoji.png;15_emoji;] image_button_exit[0,6;2,2;"..bg.."^16_emoji.png;16_emoji;] image_button_exit[2,6;2,2;"..bg.."^17_emoji.png;17_emoji;] image_button_exit[4,6;2,2;"..bg.."^18_emoji.png;18_emoji;] image_button_exit[6,6;2,2;"..bg.."^19_emoji.png;19_emoji;] image_button_exit[8,6;2,2;"..bg.."^20_emoji.png;20_emoji;]"


minetest.register_chatcommand("e", {
	params = "",
	description = "Emoji",
	privs = {},
	func = function(name, param)

		minetest.show_formspec(name, "emoji_form", form)
	
	end,
})

local v = {
	{"1_emoji", ":)"},
	{"2_emoji", "B-)"},
	{"3_emoji", ":#"},
	{"4_emoji", "*_*"},
	{"5_emoji", ":D"},
	{"6_emoji", ":*"},
	{"7_emoji", ":_("},
	{"8_emoji", ">:-["},
	{"9_emoji", "]:-)"},
	{"10_emoji", ":/"},
	{"11_emoji", ";)"},
	{"12_emoji", ":("},
	{"13_emoji", ";P"},
	{"14_emoji", ":'-D"},
	{"15_emoji", "~:["},
	{"16_emoji", "o_O"},
	{"17_emoji", "xD"},
	{"18_emoji", "xP"},
	{"19_emoji", ":X"},
	{"20_emoji", ":P"},
	{"21_emoji", ":O"},
	
}

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname=="emoji_form" then

		local pos = player:get_pos()
		
		for _, v in pairs(v) do

				if fields[v[1]] then
					minetest.sound_play("emoji_sound", {pos = pos, max_hear_distance = 12, gain = 1.0,})

					minetest.add_particlespawner(
						1, --amount
						0.01, --time
						{x=pos.x, y=pos.y+2, z=pos.z}, --minpos
						{x=pos.x, y=pos.y+2, z=pos.z}, --maxpos
						{x=0, y=0.15, z=0}, --minvel
						{x=0, y=0.15, z=0}, --maxvel
						{x=0,y=0,z=0}, --minacc
						{x=0,y=0,z=0}, --maxacc
						2.5, --minexptime
						2.5, --maxexptime
						9, --minsize
						9, --maxsize
						false, --collisiondetection
						v[1]..".png"
					)

				end	
		end

	end
end)



minetest.register_on_chat_message(function(name, message, pos)    
	local checkingmessage=( name.." "..message .." " )

	for _, v in pairs(v) do
		if string.find(checkingmessage, v[2], 1, true) ~=nil then

			local player = minetest.get_player_by_name(name)
			
			local pos = player:get_pos()
			
			minetest.add_particlespawner(
				1, --amount
				0.01, --time
				{x=pos.x, y=pos.y+2, z=pos.z}, --minpos
				{x=pos.x, y=pos.y+2, z=pos.z}, --maxpos
				{x=0, y=0.15, z=0}, --minvel
				{x=0, y=0.15, z=0}, --maxvel
				{x=0,y=0,z=0}, --minacc
				{x=0,y=0,z=0}, --maxacc
				2.5, --minexptime
				2.5, --maxexptime
				9, --minsize
				9, --maxsize
				false, --collisiondetection
				v[1]..".png"
			)
			
		end
	
	end	
		
end)







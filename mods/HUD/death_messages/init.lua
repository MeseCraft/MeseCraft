--[[
death_messages - A Minetest mod which sends a chat message when a player dies.
Copyright (C) 2016  EvergreenTree

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-----------------------------------------------------------------------------------------------
local title = "Death Messages"
local version = "1.1"
local mname = "death_messages"
-----------------------------------------------------------------------------------------------
dofile(minetest.get_modpath("death_messages").."/settings.txt")
-----------------------------------------------------------------------------------------------

death_messages = {}
death_messages.messages = {} -- Contains tables of messages for different ways to die.
death_messages.punched = {} -- (key) was last punched by (value)
death_messages.punchedWith = {} -- (key) was last punched with an item whose description is (value)
death_messages.punched_forget = {} -- Forget who punched (key) after (value) seconds
death_messages.mightBeFalling = {} -- (key) was falling fast enough to take damage (value) seconds ago.
death_messages.mob_names = {
	--["mod:entity"]="an entity"
	["mobs_monster:oerkki"]="the dreaded Oerkki",
	["mobs_monster:fireball"] = "an angry dungeon_master",
	["mobs_monster:mese_arrow"] = "an angry mese_monster",
	["zombies:1arm"] = "a hungry zombie",
	["zombies:crawler"] = "a crawling zombie",
	["zombies:normal"] = "a hungry zombie",
	["slimes:lavasmall"]="a deadly lava slime",
	["slimes:lavamedium"]="a deadly lava slime",
	["slimes:lavabig"]="a deadly lava slime",
	["slimes:greensmall"]="a deadly jungle slime",
	["slimes:greenmedium"]="a deadly jungle slime",
	["slimes:greenbig"]="a deadly jungle slime",
	["dmobs:golem"]="a wandering golem",
	["dmobs:golem_friendly"]="a golem",
	
}
local name
minetest.register_on_punchplayer(function(player, hitter)
	name = player:get_player_name()
	if hitter then
		if hitter:is_player() then
			if hitter:get_player_name() == name then return end -- Some mods like to have the player punch themself for some odd reason.
			death_messages.punched[name] = hitter:get_player_name()
			death_messages.punchedWith[name] = hitter:get_wielded_item():get_name()
			if death_messages.punchedWith[name] == "" or not death_messages.punchedWith[name] then
				death_messages.punchedWith[name] = "bare hands"
			end
			if minetest.registered_items[death_messages.punchedWith[name]] then
				if minetest.registered_items[death_messages.punchedWith[name]].description then
					death_messages.punchedWith[name] = minetest.registered_items[death_messages.punchedWith[name]].description
				end
			end
		elseif hitter:get_luaentity() then
			local entname = hitter:get_luaentity().name
			if type(entname) ~= "string" then return end
			if death_messages.mob_names[entname] then
				death_messages.punched[name] = death_messages.mob_names[entname]
			else
				if string.split(entname, ":")[2] then
					if hitter:get_luaentity()._cmi_is_mob then
						death_messages.punched[name] = "an angry "..(string.split(entname, ":")[2]):gsub("_", " ")
					else
						death_messages.punched[name] = string.split(entname, ":")[2]
					end
				else
					death_messages.punched[name] = entname
				end
			end
			death_messages.punchedWith[name] = ""
		else
			return
		end
	else
		death_messages.punched[name] = nil
	end
	death_messages.punched_forget[name] = 2.5
end)
-- Lava death messages
death_messages.messages.lava = {
	"(player) was melted.",
	"(player) was incinerated.",
	"(player) was sacrificed to a volcano god.",
	"(player) jumped into a volcano.",
	"(player) joined the fossil record.",
	"(player) went for a swim in lava.",
	"(player) likes to play in magma.",
	"(player) melted into a ball of fire.",
        "(player) thought that lava was cool.",
        "(player) didn't know that lava was hot.",
}

-- Drowning death messages
death_messages.messages.water = {
	"(player) forgot to breathe.",
	"(player) learned they aren't a fish.",
	"(player) didn't float.",
	"(player) ran out of air.",
	"(player) probably wasn't a witch, after all...",
	"(player) is sleeping with the fish.",
	"(player) tried to become a fish, and failed.",
	"(player) blew one too many bubbles.",
	"(player) drowned.",
}

-- Burning death messages
death_messages.messages.fire = {
	"(player) couldn't put the fire out.",
	"(player) was burnt to a crisp.",
	"(player) walked into the flames.",
	"(player) was consumed by a blazing pyre.",
	"(player) got too close to the campfire.",
	"(player) just got roasted, literally.",
	"(player) must have been a witch.",
	"(player) became ash.",
	"(player) was involuntarily cremated.",
	"Someone should have told (player) not to play with matches.",
}

-- Other death messages
death_messages.messages.other = {
	"(player) died.",
	"(player) was slain.",
	"(player) was eviscerated.",
	"(player) was destroyed.",
	"(player)'s body was mangled.",
	"(player)'s vital organs were ruptured.",
	"(player) was removed from the world.",
	"R.I.P (player).",
	"(player) expired.",
	"(player) is aliven't.",
	"(player) had a bad time.",
	"(player)'s lifetime ran out.",
	"(player) joined the black parade.",
	"(player) has gone to a better place.",
	"(player) no longer resides among the living.",
	"(player)'s soul is taking the ferry across Acheron.",
	"(player) found out whether or not there's an afterlife. They won't be telling us, though.",
}

-- Killed by a mob
death_messages.messages.killed_mob = {
	"(player) was slain by (killer).",
	"(player) was eviscerated by (killer).",
	"(player) was murdered by (killer).",
	"(player)'s face was torn off by (killer).",
	"(player) entrails were ripped out by (killer).",
	"(player) was destroyed by (killer).",
	"(player)'s skull was crushed by (killer).",
	"(player) got massacred by (killer).",
	"(player) got impaled by (killer).",
	"(player) was torn in half by (killer).",
	"(player) was decapitated.",
	"(player) let their arms get torn off by (killer).",
	"(player) watched their innards become outards by (killer).",
	"(player) was brutally dissected by (killer).",
	"(player)'s extremities were detached by (killer).",
	"(player)'s body was mangled by (killer).",
	"(player)'s vital organs were ruptured by (killer).",
	"(player) was turned into a pile of flesh by (killer).",
	"(player) was removed from the world by (killer).",
	"(player) got snapped in half by (killer).",
	"(player) was cut down the middle by (killer).",
	"(player) was chopped up by (killer).",
	"(player)'s plea for death was answered by (killer).",
	"(player)'s meat was ripped of the bone by (killer).",
	"(player)'s flailing about was finally stopped by (killer).",
	"(player) had their head removed by (killer).",
	"(player) was killed by (killer).",
	"(player) was slaughtered by (killer).",
	"(player) was unceremoniously terminated by (killer).",
	"(player) tasted the wrath of (killer).",
	"(player)'s continued existence was cancelled by (killer).",
	"(player) tried to escape from (killer).",
}
-- ...killed by a player.
death_messages.messages.killed_player = {
	"(killer) destroyed (player) with their (weapon).",
	"(killer)'s (weapon) became the bane of (player).",
	"(killer) put an end to (player)'s miserable existence.",
	"(killer) has removed (player) from the ranks of the living.",
	"(player) tasted the wrath of (killer)'s (weapon).",
	"(player) died by (killer)'s (weapon)",
}
-- Misc. node damage
death_messages.messages.node = {
	"(player) wandered into a very uncomfortable place.",
	"(player) got themselves into a sticky situation.",
	"(player) shouldn't have touched that.",
	"(player) ignored the \"DANGER! KEEP OUT!\" sign.",
}

-- Fall
death_messages.messages.fall = {
	"(player) became a pancake.",
	"(player) fell to their doom.",
	"(player) shattered into pieces.",
	"(player) can't be put back together again.",
	"(player) didn't bounce.",
	"(player) took a leap of faith, and was sorely disappointed.",
	"(player) was destroyed by gravity.",
	"(player) faceplanted the ground.",
	"(player) left a small crater.",
	"(player)'s parachute failed.",
	"(player) went \"splat\".",
	"\"Don't jump!\" they cried, but (player) jumped.",
	"It wasn't the fall that killed (player), it was the sudden stop at the end.",
	
}

-- Murder by fall
death_messages.messages.pushed = {
	"(killer) pushed (player) to their doom.",
	"(player) fell to their death at the hands of (killer).",
	"(player) was pushed from a great height by (killer)",
	"(player) was taught the way of Spartans by (killer)",
}

minetest.register_globalstep(function(dtime)
	for _,player in pairs(minetest.get_connected_players()) do
		name = player:get_player_name()
		if player:get_player_velocity().y < -13 then
			death_messages.mightBeFalling[name] = 2.0
		elseif death_messages.mightBeFalling[name] then
			if death_messages.mightBeFalling[name] > 0 then
				death_messages.mightBeFalling[name] = death_messages.mightBeFalling[name] - dtime
			else
				death_messages.mightBeFalling[name] = nil
			end
		end
		if death_messages.punched_forget[name] then
			if death_messages.punched_forget[name] > 0 then
				death_messages.punched_forget[name] = death_messages.punched_forget[name] - dtime
			else
				death_messages.punched[name] = nil
				death_messages.punchedWith[name] = nil
				death_messages.punched_forget[name] = nil
			end
		end
	end
end)

function death_messages.get_message(mtype)
	if RANDOM_MESSAGES then
		return death_messages.messages[mtype][math.random(1, #(death_messages.messages[mtype]))]
	else
		return death_messages.messages[1] -- 1 is the index for the non-random message
	end
end

function death_messages.reset_watchers(player) 
	name = player:get_player_name()
	death_messages.punched[name] = nil
	death_messages.punched_forget[name] = nil
	death_messages.punchedWith[name] = nil
	death_messages.mightBeFalling[name] = nil
end

minetest.register_on_leaveplayer(death_messages.reset_watchers)

minetest.register_on_dieplayer(function(player)
	name = player:get_player_name()
	local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
	local message
	--Death by entity
	if death_messages.punched[name] and death_messages.punched[name] ~= name then
		
		if death_messages.mightBeFalling[name] and death_messages.punched_forget[name] and (death_messages.mightBeFalling[name] > death_messages.punched_forget[name] - 0.5) then
			message = death_messages.get_message("pushed")
		elseif death_messages.punchedWith[name] and death_messages.punchedWith[name] ~= "" then
			message = death_messages.get_message("killed_player")
			message = string.gsub(message, "%(weapon%)", death_messages.punchedWith[name])
		else
			message = death_messages.get_message("killed_mob")
		end
		message = string.gsub(message, "%(player%)", name)
		message = string.gsub(message, "%(killer%)", death_messages.punched[name])
		minetest.chat_send_all(minetest.colorize("#FF0000",(message)))
	-- Death by drowning
	elseif player:get_breath() == 0 then
		message = death_messages.get_message("water")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	-- Death by lava
	elseif node.groups.lava then
		message = death_messages.get_message("lava")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	-- Death by fall
	elseif death_messages.mightBeFalling[name] then
		message = death_messages.get_message("fall")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	-- Death by fire
	elseif string.find(node.name, "fire") or string.find(node.name, "flame") or node.groups.igniter then
		message = death_messages.get_message("fire")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	-- Death by node
	elseif node.damage_per_second and node.damage_per_second > 1 then
		message = death_messages.get_message("node")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	--Death by GNU GNU
	else
		message = death_messages.get_message("other")
		minetest.chat_send_all(minetest.colorize("#FF0000",(string.gsub(message, "%(player%)", name))))
	end
	death_messages.reset_watchers(player) 
end)

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------

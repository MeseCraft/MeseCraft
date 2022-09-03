if not minetest.get_modpath("awards") then
	minetest.log("warning", "[df_achievements] the df_achievements mod was installed but the [awards] mod was not."
		.. " df_achievements depends on awards, but it is listed as an optional dependency so that installing the"
		.. " dfcaverns modpack won't automatically enable it. If you want df_achievements to function please"
		.. " install awards as well, otherwise you should disable df_achievements.")
	return
end

df_achievements = {}

local old_awards_version = false
if awards.run_trigger_callbacks then
	-- older versions of awards crash when attempting to use newer versions of triggers
	-- this "run_trigger_callbacks" API call is present in those older versions, so using that
	-- as a fingerprint to discover them
	old_awards_version = true
	
	minetest.register_on_dignode(function(pos, oldnode, digger)
		-- the old version of awards doesn't handle groups when triggering dug nodes, use this to hack around that
		local node_name = oldnode.name
		if minetest.get_item_group(node_name, "dfcaverns_big_crystal") > 0 then
			awards.unlock(digger:get_player_name(), "dfcaverns_ruby_crystals")
		elseif minetest.get_item_group(node_name, "dfcaverns_cave_coral") > 0 then
			awards.unlock(digger:get_player_name(), "dfcaverns_cave_coral")
		end
	end)	
else
	-- used to track the progress of achievements that are based off of other achievements
	awards.register_trigger("dfcaverns_achievements", {
		type="counted_key",
		progress = "@1/@2", -- awards seems to use a conflicting syntax with internationalization, ick. Avoid words here.
		get_key = function(self, def)
			return def.trigger.achievement_name
		end,
	})
end


local achievement_parents = {}
df_achievements.get_child_achievement_count = function(parent_achievement)
	return #achievement_parents[parent_achievement]
end

local register_achievement_old = awards.register_achievement
awards.register_achievement = function(achievement_name, achievement_def, ...)
	if old_awards_version and achievement_def.trigger and achievement_def.trigger.type=="dfcaverns_achievements" then
		-- there's a significant difference between how triggers work
		-- in older versions of the awards mod. The new version of the trigger doesn't
		-- work with the old. Rather than do a bunch of work to support old versions, strip them out.
		achievement_def.trigger = nil
	end

	-- The achievement being registered has "parent" achievements that progress when it is unlocked,
	-- track that here
	if achievement_def._dfcaverns_achievements then
		for _, parent_achievement in pairs(achievement_def._dfcaverns_achievements) do
			local parent_source_list = achievement_parents[parent_achievement] or {}
			achievement_parents[parent_achievement] = parent_source_list
			table.insert(parent_source_list, achievement_name)
		end
	end

	register_achievement_old(achievement_name, achievement_def, ...)
end

local modpath = minetest.get_modpath(minetest.get_current_modname())

awards.register_on_unlock(function(player_name, def)
	local def_dfcaverns_achievements = def._dfcaverns_achievements
	if not def_dfcaverns_achievements then return end
	local player_awards = awards.player(player_name)
	if not player_awards then return end	
	local unlocked = player_awards.unlocked
	if not unlocked then return end
	
	-- the achievement that just got unlocked had one or more "parent" achievements associated with it.
	for _, achievement_parent in pairs(def_dfcaverns_achievements) do
		player_awards.dfcaverns_achievements = player_awards.dfcaverns_achievements or {}
		local source_list = achievement_parents[achievement_parent]
		local total = #source_list
		local count = 0
		for _, source_achievement in pairs(source_list) do
			if unlocked[source_achievement] == source_achievement then count = count + 1 end
		end
		player_awards.dfcaverns_achievements[achievement_parent] = count
		awards.save()
		if count >= total then
			minetest.after(4, awards.unlock, player_name, achievement_parent)
		end			
	end
end)



dofile(modpath.."/travel.lua")
dofile(modpath.."/farming.lua")
dofile(modpath.."/dig.lua")
dofile(modpath.."/food.lua")
dofile(modpath.."/misc.lua")

-- not used outside this mod
df_achievements.test_list = nil
-- table for quick colors.
toolranks = {
	colors = {
		grey = minetest.get_color_escape_sequence("#9d9d9d"),
		green = minetest.get_color_escape_sequence("#1eff00"),
		gold = minetest.get_color_escape_sequence("#ffdf00"),
		white = minetest.get_color_escape_sequence("#ffffff")
	}
}

-- function to create our description of the tool.
function toolranks.create_description(name, uses, level)
	return toolranks.colors.green .. (name or "") .. "\n"
		.. toolranks.colors.gold .. "Level: " .. (level or 1) .. "\n"
		.. toolranks.colors.grey .. "Used: " .. (uses or 0) .. " times"
end

-- function to calculate levels (+150 uses per level)
function toolranks.get_level(uses)
  if uses < 50 then
    return 1
  else
    return math.floor((25 + math.sqrt(625 + 100 * uses))/50)
  end
end

-- function to run after a tool is used.
function toolranks.new_afteruse(itemstack, user, node, digparams)

	-- Get tool metadata and number of times used
	local itemmeta = itemstack:get_meta()
	local dugnodes = tonumber(itemmeta:get_string("dug")) or 0

	-- Only count nodes that spend the tool
	if digparams.wear > 0 then

		dugnodes = dugnodes + 1
		itemmeta:set_string("dug", dugnodes)
	else
		return
	end

	-- Get tool description and last level
	local itemdef   = itemstack:get_definition()
	local itemdesc  = itemdef.original_description or itemdef.description or "Tool"
	local lastlevel = tonumber(itemmeta:get_string("lastlevel")) or 1
	local name = user:get_player_name()

	-- Warn player when tool is almost broken
	if itemstack:get_wear() > 60100 then

		minetest.chat_send_player(name,
			toolranks.colors.gold .. "Your tool is almost broken!")

		minetest.sound_play("default_tool_breaks", {
			to_player = name,
			gain = 2.0,
		})
	end

	local level = toolranks.get_level(dugnodes)

	-- Alert player when tool has leveled up
	if lastlevel < level then

		minetest.chat_send_player(name, "Your "
			.. toolranks.colors.green .. itemdesc
			.. toolranks.colors.white .. " just leveled up!")

		minetest.sound_play("toolranks_levelup", {
			to_player = name,
			gain = 1.0,
		})

		itemmeta:set_string("lastlevel", level)
	end

	local newdesc = toolranks.create_description(itemdesc, dugnodes, level)

	-- Set new meta
	itemmeta:set_string("description", newdesc)

	local wear = digparams.wear

	-- Set wear level
	if level > 1 then
		wear = digparams.wear / (1 + level / 20)
	end

	itemstack:add_wear(wear)

	return itemstack
end


-- Helper function
local function add_tool(name, desc, afteruse)

	minetest.override_item(name, {
		original_description = desc,
		description = toolranks.create_description(desc, 0, 1),
		after_use = afteruse and toolranks.new_afteruse
	})
end

-- Sword
add_tool("default:sword_wood", "Wooden Sword", true)
add_tool("default:sword_stone", "Stone Sword", true)
add_tool("default:sword_steel", "Steel Sword", true)
add_tool("default:sword_bronze", "Bronze Sword", true)
add_tool("default:sword_mese", "Mese Sword", true)
add_tool("default:sword_diamond", "Diamond Sword", true)

-- Pickaxe
add_tool("default:pick_wood", "Wooden Pickaxe", true)
add_tool("default:pick_stone", "Stone Pickaxe", true)
add_tool("default:pick_steel", "Steel Pickaxe", true)
add_tool("default:pick_bronze", "Bronze Pickaxe", true)
add_tool("default:pick_mese", "Mese Pickaxe", true)
add_tool("default:pick_diamond", "Diamond Pickaxe", true)

-- Axe
add_tool("default:axe_wood", "Wooden Axe", true)
add_tool("default:axe_stone", "Stone Axe", true)
add_tool("default:axe_steel", "Steel Axe", true)
add_tool("default:axe_bronze", "Bronze Axe", true)
add_tool("default:axe_mese", "Mese Axe", true)
add_tool("default:axe_diamond", "Diamond Axe", true)

-- Shovel
add_tool("default:shovel_wood", "Wooden Shovel", true)
add_tool("default:shovel_stone", "Stone Shovel", true)
add_tool("default:shovel_steel", "Steel Shovel", true)
add_tool("default:shovel_bronze", "Bronze Shovel", true)
add_tool("default:shovel_mese", "Mese Shovel", true)
add_tool("default:shovel_diamond", "Diamond Shovel", true)

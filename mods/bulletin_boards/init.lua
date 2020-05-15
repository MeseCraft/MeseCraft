-- TODO:
-- There's potential race conditions in here if two players have the board open
-- and a culling happens or they otherwise diddle around with it. For now just
-- make sure it doesn't crash

local S = minetest.get_translator(minetest.get_current_modname())

local bulletin_max = 7*8

local culling_interval = 86400 -- one day in seconds
local culling_min = bulletin_max - 12 -- won't cull if there are this many or fewer bulletins

local bulletin_boards = {}
bulletin_boards.player_state = {}
bulletin_boards.board_def = {}

local path = minetest.get_worldpath() .. "/bulletin_boards.lua"
local f, e = loadfile(path);
if f then
	bulletin_boards.global_boards = f()
else
	bulletin_boards.global_boards = {}
end

local function save_boards()
	local file, e = io.open(path, "w");
	if not file then
		return error(e);
	end
	file:write(minetest.serialize(bulletin_boards.global_boards))
	file:close()
end

local max_text_size = 5000 -- half a book
local max_title_size = 60
local short_title_size = 12

-- gets the bulletins currently on a board
-- and other persisted data
local function get_board(name)
	local board = bulletin_boards.global_boards[name]
	if board then
		return board
	end
	board = {}
	board.last_culled = minetest.get_gametime()
	bulletin_boards.global_boards[name] = board
	return board
end

-- for incrementing through the bulletins on a board
local function find_next(board, start_index)
	local index = start_index + 1
	while index ~= start_index do
		if board[index] then
			return index
		end
		index = index + 1
		if index > bulletin_max then
			index = 1
		end		
	end
	return index
end
local function find_prev(board, start_index)
	local index = start_index - 1
	while index ~= start_index do
		if board[index] then
			return index
		end
		index = index - 1
		if index < 1 then
			index = bulletin_max
		end		
	end
	return index
end

-- Groups bulletins by count-per-player, then picks the oldest bulletin from the group with the highest count.

-- eg, if A has 1 bulletin, B has 2 bulletins, and C has 2 bulletins, then this will pick the oldest
-- bulletin from (B and C)'s bulletins. Returns index and timestamp, or nil if there's nothing.
local function find_most_cullable(board_name)
	local board = get_board(board_name)
	local player_count = {}
	local max_count = 0
	local total = 0
	for i = 1, bulletin_max do
		 local bulletin = board[i]
		 if bulletin then
			total = total + 1
			local player_name = bulletin.owner
			local count = (player_count[player_name] or 0) + 1
			max_count = math.max(count, max_count)
			player_count[player_name] = count		 
		 end
	end
	
	if total <= culling_min then
		return
	end
	
	local max_players = {}
	for player_name, count in pairs(player_count) do
		if count == max_count then
			max_players[player_name] = true
		end
	end
	
	local most_cullable_index
	local most_cullable_timestamp
	for i = 1, bulletin_max do
		local bulletin = board[i]
		if bulletin and max_players[bulletin.owner] then
			if bulletin.timestamp <= (most_cullable_timestamp or bulletin.timestamp) then
				most_cullable_timestamp = bulletin.timestamp
				most_cullable_index = i
			end
		end
	end
	
	return most_cullable_index, most_cullable_timestamp
end

-- safe way to get the description string of an item, in case it's not registered
local function get_item_desc(stack)
	local stack_def = stack:get_definition()
	if stack_def then
		return stack_def.description
	end
	return stack:get_name()
end

-- shows the base board to a player
local function show_board(player_name, board_name)
	local formspec = {}
	local board = get_board(board_name)
	local current_time = minetest.get_gametime()
	
	local intervals = (current_time - board.last_culled)/culling_interval
	local cull_count, remaining_cull_time = math.modf(intervals)
	while cull_count > 0 do
		local cull_index = find_most_cullable(board_name)
		if cull_index then
			board[cull_index] = nil
			cull_count = cull_count - 1
		else
			cull_count = 0
		end
	end
	board.last_culled = current_time - math.floor(culling_interval * remaining_cull_time)
	
	local def = bulletin_boards.board_def[board_name]
	local desc = minetest.formspec_escape(def.desc)
	local tip
	if def.cost then
		local stack = ItemStack(def.cost)
		tip = S("Post your bulletin here for the cost of @1 @2", stack:get_count(), get_item_desc(stack))
		desc = desc .. S(", Cost: @1 @2", stack:get_count(), get_item_desc(stack))
	else
		tip = S("Post your bulletin here")
	end
	
	formspec[#formspec+1] = "size[8,8.5]"
	.. "container[0,0]"
	.. "label[0.0,-0.25;"..desc.."]"
	.. "container_end[]"
	.. "container[0,0.5]"
	local i = 0
	for y = 0, 6 do
		for x = 0, 7 do
			i = i + 1
			local bulletin = board[i] or {}
			local short_title = bulletin.title or ""
			--Don't bother triming the title if the trailing dots would make it longer
			if #short_title > short_title_size + 3 then
				short_title = short_title:sub(1, short_title_size) .. "..."
			end
			local img = bulletin.icon or ""
	
			formspec[#formspec+1] =
				"image_button["..x..",".. y*1.2 ..";1,1;"..img..";button_"..i..";]"
				.."label["..x..","..y*1.2-0.35 ..";"..minetest.formspec_escape(short_title).."]"
			if bulletin.title and bulletin.owner and bulletin.timestamp then
				local days_ago = math.floor((current_time-bulletin.timestamp)/86400)
				formspec[#formspec+1] = "tooltip[button_"..i..";"
					..S("@1\nPosted by @2\n@3 days ago", minetest.formspec_escape(bulletin.title), bulletin.owner, days_ago).."]"
			else
				formspec[#formspec+1] = "tooltip[button_"..i..";"..tip.."]"
			end
		end
	end
	formspec[#formspec+1] = "container_end[]"

	bulletin_boards.player_state[player_name] = {board=board_name}
	minetest.show_formspec(player_name, "bulletin_boards:board", table.concat(formspec))
end

-- shows a specific bulletin on a board
local function show_bulletin(player, board_name, index)
	local board = get_board(board_name)
	local def = bulletin_boards.board_def[board_name]
	local icons = def.icons
	local bulletin = board[index] or {}
	local player_name = player:get_player_name()
	bulletin_boards.player_state[player_name] = {board=board_name, index=index}
	
	local tip
	local has_cost
	if def.cost then
		local stack = ItemStack(def.cost)
		local player_inventory = minetest.get_inventory({type="player", name=player_name})
		tip = S("Post bulletin with this icon at the cost of @1 @2", stack:get_count(), get_item_desc(stack))
		has_cost = player_inventory:contains_item("main", stack)
	else
		tip = S("Post bulletin with this icon")
		has_cost = true
	end
	
	local admin = minetest.check_player_privs(player, "server")
	
	local formspec = {"size[8,8]"
		.."button[0.2,0;1,1;prev;"..S("Prev").."]"
		.."button[6.65,0;1,1;next;"..S("Next").."]"}
	local esc = minetest.formspec_escape
	if ((bulletin.owner == nil or bulletin.owner == player_name) and has_cost) or admin then
		formspec[#formspec+1] = 
			"field[1.5,0.75;5.5,0;title;"..S("Title:")..";"..esc(bulletin.title or "").."]"
			.."textarea[0.5,1.15;7.5,7;text;"..S("Contents:")..";"..esc(bulletin.text or "").."]"
			.."label[0.3,7;"..S("Post:").."]"
		for i, icon in ipairs(icons) do
			formspec[#formspec+1] = "image_button[".. i*0.75-0.5 ..",7.35;1,1;"..icon..";save_"..i..";]"
			.."tooltip[save_"..i..";"..tip.."]"
		end
		formspec[#formspec+1] = "image_button[".. (#icons+1)*0.75-0.25 ..",7.35;1,1;bulletin_boards_delete.png;delete;]"
			.."tooltip[delete;"..S("Delete this bulletin").."]"
			.."label["..(#icons+1)*0.75-0.25 ..",7;"..S("Delete:").."]"
	elseif bulletin.owner then
		formspec[#formspec+1] = 
			"label[1.4,0.5;"..S("Posted by @1", bulletin.owner).."]"
			.."tablecolumns[color;text]"
			.."tableoptions[background=#00000000;highlight=#00000000;border=false]"
			.."table[1.35,0.25;5,0.5;title;#FFFF00,"..esc(bulletin.title or "").."]"
			.."textarea[0.5,1.5;7.5,7;;"..esc(bulletin.text or "")..";]"
			.."button[2.5,7.5;3,1;back;" .. S("Back to Board") .. "]"
		if bulletin.owner == player_name then
			formspec[#formspec+1] = "image_button[".. (#icons+1)*0.75-0.25 ..",7.35;1,1;bulletin_boards_delete.png;delete;]"
				.."tooltip[delete;"..S("Delete this bulletin").."]"
				.."label["..(#icons+1)*0.75-0.25 ..",7;"..S("Delete:").."]"
		end
	else
		return
	end

	minetest.show_formspec(player_name, "bulletin_boards:bulletin", table.concat(formspec))
end

-- interpret clicks on the base board
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "bulletin_boards:board" then return end
	local player_name = player:get_player_name()
	for field, state in pairs(fields) do
		if field:sub(1, #"button_") == "button_" then
			local i = tonumber(field:sub(#"button_"+1))
			local state = bulletin_boards.player_state[player_name]
			if state then
				show_bulletin(player, state.board, i)
			end
			return
		end		
	end	
end)

-- interpret clicks on the bulletin
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "bulletin_boards:bulletin" then return end
	local player_name = player:get_player_name()
	local state = bulletin_boards.player_state[player_name]
	if not state then return end	
	local board = get_board(state.board)
	local def = bulletin_boards.board_def[state.board]
	if not board then return end
	
	-- no security needed on these actions
	if fields.back then
		bulletin_boards.player_state[player_name] = nil
		show_board(player_name, state.board)
	end
	
	if fields.prev then
		local next_index = find_prev(board, state.index)
		show_bulletin(player, state.board, next_index)
		return
	end
	if fields.next then
		local next_index = find_next(board, state.index)
		show_bulletin(player, state.board, next_index)
		return
	end

	if fields.quit then
		minetest.after(0.1, show_board, player_name, state.board)
	end

	-- check if the player's allowed to do the stuff after this
	local admin = minetest.check_player_privs(player, "server")
	local current_bulletin = board[state.index]
	if not admin and (current_bulletin and current_bulletin.owner ~= player_name) then
		-- someone's done something funny. Don't be accusatory, though - could be a race condition
		return
	end
	
	if fields.delete then
		board[state.index] = nil
		fields.title = ""
		save_boards()
	end
	
	local player_inventory = minetest.get_inventory({type="player", name=player_name})
	local has_cost = true
	if def.cost then
		has_cost = player_inventory:contains_item("main", def.cost)
	end
	
	if fields.text ~= "" and (has_cost or admin) then
		for field, _ in pairs(fields) do
			if field:sub(1, #"save_") == "save_" then
				local i = tonumber(field:sub(#"save_"+1))
				local bulletin = {}
				bulletin.owner = player_name
				bulletin.title = fields.title:sub(1, max_title_size)
				bulletin.text = fields.text:sub(1, max_text_size)
				bulletin.icon = def.icons[i]
				bulletin.timestamp = minetest.get_gametime()
				board[state.index] = bulletin
				if not admin and def.cost then
					player_inventory:remove_item("main", def.cost)
				end
				save_boards()
				break
			end
		end
	end

	bulletin_boards.player_state[player_name] = nil
	show_board(player_name, state.board)
end)

-- default icon set
local base_icons = {
	"bulletin_boards_document_comment_above.png",
	"bulletin_boards_document_back.png",
	"bulletin_boards_document_next.png",
	"bulletin_boards_document_image.png",
	"bulletin_boards_document_signature.png",
	"bulletin_boards_to_do_list.png",
	"bulletin_boards_documents_email.png",
	"bulletin_boards_receipt_invoice.png",
}

-- generates a random jumble of icons to superimpose on a bulletin board texture
-- rez is the "working" canvas size. 32-pixel icons get scattered on that canvas
-- before it is scaled down to 16 pixels
local function generate_random_board(rez, count, icons)
	icons = icons or base_icons
	local tex = {"([combine:"..rez.."x"..rez}
	for i = 1, count do
		tex[#tex+1] = ":"..math.random(1,rez-32)..","..math.random(1,rez-32)
			.."="..icons[math.random(1,#icons)]
	end
	tex[#tex+1] = "^[resize:16x16)"
	return table.concat(tex)
end

local function register_board(board_name, board_def)
	bulletin_boards.board_def[board_name] = board_def
	local background = board_def.background or "bulletin_boards_corkboard.png"
	local foreground = board_def.foreground or "bulletin_boards_frame.png"
	local tile = background.."^"..generate_random_board(98, 7, board_def.icons).."^"..foreground
	local bulletin_board_def = {
		description = board_def.desc,
		groups = {choppy=1},
		tiles = {tile},
		inventory_image = tile,
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = {
			type = "wallmounted",
			wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
		},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local player_name = clicker:get_player_name()
			show_board(player_name, board_name)
		end,
		
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", board_def.desc or "")
		end,
	}

	minetest.register_node(board_name, bulletin_board_def)
end

if minetest.get_modpath("default") then

register_board("bulletin_boards:bulletin_board_basic", {
	desc = S("Public Bulletin Board"),
	cost = "default:paper",
	icons = base_icons,
})
minetest.register_craft({
	output = "bulletin_boards:bulletin_board_basic",
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'default:paper', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	},
})

register_board("bulletin_boards:bulletin_board_copper", {
	desc = S("Copper Board"),
	cost = "default:copper_ingot",
	foreground = "bulletin_boards_frame_copper.png",
	icons = base_icons,
})
minetest.register_craft({
	output = "bulletin_boards:bulletin_board_copper",
	recipe = {
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", 'default:paper', "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
	},
})
end
local level_config = {
	['Small'] = { w = 9, h = 9, bomb = 10, icon_size = 0.9 },
	['Small hard'] = { w = 9, h = 9, bomb = 35, icon_size = 0.9},
	['Midsize'] = { w = 16, h = 16, bomb = 40, icon_size = 0.7 },
	['Midsize hard'] = { w = 16, h = 16, bomb = 99, icon_size = 0.7},
	['Big'] = { w = 24, h = 20, bomb = 99, icon_size = 0.58 },
	['Big hard'] = { w = 24, h = 20, bomb = 170, icon_size = 0.58},
}


local sweeper_class = {}
sweeper_class.__index = sweeper_class

function sweeper_class:init(level)
	self.data.level = level
	if not level_config[level] then print('ERROR: WRONG LEVEL', level) end
	local config = level_config[level]
	-- build board
	self.data.board = {}
	self.data.open_all = config.w * config.h - config.bomb
	self.data.open_count = 0
	self.data.bomb_all = config.bomb
	self.data.bomb_count = 0

	local board = self.data.board
	for w = 1, config.w do
		board[w] = {}
		for h = 1, config.h do
			board[w][h] = { count = 0, is_bomb = false, is_revealed = false }
		end
	end

	-- fill board with bombs
	local placed = 0
	while placed < config.bomb do
		local rnd_w = math.random(config.w)
		local rnd_h = math.random(config.h)
		local rndfield = board[rnd_w][rnd_h]
		if not rndfield.is_bomb then
			rndfield.is_bomb = true
			placed = placed + 1
			for w = rnd_w - 1, rnd_w + 1 do
				for h = rnd_h - 1, rnd_h + 1 do
					if board[w] and board[w][h] then
						board[w][h].count = board[w][h].count + 1
					end
				end
			end
		end
	end
end

function sweeper_class:get(sel_w, sel_h)
	local board = self.data.board
	if board[sel_w] then
		return board[sel_w][sel_h]
	end
end

function sweeper_class:reveal(sel_w, sel_h)
	local board = self.data.board
	local sel = self:get(sel_w, sel_h)

	-- unmark bomb
	if sel.bomb_marked then
		self:toggle_bomb_mark(sel_w, sel_h)
	end

	sel.is_revealed = true
	if sel.is_bomb then
		-- Bomb found
		self.data.bomb_count = self.data.bomb_count + 1
	else
		-- No bomb, count empty fields
		self.data.open_count = self.data.open_count + 1
		if sel.count == 0 then
			for w = sel_w - 1, sel_w + 1 do
				for h = sel_h - 1, sel_h + 1 do
					local chk_sel = self:get(w,h)
					if chk_sel and
							not chk_sel.is_revealed and
							not chk_sel.bomb_marked then
						self:reveal(w,h)
					end
				end
			end
		end
	end
end

function sweeper_class:toggle_bomb_mark(sel_w, sel_h)
	local sel = self:get(sel_w, sel_h)
	if sel.bomb_marked then
		self.data.bomb_count = self.data.bomb_count - 1
		sel.bomb_marked = nil
	else
		self.data.bomb_count = self.data.bomb_count + 1
		sel.bomb_marked = true
	end
end

local function get_sweeper(data)
	local self = setmetatable({}, sweeper_class)
	self.data = data
	return self
end


laptop.register_app("tntsweeper", {
	app_name = "TNT Sweeper",
	app_icon = "laptop_tnt.png",
	app_info = "Avoid hitting TNT",
	formspec_func = function(app, mtos)
		local data = mtos.bdev:get_app_storage('ram', 'tntsweeper')
		local sweeper = get_sweeper(data)

		if not sweeper.data.level then
			sweeper:init('Midsize')
		end
		local config = level_config[sweeper.data.level]
		local formspec = ""

		for w = 1, config.w do
			for h = 1, config.h do
				local pos = (w*config.icon_size*0.8)..','..(h*config.icon_size*0.85)
				local field = sweeper.data.board[w][h]
				if not field.is_revealed then
					if field.bomb_marked then
						formspec = formspec .. "image_button["..pos..";"..config.icon_size..","..config.icon_size..";"..mtos.theme.minor_button.."^"..mtos.theme:get_texture("laptop_tnt.png")..";field:"..w..":"..h..";]"
					else
						formspec = formspec .. "image_button["..pos..";"..config.icon_size..","..config.icon_size..";"..mtos.theme.minor_button..";field:"..w..":"..h..";]"
					end
				elseif field.is_bomb then
					formspec = formspec .. "image["..pos..";"..config.icon_size..","..config.icon_size..";"..mtos.theme:get_texture("laptop_boom.png").."]"
				elseif field.count > 0 then
					local lbpos = ((w+0.4)*config.icon_size*0.8)..','..((h+0.1)*config.icon_size*0.85)
					formspec = formspec .. mtos.theme:get_label(lbpos, field.count)
				end
			end
		end

		formspec = formspec .. "background[12,0.5;3,1;"..mtos.theme.contrast_background..']'..
				mtos.theme:get_label("12,0.5", "Open fields: "..sweeper.data.open_count.."/"..sweeper.data.open_all, "contrast")..
				mtos.theme:get_label("12,1", "Bomb: "..sweeper.data.bomb_count.."/"..sweeper.data.bomb_all, "contrast")..
				mtos.theme:get_button('12.5,2;1.5,0.8', 'major', 'reset', 'Small')..
				mtos.theme:get_button('12.5,3;1.5,0.8', 'major', 'reset', 'Small hard')..
				mtos.theme:get_button('12.5,4;1.5,0.8', 'major', 'reset', 'Midsize')..
				mtos.theme:get_button('12.5,5;1.5,0.8', 'major', 'reset', 'Midsize hard')..
				mtos.theme:get_button('12.5,6;1.5,0.8', 'major', 'reset', 'Big')..
				mtos.theme:get_button('12.5,7;1.5,0.8', 'major', 'reset', 'Big hard')
		if data.mark_mode then
			formspec = formspec .. mtos.theme:get_button('12.5,9;1.5,0.8', 'minor', 'mark_mode', 'mark', 'change to reveal mode')
		else
			formspec = formspec .. mtos.theme:get_button('12.5,9;1.5,0.8', 'minor', 'mark_mode', 'reveal', 'change to mark mode')
		end
		return formspec
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'tntsweeper')
		local sweeper = get_sweeper(data)
		local config = level_config[sweeper.data.level]
		for field, _ in pairs(fields) do
			if field:sub(1,6) ==  'field:' then
				local sel_w, sel_h
				for str in field:gmatch("([^:]+)") do
					if str ~= 'field' then
						if not sel_w then
							sel_w = tonumber(str)
						else
							sel_h = tonumber(str)
						end
					end
				end

				--if sender:get_player_control().sneak then -- TODO: test if https://github.com/minetest/minetest/issues/6353
				if data.mark_mode then
					sweeper:toggle_bomb_mark(sel_w, sel_h)
				else
					sweeper:reveal(sel_w, sel_h)
				end
			end
		end

		if fields.reset then
			sweeper:init(minetest.strip_colors(fields.reset))
		elseif fields.mark_mode then
			if data.mark_mode then
				data.mark_mode = nil
			else
				data.mark_mode = true
			end
		end
	end
})

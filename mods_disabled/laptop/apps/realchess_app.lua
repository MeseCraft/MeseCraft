-- Based on https://github.com/minetest-mods/realchess
-- WTFPL by kilbith

local realchess = {}

local function index_to_xy(idx)
	idx = idx - 1
	local x = idx % 8
	local y = (idx - x) / 8
	return x, y
end

local function xy_to_index(x, y)
	return x + y * 8 + 1
end

function realchess.move(data, pos, from_list, from_index, to_list, to_index, _, player)
	if from_list ~= "board" and to_list ~= "board" then
		return 0
	end

	local playerName = player:get_player_name()
	local meta = minetest.get_meta(pos)

	if data.winner ~= "" then
		data.messageOther = "This game is over."
		return 0
	end

	local inv = meta:get_inventory()
	local pieceFrom = inv:get_stack(from_list, from_index):get_name():sub(8) --:sub(8) cuts "laptop:"
	local pieceTo = inv:get_stack(to_list, to_index):get_name():sub(8) --:sub(8) cuts "laptop:"
	local thisMove -- will replace lastMove when move is legal

	if pieceFrom:find("white") then
		if data.playerWhite ~= "" and data.playerWhite ~= playerName then
			data.messageOther = "Someone else plays white pieces!"
			return 0
		end
		if data.lastMove ~= "" and data.lastMove ~= "black" then
			data.messageWhite = "It's not your turn, wait for your opponent to play."
			return 0
		end
		if pieceTo:find("white") then
			-- Don't replace pieces of same color
			return 0
		end
		data.playerWhite = playerName
		thisMove = "white"
	elseif pieceFrom:find("black") then
		if data.playerBlack ~= "" and data.playerBlack ~= playerName then
			data.messageOther = "Someone else plays white pieces!"
			return 0
		end
		if data.lastMove ~= "" and data.lastMove ~= "white" then
			data.messageBlack = "It's not your turn, wait for your opponent to play."
			return 0
		end
		if pieceTo:find("black") then
			-- Don't replace pieces of same color
			return 0
		end
		data.playerBlack = playerName
		thisMove = "black"
	end

	-- DETERMINISTIC MOVING

	local from_x, from_y = index_to_xy(from_index)
	local to_x, to_y = index_to_xy(to_index)

	if pieceFrom:sub(11,14) == "pawn" then
		if thisMove == "white" then
			local pawnWhiteMove = inv:get_stack(from_list, xy_to_index(from_x, from_y - 1)):get_name()
			-- white pawns can go up only
			if from_y - 1 == to_y then
				if from_x == to_x then
					if pieceTo ~= "" then
						return 0
					elseif to_index >= 1 and to_index <= 8 then
						inv:set_stack(from_list, from_index, "laptop:realchess_queen_white")
					end
				elseif from_x - 1 == to_x or from_x + 1 == to_x then
					if not pieceTo:find("black") then
						return 0
					elseif to_index >= 1 and to_index <= 8 then
						inv:set_stack(from_list, from_index, "laptop:realchess_queen_white")
					end
				else
					return 0
				end
			elseif from_y - 2 == to_y then
				if pieceTo ~= "" or from_y < 6 or pawnWhiteMove ~= "" then
					return 0
				end
			else
				return 0
			end

			-- if x not changed,
			--   ensure that destination cell is empty
			-- elseif x changed one unit left or right
			--   ensure the pawn is killing opponent piece
			-- else
			--   move is not legal - abort

			if from_x == to_x then
				if pieceTo ~= "" then
					return 0
				end
			elseif from_x - 1 == to_x or from_x + 1 == to_x then
				if not pieceTo:find("black") then
					return 0
				end
			else
				return 0
			end
		elseif thisMove == "black" then
			local pawnBlackMove = inv:get_stack(from_list, xy_to_index(from_x, from_y + 1)):get_name()
			-- black pawns can go down only
			if from_y + 1 == to_y then
				if from_x == to_x then
					if pieceTo ~= "" then
						return 0
					elseif to_index >= 57 and to_index <= 64 then
						inv:set_stack(from_list, from_index, "laptop:realchess_queen_black")
					end
				elseif from_x - 1 == to_x or from_x + 1 == to_x then
					if not pieceTo:find("white") then
						return 0
					elseif to_index >= 57 and to_index <= 64 then
						inv:set_stack(from_list, from_index, "laptop:realchess_queen_black")
					end
				else
					return 0
				end
			elseif from_y + 2 == to_y then
				if pieceTo ~= "" or from_y > 1 or pawnBlackMove ~= "" then
					return 0
				end
			else
				return 0
			end

			-- if x not changed,
			--   ensure that destination cell is empty
			-- elseif x changed one unit left or right
			--   ensure the pawn is killing opponent piece
			-- else
			--   move is not legal - abort

			if from_x == to_x then
				if pieceTo ~= "" then
					return 0
				end
			elseif from_x - 1 == to_x or from_x + 1 == to_x then
				if not pieceTo:find("white") then
					return 0
				end
			else
				return 0
			end
		else
			return 0
		end

	elseif pieceFrom:sub(11,14) == "rook" then
		if from_x == to_x then
			-- moving vertically
			if from_y < to_y then
				-- moving down
				-- ensure that no piece disturbs the way
				for i = from_y + 1, to_y - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- mocing up
				-- ensure that no piece disturbs the way
				for i = to_y + 1, from_y - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, i)):get_name() ~= "" then
						return 0
					end
				end
			end
		elseif from_y == to_y then
			-- mocing horizontally
			if from_x < to_x then
				-- mocing right
				-- ensure that no piece disturbs the way
				for i = from_x + 1, to_x - 1 do
					if inv:get_stack(from_list, xy_to_index(i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- mocing left
				-- ensure that no piece disturbs the way
				for i = to_x + 1, from_x - 1 do
					if inv:get_stack(from_list, xy_to_index(i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			end
		else
			-- attempt to move arbitrarily -> abort
			return 0
		end

		if thisMove == "white" or thisMove == "black" then
			if pieceFrom:sub(-1) == "1" then
				data.castlingWhiteL = 0
			elseif pieceFrom:sub(-1) == "2" then
				data.castlingWhiteR = 0
			end
		end

	elseif pieceFrom:sub(11,16) == "knight" then
		-- get relative pos
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- sort x and y
		if dx > dy then dx, dy = dy, dx end

		-- ensure that dx == 1 and dy == 2
		if dx ~= 1 or dy ~= 2 then
			return 0
		end
		-- just ensure that destination cell does not contain friend piece
		-- ^ it was done already thus everything ok

	elseif pieceFrom:sub(11,16) == "bishop" then
		-- get relative pos
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- ensure dx and dy are equal
		if dx ~= dy then return 0 end

		if from_x < to_x then
			if from_y < to_y then
				-- moving right-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- moving right-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		else
			if from_y < to_y then
				-- moving left-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- moving left-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		end

	elseif pieceFrom:sub(11,15) == "queen" then
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- ensure valid relative move
		if dx ~= 0 and dy ~= 0 and dx ~= dy then
			return 0
		end

		if from_x == to_x then
			if from_y < to_y then
				-- goes down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		elseif from_x < to_x then
			if from_y == to_y then
				-- goes right
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			elseif from_y < to_y then
				-- goes right-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes right-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		else
			if from_y == to_y then
				-- goes left
				-- ensure that no piece disturbs the way and destination cell does
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			elseif from_y < to_y then
				-- goes left-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes left-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		end

	elseif pieceFrom:sub(11,14) == "king" then
		local dx = from_x - to_x
		local dy = from_y - to_y
		local check = true

		if thisMove == "white" then
			if from_y == 7 and to_y == 7 then
				if to_x == 1 then
					local idx57 = inv:get_stack(from_list, 57):get_name()

					if data.castlingWhiteL == 1 and idx57 == "laptop:realchess_rook_white_1" then
						for i = 58, from_index - 1 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 57, "")
						inv:set_stack(from_list, 59, "laptop:realchess_rook_white_1")
						check = false
					end
				elseif to_x == 6 then
					local idx64 = inv:get_stack(from_list, 64):get_name()

					if data.castlingWhiteR == 1 and idx64 == "laptop:realchess_rook_white_2" then
						for i = from_index + 1, 63 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 62, "laptop:realchess_rook_white_2")
						inv:set_stack(from_list, 64, "")
						check = false
					end
				end
			end
		elseif thisMove == "black" then
			if from_y == 0 and to_y == 0 then
				if to_x == 1 then
					local idx1 = inv:get_stack(from_list, 1):get_name()

					if data.castlingBlackL == 1 and idx1 == "laptop:realchess_rook_black_1" then
						for i = 2, from_index - 1 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 1, "")
						inv:set_stack(from_list, 3, "laptop:realchess_rook_black_1")
						check = false
					end
				elseif to_x == 6 then
					local idx8 = inv:get_stack(from_list, 1):get_name()

					if data.castlingBlackR == 1 and idx8 == "laptop:realchess_rook_black_2" then
						for i = from_index + 1, 7 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 6, "laptop:realchess_rook_black_2")
						inv:set_stack(from_list, 8, "")
						check = false
					end
				end
			end
		end

		if check then
			if dx < 0 then dx = -dx end
			if dy < 0 then dy = -dy end
			if dx > 1 or dy > 1 then return 0 end
		end

		if thisMove == "white" then
			data.castlingWhiteL = 0
			data.castlingWhiteR = 0
		elseif thisMove == "black" then
			data.castlingBlackL = 0
			data.castlingBlackR = 0
		end
	end

	data.lastMove = thisMove
	data.lastMoveTime = minetest.get_gametime()

	if data.lastMove == "black" then
		data.messageWhite = "["..os.date("%H:%M:%S").."] "..
				playerName.." moved a "..pieceFrom:match("_(%a+)")..", it's now your turn."
	elseif data.lastMove == "white" then
		data.messageBlack = "["..os.date("%H:%M:%S").."] "..
				playerName.." moved a "..pieceFrom:match("_(%a+)")..", it's now your turn."
	end

	if pieceTo:sub(11,14) == "king" then
		data.messageWhite =  playerName.." won the game."
		data.messageBlack =  playerName.." won the game."
		data.winner = thisMove
	end

	return 1
end

local function timeout_format(timeout_limit)
	local time_remaining = timeout_limit - minetest.get_gametime()
	local minutes = math.floor(time_remaining / 60)
	local seconds = time_remaining % 60

	if minutes == 0 then return seconds.." sec." end
	return minutes.." min. "..seconds.." sec."
end

local function register_piece(name, count)
	for _, color in pairs({"black", "white"}) do
	if not count then
		minetest.register_craftitem("laptop:realchess_"..name.."_"..color, {
			description = color:gsub("^%l", string.upper).." "..name:gsub("^%l", string.upper),
			inventory_image = "laptop_realchess_"..name.."_"..color..".png",
			stack_max = 1,
			groups = {not_in_creative_inventory=1}
		})
	else
		for i = 1, count do
			minetest.register_craftitem("laptop:realchess_"..name.."_"..color.."_"..i, {
				description = color:gsub("^%l", string.upper).." "..name:gsub("^%l", string.upper),
				inventory_image = "laptop_realchess_"..name.."_"..color..".png",
				stack_max = 1,
				groups = {not_in_creative_inventory=1}
			})
		end
	end
	end
end

register_piece("pawn", 8)
register_piece("rook", 2)
register_piece("knight", 2)
register_piece("bishop", 2)
register_piece("queen")
register_piece("king")


-- Laptop app registration
	laptop.register_app("realchess", {
		app_name = "Realchess",
		app_icon = "laptop_realchess_chessboard_icon.png",
		app_info = "A Chess game",
		os_min_version = "5.51",
		formspec_func = function(app, mtos)
			local data = mtos.bdev:get_app_storage('ram', 'realchess')
			if not data.init_done then
				data.init_done = true
				-- Initialize the game
				data.playerBlack = ""
				data.playerWhite = ""
				data.lastMove = ""
				data.winner = ""

				data.lastMoveTime = 0
				data.castlingBlackL = 1
				data.castlingBlackR = 1
				data.castlingWhiteL = 1
				data.castlingWhiteR = 1

				local meta = minetest.get_meta(mtos.pos)
				local inv = meta:get_inventory()
				inv:set_size("board", 64)
				inv:set_list("board", {
					"laptop:realchess_rook_black_1",
					"laptop:realchess_knight_black_1",
					"laptop:realchess_bishop_black_1",
					"laptop:realchess_queen_black",
					"laptop:realchess_king_black",
					"laptop:realchess_bishop_black_2",
					"laptop:realchess_knight_black_2",
					"laptop:realchess_rook_black_2",
					"laptop:realchess_pawn_black_1",
					"laptop:realchess_pawn_black_2",
					"laptop:realchess_pawn_black_3",
					"laptop:realchess_pawn_black_4",
					"laptop:realchess_pawn_black_5",
					"laptop:realchess_pawn_black_6",
					"laptop:realchess_pawn_black_7",
					"laptop:realchess_pawn_black_8",
					'','','','','','','','','','','','','','','','',
					'','','','','','','','','','','','','','','','',
					"laptop:realchess_pawn_white_1",
					"laptop:realchess_pawn_white_2",
					"laptop:realchess_pawn_white_3",
					"laptop:realchess_pawn_white_4",
					"laptop:realchess_pawn_white_5",
					"laptop:realchess_pawn_white_6",
					"laptop:realchess_pawn_white_7",
					"laptop:realchess_pawn_white_8",
					"laptop:realchess_rook_white_1",
					"laptop:realchess_knight_white_1",
					"laptop:realchess_bishop_white_1",
					"laptop:realchess_queen_white",
					"laptop:realchess_king_white",
					"laptop:realchess_bishop_white_2",
					"laptop:realchess_knight_white_2",
					"laptop:realchess_rook_white_2"
				})
			end
			local formspec =
					"bgcolor[#080808BB;true]background[3,1;8,8;laptop_realchess_chess_bg.png]"..
					mtos.theme:get_button('12,1;2,2', 'major', 'new', 'New Game', 'Start a new game')..
					"list[context;board;3,1;8,8;]"..
					"listcolors[#00000000;#00000000;#00000000;#30434C;#FFF]"
					if data.messageOther then
						formspec = formspec..mtos.theme:get_label('4,9.3', mtos.sysram.current_player.." "..data.messageOther)
					else
						formspec=formspec..
								mtos.theme:get_label('2,0.3', data.playerBlack.." "..(data.messageBlack or ""))..
								mtos.theme:get_label('4,9.3', data.playerWhite.." "..(data.messageWhite or ""))
					end
					return formspec
		end,

		receive_fields_func = function(app, mtos, sender, fields)
			local data = mtos.bdev:get_app_storage('ram', 'realchess')
			local playerName = sender:get_player_name()
			local timeout_limit = (data.lastMoveTime or 0) + 300

			if fields.quit then return end

			data.messageBlack = nil
			data.messageWhite = nil
			data.messageOther = nil

			-- timeout is 5 min. by default for resetting the game (non-players only)
			if fields.new and (data.playerWhite == playerName or data.playerBlack == playerName) then
				data.init_done = nil
			elseif fields.new and data.lastMoveTime ~= 0 and minetest.get_gametime() >= timeout_limit and
					(data.playerWhite ~= playerName or data.playerBlack ~= playerName) then
				data.init_done = nil
			else
				data.messageOther = "[!] You can't reset the chessboard, a game has been started.\n"..
						"If you are not a current player, try again in "..timeout_format(timeout_limit)
			end
		end,
		allow_metadata_inventory_move = function(app, mtos, player, from_list, from_index, to_list, to_index, count)
			local data = mtos.bdev:get_app_storage('ram', 'realchess')

			data.messageBlack = nil
			data.messageWhite = nil
			data.messageOther = nil

			local ret = realchess.move(data, mtos.pos, from_list, from_index, to_list, to_index, count, player), false  --reshow = true
			minetest.after(0, mtos.set_app, mtos, mtos.sysram.current_app) -- refresh screen
			return ret
		end,
		on_metadata_inventory_move = function(app, mtos, player, from_list, from_index, to_list, to_index, count)
			local inv = minetest.get_meta(mtos.pos):get_inventory()
			inv:set_stack(from_list, from_index, '')
			return false
		end,
		allow_metadata_inventory_take = function()
			return 0
		end,
	})

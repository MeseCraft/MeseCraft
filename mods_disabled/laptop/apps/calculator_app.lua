laptop.register_app("calculator", {
	app_name = "Calculator",
	app_icon = "laptop_calculator.png",
	app_info = "Perform Mathematical Calculations",
	formspec_func = function(app, mtos)
		local data = mtos.bdev:get_app_storage('ram', 'calculator')

		if not data.tab then
			data.tab = {}
		end
		if not data.tab[1] then
			table.insert(data.tab, {})
		end

		local formspec = mtos.theme:get_tableoptions(false).."tablecolumns[" ..
			"text,align=right,padding=1.5,width=10;".. -- first value
			"text,align=right,padding=1.5;".. -- operator
			"text,align=right,padding=1.5,width=10]".. -- last value
			"table[3.9,0.8;7,2;tab;"

		for idx,entry in ipairs(data.tab) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..(entry.var1 or "")..","..(entry.operator or "")..","..(entry.var2 or "")
		end

		formspec = formspec .. ";"..#data.tab.."]"..
				mtos.theme:get_button('4,3;1,1', "minor", 'number', '1') ..
				mtos.theme:get_button('5,3;1,1', "minor", 'number', '2') ..
				mtos.theme:get_button('6,3;1,1', "minor", 'number', '3') ..
				mtos.theme:get_button('4,4;1,1', "minor", 'number', '4') ..
				mtos.theme:get_button('5,4;1,1', "minor", 'number', '5') ..
				mtos.theme:get_button('6,4;1,1', "minor", 'number', '6') ..
				mtos.theme:get_button('4,5;1,1', "minor", 'number', '7') ..
				mtos.theme:get_button('5,5;1,1', "minor", 'number', '8') ..
				mtos.theme:get_button('6,5;1,1', "minor", 'number', '9') ..
				mtos.theme:get_button('4,6;1,1', "minor", 'number', '0') ..
				mtos.theme:get_button('5,6;1,1', "minor", 'number', '.') ..
				mtos.theme:get_button('6,6;1,1', "minor", 'minus', '+/-') ..

				mtos.theme:get_button('4,7;1,1',"minor", 'constant_pi', "PI")..
				mtos.theme:get_button('5,7;1,1', "minor", 'constant_e', "e")..
				mtos.theme:get_button('6,7;1,1', "minor", 'rnd', "RND")..

				mtos.theme:get_button('8,3;1,1', "minor", 'operator', '+') ..
				mtos.theme:get_button('8,4;1,1', "minor", 'operator', '-') ..
				mtos.theme:get_button('8,5;1,1', "minor", 'operator', '/') ..
				mtos.theme:get_button('8,6;1,1', "minor", 'operator', '*') ..
				mtos.theme:get_button('8,7;1,1', "minor", 'operator', '^') ..
				mtos.theme:get_button('9,6;2,1', "minor", 'operator', '=') ..

				mtos.theme:get_button('9,3;2,1', "minor", 'del_char', 'DEL-1') ..
				mtos.theme:get_button('9,4;2,1', "minor", 'del_line', 'DEL-L') ..
				mtos.theme:get_button('9,5;2,1', "minor", 'del_all', 'DEL-A')
		return formspec
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'calculator')
		local entry = data.tab[#data.tab]

		if fields.number then
			-- simple number entry. With check for valid value
			local new_val = (entry.var2 or "")..minetest.strip_colors(fields.number)
			if tonumber(new_val) then
				entry.var2 = new_val
			end
		elseif fields.minus then
			if entry.var2 then
				entry.var2 = tostring(-tonumber(entry.var2))
			else
				entry.var2 = '-0'
			end
		elseif fields.constant_pi then
			entry.var2 = tostring(math.pi)
		elseif fields.constant_e then
			entry.var2 = tostring(math.exp(1))
		elseif fields.rnd then
			entry.var2 = tostring(math.random())
		elseif fields.del_char then
			-- delete char
			if entry.var2 then
				-- remove char from current number
				entry.var2 = entry.var2:sub(1, -2)
				if not tonumber(entry.var2) then
					entry.var2 = nil
				end
			else
				-- get previous number
				if #data.tab > 1 then
					-- go back to previous line if exists
					table.remove(data.tab, #data.tab)
				else
					-- get from left site if first entry
					entry.var2 = entry.var1
					entry.operator = nil
					entry.var1 = nil
				end
			end
		elseif fields.del_line then
			-- just delete full number if exists
			if entry.var2 then
				entry.var2 = nil
			else
				-- go back to previous line and delete the full number if exists
				table.remove(data.tab, #data.tab)
				if #data.tab > 0 then
					entry = data.tab[#data.tab]
					entry.var2 = nil
				end
			end
		elseif fields.del_all then
			data.tab = nil
		elseif fields.operator then
			fields.operator = minetest.strip_colors(fields.operator)
			-- no previous operator
			if not entry.operator then
				if fields.operator == '=' and (entry.var1 or entry.var2) then
					table.insert(data.tab, {}) -- add empty line
				elseif entry.var2 then
					-- move to the left
					entry.var1 = entry.var2
					entry.operator = fields.operator
					entry.var2 = nil
				end
			-- process previous operator
			else
				local result
				if entry.var2 then
					-- both values available
					if entry.operator == '+' then
						result = tonumber(entry.var1) + tonumber(entry.var2)
					elseif entry.operator == '-' then
						result = tonumber(entry.var1) - tonumber(entry.var2)
					elseif entry.operator == '/' then
						result = tonumber(entry.var1) / tonumber(entry.var2)
					elseif entry.operator == '*' then
						result = tonumber(entry.var1) * tonumber(entry.var2)
					elseif entry.operator == '^' then
						result = tonumber(entry.var1) ^ tonumber(entry.var2)
					elseif entry.operator == '=' then
						result = tonumber(entry.var2)
					end
				else
					if entry.operator == '-' then
						result = - tonumber(entry.var1)
					end
				end
				if result then
					if fields.operator == '=' then
						table.insert(data.tab, {var2 = tostring(result)})
					else
						table.insert(data.tab, {var1 = tostring(result), operator = fields.operator})
					end
				end
			end
		end
	end
})

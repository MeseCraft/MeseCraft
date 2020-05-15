--[[
	Hidden Doors - Adds various wood, stone, etc. doors.
	Copyright © 2017, 2019 Hamlet <hamlatmesehub@riseup.net> and contributors.

	Licensed under the EUPL, Version 1.2 or – as soon they will be
	approved by the European Commission – subsequent versions of the
	EUPL (the "Licence");
	You may not use this work except in compliance with the Licence.
	You may obtain a copy of the Licence at:

	https://joinup.ec.europa.eu/software/page/eupl
	https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863

	Unless required by applicable law or agreed to in writing,
	software distributed under the Licence is distributed on an
	"AS IS" basis,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.
	See the Licence for the specific language governing permissions
	and limitations under the Licence.

--]]


--
-- General variables
--

local s_ModPath = minetest.get_modpath("hidden_doors")


-- Hidden Doors' operation mode
local b_HiddenDoorsRemover = minetest.settings:get_bool("b_HiddenDoorsRemover")

if (b_HiddenDoorsRemover == nil) then
	b_HiddenDoorsRemover = false
end

if (b_HiddenDoorsRemover == false) then
	dofile(s_ModPath .. "/main.lua")

else
	dofile(s_ModPath .. "/remover.lua")

end


--
-- Minetest engine debug logging
--

local s_LogLevel = minetest.settings:get("debug_log_level")

if (s_LogLevel == nil)
or (s_LogLevel == "action")
or (s_LogLevel == "info")
or (s_LogLevel == "verbose")
then
	s_LogLevel = nil
	minetest.log("action", "[Mod] Hidden Doors [v1.12.0] loaded.")
end

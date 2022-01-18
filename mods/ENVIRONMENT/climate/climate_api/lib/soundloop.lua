local soundloop = {}
local sounds = {}

local function parse_sound(sound)
	if type(sound) == "string" then
		return { name = sound, gain = 1, pitch = 1 }
	end
	if sound.gain == nil then sound.gain = 1 end
	if sound.pitch == nil then sound.pitch = 1 end
	return sound
end

soundloop.play = function(player, sound, fade)
	sound = parse_sound(sound)
	if fade == nil then fade = 1 end
	local step
	local handle
	local start_gain
	if sounds[player] == nil then sounds[player] = {} end
	if sounds[player][sound.name] == nil then
		step = sound.gain / fade
		start_gain = 0
	elseif sounds[player][sound.name] ~= sound.gain then
		minetest.sound_stop(sounds[player][sound.name].handle)
		start_gain = sounds[player][sound.name].gain
		local change = sound.gain - start_gain
		step = change / fade
	else
		return
	end
	handle = minetest.sound_play(sound.name, {
		to_player = player,
		loop = true,
		gain = 0
	})
	sounds[player][sound.name] = {
		gain = sound.gain,
		handle = handle
	}
	minetest.sound_fade(handle, step, sound.gain)
	return handle
end

soundloop.stop = function(player, sound, fade)
	sound = parse_sound(sound)
	if sounds[player] == nil or sounds[player][sound.name] == nil then
		return
	end
	if fade == nil then fade = 1 end
	local handle = sounds[player][sound.name].handle
	local step = -sounds[player][sound.name].gain / fade
	minetest.sound_fade(handle, step, 0)
	sounds[player][sound.name].gain = 0
	minetest.after(fade, minetest.sound_stop, handle)
end

return soundloop
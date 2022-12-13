--[[
# Particle Effect
Use this effect to render downfall or similar visuals using particles.
Expects a table as the parameter containing information for the spawner.
All values for ParticleSpawner definitions are valid.
See https://minetest.gitlab.io/minetest/definition-tables/#particlespawner-definition

Furthermore, the following default values have been changed:
- time <int> [0.5] (reduced time results in smoother position updates, but more lag)
- collisiondetection <bool> [true]
- collision_removal <bool> [true]
- playername <string> [current player] (Set to empty string to show for everyone)
- vertical <bool> [nil] (Unless explicitly set, particle facing rotation will be automatically set based on direction of velocity)

The following optional values have been introduced for convenience:
- boxsize <vector> [nil] (Overrides minpos and maxpos based on specified sizes per direction with the player in the center)
- boxsize <number> [nil] (If set to a number, the resulting vector will have the specified size in all directions)
- v_offset <int> [0] (Use in conjunctin with boxsize. Adds specified height to minpos and maxpos y-coordinates)
- attach_to_player <bool> [false] (Overrides attached object with current player)

The following optional values have been expanded with additional value types for convenience:
- size <int> [nil] (Overrides both minsize and maxsize if set)
- minvel <int> [nil] (Overrides minvel with a downward facing vector of specified length)
- maxvel <int> [nil] (Overrides maxvel with a downward facing vector of specified length)
- velocity <vector | int> [nil] (Overrides both minvel and maxvel if set)
- minacc <int> [nil] (Overrides minacc with a downward facing vector of specified length)
- maxacc <int> [nil] (Overrides maxacc with a downward facing vector of specified length)
- acceleration <vector | int> [nil] (Overrides both minacc and maxacc if set)

The following new behaviours have been introduced:
- use_wind <bool> [true] (Adjusts velocity and position for current windspeed)
- detach <bool> [false] (Unless enabled, considers positions as relative to current player as if spawner's position would be attached)
- adjust_for_velocity <bool> [true] (Corrects position of particle spawner by player's movement speed. Only applicable if detach = false and not manually attached)
]]

if not climate_mod.settings.particles then return end

local EFFECT_NAME = "climate_api:particles"
local CYCLE_LENGTH = climate_api.SHORT_CYCLE

-- parse config by injecting default values and adding additional parameters
local function parse_config(player, particles)
	-- override default values with more useful ones
	local defaults = {
		time = 0.5,
		collisiondetection = true,
		collision_removal = true,
		playername = player:get_player_name(),
		use_wind = true,
		attach_to_player = false,
		detach = false,
		adjust_for_velocity = true
	}

	-- inject missing default values into specified config
	local config = climate_api.utility.merge_tables(defaults, particles)

	-- scale particle amount based on mod config
	if particles.amount ~= nil then
		config.amount = particles.amount * climate_mod.settings.particle_count
	end

	-- restore default visibility if specified
	if particles.playername == "" then
		config.playername = nil
	end

	-- provide easier param for exptime
	if particles.expirationtime ~= nil then
		config.minexptime = particles.expirationtime
		config.maxexptime = particles.expirationtime
		config.expirationtime = nil
	end

	-- provide easier param for size
	if particles.size ~= nil then
		config.minsize = particles.size
		config.maxsize = particles.size
		config.size = nil
	end

	-- randomly select a texture when given a table
	if type(particles.texture) == "table" then
		config.texture = particles.texture[math.random(#particles.texture)]
	end

	if particles.pos ~= nil then
		config.minpos = particles.pos
		config.maxpos = particles.pos
		config.pos = nil
	end

	-- provide easier size based param for position
	if type(particles.boxsize) == "number" then
		particles.boxsize = {
			x = particles.boxsize,
			y = particles.boxsize,
			z = particles.boxsize
		}
	end

	if particles.boxsize ~= nil then
		local size_x = particles.boxsize.x or 0
		local size_y = particles.boxsize.y or 0
		local size_z = particles.boxsize.z or 0
		local v_offset = particles.v_offset or 0
		v_offset = v_offset + (size_y / 2)
		config.minpos = {
			x = -size_x / 2,
			y = v_offset - (size_y / 2),
			z = -size_z / 2
		}
		config.maxpos = {
			x = size_x / 2,
			y = v_offset + (size_y / 2),
			z = size_z / 2
		}
		config.size_x = nil
		config.size_y = nil
		config.size_z = nil
		config.v_offset = nil
	end

	-- provide easy param to define unanimous falling speed
	if particles.velocity ~= nil then
		particles.minvel = particles.velocity
		particles.maxvel = particles.velocity
		config.velocity = nil
	end

	if type(particles.minvel) == "number" then
		config.minvel = { x = 0, y = -particles.minvel, z = 0 }
	end

	if type(particles.maxvel) ~= nil then
		config.maxvel = { x = 0, y = -particles.maxvel, z = 0 }
	end

	-- provide easy param to define unanimous falling acceleration
	if particles.acceleration ~= nil then
		particles.minacc = particles.acceleration
		particles.maxacc = particles.acceleration
		config.acceleration = nil
	end

	if type(particles.minacc) == "number" then
		config.minacc = { x = 0, y = -particles.minacc, z = 0 }
	end

	if type(particles.maxacc) == "number" then
		config.maxacc = { x = 0, y = -particles.maxacc, z = 0 }
	end

	-- attach particles to current player if specified
	if config.attach_to_player then
		config.attached = player
	end
	config.attach_to_player = nil

	-- attach coordinates to player unless specified or already attached
	if (not config.detach) and config.attached == nil then
		local ppos = player:get_pos()
		config.minpos = vector.add(config.minpos, ppos)
		config.maxpos = vector.add(config.maxpos, ppos)

		-- correct spawn coordinates to adjust for player movement
		if config.adjust_for_velocity then
			local velocity = player:get_player_velocity()
			config.minpos = vector.add(config.minpos, velocity)
			config.maxpos = vector.add(config.maxpos, velocity)
		end
	end
	config.detach = nil
	config.adjust_for_velocity = nil

	-- move particles in wind direction
	if config.use_wind then
		local pos = vector.multiply(vector.add(config.minpos, config.maxpos), 0.5)
		local wind = climate_api.environment.get_wind(pos)
		-- adjust velocity to include wind
		config.minvel = vector.add(config.minvel, wind)
		config.maxvel = vector.add(config.maxvel, wind)

		-- adjust spawn position for better visibility
		local vel = vector.multiply(vector.add(config.minvel, config.maxvel), 0.5)
		local windpos = vector.multiply(
			vector.normalize(vel),
			-vector.length(wind)
		)
		config.minpos = vector.add(config.minpos, windpos)
		config.maxpos = vector.add(config.maxpos, windpos)
	end
	config.use_wind = nil

	-- if unspecified, use 2D or 3D rotation based on movement direction
	if particles.vertical == nil then
		local vel = vector.multiply(vector.add(config.minvel, config.maxvel), 0.5)
		config.vertical = math.abs(vector.normalize(vel).y) >= 0.6
	end

	return config
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		for weather, value in pairs(data) do
			local config = parse_config(player, value)
			minetest.add_particlespawner(config)
		end
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.set_effect_cycle(EFFECT_NAME, CYCLE_LENGTH)
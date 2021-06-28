# API Documentation

## How to read this document
If a function states multiple parameters of the same name then either of them has to be passed on function call. Look at the function signature to determine the order of required parameters. So far, all parameters are mandatory.

## Custom Weather Registration

### Register Weather Preset
``climate_api.register_weather(name, conditions, effects)``

Invoke this function in order to create and register a new weather preset. Presets control which effects are to be applied to a player under specific circumstances. As an example, a preset for rain could require a high level of humidity and apply particle and sound effects.

__Parameters__:
- ``name <string>``: A unique identifier resembling the new weather preset.
	Should be prefixed with the mod's name in a way that could look like ``mymod:awesome_weather``. This name should only be used once.
- ``conditions <table>``: An associative array that checks weather influences for specified values. Keys should be the name of an influence, values should be of matching type for repective influence. Keys can be prefixed with ``min_`` to accept any value equal or higher than influence value. A prefix of ``max_`` will accept any value lesser than influence value. A prefix of ``has_`` can be used in conjunction with a numeric array as a value. It will accept any influence value that is present in the specified table. Omitting a prefix will accept the specified value only. All table entries have to be matched positively for the weather preset to be applied.
- ``conditions <function>``: For more control, a function can be specified instead of a conditions table. The function will receive a table as its first parameter, consisting of key-value pairs indicating the current value for each weather influence. The function is expected to return true if the weather preset is to be applied or false otherwise.
- ``effects <table>``: An associative array indicating which weather effects are to be applied whenever the weather preset is active. The key should be a registered weather effect name. The value will be passed as a parameter to the effect. Look at the documentation of individual effects to determine valid values.
- ``effects <function>``: A generator function that returns a set of weather effects and its parameters. This function will receive a table as its first parameter, consisting of key-value pairs indicating the current value for each weather influence. It is expected to return a table in the same fashion as ``effects <table>`` would have looked like.

__Returns__: ``nil``


### Register Weather Effect
``climate_api.register_effect(name, handler, htype)``

__Parameters__:
- ``name <string>``: A unique identifier resembling the new weather effect.
	Should be prefixed with the mod's name in a way that could look like ``mymod:special_effect``. Call this function multiple times with the same name in order to apply multiple handler methods to the same effect.
- ``handler <function>``: This function will be called whenever players are affected by the registered effect. It receives a single parameter containing an accociative array. The keys represent player names and the values represent the set of applied preset parameters. This set is an accociative array as well with the keys representing the names of applied weather presets and the values representing the supplied data from those presets. This parameter could look like this:
``{ singleplayer = {"mymod:awesome_weather" = "a", "mymod:amazing_weather" = "b"} }``. If ``htype`` is ``tick`` then the list of players represents all currently affected players. If it is ``start`` or ``end`` then the list contains all players going though that change.
- ``htype <"start" | "tick" | "end">``: Determines when the handler will be called. ``start`` results in a callback whenever an effect is applied to at least one player, meaning that the very first weather preset applies it. ``tick`` results in a callback every update cycle as long as at least one player has the effect from at least one preset. ``end`` results in a callback whenever at least one player loses the effect completely.

__Returns__: ``nil``


### Set Update Cycle for Effect
``climate_api.set_effect_cycle(name, cycle)``

__Parameters__:
- ``name <string>``: The identifier of a registered weather effect
- ``cycle <number>``: The minimal time between update calls to registered effect handlers in seconds. This value defaults to ``climate_api.DEFAULT_CYCLE`` (2.0s). Other values are ``climate_api.SHORT_CYCLE`` (0s) for frequent update calls (like for particle effects) and ``climate_api.LONG_CYCLE`` (5.0s) for ressource intensive tasks and timed effects (like lightning strikes). You can also use any other custom number representing the amount of time in seconds.

__Returns__: ``nil``

### Register Global Environment Influence
``climate_api.register_global_influence(name, func)``

__Parameters__:
- ``name <string>`` A unique name identifying the registered influence
- ``func <function>``: A generator function that returns some value which is in turn supplied to weather presets and can be used as a condition.

__Returns__: ``nil``

### Register Local Environment Influence
``climate_api.register_influence(name, func)``

__Parameters__:
- ``name <string>`` A unique name identifying the registered influence
- ``func <function>``: A generator function that returns some value which is in turn supplied to weather presets and can be used as a condition. This function will receive a vector as its single parameter indicating the current position.

__Returns__: ``nil``

### Register Active Block Modifier
``climate_api.register_abm(config)``


## Environment Access

### Get Temperature At Position
``climate_api.environment.get_heat(pos)``

__Parameter__: ``pos <vector>``: Coordinates of requested location

__Returns__: ``<number>`` indicating current temperature in °F

### Get Humidity At Position
``climate_api.environment.get_humidity(pos)``

__Parameter__: ``pos <vector>``: Coordinates of requested location

__Returns__: ``<number>`` indicating current humidity

### Get Current Windspeed
``climate_api.environment.get_wind(pos)``

__Parameter__: ``pos <vector>``: Coordinates of requested location. Right now, only y-coordinate is used.

__Returns__: ``<vector>`` indicating speed and direction

### Get Active Weather Presets
``climate_api.environment.get_weather_presets(player)``

### Get Active Weather Effects
``climate_api.environment.get_effects(player)``


## Skybox Modification

### Add Sky Configuration Layer
``climate_api.skybox.add(playername, name, sky)``

### Remove Sky Configuration Layer
``climate_api.skybox.remove(playername, name)``

### Update Player Sky
``climate_api.skybox.update(playername)``


## Player Physics Modifications
Climate API provides an easy way of modfying player physics in a compatible way.
The API is similar to those of ``player_monoids`` or ``playerphysics`` because it also uses multiplication to account for multiple modifiers.
In fact, these functions use ``player_monoids`` under the hud if that mod is available. If not, they will fall back to ``playerphysics``, ``pova``, or native overrides in that order.

### Add Physics Modifier
``climate_api.player_physics.add(id, player, effect, value)``

Register a new modifier that will be multiplied with the current value to set the new physics factor. Call this function again with the same id in order to change an existing modifier.

__Parameters__:
- ``id <string>``: A unique name used to identify the modifier. Should be prefixed with the mod's name.
- ``player <ObjectRef>``: The player affected by the physics change
- ``effect <"speed" | "jump" | "gravity">``: The type of physics to be changed
- ``value <number>``: The multiplicator. Use values between 0 and 1 to reduce physics attribute. Use values above 1 to increase it.

__Returns__: ``nil``

### Remove Physics Modifier
``climate_api.player_physics.remove(id, player, effect)``

Use this function to completely remove a physics modifer from the attribute calculation.

__Parameters__:
- ``id <string>``: The name used in ``player_physics.add`` that identifies a registered modifier
- ``player <ObjectRef>``: The player affected by the physics change
- ``effect <"speed" | "jump" | "gravity">``: The type of physics to be changed

__Returns__: ``nil``


## Utility Functions

### Merge Tables
``climate_api.utility.merge_tables(a, b)``

This function will merge two given accociative tables and return the result.
If in conflict, attributes of table B will override those of table A.
This is especially useful when assigning default values to a specified configuration with possibly missing entries.
Note that this function will also modify table A. If you want to prevent that, you should copy the table first: ``climate_api.utility.merge_tables(table.copy(a), b)``.

__Parameters__:
- ``a <table>``: The base table consisting of default values or other data
- ``b <table>``: The prioritized table to merge with, and possibly override A

__Returns__: ``<table>`` consisting of all attributes from A and B.

### Limit Numeric Boundaries
``climate_api.utility.rangelim(value, min, max)``

This function will return the specified value if it falls in range between minimum and maximum. Otherwise, it will return the closest boundary.

__Parameter__:
- ``value <number>``: The number to check and return
- ``min <number>``: The lower boundary
- ``max <number>``: The upper boundary

__Returns__: ``<number>`` being either the value or the closest boundary

### Statistical Sigmoid Function
``climate_api.utility.sigmoid(value, max, growth, midpoint)``

This method provides a logistic function that will result in growing return values for greater input values. The resulting function graph will look like an S and fall in range between ``0`` and ``max``. You can adjust the curve by specifying growth rate and midpoint.

__Parameters__:
- ``value <number>``: x value supplied to the function
- ``max <number>``: Maximum return value
- ``growth <number>``: Logistic growth rate
- ``midpoint <number>`` Return value for ``value = 0`` and function midpoint

__Returns__: ``<number>`` indicating y coordinate of logistic function

### Normalized Sinus Cycle
``climate_api.utility.normalized_cycle(value)``

This function provides an easy way to generate a simple curve with a maximal turning point of ``y = 1`` located at ``value = 0`` and the lowest points of ``y = 0`` at ``value = +/- 1``.

__Parameter__: ``value <number>``: The supplied x coordinate

__Returns__: ``<number>`` indicating resulting y coordinate between ``0`` and ``1``.
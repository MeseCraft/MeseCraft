
# Skybox management mod


## Cave example

```lua
-- earth caves
skybox.register({
	name = "earth_cave",
	miny = -32000,
	maxy = -50,
	gravity = 1,
	sky_type = "plain",
	sky_color = {r=0, g=0, b=0}
})
```


## Space example
* fly mod

```lua
skybox.register({
	-- https://github.com/Ezhh/other_worlds/blob/master/skybox.lua
	name = "deepspace",
	miny = 6001,
	maxy = 10999,
	gravity = 0.1,
	always_day = true,
	fly = true,
	textures = {
		"sky_pos_z.png",
		"sky_neg_z.png^[transformR180",
		"sky_neg_y.png^[transformR270",
		"sky_pos_y.png^[transformR270",
		"sky_pos_x.png^[transformR270",
		"sky_neg_x.png^[transformR90"
	}
})

```

## Custom matcher

TODO

## Custom skybox function

TODO

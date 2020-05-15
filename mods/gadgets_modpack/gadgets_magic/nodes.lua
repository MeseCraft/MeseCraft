minetest.register_node("gadgets_magic:magic_lantern", {
    description = "Magic Lantern",
    tiles = {"gadgets_magic_magic_lantern.png"},
    drop = "",
    light_source = 12,
    groups = {not_in_creative_inventory = 1, cracky=1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("gadgets_magic:magic_bridge", {
    description = "Magic Bridge Block",
    tiles = {"gadgets_magic_magic_bridge_node.png"},
    drawtype = "glasslike",
    diggable = false,
    walkable = true,
    pointable = false,
    sunlight_propagades = true,
    drop = "",
    light_source = 10,
    groups = {not_in_creative_inventory = 1},
    sounds = default.node_sound_stone_defaults(),
    on_timer = function(pos, elapsed)
        minetest.add_particlespawner({
            amount = 8,
            time = 0.05,
            minpos = {x=pos.x-0.25, y=pos.y, z=pos.z-0.25},
            maxpos = {x=pos.x+0.25, y=pos.y+0.5, z=pos.z+0.25},
            minvel = {x=-1, y=-1, z=-1},
            maxvel = {x=1, y=1, z=1},
            minacc = {x=0, y=2, z=0},
            maxacc = {x=0, y=2, z=0},
            minexptime = 1,
            maxexptime = 4,
            minsize = 2,
            maxsize = 4,
            glow = 14,
            texture = "gadgets_magic_magic_bridge_particle.png",
        })
        minetest.set_node(pos, {name = "air"})
    end
})

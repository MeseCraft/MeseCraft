--Blood Bucket and Blood Source items originally from "horror" mod by D00M3D.
minetest.register_node("mobs_creatures:blood_flowing", {
        description = "blood_source",
        inventory_image = minetest.inventorycube("mobs_creatures_items_blood_source.png^[opacity:190"),
        drawtype = "flowingliquid",
        tiles = {"mobs_creatures_items_blood_source.png^[opacity:190"},
        special_tiles = {
                {
                        image="mobs_creatures_items_blood_animate.png^[opacity:190",
                        backface_culling=false,
                        animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1}
                },
                {
                        image="mobs_creatures_items_blood_animate.png^[opacity:190",
                        backface_culling=true,
                        animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1}
                },
        },
        use_texture_alpha = "blend",
        paramtype = "light",
        paramtype2 = "flowingliquid",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
	is_ground_content = false,
        drop = "",
        drowning = 1,
        liquidtype = "flowing",
        liquid_alternative_flowing = "mobs_creatures:blood_flowing",
        liquid_alternative_source = "mobs_creatures:blood_source",
        liquid_viscosity = 3,
	liquid_renewable = false,
        post_effect_color = {a=70, r=200, g=70, b=70},
        groups = {liquid=3, not_in_creative_inventory=1, dynamic_lava_flowing_destroys=1, dynamic_lava_source_destroys=1 },
})

minetest.register_node("mobs_creatures:blood_source", {
        description = "Blood Source",
        inventory_image = minetest.inventorycube("mobs_creatures_items_blood_source.png^[opacity:190"),
        drawtype = "liquid",
        tiles = {
                {name="mobs_creatures_items_blood_animate.png^[opacity:190", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1}}
        },
        special_tiles = {
                -- New-style water source material (mostly unused)
                {
                        name="mobs_creatures_items_blood_animate.png^[opacity:190",
                        animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1},
                        backface_culling = false,
                }
        },
        use_texture_alpha = "blend",
        paramtype = "light",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
	is_ground_content = false,
        drop = "",
        drowning = 1,
        liquidtype = "source",
        liquid_alternative_flowing = "mobs_creatures:blood_flowing",
        liquid_alternative_source = "mobs_creatures:blood_source",
        liquid_viscosity = 3,
	liquid_renewable = false,
        post_effect_color = {a=70, r=200, g=70, b=70},
        groups = {liquid=3, dynamic_lava_flowing_destroys=1, dynamic_lava_source_destroys=1}
})

--bucket
if minetest.get_modpath("bucket") then
bucket.register_liquid(
        "mobs_creatures:blood_source",
        "mobs_creatures:blood_flowing",
        "mobs_creatures:bucket_blood",
        "mobs_creatures_items_blood_bucket.png",
        "Blood Bucket"
)
end

-- add dynamic liquid support
if minetest.get_modpath("dynamic_liquid") then
	dynamic_liquid.liquid_abm("mobs_creatures:blood_source", "mobs_creatures:blood_flowing", 3)
end

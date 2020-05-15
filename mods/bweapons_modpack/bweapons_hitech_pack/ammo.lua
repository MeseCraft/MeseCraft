bweapons.register_ammo({
    name = "bweapons_hitech_pack:rail_slug",
    description = "Depleted Uranium Slug",
    texture = "bweapons_hitech_pack_rail_gun_slug.png",
    recipe={
        {
            {'', 'technic:uranium0_ingot', ''},
            {'', 'technic:uranium0_ingot', ''},
            {'', 'default:steel_ingot', ''}
        },
    },
    amount = 1,
})

bweapons.register_ammo({
    name = "bweapons_hitech_pack:missile",
    description = "Missile",
    texture = "bweapons_hitech_pack_missile.png",
    recipe={
        {
            {'technic:carbon_plate', 'technic:silicon_wafer', 'technic:carbon_plate'},
            {'tnt:gunpowder', 'tnt:gunpowder', 'tnt:gunpowder'},
            {'technic:stainless_steel_ingot', 'technic:coal_dust', 'technic:stainless_steel_ingot'}
        },
    },
    amount = 1,
})

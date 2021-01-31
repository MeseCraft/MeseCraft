bweapons.register_ammo({
    name = "bweapons_firearms_pack:pistol_round",
    description = "Pistol Round",
    texture = "bweapons_firearms_pack_pistol_round.png",
    recipe = {
        {
            {'', 'technic:lead_ingot', ''},
            {'', 'tnt:gunpowder', ''},
            {'', 'technic:brass_ingot', ''},
        },
    },
    amount = 8,
})

bweapons.register_ammo({
    name = "bweapons_firearms_pack:rifle_round",
    description = "Rifle Round",
    texture = "bweapons_firearms_pack_rifle_round.png",
    recipe = {
        {
            {'', 'technic:lead_ingot', ''},
            {'technic:stainless_steel_ingot', 'tnt:gunpowder', 'technic:stainless_steel_ingot'},
            {'', 'technic:brass_ingot', ''},
        }
    },
    amount = 8,
})

bweapons.register_ammo({
    name = "bweapons_firearms_pack:shotgun_shell",
    description = "Shotgun Shell",
    texture = "bweapons_firearms_pack_shotgun_shell.png",
    recipe = {
        {
            {'', 'technic:lead_dust', ''},
            {'basic_materials:plastic_sheet', 'tnt:gunpowder', 'basic_materials:plastic_sheet'},
            {'', 'technic:brass_ingot', ''},
        }
    },
    amount = 8,
})

bweapons.register_ammo({
    name = "bweapons_firearms_pack:grenade",
    description = "Grenade",
    texture = "bweapons_firearms_pack_grenade.png",
    recipe = {
        {
            {'technic:coal_dust', 'technic:lead_ingot', 'technic:coal_dust'},
            {'tnt:gunpowder', 'tnt:gunpowder', 'tnt:gunpowder'},
            {'technic:brass_ingot', 'technic:brass_ingot', 'technic:brass_ingot'},
        }
    },
    amount = 4,
})

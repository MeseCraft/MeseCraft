-- Add Christmas Costumes.(Requires 3d Armor Mod by Stu)
-- Mostly based on the costumes submodule in the mod "halloween" by GreenDiamond.

-- Function for registering suits
function mesecraft_christmas.register(costume, nodename, def)
	if not def then
		def = {}
	end

	local gen_prev = "((([combine:16x32:-16,-12=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_chest.png)^([combine:16x32:-36,-8=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_head.png)^([combine:16x32:-44,-12=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_arm.png^[transformFX)^([combine:16x32:-44,-12=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_arm.png)^([combine:16x32:4,0=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_leg.png^[transformFX)^([combine:16x32:4,0=mesecraft_christmas_suit_" .. nodename .. ".png^[mask:mask_leg.png))^[resize:32x64)^[mask:mask_preview.png"

	local grouptypes = {
		["suit"] = {armor_head=1, armor_torso=1, armor_legs=1, armor_feet=1, armor_use=1000},
		["mask"] = {armor_head=1, armor_use=1000},
		["shirt"] = {armor_torso=1, armor_use=1000},
	}

	local function is_type(key)
		return grouptypes[key] ~= nil
	end

	local grouptype = "suit"

	if def.type then
		if is_type(def.type) then
			grouptype = def.type
		end
	end

	local armor_groups = grouptypes[grouptype]
	local node_str = grouptype.."_"..nodename

	if def.name then
		node_str = def.name
	end

	armor:register_armor("mesecraft_christmas:"..node_str, {
		description = costume,
		inventory_image = "inv_"..grouptype.."_"..nodename..".png",
		groups = armor_groups,
		on_equip = def.on_equip or nil,
		on_unequip = def.on_unequip or nil,
		on_destroy = def.on_destroy or nil,
		on_damage = def.on_damage or nil,
		on_punched = def.on_punched or nil,
	})

	local override_prev = gen_prev

	if def.preview then
		override_prev = def.preview
	end

	minetest.override_item("mesecraft_christmas:"..node_str, {
		preview = override_prev
	})
end

-- Register Costumes
mesecraft_christmas.register("Orange Parka", "orange_parka")
mesecraft_christmas.register("Christmas Elf Costume", "elf")
mesecraft_christmas.register("Christmas Tree Costume", "tree")
mesecraft_christmas.register("Santa Claus Costume", "santa")

-- Register Ugly Sweater
mesecraft_christmas.register("Ugly Christmas Sweater", "ugly_sweater", {
	type = "shirt",
	preview = "((([combine:16x32:-28,-12=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_chest.png)^([combine:16x32:-36,-8=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_head.png)^([combine:16x32:-52,-12=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_arm.png^[transformFX)^([combine:16x32:-52,-12=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_arm.png)^([combine:16x32:4,0=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_leg.png^[transformFX)^([combine:16x32:4,0=mesecraft_christmas_shirt_ugly_sweater.png^[mask:mask_leg.png))^[resize:32x64)^[mask:mask_preview.png"
})
-- Register Santa Hat
mesecraft_christmas.register("Santa Hat", "santa_hat", {
	type = "mask",
	preview = "((([combine:16x32:-16,-12=mesecraft_christmas_mask_santa_hat.png^[mask:mask_chest.png)^([combine:16x32:-36,-8=mesecraft_christmas_mask_santa_hat.png^[mask:mask_head.png)^([combine:16x32:-44,-12=mesecraft_christmas_mask_santa_hat.png^[mask:mask_arm.png^[transformFX)^([combine:16x32:-44,-12=mesecraft_christmas_mask_santa_hat.png^[mask:mask_arm.png)^([combine:16x32:4,0=mesecraft_christmas_mask_santa_hat.png^[mask:mask_leg.png^[transformFX)^([combine:16x32:4,0=mesecraft_christmas_mask_santa_hat.png^[mask:mask_leg.png))^[resize:32x64)^[mask:mask_preview.png"
})
-- Register Green Santa Hat
mesecraft_christmas.register("Green Chritmas Hat", "green_santa_hat", {
	type = "mask",
	preview = "((([combine:16x32:-16,-12=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_chest.png)^([combine:16x32:-36,-8=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_head.png)^([combine:16x32:-44,-12=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_arm.png^[transformFX)^([combine:16x32:-44,-12=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_arm.png)^([combine:16x32:4,0=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_leg.png^[transformFX)^([combine:16x32:4,0=mesecraft_christmas_mask_green_santa_hat.png^[mask:mask_leg.png))^[resize:32x64)^[mask:mask_preview.png"
})
-- Register Red Poof Ball Hat
mesecraft_christmas.register("Red Poofball Hat", "red_poof_ball_hat", {
	type = "mask",
	preview = "((([combine:16x32:-16,-12=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_chest.png)^([combine:16x32:-36,-8=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_head.png)^([combine:16x32:-44,-12=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_arm.png^[transformFX)^([combine:16x32:-44,-12=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_arm.png)^([combine:16x32:4,0=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_leg.png^[transformFX)^([combine:16x32:4,0=mesecraft_christmas_mask_red_poof_ball_hat.png^[mask:mask_leg.png))^[resize:32x64)^[mask:mask_preview.png"
})

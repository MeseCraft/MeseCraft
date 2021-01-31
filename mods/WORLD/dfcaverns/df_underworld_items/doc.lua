df_underworld_items.doc = {}

if not minetest.get_modpath("doc") then
	return
end

local S = df_underworld_items.S

df_underworld_items.doc.glowstone_desc = S("Bright glowing stones of unknown origin found lodged in the crevices of the underworld's ceiling.")
df_underworld_items.doc.glowstone_usage = S("These stones are highly volatile and should not be disturbed.")

df_underworld_items.doc.slade_desc = S("The very foundation of the world, Slade is a mysterious ultra-dense substance.")
df_underworld_items.doc.slade_usage = S("Slade is extremely hard to work with so it has little use.")
if df_underworld_items.config.invulnerable_slade then
	df_underworld_items.doc.slade_usage = df_underworld_items.doc.slade_usage .. " " .. S("In fact, Slade is impervious to conventional mining entirely.")
end

df_underworld_items.doc.slade_seal_desc = S("This block of Slade, carved by an unknown hand, is engraved with mysterious symbols. Most of the engraving's meaning is lost to the mists of time but one frament in the oldest known language can be translated: \"This place is not a place of honor.\"")

df_underworld_items.doc.glow_amethyst_desc = S("Glowing purple crystals that grow through holes in the foundation of the world.")
df_underworld_items.doc.glow_amethyst_usage = S("These crystals have no known use.")

df_underworld_items.doc.pit_plasma_desc = S("The liquid found in the deepest pits in the underworld is highly dangerous and damaging.")
df_underworld_items.doc.pit_plasma_usage = S("The only use for this material is that it destroys whatever is thrown into it. It cannot otherwise be manipulated.")
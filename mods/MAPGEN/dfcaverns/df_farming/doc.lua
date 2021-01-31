df_farming.doc = {}

if not minetest.get_modpath("doc") then
	return
end

local S = df_farming.S

df_farming.doc.simple_meal_desc = S("A meal made from the admixture of two ingredients, it keeps well but are not a rich source of nutrients.")
df_farming.doc.simple_meal_usage = nil
df_farming.doc.medium_meal_desc = S("A meal made from three ingredients mixed together. They're more wholesome, packing more nutrition into a single serving.")
df_farming.doc.medium_meal_usage = nil
df_farming.doc.complex_meal_desc = S("Four finely minced ingredients combine into a fine, full meal.")
df_farming.doc.complex_meal_usage = nil


-- Plants

df_farming.doc.dead_fungus_desc = S("Whatever this fungus was in life, it is now dead.")
df_farming.doc.dead_fungus_usage = S("Dead fungus quickly decays into an unrecognizable mess. It can be used as weak fuel or terrible decor.")

df_farming.doc.cavern_fungi_desc = S("A species of lavender mushroom ubiquitous in caves that is most notable for the soft bioluminescence it produces.")
df_farming.doc.cavern_fungi_usage = S("This mushroom is inedible but continues producing modest levels of light long after it's picked.")

df_farming.doc.cave_wheat_desc = S("Cave wheat is literally a breed of grain-producing grass that somehow lost its ability to photosynthesize and adapted to a more fungal style of life.")
df_farming.doc.cave_wheat_usage = S("Like its surface cousin, cave wheat produces grain that can be ground into a form of flour.")
df_farming.doc.cave_flour_desc = S("Cave wheat seed ground into a powder suitable for cooking.")
df_farming.doc.cave_flour_usage = S("When baked alone it forms an edible bread, but it combines well with other more flavorful ingredients.")
df_farming.doc.cave_bread_desc = S("Bread baked from cave wheat flour is tough and durable. A useful ration for long expeditions.")
df_farming.doc.cave_bread_usage = S("It's not tasty, but it keeps you going.")

df_farming.doc.dimple_cup_desc = S("The distinctive midnight-blue caps of these mushrooms are inverted, exposing their gills to any breeze that might pass, and have dimpled edges that give them their name.")
df_farming.doc.dimple_cup_usage = S("Dimple cups can be dried, ground, and processed to extract a deep blue dye.")

df_farming.doc.pig_tail_desc = S("Pig tails are a fibrous fungal growth that's most notable for its twisting stalks. In a mature stand of pig tails the helical stalks intertwine into a dense mesh.")
df_farming.doc.pig_tail_usage = S("Pig tail stalks can be processed to extract fibers useful as thread.")
df_farming.doc.pig_tail_thread_desc = S("Threads of pig tail fiber.")
df_farming.doc.pig_tail_thread_usage = S("A crafting item that can be woven into textiles and other similar items.")

df_farming.doc.plump_helmet_desc = S("Plump helmets are a thick, fleshy mushroom that's edible picked straight from the ground. They form a staple diet for both lost cave explorers and the fauna that preys on them.")
df_farming.doc.plump_helmet_usage = S("While they can be eaten fresh, they can be monotonous fare and are perhaps better appreciated as part of a more complex prepared dish.")

df_farming.doc.quarry_bush_desc = S("A rare breed of fungus from deep underground that produces a bushy cluster of rumpled gray 'blades'. The biological function of these blades is not known, as quarry bushes reproduce via hard-shelled nodules that grow down at the blade's base.")
df_farming.doc.quarry_bush_usage = S("Quarry bush leaves and nodules (called 'rock nuts') can be harvested and are edible with processing.")
df_farming.doc.quarry_bush_leaves_desc = S("The dried blades of a quarry bush add a welcome zing to recipes containing otherwise-bland subterranean foodstuffs, but they're too spicy to be eaten on their own.")
df_farming.doc.quarry_bush_leaves_usage = S("Quarry bush leaves can be used as an ingredient in foodstuffs.")

df_farming.doc.sweet_pod_desc = S("Sweet pods grow in rich soil, and once they reach maturity they draw that supply of nutrients up to concentrate it in their fruiting bodies. They turn bright red when ripe and can be processed in a variety of ways to extract the sugars they contain.")

if minetest.get_modpath("cottages") then
	df_farming.doc.sweet_pod_usage = S("When milled, sweet pods produce a granular sugary substance.")
else
	df_farming.doc.sweet_pod_usage = S("When dried in an oven, sweet pods produce a granular sugary substance.")
end
df_farming.doc.sweet_pod_usage = df_farming.doc.sweet_pod_usage .. " " .. S("Crushing them in a bucket squeezes out a flavorful syrup.")

df_farming.doc.sweet_pod_sugar_desc = S("Sweet pod sugar has a pink tint to it.")
df_farming.doc.sweet_pod_sugar_usage = S("Too sweet to be eaten directly, it makes an excellent ingredient in food recipes.")
df_farming.doc.sweet_pod_syrup_desc = S("Sweet pod syrup is thick and flavorful.")
df_farming.doc.sweet_pod_syrup_usage = S("Too strong and thick to drink straight, sweet pod syrup is useful in food recipes.")

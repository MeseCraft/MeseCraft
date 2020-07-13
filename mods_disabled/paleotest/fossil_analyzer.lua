-- declare cores
cores={"brachiosaurus","tyrannosaurus","triceratops","stegosaurus","dilophosaurus","velociraptor","mosasaurus","elasmosaurus","dunkleosteus","pteranodon", "horsetails","cycad"}
cores2={"Mammoth","Elasmotherium","Smilodon","Direwolf","Thylacoleo"}

-- declare formspec page.
local fossil_analyzer_fs = "size[8,7]"
    .."image[3.28,1.75;1.5,.5;paleotest_progress_bar.png^[transformR270]"
    .."list[current_player;main;0,3;8,4;]"
    .."list[context;input;2,1.5;1,1;]"
    .."list[context;output;5,1.5;1,1;]"
    .."label[3,0.5;Fossil Analyzer]"
    .."label[2.0,1;Fossil]"
    .."label[5.1,1;DNA]"

-- get formspec page (active).
local function get_active_fossil_analyzer_fs(item_percent)
    return "size[8,7]"
	    .."image[3.28,1.75;1.5,.5;paleotest_progress_bar.png^[lowpart:"
	    ..(item_percent)..":paleotest_progress_bar_full.png^[transformR270]"
        .."list[current_player;main;0,3;8,4;]"
        .."list[context;input;2,1.5;1,1;]"
        .."list[context;output;5,1.5;1,1;]"
        .."label[3,0.5;Fossil Analyzer]"
        .."label[2.0,1;Fossil]"
        .."label[5.1,1;DNA]"
end

-- initialize table.
paleotest.fossil_analyzer = {}
local fossil_analyzer = paleotest.fossil_analyzer

-- initialize table for recipes.
fossil_analyzer.recipes = {}

-- function to register recipes.
function fossil_analyzer.register_recipe(input, output) 
fossil_analyzer.recipes[input] = output end

-- function to control formspec version.
local function update_formspec(progress, goal, meta)
    local formspec
	if progress > 0 and progress <= goal then
	-- when analyzing is active, we add a progress bar to the analyzer.
		local item_percent = math.floor(progress / goal * 100)
		formspec = get_active_fossil_analyzer_fs(item_percent)
	else
	-- otherwise we just use the standard formspec.
		formspec = fossil_analyzer_fs
	end
	-- set the formspec meta string to whichever version we are using
	meta:set_string("formspec", formspec)
end

-- timer?
local function recalculate(pos)
	local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("input", 1)

	local k = stack:get_name()
	if not k then return end

	timer:stop()
	update_formspec(0, 3, meta)
	timer:start(1)
end

-- function to cook
local function do_cook_single(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local fossil = inv:get_stack("input", 1)
	fossil:set_count(1)

	if not "paleotest:fossil" or "paleotest:prehistoric_bone" then
        minetest.chat_send_all("fossil_analyzer cooked nothing because there was nothing to cook.")
		minetest.get_node_timer(pos):stop()
		update_formspec(0, 3, meta)
	elseif "paleotest:fossil" then
        minetest.chat_send_all("fuck")
		inv:remove_item("input", "paleotest:fossil")
		local dinosaur_dna = "paleotest:"..cores[math.random(1,#cores)].."_dna"
		inv:add_item("output", dinosaur_dna)
	elseif "paleotest:bone" then
        minetest.chat_send_all("fuck")
		inv:remove_item("input", "paleotest:bone")
		local dinosaur_dna = "paleotest:"..cores2[math.random(1,#cores2)].."_dna"
		inv:add_item("output", dinosaur_dna)
	end
end

-- Register the fossil analyzer node.
minetest.register_node("paleotest:fossil_analyzer", {
	description = "Fossil Analyzer",
	tiles = {
		"default_steel_block.png",
		"paleotest_fossil_analyzer_bottom.png",
		"paleotest_fossil_analyzer_side.png",
		"paleotest_fossil_analyzer_side.png",
		"paleotest_fossil_analyzer_side.png",
		"paleotest_fossil_analyzer_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	drawtype = "node",
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("input") and inv:is_empty("output")
	end,

	on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local stack = meta:get_inventory():get_stack("input", 1)
        local cooking_time = meta:get_int("cooking_time") or 0
        cooking_time = cooking_time + 1
        
        if cooking_time % 200 == 0 then
            do_cook_single(pos)
        end

        update_formspec(cooking_time % 200, 200, meta)
        meta:set_int("cooking_time", cooking_time)

        if not stack:is_empty() then
            return true
        else
            meta:set_int("cooking_time", 0)
            update_formspec(0, 3, meta)
            return false
        end
	end,

	on_metadata_inventory_put = recalculate,
	on_metadata_inventory_take = recalculate,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", fossil_analyzer_fs)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
     		inv:set_size("output", 1)
	end,
	
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
		table.insert(drops, "paleotest:fossil_analyzer")
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = function(pos, list, index, stack, player)
		return "paleotest:fossil" and "paleotest:bone" and 1 or 0
	end,
})
--[[

  Register decorations for Nether mapgen

  Copyright (C) 2020 Treer

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
  WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
  BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
  OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
  SOFTWARE.

]]--

-- Lava is unreliable in the old Nether mapgen because it removes lava
-- from the overdraw areas, so any decorations involving lava will often
-- have the lava missing depending on whether nearby chunks were already
-- emerged or not before the decoration was placed.
local allow_lava_decorations = nether.useBiomes

local _ = {name = "air",                     prob = 0}
local A = {name = "air",                     prob = 255, force_place = true}
local G = {name = "nether:glowstone",        prob = 255, force_place = true}
local N = {name = "nether:rack",             prob = 255}
local S = {name = "nether:sand",             prob = 255, force_place = true}
local L = {name = "default:lava_source",     prob = 255, force_place = true}


-- =================
--    Stalactites
-- =================

local schematic_GlowstoneStalactite = {
    size = {x = 5, y = 10, z = 5},
    data = {
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, N, G, N, _,
        _, N, N, N, _,

        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, G, _, _,
        _, _, G, _, _,
        _, G, G, G, _,
        N, G, G, G, N,
        N, N, G, N, N,

        _, _, N, _, _,   -- ypos 0, prob 25% (64/256)
        _, _, G, _, _,   -- ypos 1, prob 37% (96/256)
        _, _, G, _, _,   -- ypos 2, prob 100%
        _, _, G, _, _,   -- ypos 3, prob 100%
        _, _, G, G, _,   -- ypos 4, prob 50% (128/256) to make half of stalactites asymmetric
        _, G, G, G, _,   -- ypos 5, prob 75% (192/256)
        _, G, G, G, _,   -- ypos 6, prob 75% (192/256)
        _, G, G, G, _,   -- ypos 7, prob 100%
        G, G, G, G, G,   -- ypos 8, prob 100%
        N, G, G, G, N,   -- ypos 9, prob 75% (192/256)

        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, G, _, _,
        _, _, G, _, _,
        _, _, G, _, _,
        _, G, G, G, _,
        N, G, G, G, N,
        N, N, G, N, N,

        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, _, _, _, _,
        _, N, G, N, _,
        _, N, N, N, _
    },
    -- Y-slice probabilities do not function correctly for ceiling schematic
    -- decorations because they are inverted, so ypos numbers have been inverted
    -- to match, and a larger offset in place_offset_y should be used (e.g. -3).
    yslice_prob = {
        {ypos = 9, prob = 192},
        {ypos = 6, prob = 192},
        {ypos = 5, prob = 192},
        {ypos = 4, prob = 128},
        {ypos = 1, prob = 96},
        {ypos = 0, prob = 64}
    }
}

minetest.register_decoration({
    name = "Glowstone stalactite",
    deco_type = "schematic",
    place_on = "nether:rack",
    sidelen = 80,
    fill_ratio = 0.0003,
    biomes = {"nether_caverns"},
    y_max = nether.DEPTH_CEILING, -- keep compatibility with mapgen_nobiomes.lua
    y_min = nether.DEPTH_FLOOR,
    schematic = schematic_GlowstoneStalactite,
    flags = "place_center_x,place_center_z,force_placement,all_ceilings",
    place_offset_y=-3
})

minetest.register_decoration({
    name = "Netherrack stalactite",
    deco_type = "schematic",
    place_on = "nether:rack",
    sidelen = 80,
    fill_ratio = 0.0008,
    biomes = {"nether_caverns"},
    y_max = nether.DEPTH_CEILING, -- keep compatibility with mapgen_nobiomes.lua
    y_min = nether.DEPTH_FLOOR,
    schematic = schematic_GlowstoneStalactite,
    replacements = {["nether:glowstone"] = "nether:rack"},
    flags = "place_center_x,place_center_z,all_ceilings",
    place_offset_y=-3
})

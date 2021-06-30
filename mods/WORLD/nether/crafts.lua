--[[

  Copyright (C) 2013 PilzAdam
  Copyright (C) 2020 lortas
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

minetest.register_craft({
	output = "nether:brick 4",
	recipe = {
		{"nether:rack", "nether:rack"},
		{"nether:rack", "nether:rack"},
	}
})

minetest.register_craft({
	output = "nether:fence_nether_brick 6",
	recipe = {
		{"nether:brick", "nether:brick", "nether:brick"},
		{"nether:brick", "nether:brick", "nether:brick"},
	},
})

minetest.register_craft({
	output = "nether:brick_compressed",
	recipe = {
		{"nether:brick","nether:brick","nether:brick"},
		{"nether:brick","nether:brick","nether:brick"},
		{"nether:brick","nether:brick","nether:brick"},
	}
})

minetest.register_craft({
    output = "nether:basalt_hewn",
    type = "shapeless",
    recipe = {
      "nether:basalt",
      "nether:basalt",
    },
})

minetest.register_craft({
  output = "nether:basalt_chiselled 4",
  recipe = {
    {"nether:basalt_hewn", "nether:basalt_hewn"},
    {"nether:basalt_hewn", "nether:basalt_hewn"}
  }
})

-- See tools.lua for tools related crafting
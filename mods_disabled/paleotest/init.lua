paleotest = {}

local path = minetest.get_modpath("paleotest")

dofile(path .. "/craftitems.lua")
dofile(path .. "/crafts.lua")
dofile(path .. "/dna_cultivator.lua")
dofile(path .. "/fossil_analyzer.lua")
dofile(path .. "/fossil_generation.lua")
dofile(path .. "/nodes.lua")

-- PaleoTest Dinosaurs
dofile(path .. "/dinos/spinosaurus.lua")
dofile(path .. "/dinos/stegosaurus.lua")
dofile(path .. "/dinos/brachiosaurus.lua")
dofile(path .. "/dinos/triceratops.lua")
dofile(path .. "/dinos/tyrannosaurus.lua")
dofile(path .. "/dinos/velociraptor.lua")

-- PaleoTest Megafauna
dofile(path .. "/dinos/mammoth.lua")
dofile(path .. "/dinos/elasmotherium.lua")
dofile(path .. "/dinos/procoptodon.lua")
dofile(path .. "/dinos/smilodon.lua")
dofile(path .. "/dinos/thylacoleo.lua")
-- missing dofile(path .. "/dinos/dire_wolf.lua")

-- PaleoTest Reptiles
dofile(path .. "/dinos/dunkleosteus.lua")
dofile(path .. "/dinos/elasmosaurus.lua")
dofile(path .. "/dinos/mosasaurus.lua")
--dofile(path .. "/dinos/sarcosuchus.lua")
dofile(path .. "/dinos/pteranodon.lua")
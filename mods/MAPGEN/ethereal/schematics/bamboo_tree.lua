
local _ = {name = "air", param1 = 000}
local B = {name = "ethereal:bamboo", param1 = 255}
local L = {name = "ethereal:bamboo_leaves", param1 = 255}
local l = {name = "ethereal:bamboo_leaves", param1 = 100}

ethereal.bambootree = {

	size = {x = 3, y = 18, z = 3},

	yslice_prob = {
		{ypos = 0, prob = 127},
		{ypos = 1, prob = 127},
		{ypos = 2, prob = 127},
	},

	data = {

	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	l,L,l,
	_,L,_,
	_,_,_,

	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	_,B,_,
	l,L,l,
	_,L,_,
	_,l,_,

	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	_,_,_,
	l,L,l,
	_,L,_,
	_,_,_,

	}
}

if ethereal.papyruswalk == true then

	minetest.override_item("default:papyrus", {
		walkable = true,
		sunlight_propagates = true
	})
end

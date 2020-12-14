
local _ = {name = "air", prob = 0}
local l = {name = "default:lava_source", prob = 225}
local s = {name = "default:stone", prob = 255}
local d = {name = "ethereal:fiery_dirt", prob = 255}

ethereal.volcanom = {

	size = {x = 6, y = 2, z = 6},

	yslice_prob = {
		{ypos = 0, prob = 127},
	},

	data = {

	_,_,s,_,_,_,
	_,_,_,_,_,_,

	_,s,l,s,_,_,
	_,_,s,d,_,_,

	_,s,l,l,s,_,
	_,s,_,_,s,_,

	s,l,l,l,s,_,
	_,s,_,_,d,_,

	_,d,l,l,d,d,
	_,_,s,d,_,_,

	_,_,d,d,d,_,
	_,_,_,_,_,_,

	}
}

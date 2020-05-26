
local _ = {name = "air", param1 = 0}
local B = {name = "ethereal:bush", param1 = 255}
local b = {name = "ethereal:bush", param1 = 100}

ethereal.bush = {

	size = {x = 5, y = 3, z = 5},

	yslice_prob = {
		{ypos = 0, prob = 127},
		{ypos = 2, prob = 127},
	},

	data = {

	b,B,B,B,b,
	_,_,_,_,_,
	_,_,_,_,_,

	B,B,B,B,B,
	_,b,B,b,_,
	_,_,_,_,_,

	B,B,B,B,B,
	_,B,B,B,_,
	_,_,b,_,_,

	B,B,B,B,B,
	_,b,B,b,_,
	_,_,_,_,_,

	b,B,B,B,b,
	_,_,_,_,_,
	_,_,_,_,_,

	}
}


local _ = {name = "air", param1 = 0}
local L = {name = "ethereal:orange_leaves", param1 = 255}
local l = {name = "ethereal:orange_leaves", param1 = 200}
local T = {name = "default:tree", param1 = 255}
local o = {name = "ethereal:orange", param1 = 200}

ethereal.orangetree = {

	size = {x = 3, y = 6, z = 3},

	yslice_prob = {
		{ypos = 0, prob = 127},
		{ypos = 3, prob = 127},
	},

	data = {

	_,_,_,
	_,_,_,
	_,_,_,
	l,l,o,
	L,L,L,
	l,o,l,

	_,T,_,
	_,T,_,
	_,T,_,
	l,T,l,
	L,T,L,
	l,L,l,

	_,_,_,
	_,_,_,
	_,_,_,
	o,l,l,
	L,L,L,
	l,l,l,

	}
}


local _ = {name = "air", prob = 0}
local T = {name = "default:tree", prob = 255}
local L = {name = "default:leaves", prob = 255}
local u = {name = "ethereal:vine", prob = 255, param2 = 2}
local U = {name = "ethereal:vine", prob = 255, param2 = 3}
local W = {name = "ethereal:vine", prob = 255, param2 = 4}
local w = {name = "ethereal:vine", prob = 255, param2 = 5}

ethereal.vinetree = {

	size = {x = 7, y = 7, z = 7},

	yslice_prob = {
		{ypos = 0, prob = 127},
	},

	data = {

	_,_,_,_,_,_,_,
	_,W,_,_,_,_,_,
	_,W,_,W,_,_,_,
	_,W,_,W,_,_,_,
	_,W,_,_,_,W,_,
	_,W,_,_,_,W,_,
	_,_,_,_,_,_,_,

	_,_,_,_,_,_,_,
	_,_,_,_,W,_,_,
	_,_,_,_,W,_,_,
	_,L,L,L,W,L,_,
	_,L,L,_,L,L,_,
	_,L,L,L,L,L,_,
	_,_,_,_,_,_,_,

	_,_,_,_,_,_,U,
	_,_,_,_,_,_,U,
	_,_,_,_,_,_,U,
	_,L,T,_,T,L,U,
	u,L,L,L,L,_,_,
	_,_,L,L,L,L,_,
	_,_,L,L,L,_,_,

	_,_,_,T,_,_,_,
	_,_,_,T,_,_,_,
	u,_,_,T,_,_,_,
	u,L,_,L,_,L,_,
	u,L,L,L,L,L,_,
	_,L,L,L,L,L,_,
	_,_,L,L,L,_,_,

	_,_,_,_,_,_,_,
	_,_,_,_,_,_,U,
	_,_,_,_,_,_,U,
	_,L,T,_,T,L,U,
	_,L,L,L,L,L,U,
	_,L,L,L,L,L,_,
	_,_,_,L,L,_,_,

	_,_,_,_,_,_,_,
	u,_,_,_,_,_,_,
	u,_,_,_,w,_,_,
	u,L,L,L,w,L,_,
	_,L,L,L,L,_,_,
	_,_,L,L,L,L,_,
	_,_,_,_,_,_,_,

	_,_,_,_,_,_,_,
	_,_,w,_,_,_,_,
	_,_,w,_,_,_,_,
	_,_,w,w,_,_,_,
	_,_,_,w,w,_,_,
	_,_,_,_,_,_,_,
	_,_,_,_,_,_,_,

	}
}

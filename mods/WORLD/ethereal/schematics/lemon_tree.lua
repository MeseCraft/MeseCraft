
local _ = {name = "air", param1 = 0}
local L = {name = "ethereal:lemon_leaves", param1 = 255}
local l = {name = "ethereal:lemon_leaves", param1 = 127}
local T = {name = "default:tree", param1 = 255}
local e = {name = "ethereal:lemon", param1 = 100}

ethereal.lemontree = {

	size = {x = 5, y = 8, z = 5},

	yslice_prob = {
		{ypos = 0, prob = 127},
		{ypos = 3, prob = 127},
	},

	data = {

	_,_,_,_,_,
	_,_,_,_,_,
    _,_,_,_,_,
    _,_,e,_,_,
    _,L,L,L,e,
    e,L,L,l,_,
    _,l,L,L,_,
    _,_,l,_,_,
    
    _,_,_,_,_,
	_,_,_,_,_,
    _,_,_,_,_,
    _,L,L,l,_,
    l,L,l,L,L,
    L,l,L,L,L,
    L,L,L,l,L,
    _,L,L,L,_,
    
    _,_,T,_,_,
	_,_,T,_,_,
    _,_,T,_,_,
    l,e,T,l,l,
    L,L,T,L,l,
    l,L,T,L,L,
    L,L,L,l,L,
    l,L,L,L,l,
    
    _,_,_,_,_,
	_,_,_,_,_,
    _,_,_,_,_,
    _,L,L,L,_,
    L,l,L,L,L,
    L,L,L,L,L,
    L,L,L,L,l,
    _,l,L,L,_,
    
    _,_,_,_,_,
	_,_,_,_,_,
    _,_,_,_,_,
    _,_,l,_,_,
    e,L,L,l,_,
    _,l,L,L,_,
    _,L,L,L,e,
    _,_,l,_,_,

	}
}

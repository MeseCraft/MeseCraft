local S = drinks.get_translator
local F = minetest.formspec_escape

function drinks.liquid_storage_formspec(juice_desc, fullness, max)
  return
  'size[8,8]'..
  'label[0,0;'..F(S('Fill with the drink of your choice'))..',]'..
  'label[0,.4;'..F(S('you can only add more of the same type of drink.'))..']'..
  'label[5,1.2;<- '..F(S('Add liquid'))..']'..
  'label[.5,1.2;'..F(S('Storing @1 juice.', juice_desc))..']'..
  'label[.5,1.65;'..F(S('Holding @1 of @2 cups.', fullness/2, max/2))..']'..
  'label[5,2.25;<- '..F(S('Take liquid'))..']'..
  'label[2,3.2;'..F(S('(This empties the container completely)'))..']'..
  'button[0,3;2,1;purge;'..F(S('Purge'))..']'..
  'list[context;src;4,1;1,1;]'..
  'list[context;dst;4,2;1,1;]'..
  'list[current_player;main;0,4;8,5;]'..
  'listring[context;dst]'..
  'listring[current_player;main]'..
  'listring[context;src]'..
  'listring[current_player;main]'
end

function drinks.juice_press_formspec(action_desc)
  local cup_req = drinks.shortname.jcu.size
  local bottle_req = drinks.shortname.jbo.size
  local bucket_req = drinks.shortname.jbu.size
  return
  'size[8,7]'..
  'label[1.5,0;'..F(action_desc)..']' ..
  'label[4.2,.75;<- '..S('Put fruit here')..']'..
  'label[4.2,1.75;<- '..S('Put container here')..']'..
  'label[0.2,1.8;'..cup_req..' fruits to a glass,]'..
  'label[0.2,2.1;'..bottle_req..' fruits to a bottle,]'..
  'label[0.2,2.4;'..bucket_req..' fruits to a bucket.]'..
  'button[0.5,1;2.5,1;press;'..S('Start Juicing')..']'..
  'list[context;src;3.2,.5;1,1;]'..
  'list[context;dst;3.2,1.5;1,1;]'..
  'list[current_player;main;0,3;8,4;]'..
  'listring[context;dst]'..
  'listring[current_player;main]'..
  'listring[context;src]'..
  'listring[current_player;main]'
end

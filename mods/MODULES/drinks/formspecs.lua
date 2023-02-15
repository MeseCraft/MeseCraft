function drinks.liquid_storage_formspec(juice_desc, fullness, max)
  return
  'size[8,8]'..
  'label[0,0;Fill with the drink of your choice,]'..
  'label[0,.4;you can only add more of the same type of drink.]'..
  'label[4.5,1.2;Add liquid ->]'..
  'label[.5,1.2;Storing '..juice_desc..' juice.]'..
  'label[.5,1.65;Holding '..(fullness/2)..' of '..(max/2)..' cups.]'..
  'label[4.5,2.25;Take liquid ->]'..
  'label[2,3.2;(This empties the container completely)]'..
  'button[0,3;2,1;purge;Purge]'..
  'list[context;src;6.5,1;1,1;]'..
  'list[context;dst;6.5,2;1,1;]'..
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
  'label[1.5,0;'..minetest.formspec_escape(action_desc)..']' ..
  'label[4.3,.75;Put fruit here ->]'..
  'label[3.5,1.75;Put container here ->]'..
  'label[0.2,1.8;'..cup_req..' fruits to a glass,]'..
  'label[0.2,2.1;'..bottle_req..' fruits to a bottle,]'..
  'label[0.2,2.4;'..bucket_req..' fruits to a bucket.]'..
  'button[1,1;2,1;press;Start Juicing]'..
  'list[context;src;6.5,.5;1,1;]'..
  'list[context;dst;6.5,1.5;1,1;]'..
  'list[current_player;main;0,3;8,4;]'..
  'listring[context;dst]'..
  'listring[current_player;main]'..
  'listring[context;src]'..
  'listring[current_player;main]'
end

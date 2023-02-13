function drinks.liquid_storage_formspec(fruit_name, fullness, max)
	local formspec =
   'size[8,8]'..
      'label[0,0;Fill with the drink of your choice,]'..
      'label[0,.4;you can only add more of the same type of drink.]'..
      'label[4.5,1.2;Add liquid ->]'..
      'label[.5,1.2;Storing '..fruit_name..' juice.]'..
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
   return formspec
end

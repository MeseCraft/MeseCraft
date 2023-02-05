ma_pops_furniture.fireplace_formspec =
	'size[8,6]'..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	'background[8,6;0,0;default_brick.png;true]'..
	'list[context;fuel;1,0;1,1;]'..
	'list[current_player;main;0,2.5;8,4;]'..
	'listring[]'
	default.get_hotbar_bg(0,4.85)
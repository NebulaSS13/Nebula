/atom/movable/remove_fire_graphic(var/intensity)
	var/fire_vis = get_fire_graphic(intensity)
	if(fire_vis)
		remove_vis_contents(src, fire_vis)

/atom/movable/add_fire_graphic(var/intensity)
	var/fire_vis = get_fire_graphic(intensity)
	if(fire_vis)
		add_vis_contents(src, fire_vis)

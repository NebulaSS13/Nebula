/obj/item/firearm_component/receiver/ballistic/magnetic
	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,     one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
	)
/*
/obj/item/gun/magnetic/railgun/flechette/out_of_ammo()
	visible_message("<span class='warning'>\The [src] beeps to indicate the magazine is empty.</span>")
*/
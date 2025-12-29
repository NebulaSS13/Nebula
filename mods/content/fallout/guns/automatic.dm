/obj/item/gun/projectile/automatic/assault_rifle/NCR
	name = "service rifle"
	desc = "The standard-issue rifle of the NCR. Threatening."
	icon = 'mods/content/fallout/guns/icons/rifle/servicerifle.dmi'
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, use_launcher=null, one_hand_penalty=8,  burst_accuracy=null,            dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, use_launcher=null, one_hand_penalty=9,  burst_accuracy=list(0,-1,-1),   dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="full auto",      burst=1,    fire_delay=0,    burst_delay=1,     use_launcher=null,   one_hand_penalty=7,             burst_accuracy = list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0), autofire_enabled=1)
	)

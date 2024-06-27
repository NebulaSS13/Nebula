/obj/structure/ship_munition
	name = "munitions"
	icon = 'icons/obj/munitions.dmi'
	density = TRUE
	material = /decl/material/solid/metal/titanium
	var/static/list/move_sounds = list( // some nasty sounds to make when moving the board
		'sound/effects/metalscrape1.ogg',
		'sound/effects/metalscrape2.ogg',
		'sound/effects/metalscrape3.ogg'
	)

// make a screeching noise to drive people mad
/obj/structure/ship_munition/Move()
	. = ..()
	if(.)
		var/turf/T = get_turf(src)
		if(!isspaceturf(T) && !istype(T, /turf/floor/carpet))
			playsound(T, pick(move_sounds), 75, 1)

/obj/structure/ship_munition/md_slug
	name = "mass driver slug"
	icon_state = "slug"

/obj/structure/ship_munition/ap_slug
	name = "armor piercing mass driver slug"
	icon_state = "ap"
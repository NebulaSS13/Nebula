//Special world edge turf

/turf/exterior/planet_edge
	name = "world's edge"
	desc = "The government doesn't want you to see this!"
	density = TRUE
	blocks_air = TRUE
	dynamic_lighting = FALSE
	icon = null
	icon_state = null
	permit_ao = FALSE
	var/mimicx
	var/mimicy

/turf/exterior/planet_edge/Initialize()
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = global.overmap_sectors["[z]"]
	if(!istype(E))
		return
	mimicx = x
	if (x <= TRANSITIONEDGE)
		mimicx = x + (E.maxx - 2*TRANSITIONEDGE) - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		mimicx = x - (E.maxx  - 2*TRANSITIONEDGE) + 1

	mimicy = y
	if(y <= TRANSITIONEDGE)
		mimicy = y + (E.maxy - 2*TRANSITIONEDGE) - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		mimicy = y - (E.maxy - 2*TRANSITIONEDGE) + 1
	refresh_vis_contents()

	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	var/obj/effect/overlay/O = new(src)
	O.mouse_opacity = 2
	O.name = "distant terrain"
	O.desc = "You need to come over there to take a better look."

/turf/exterior/planet_edge/Bumped(atom/movable/A)
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = global.overmap_sectors["[z]"]
	if(!istype(E))
		return
	if(E.planetary_area && istype(loc, world.area))
		ChangeArea(src, E.planetary_area)
	var/new_x = A.x
	var/new_y = A.y
	if(x <= TRANSITIONEDGE)
		new_x = E.maxx - TRANSITIONEDGE - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (y <= TRANSITIONEDGE)
		new_y = E.maxy - TRANSITIONEDGE - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	var/turf/T = locate(new_x, new_y, A.z)
	if(T && !T.density)
		A.forceMove(T)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(T)

/turf/exterior/planet_edge/on_update_icon()
	return

/turf/exterior/planet_edge/get_vis_contents_to_add()
	. = ..()
	var/turf/NT = mimicx && mimicy && locate(mimicx, mimicy, z)
	if(NT)
		LAZYADD(., NT)

// This type of flooring cannot be altered short of being destroyed and rebuilt.
// Use this to bypass the flooring system entirely ie. event areas, holodeck, etc.

/turf/floor/fixed
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = null
	footstep_type = /decl/footsteps/plating
	is_outside = OUTSIDE_AREA

/turf/floor/fixed/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/stack) && !IS_COIL(C))
		return
	return ..()

/turf/floor/fixed/on_update_icon()
	queue_ao(FALSE)

/turf/floor/fixed/is_plating()
	return 0

/turf/floor/fixed/set_flooring(var/decl/flooring/newflooring, skip_update)
	return

/turf/floor/fixed/alium
	name = "alien plating"
	desc = "This obviously wasn't made for your feet."
	icon = 'icons/turf/flooring/alium.dmi'
	icon_state = "jaggy"

/turf/floor/fixed/alium/attackby(var/obj/item/C, var/mob/user)
	if(IS_CROWBAR(C))
		to_chat(user, "<span class='notice'>There aren't any openings big enough to pry it away...</span>")
		return TRUE
	return ..()

/turf/floor/fixed/alium/Initialize()
	. = ..()
	var/decl/material/A = GET_DECL(/decl/material/solid/metal/aliumium)
	if(!A)
		return
	color = A.color
	var/style = A.hardness % 2 ? "curvy" : "jaggy"
	icon_state = "[style][(x*y) % 7]"

/turf/floor/fixed/alium/airless
	initial_gas = null
	temperature = TCMB

/turf/floor/fixed/alium/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	var/decl/material/A = GET_DECL(/decl/material/solid/metal/aliumium)
	if(prob(A.explosion_resistance))
		return
	if(severity == 1)
		ChangeTurf(get_base_turf_by_area(src), keep_air = TRUE)

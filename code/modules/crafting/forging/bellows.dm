/obj/structure/working/bellows
	name = "bellows"
	desc = "An air pump used to improve the heat of a furnace."
	icon = 'icons/obj/structures/forging/bellows.dmi'
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	work_skill = SKILL_HAULING
	var/decl/material/bellows_material = /decl/material/solid/organic/leather

/obj/structure/working/bellows/Initialize()
	bellows_material = GET_DECL(bellows_material)
	. = ..()

/obj/structure/working/bellows/on_update_icon()
	. = ..()
	underlays = list(overlay_image(icon, "[icon_state]-bellows", bellows_material.color, RESET_COLOR))

/obj/structure/working/bellows/try_start_working(mob/user)

	var/obj/structure/fire_source/stoking = locate() in get_step(loc, EAST)
	if(!istype(stoking) || !stoking.lit)
		to_chat(user, SPAN_WARNING("\The [src] must face east towards a lit fire source; it would be pointless to work them currently."))
		return TRUE

	to_chat(user, SPAN_NOTICE("You begin working \the [src], stoking \the [stoking] to a hotter flame."))
	start_working()
	while(user.do_skilled(3 SECONDS, work_skill, src))
		if(QDELETED(src) || QDELETED(user) || user.get_stamina() < 25 || !user.get_empty_hand_slot())
			break
		stoking = locate() in get_step(loc, EAST)
		if(!istype(stoking) || !stoking.lit)
			break
		user.adjust_stamina(-25)
		stoking.bellows_oxygenation = max(50, stoking.bellows_oxygenation+3)

	if(!QDELETED(user))
		to_chat(user, SPAN_NOTICE("You stop working \the [src]."))

	stop_working()
	return TRUE


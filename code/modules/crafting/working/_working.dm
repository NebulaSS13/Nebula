/obj/structure/working

	abstract_type       = /obj/structure/working
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	density             = TRUE
	color               = /decl/material/solid/organic/wood::color
	material            = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	atom_flags          = ATOM_FLAG_CLIMBABLE
	obj_flags           = OBJ_FLAG_ANCHORABLE
	throwpass           = TRUE // You can reach over these to things behind them.

	var/tmp/working     = FALSE
	var/work_skill      = SKILL_CONSTRUCTION
	var/product_type
	var/datum/composite_sound/work_sound

/obj/structure/working/Initialize()
	. = ..()
	if(ispath(work_sound))
		work_sound = new work_sound(list(src), FALSE)
	else
		work_sound = null

/obj/structure/working/Destroy()
	QDEL_NULL(work_sound)
	return ..()

/obj/structure/working/proc/apply_working_overlays()
	return

/obj/structure/working/on_update_icon()
	..()
	icon_state = initial(icon_state)
	apply_working_overlays()
	if(working)
		icon_state = "[icon_state]-working"

/obj/structure/working/proc/start_working()
	working = TRUE
	if(work_sound && !work_sound.started)
		work_sound.start(src)
	update_icon()

/obj/structure/working/proc/stop_working()
	working = FALSE
	if(work_sound?.started)
		work_sound.stop(src)
	update_icon()

/obj/structure/working/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

	if(try_take_input(W, user))
		return TRUE

	return ..()

/obj/structure/working/proc/try_take_input(obj/item/W, mob/user, silent)
	return FALSE

/obj/structure/working/proc/try_unload_material(mob/user)
	return FALSE

/obj/structure/working/proc/try_start_working(mob/user)
	return FALSE

/obj/structure/working/attack_hand(mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

	if(try_unload_material(user))
		return TRUE

	if(try_start_working(user))
		return TRUE

	return ..()

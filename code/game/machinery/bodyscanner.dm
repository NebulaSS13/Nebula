// Pretty much everything here is stolen from the dna scanner FYI
/obj/machinery/bodyscanner
	var/mob/living/carbon/human/occupant
	var/locked
	name = "Body Scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/open_sound = 'sound/machines/podopen.ogg'
	var/close_sound = 'sound/machines/podclose.ogg'

// Don't dump out the occupant!
/obj/machinery/bodyscanner/proc/dump_obj_contents()
	for(var/obj/O in get_contained_external_atoms())
		O.dropInto(loc)

/obj/machinery/bodyscanner/examine(mob/user)
	. = ..()
	if (occupant && user.Adjacent(src))
		occupant.examine(arglist(args))

/obj/machinery/bodyscanner/relaymove(mob/user)
	..()
	src.go_out()

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if(!user_can_move_target_inside(usr,usr))
		return
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src

/obj/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	dump_obj_contents()
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.dropInto(loc)
	src.occupant = null
	update_use_power(POWER_USE_IDLE)
	SetName(initial(name))
	if(open_sound)
		playsound(src, open_sound, 40)

/obj/machinery/bodyscanner/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/bodyscanner/attackby(obj/item/grab/G, user)
	if(istype(G))
		var/mob/M = G.get_affecting_mob()
		if(!M || !user_can_move_target_inside(M, user))
			return
		qdel(G)
		return TRUE
	return ..()

/obj/machinery/bodyscanner/proc/user_can_move_target_inside(var/mob/target, var/mob/user)
	if(!istype(user) || !istype(target) || target.anchored)
		return FALSE
	if(occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return FALSE
	if(target.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return FALSE
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return FALSE

	target.forceMove(src)
	src.occupant = target

	update_use_power(POWER_USE_ACTIVE)
	dump_obj_contents()
	SetName("[name] ([occupant])")

	src.add_fingerprint(user)
	if(close_sound)
		playsound(src, close_sound, 40)
	return TRUE

/obj/machinery/bodyscanner/on_update_icon()
	if(!occupant)
		icon_state = "body_scanner_0"
	else if(stat & (BROKEN|NOPOWER))
		icon_state = "body_scanner_1"
	else
		icon_state = "body_scanner_2"

//Like grap-put, but for mouse-drop.
/obj/machinery/bodyscanner/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()
	if(!. && isliving(dropping))
		var/mob/living/M = dropping
		if(M.anchored)
			return FALSE
		user.visible_message( \
			SPAN_NOTICE("\The [user] begins placing \the [dropping] into \the [src]."), \
			SPAN_NOTICE("You start placing \the [dropping] into \the [src]."))
		if(do_after(user, 30, src))
			user_can_move_target_inside(dropping, user)
		return TRUE

/obj/machinery/bodyscanner/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant = null
	. = ..()
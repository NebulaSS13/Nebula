/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/structures/morgue.dmi'
	icon_state = "morgue_closed"
	density = TRUE
	anchored = TRUE

	var/open = FALSE

	var/obj/structure/morgue_tray/connected_tray

/obj/structure/morgue/get_mechanics_info()
	return "[..()]<BR>Can be labeled once with a hand labeler."

/obj/structure/morgue/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	connected_tray = new /obj/structure/morgue_tray(src)
	connected_tray.connected_morgue = src
	get_or_create_extension(src, /datum/extension/labels/single)

/obj/structure/morgue/Destroy()
	if(!QDELETED(connected_tray))
		QDEL_NULL(connected_tray)
	return ..()

/obj/structure/morgue/on_update_icon()
	..()
	if(open)
		icon_state = "morgue_open"
	else if(contents.len > 1)
		icon_state = "morgue_filled"
	else
		icon_state = "morgue_closed"

/obj/structure/morgue/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/morgue/proc/open()
	if(open)
		return

	if(!connected_tray)
		return

	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	var/turf/T = get_step(src, dir)
	connected_tray.forceMove(T)
	connected_tray.set_dir(dir)
	for(var/atom/movable/A in src)
		A.forceMove(get_turf(connected_tray))

	open = TRUE
	update_icon()

/obj/structure/morgue/proc/close()
	if(!open)
		return

	if(!connected_tray)
		return

	for(var/atom/movable/A in get_turf(connected_tray))
		if(!A.anchored && A.simulated && !(A == connected_tray))
			A.forceMove(src)

	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	connected_tray.forceMove(src)

	open = FALSE
	update_icon()

/obj/structure/morgue/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	if(open)
		close()
	else
		open()
	return TRUE

/obj/structure/morgue/attack_robot(mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/morgue/relaymove(mob/user)
	if(user.incapacitated())
		return

	open()

/obj/structure/morgue_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/structures/morgue.dmi'
	icon_state = "morgue_tray"
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	layer = BELOW_OBJ_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED | OBJ_FLAG_NOFALL

	var/obj/structure/morgue/connected_morgue

/obj/structure/morgue_tray/Destroy()
	if(!QDELETED(connected_morgue))
		QDEL_NULL(connected_morgue)
	return ..()

/obj/structure/morgue_tray/attack_hand(mob/user)
	return connected_morgue.attack_hand_with_interaction_checks(user) || ..()

/obj/structure/morgue_tray/attack_robot(mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/morgue_tray/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!. && (ismob(dropping) || istype(dropping, /obj/structure/closet/body_bag)))
		var/atom/movable/AM = dropping
		if(!AM.anchored)
			AM.forceMove(loc)
			if(user != dropping)
				user.visible_message(SPAN_NOTICE("\The [user] stuffs \the [dropping] onto \the [src]!"))
			return TRUE

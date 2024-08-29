/obj/item/chameleon
	name = "chameleon projector"
	icon = 'icons/obj/items/device/chameleon_proj.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"esoteric":4,"magnets":4}'
	material = /decl/material/solid/organic/plastic
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_appearance

/obj/item/chameleon/Destroy()
	saved_appearance = null
	if(istype(active_dummy) && !QDELETED(active_dummy))
		qdel(active_dummy)
	active_dummy = null
	return ..()

/obj/item/chameleon/dropped()
	disrupt()
	..()

/obj/item/chameleon/equipped()
	disrupt()
	..()

/obj/item/chameleon/attack_self()
	toggle()

/obj/item/chameleon/afterattack(atom/target, mob/user , proximity)

	if(!proximity)
		return ..()

	if(active_dummy)
		to_chat(user, SPAN_WARNING("\The [src] is already projecting. Turn it off first."))
		return TRUE

	if(!istype(target, /obj/item))
		to_chat(user, SPAN_WARNING("\The [src] can only mimic items."))
		return TRUE

	if(istype(target, /obj/item/disk/nuclear))
		to_chat(user, SPAN_WARNING("Inter-system tax fraud regulations prevent scanning \the [target]."))
		return TRUE

	if(!target.simulated || !target.icon || !target.icon_state || !check_state_in_icon(target.icon_state, target.icon))
		to_chat(user, SPAN_WARNING("\The [target] is not suitable for scanning."))
		return TRUE

	playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
	to_chat(user, SPAN_NOTICE("Scanned [target]."))
	saved_appearance = target.appearance

/obj/item/chameleon/proc/toggle()

	if(!can_use)
		to_chat(usr, SPAN_WARNING("\The [src] needs time to recharge!"))
		return

	if(!saved_appearance)
		to_chat(usr, SPAN_WARNING("\The [src] needs to scan something to mimic first!"))
		return

	playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
	var/obj/effect/overlay/T = new(get_turf(src))
	T.icon = 'icons/effects/effects.dmi'
	flick("emppulse",T)
	QDEL_IN(T, 8)

	if(active_dummy)
		active_dummy.dump_contents()
		QDEL_NULL(active_dummy)
		to_chat(usr, SPAN_NOTICE("You deactivate \the [src]."))
	else
		active_dummy = new(get_turf(usr), src)
		active_dummy.appearance = saved_appearance
		to_chat(usr, SPAN_NOTICE("You activate \the [src]."))
		usr.forceMove(active_dummy)

/obj/item/chameleon/proc/disrupt(var/delete_dummy = 1)
	if(!active_dummy)
		return
	spark_at(loc, amount = 5, cardinal_only = TRUE, holder = src)
	active_dummy.dump_contents()
	if(delete_dummy)
		qdel(active_dummy)
	active_dummy = null
	can_use = FALSE
	addtimer(CALLBACK(src, PROC_REF(reset_can_use)), 5 SECONDS, (TIMER_UNIQUE | TIMER_OVERRIDE))

/obj/item/chameleon/proc/reset_can_use()
	can_use = TRUE

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	is_spawnable_type = FALSE
	movement_handlers = list(/datum/movement_handler/delay/chameleon_projector)
	var/can_move = TRUE
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/Initialize(mapload, var/obj/item/chameleon/projector)
	. = ..()
	verbs.Cut()
	master = projector
	if(!istype(master) || !master.saved_appearance)
		master = null
		return INITIALIZE_HINT_QDEL
	appearance = master.saved_appearance
	master.active_dummy = src

/obj/effect/dummy/chameleon/Destroy()
	if(master)
		master.disrupt(FALSE)
		master = null
	. = ..()

/obj/effect/dummy/chameleon/proc/disrupted()
	for(var/mob/held in src)
		to_chat(held, SPAN_DANGER("Your [master.name] deactivates!"))
	master.disrupt()

/obj/effect/dummy/chameleon/attackby()
	disrupted()
	return TRUE

/obj/effect/dummy/chameleon/attack_hand()
	SHOULD_CALL_PARENT(FALSE)
	disrupted()
	return TRUE

/obj/effect/dummy/chameleon/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	disrupted()

/obj/effect/dummy/chameleon/bullet_act()
	disrupted()

// This is not ideal, but the alternative is making the effect simulated.
// As it is, the effect can freely levitate over any open space.
/obj/effect/dummy/chameleon/Move()
	. = ..()
	if(. && isturf(loc) && loc.has_gravity() && !(locate(/obj/structure/catwalk) in loc) && !(locate(/obj/structure/lattice) in loc))
		disrupted()

/datum/movement_handler/delay/chameleon_projector
	delay = 2.5 SECONDS

/datum/movement_handler/delay/chameleon_projector/MayMove(mob/mover, is_external)
	return host.loc?.has_gravity() ? ..() : MOVEMENT_STOP

/datum/movement_handler/delay/chameleon_projector/DoMove(direction, mob/mover, is_external)
	if(istype(mover))
		switch(mover.bodytemperature)
			if(300 to INFINITY)
				delay = 1 SECOND
			if(295 to 300)
				delay = 1.3 SECONDS
			if(280 to 295)
				delay = 1.6 SECONDS
			if(260 to 280)
				delay = 2 SECONDS
			else
				delay = 2.5 SECONDS
	else
		delay = 2.5 SECONDS
	..()
	step(host, direction)
	return MOVEMENT_HANDLED

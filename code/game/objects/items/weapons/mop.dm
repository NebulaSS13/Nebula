/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	throw_speed = 5
	throw_range = 10
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	material = /decl/material/solid/organic/wood/oak
	matter = list(
		/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY,
	)
	chem_volume = 30

	var/mopspeed = 40
	var/static/list/moppable_types

/obj/item/mop/proc/populate_moppable_types()
	moppable_types = list(
		/turf/floor,
		/obj/effect/decal/cleanable,
		/obj/structure/catwalk
	)

/obj/item/mop/Initialize()
	. = ..()
	if(!moppable_types)
		populate_moppable_types()

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return ..()
	var/turf/moppable_turf = get_turf(A)
	if(!istype(moppable_turf))
		return ..()

	if(moppable_turf?.reagents?.total_volume > 0)
		if(moppable_turf.reagents.total_volume > FLUID_SHALLOW)
			to_chat(user, SPAN_WARNING("There is too much water here to be mopped up."))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] begins to mop up \the [moppable_turf]."))
		if(do_after(user, 40, moppable_turf) && !QDELETED(moppable_turf))
			if(moppable_turf.reagents?.total_volume > FLUID_SHALLOW)
				to_chat(user, SPAN_WARNING("There is too much water here to be mopped up."))
			else
				to_chat(user, SPAN_NOTICE("You have finished mopping!"))
				moppable_turf.reagents?.clear_reagents()
		return TRUE

	if(!is_type_in_list(A, moppable_types))
		return ..()

	if(reagents?.total_volume < 1)
		to_chat(user, SPAN_WARNING("\The [src] is dry!"))
		return TRUE

	if(user.check_intent(I_FLAG_HARM))
		user.visible_message(SPAN_DANGER("\The [user] begins to aggressively mop \the [moppable_turf]!"))
	else
		user.visible_message(SPAN_NOTICE("\The [user] begins to clean \the [moppable_turf]."))
	if(do_after(user, mopspeed, moppable_turf) && reagents?.total_volume)
		reagents.touch_turf(moppable_turf)
		reagents.remove_any(1)
		to_chat(user, SPAN_NOTICE("You have finished mopping!"))
	return TRUE

/obj/effect/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/mop) || istype(used_item, /obj/item/soap))
		return FALSE
	return ..()

/obj/item/mop/advanced
	desc = "The most advanced tool in a custodian's arsenal, with a cleaner synthesizer to boot! Just think of all the viscera you will clean up with this!"
	name = "advanced mop"
	icon_state = "advmop"
	item_state = "mop"
	mopspeed = 20
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"engineering":4,"materials":4,"powerstorage":3}'
	_base_attack_force = 6

	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = /decl/material/liquid/cleaner //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/Initialize()
	. = ..()
	if(refill_enabled)
		START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, SPAN_NOTICE("You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position."))
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/Process()
	if(reagents.total_volume < reagents.maximum_volume)
		add_to_reagents(refill_reagent, refill_rate)

/obj/item/mop/advanced/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.")

/obj/item/mop/advanced/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

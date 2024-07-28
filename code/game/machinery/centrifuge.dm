/datum/storage/hopper/industrial/centrifuge
	can_hold = list(/obj/item/food) // also handles hive frames; see insects modpack.
	expected_type = /obj/machinery/centrifuge

/datum/storage/hopper/industrial/centrifuge/can_be_inserted(obj/item/W, mob/user, stop_messages)
	. = ..()
	if(. && !W.reagents?.total_volume)
		if(user)
			to_chat(user, SPAN_WARNING("\The [W] is empty."))
		return FALSE

/obj/machinery/centrifuge
	name = "industrial centrifuge"
	desc = "A machine used to extract reagents and materials from objects via spinning them at extreme speed."
	icon = 'icons/obj/machines/centrifuge.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	density = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	storage = /datum/storage/hopper/industrial/centrifuge
	base_type = /obj/machinery/centrifuge
	stat_immune = 0

	// Reference to our reagent container. Set to a path to create on init.
	var/obj/item/loaded_beaker

	// Stolen from fabricators.
	var/sound_id
	var/datum/sound_token/sound_token
	var/work_sound = 'sound/machines/fabricator_loop.ogg'

/obj/machinery/centrifuge/mapped
	loaded_beaker = /obj/item/chems/glass/beaker/large

/obj/machinery/centrifuge/Initialize()
	. = ..()
	if(ispath(loaded_beaker))
		loaded_beaker = new loaded_beaker

/obj/machinery/centrifuge/Destroy()
	QDEL_NULL(loaded_beaker)
	return ..()

/obj/machinery/centrifuge/dismantle()
	if(loaded_beaker)
		loaded_beaker.dropInto(loc)
		loaded_beaker = null
	return ..()

/obj/machinery/centrifuge/components_are_accessible(path)
	return use_power != POWER_USE_ACTIVE && ..()

/obj/machinery/centrifuge/cannot_transition_to(state_path, mob/user)
	if(use_power == POWER_USE_ACTIVE)
		return SPAN_NOTICE("You must wait for \the [src] to finish first!")
	return ..()

/obj/machinery/centrifuge/attackby(obj/item/used_item, mob/user)

	if(use_power == POWER_USE_ACTIVE)
		to_chat(user, SPAN_NOTICE("\The [src] is currently spinning, wait until it's finished."))
		return TRUE

	if((. = component_attackby(used_item, user)))
		return

	// Load in a new container for products.
	if(istype(used_item, /obj/item/chems/glass/beaker))
		if(loaded_beaker)
			to_chat(user, SPAN_WARNING("\The [src] already has a beaker loaded."))
			return TRUE
		if(user.try_unequip(used_item, src))
			loaded_beaker = used_item
			to_chat(user, SPAN_NOTICE("You load \the [loaded_beaker] into \the [src]."))
		return TRUE

	// Parent call handles inserting the frame into our contents,
	return ..()

/obj/machinery/centrifuge/attack_hand(mob/user)

	if(use_power == POWER_USE_ACTIVE)
		user.visible_message("\The [user] disengages \the [src].")
		update_use_power(POWER_USE_IDLE)
		return TRUE

	if(use_power == POWER_USE_IDLE)
		if(!loaded_beaker || QDELETED(loaded_beaker))
			to_chat(user, SPAN_WARNING("\The [src] has no beaker loaded to receive any products."))
			loaded_beaker = null // just in case
			return TRUE

		if(length(get_stored_inventory()))
			user.visible_message("\The [user] engages \the [src].")
			update_use_power(POWER_USE_ACTIVE)
		else
			to_chat(user, SPAN_WARNING("\The [src]'s hopper is empty."))
		return TRUE

	if(use_power == POWER_USE_OFF || !operable())
		to_chat(user, SPAN_WARNING("\The [src]'s interface is unresponsive."))
		return TRUE

	return ..()

/obj/machinery/centrifuge/Process(wait, tick)
	..()

	if(use_power != POWER_USE_ACTIVE)
		return

	if(!loaded_beaker)
		visible_message("\The [src] stops spinning and flashes a red light.")
		update_use_power(POWER_USE_IDLE)
		return

	var/list/processing_items = get_stored_inventory()
	if(!length(processing_items))
		visible_message("\The [src] stops spinning and flashes a green light.")
		update_use_power(POWER_USE_IDLE)
		return

	var/obj/item/thing = processing_items[1]
	thing.handle_centrifuge_process(src)
	if(!QDELETED(thing) && loc)
		thing.dropInto(loc)

/obj/machinery/recycler/Initialize()
	sound_id = "[work_sound]"
	return ..()

/obj/machinery/recycler/Destroy()
	QDEL_NULL(sound_token)
	return ..()

/obj/machinery/recycler/update_use_power()
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, work_sound, volume = 30)
	else
		dump_trace_material()
		QDEL_NULL(sound_token)

/obj/machinery/centrifuge/on_update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state = "[icon_state]-broken"
	else if(use_power == POWER_USE_OFF || !operable())
		icon_state = "[icon_state]-off"
	else if(use_power == POWER_USE_ACTIVE)
		icon_state = "[icon_state]-working"

/obj/machinery/centrifuge/get_alt_interactions(var/mob/user)
	. = ..()
	if(loaded_beaker)
		LAZYADD(., list(/decl/interaction_handler/remove_centrifuge_beaker))

/decl/interaction_handler/remove_centrifuge_beaker
	name = "Remove Beaker"
	expected_target_type = /obj/machinery/centrifuge

/decl/interaction_handler/remove_centrifuge_beaker/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/machinery/centrifuge/centrifuge = target
	if(centrifuge.loaded_beaker)
		centrifuge.loaded_beaker.dropInto(centrifuge.loc)
		user.put_in_hands(centrifuge.loaded_beaker)
		centrifuge.loaded_beaker = null

#define WASHER_STATE_CLOSED  1
#define WASHER_STATE_LOADED  2
#define WASHER_STATE_RUNNING 4
#define WASHER_STATE_BLOODY  8

// WASHER_STATE_RUNNING implies WASHER_STATE_CLOSED | WASHER_STATE_LOADED
// if you break this assumption, you must update the icon file
// other states are independent.

/obj/machinery/washing_machine
	name = "washing machine"
	desc = "A commerical washing machine used to wash clothing items and linens. It requires detergent for efficient washing."
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_00"
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOSCREEN
	obj_flags = OBJ_FLAG_ANCHORABLE
	clicksound = "button"
	clickvol = 40

	// Power
	idle_power_usage = 10
	active_power_usage = 150

	var/state = 0
	var/gibs_ready = FALSE
	var/max_item_size = ITEM_SIZE_LARGE

/obj/machinery/washing_machine/proc/get_wash_whitelist()
	var/static/list/wash_whitelist = list(
		/obj/item/clothing/costume,
		/obj/item/clothing/shirt,
		/obj/item/clothing/pants,
		/obj/item/clothing/skirt,
		/obj/item/clothing/dress,
		/obj/item/clothing/mask,
		/obj/item/clothing/head,
		/obj/item/clothing/gloves,
		/obj/item/clothing/shoes,
		/obj/item/clothing/suit,
		/obj/item/bedsheet,
		/obj/item/underwear
	)
	return wash_whitelist

/obj/machinery/washing_machine/proc/get_wash_blacklist()
	var/static/list/wash_blacklist = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/syndicatefake,
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/suit/armor,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/smokable/cigarette,
		/obj/item/clothing/head/helmet
	)
	return wash_blacklist

/obj/machinery/washing_machine/Initialize(mapload, d, populate_parts)
	create_reagents(100)
	. = ..()

/obj/machinery/washing_machine/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The detergent port is [atom_flags & ATOM_FLAG_OPEN_CONTAINER ? "open" : "closed"]."))

/obj/machinery/washing_machine/proc/wash()
	if(operable())
		var/list/washing_atoms = get_contained_external_atoms()
		var/amount_per_atom = floor(reagents.total_volume / length(washing_atoms))

		if(amount_per_atom > 0)
			var/decl/material/smelliest = get_smelliest_reagent(reagents)
			for(var/atom/A as anything in get_contained_external_atoms())

				// Handles washing, decontamination, dyeing, etc.
				reagents.trans_to(A, amount_per_atom)

				if(istype(A, /obj/item/clothing))
					var/obj/item/clothing/C = A
					C.ironed_state = WRINKLES_WRINKLY
					if(smelliest)
						C.change_smell(smelliest)

		// Clear out whatever remains of the reagents.
		reagents.clear_reagents()

		if(locate(/mob/living) in src)
			gibs_ready = TRUE

	state &= ~WASHER_STATE_RUNNING
	update_use_power(POWER_USE_IDLE)

/obj/machinery/washing_machine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/chems/pill/detergent))
		if(!(atom_flags & ATOM_FLAG_OPEN_CONTAINER))
			to_chat(user, SPAN_WARNING("Open the detergent port first!"))
			return
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("The detergent port is full!"))
			return
		if(!user.try_unequip(W))
			return
		// Directly transfer to the holder to avoid touch reactions.
		W.reagents?.trans_to_holder(reagents, W.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You dissolve \the [W] in the detergent port."))
		qdel(W)
		return TRUE

	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("\The [src] is currently running."))
		return TRUE

	// If the detergent port is open and the item is an open container, assume we're trying to fill the detergent port.
	if(!(state & WASHER_STATE_CLOSED) && !((atom_flags & W.atom_flags) & ATOM_FLAG_OPEN_CONTAINER))
		var/list/wash_whitelist = get_wash_whitelist()
		var/list/wash_blacklist = get_wash_blacklist()
		var/list/washing_atoms = get_contained_external_atoms()
		if(length(washing_atoms) < 5)
			if(istype(W, /obj/item/holder)) // Mob holder
				for(var/mob/living/doggy in W)
					doggy.forceMove(src)
				qdel(W)
				state |= WASHER_STATE_LOADED
				update_icon()
				return TRUE

			// An empty whitelist implies all items can be washed.
			else if((!length(wash_whitelist) || is_type_in_list(W, wash_whitelist)) && !is_type_in_list(W, wash_blacklist))
				if(W.w_class > max_item_size)
					to_chat(user, SPAN_WARNING("\The [W] is too large for \the [src]!"))
					return
				if(!user.try_unequip(W, src))
					return
				state |= WASHER_STATE_LOADED
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't put \the [W] in \the [src]."))
				return
		else
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return TRUE

	return ..()

/obj/machinery/washing_machine/physical_attack_hand(mob/user)
	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("\The [src] is currently running."))
		return TRUE
	if(state & WASHER_STATE_CLOSED)
		state &= ~WASHER_STATE_CLOSED
		if(gibs_ready)
			gibs_ready = FALSE
			var/mob/M = locate(/mob/living) in src
			if(M)
				M.gib()
		dump_contents()
		state &= ~WASHER_STATE_LOADED
		update_icon()
		return TRUE
	state |= WASHER_STATE_CLOSED
	update_icon()
	return TRUE

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	if(!CanPhysicallyInteract(usr))
		return
	if(state & WASHER_STATE_CLOSED)
		to_chat(usr, SPAN_WARNING("\The [src] is closed."))
		return
	if(!do_after(usr, 2 SECONDS, src))
		return
	if(!(state & WASHER_STATE_CLOSED))
		usr.dropInto(loc)

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)

	if(!CanPhysicallyInteract(usr))
		return

	start_washing(usr)

/obj/machinery/washing_machine/proc/start_washing(mob/user)
	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("\The [src] is already running!"))
		return
	if(!(state & WASHER_STATE_CLOSED))
		to_chat(user, SPAN_WARNING("You must first close \the [src]."))
		return
	if(!(state & WASHER_STATE_LOADED))
		to_chat(user, SPAN_WARNING("Load \the [src] first!!"))
		return
	if(!operable())
		to_chat(user, SPAN_WARNING("\The [src] isn't functioning!"))
		return

	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("There are no cleaning products loaded in \the [src]!"))
		return

	atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER

	state |= WASHER_STATE_RUNNING
	if(locate(/mob/living) in src)
		state |= WASHER_STATE_BLOODY

	update_use_power(POWER_USE_ACTIVE)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/washing_machine, wash)), 20 SECONDS)

	return TRUE

/obj/machinery/washing_machine/verb/toggle_port()
	set name = "Toggle Detergent Port"
	set category = "Object"
	set src in oview(1)

	if(!CanPhysicallyInteract(usr))
		return

	toggle_detergent_port(usr)

/obj/machinery/washing_machine/proc/toggle_detergent_port(mob/user)
	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("You can't open the detergent port while \the [src] is running!"))
		return

	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		to_chat(user, SPAN_NOTICE("You close the detergent port on \the [src]."))
	else
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		to_chat(user, SPAN_NOTICE("You open the detergent port on \the [src]."))

	return TRUE

/obj/machinery/washing_machine/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/start_washer)
	LAZYADD(., /decl/interaction_handler/toggle_open/washing_machine)

/decl/interaction_handler/start_washer
	name = "Start washer"
	expected_target_type = /obj/machinery/washing_machine

/decl/interaction_handler/start_washer/is_possible(obj/machinery/washing_machine/washer, mob/user)
	. = ..()
	if(.)
		return washer.operable() && !(washer.state & WASHER_STATE_RUNNING)

/decl/interaction_handler/start_washer/invoked(obj/machinery/washing_machine/washer, mob/user)
	return washer.start_washing(user)

/decl/interaction_handler/toggle_open/washing_machine
	name = "Toggle detergent port"
	expected_target_type = /obj/machinery/washing_machine

/decl/interaction_handler/toggle_open/washing_machine/invoked(obj/machinery/washing_machine/washer, mob/user)
	return washer.toggle_detergent_port(user)

/obj/machinery/washing_machine/on_update_icon()
	icon_state = "wm_[state][panel_open]"

/obj/machinery/washing_machine/clean(clean_forensics = TRUE)
	. = ..()
	state &= ~WASHER_STATE_BLOODY
	update_icon()

/obj/machinery/washing_machine/components_are_accessible(path)
	return !(state & WASHER_STATE_RUNNING) && ..()

/obj/machinery/washing_machine/autoclave
	name = "autoclave"
	desc = "An industrial washing machine used to sterilize and decontaminate items. It requires detergent for efficient decontamination."
	max_item_size = ITEM_SIZE_HUGE
	idle_power_usage = 10
	active_power_usage = 300

/obj/machinery/washing_machine/autoclave/get_wash_whitelist()
	return

/obj/machinery/washing_machine/autoclave/get_wash_blacklist()
	return

#undef WASHER_STATE_CLOSED
#undef WASHER_STATE_LOADED
#undef WASHER_STATE_RUNNING
#undef WASHER_STATE_BLOODY
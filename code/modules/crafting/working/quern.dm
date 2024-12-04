/datum/storage/hopper/mortar/quern
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

/obj/structure/working/quern
	name       = "quern-stone"
	desc       = "A pair of heavy stones connected by an axle, used to grind plants and minerals into powder."
	icon       = 'icons/obj/structures/quern.dmi'
	material   = /decl/material/solid/stone/granite
	color      = /decl/material/solid/stone/granite::color
	storage    = /datum/storage/hopper/mortar/quern
	work_skill = SKILL_COOKING // Maybe?
	var/tmp/volume = 1000 // Same as reagent dispensers. Possibly too large?
	var/amount_dispensed              = 10
	var/tmp/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/working/quern/Initialize()
	. = ..()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	initialize_reagents()

/obj/structure/working/quern/try_start_working(mob/user)

	if(!length(get_stored_inventory()))
		to_chat(user, SPAN_WARNING("There is nothing in \the [src] to grind."))
		return TRUE

	start_working()
	while(length(get_stored_inventory()) && user.do_skilled(1.5 SECONDS, work_skill, src))
		if(QDELETED(src) || QDELETED(user) || user.get_stamina() < 25 || !user.get_empty_hand_slot())
			break
		var/list/stored = get_stored_inventory()
		var/obj/item/grinding = stored[1]
		if(!istype(grinding))
			break
		if(!grind_item(grinding, user))
			visible_message(SPAN_WARNING("\The [src] clunks and grinds loudly, unable to crush \the [grinding]."))
			break
		user.adjust_stamina(-25)

	if(!QDELETED(user))
		to_chat(user, SPAN_NOTICE("You stop working \the [src]."))

	stop_working()
	return TRUE

/obj/structure/working/quern/proc/grind_item(obj/item/grinding, mob/user)
	if(!istype(grinding))
		return
	var/decl/material/attacking_material = get_material()
	var/decl/material/crushing_material = grinding.get_material()
	if(!attacking_material || !crushing_material || attacking_material.hardness <= crushing_material.hardness)
		return FALSE
	if(REAGENTS_FREE_SPACE(reagents) < grinding.reagents?.total_volume)
		return FALSE
	if(grinding.reagents?.total_volume) // if it has no reagents, skip all the fluff and destroy it instantly
		grinding.reagents.trans_to(src, grinding.reagents.total_volume)
	QDEL_NULL(grinding)
	return TRUE

// Reagent handling code copied from reagent dispensers. TODO: make reagent handling an extension or something.
/obj/structure/working/quern/attackby(obj/item/used_item, mob/user)
	// We do this here to avoid putting the vessel straight into storage.
	// This is usually handled by afterattack on /chems.
	if(storage && ATOM_IS_OPEN_CONTAINER(used_item) && user.check_intent(I_FLAG_HELP))
		if(used_item.standard_dispenser_refill(user, src))
			return TRUE
		if(used_item.standard_pour_into(user, src))
			return TRUE
	return ..()

/obj/structure/working/quern/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(volume)
	else
		reagents.maximum_volume = max(reagents.maximum_volume, volume)
	. = ..()

/obj/structure/working/quern/verb/set_amount_dispensed()
	set name = "Set amount dispensed"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!"))
		return
	var/new_amount = input("Amount dispensed:","[src]") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (new_amount)
		amount_dispensed = new_amount

/obj/structure/working/quern/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		. += SPAN_NOTICE("It contains:")
		if(LAZYLEN(reagents?.reagent_volumes))
			for(var/decl/material/reagent as anything in reagents.liquid_volumes)
				. += SPAN_NOTICE("[LIQUID_VOLUME(reagents, reagent)] unit\s of [reagent.get_reagent_name(reagents, MAT_PHASE_LIQUID)].")
			for(var/decl/material/reagent as anything in reagents.solid_volumes)
				. += SPAN_NOTICE("[SOLID_VOLUME(reagents, reagent)] unit\s of [reagent.get_reagent_name(reagents, MAT_PHASE_SOLID)].")

/obj/structure/working/quern/get_reagent_amount_dispensed()
	return amount_dispensed

/obj/structure/working/quern/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/set_transfer/quern)

//Set amount dispensed
/decl/interaction_handler/set_transfer/quern
	expected_target_type = /obj/structure/working/quern

/decl/interaction_handler/set_transfer/quern/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/structure/working/quern/quern = target
		return !!quern.possible_transfer_amounts

/decl/interaction_handler/set_transfer/quern/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/structure/working/quern/quern = target
	quern.set_amount_dispensed()

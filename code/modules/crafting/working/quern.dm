/datum/storage/hopper/mortar/quern
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

/obj/structure/working/quern
	name        = "quern-stone"
	desc        = "A pair of heavy stones connected by an axle, used to grind plants and minerals into powder."
	icon        = 'icons/obj/structures/quern.dmi'
	material    = /decl/material/solid/stone/granite
	color       = /decl/material/solid/stone/granite::color
	storage     = /datum/storage/hopper/mortar/quern
	work_skill  = SKILL_COOKING // Maybe?
	chem_volume = 1000 // Same as reagent dispensers. Possibly too large?
	var/amount_dispensed              = 10
	var/tmp/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/working/quern/Initialize()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	. = ..()

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
	if(REAGENTS_FREE_SPACE(reagents) < REAGENT_TOTAL_VOLUME(grinding.reagents))
		return FALSE
	if(REAGENT_TOTAL_VOLUME(grinding.reagents)) // if it has no reagents, skip all the fluff and destroy it instantly
		grinding.reagents.trans_to(src, REAGENT_TOTAL_VOLUME(grinding.reagents))
	QDEL_NULL(grinding)
	return TRUE

/obj/structure/working/quern/set_reagent_amount_dispensed(new_amount)
	amount_dispensed = new_amount

/obj/structure/working/quern/get_reagent_amount_dispensed()
	return amount_dispensed

/obj/structure/working/quern/get_possible_reagent_transfer_amounts()
	return cached_json_decode(possible_transfer_amounts)

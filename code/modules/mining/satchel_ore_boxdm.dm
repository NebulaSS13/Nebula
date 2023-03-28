
/**********************Ore box**************************/

/obj/structure/ore_box
	name                   = "ore box"
	desc                   = "A heavy box used for storing ore."
	icon                   = 'icons/obj/mining.dmi'
	icon_state             = "orebox0"
	density                = TRUE
	material               = /decl/material/solid/wood
	atom_flags             = ATOM_FLAG_CLIMBABLE
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	///Maximum amount of ores of all types that can be stored in the box.
	var/tmp/maximum_ores  = 1200
	///The current total amount of ores of all types that were placed inside.
	var/total_ores = 0
	///A list with all the ores of every types that are currently inside. Associative list (ore name = ore amount).
	var/list/stored_ore

/obj/structure/ore_box/attack_hand(mob/user)
	if(total_ores <= 0 || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/obj/item/stack/material/ore/O = pick(get_contained_external_atoms())
	if(!remove_ore(O, user))
		return ..()
	to_chat(user, SPAN_NOTICE("You grab a random ore pile from \the [src]."))
	return TRUE

/obj/structure/ore_box/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/stack/material/ore))
		return insert_ore(W, user)

	else if (istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		S.hide_from(usr)
		for(var/obj/item/stack/material/ore/O in S.contents)
			if(total_ores >= maximum_ores)
				break
			S.remove_from_storage(O, src, TRUE) //This will move the item to this item's contents
			insert_ore(O)

		S.finish_bulk_removal()
		to_chat(user, SPAN_NOTICE("You empty \the [W] into \the [src]."))
		return TRUE

	return ..()

///Insert many ores into the box
/obj/structure/ore_box/proc/insert_ores(var/list/ores, var/mob/user)
	var/inserted = 0
	for(var/obj/item/stack/material/ore/O in ores)
		if(total_ores >= maximum_ores)
			if(user)
				to_chat(user, SPAN_WARNING("You insert only what you can.."))
			break
		inserted += O.amount
		insert_ore(O)
	return inserted

///Inserts an ore pile into the box
/obj/structure/ore_box/proc/insert_ore(var/obj/item/stack/material/ore/O, var/mob/user)
	var/possible_amount = max(0, maximum_ores - (O.amount + total_ores))
	if(possible_amount == 0)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return FALSE
	else if(possible_amount < O.amount) //Only split if we have more than one, and if the whole stack doesn't fit
		if(!O.can_split())
			if(user)
				to_chat(user, SPAN_WARNING("You can't fit that in there!"))
			return FALSE
		O = O.split(possible_amount)

	if(user)
		user.try_unequip(O, src)
		add_fingerprint(user)
	else
		O.forceMove(src)

	LAZYSET(stored_ore, O.name, min(LAZYACCESS(stored_ore, O.name) + O.amount, maximum_ores))
	total_ores = min(O.amount + total_ores, maximum_ores)
	return TRUE

///Remove the given ore from the box
/obj/structure/ore_box/proc/remove_ore(var/obj/item/stack/material/ore/O, var/mob/user)
	if(total_ores <= 0)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return FALSE
	if(user && !user.check_dexterity(DEXTERITY_GRIP))
		to_chat(user, SPAN_WARNING("You lack the dexterity to empty \the [src]!"))
		return FALSE

	if(user)
		user.put_in_hands(O)
		add_fingerprint(user)
	else
		O.forceMove(loc)

	LAZYSET(stored_ore, O.name, max(0, LAZYACCESS(stored_ore, O.name) - O.amount))
	total_ores = max(0, total_ores - O.amount)
	return O

/obj/structure/ore_box/proc/empty_box(var/mob/user)
	if(total_ores <= 0)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return FALSE
	if(user && !user.check_dexterity(DEXTERITY_GRIP))
		to_chat(user, SPAN_WARNING("You lack the dexterity to empty \the [src]!"))
		return FALSE
	if(user)
		add_fingerprint(user)
		to_chat(user, SPAN_NOTICE("You empty \the [src]."))
	dump_contents()
	LAZYCLEARLIST(stored_ore)
	total_ores = 0
	return TRUE

/obj/structure/ore_box/examine(mob/user, distance)
	. = ..()
	if(distance > 1) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(user)
	if(total_ores <= 0)
		to_chat(user, "It is empty.")
		return
	to_chat(user, "It holds:")
	for(var/ore in stored_ore)
		to_chat(user, "- [stored_ore[ore]] [ore]")

/obj/structure/ore_box/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src) && (severity == 1 || prob(50)))
		physically_destroyed()

/obj/structure/ore_box/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/empty/ore_box)

/decl/interaction_handler/empty/ore_box
	name = "Empty Box"
	expected_target_type = /obj/structure/ore_box

/decl/interaction_handler/empty/ore_box/is_possible(obj/structure/ore_box/target, mob/user, obj/item/prop)
	return ..() && target.total_ores > 0

/decl/interaction_handler/empty/ore_box/invoked(obj/structure/ore_box/target, mob/user)
	target.empty_box(user)
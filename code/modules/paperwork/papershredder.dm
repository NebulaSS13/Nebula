//////////////////////////////////////////////////////////////////
// Paper Shredder
//////////////////////////////////////////////////////////////////
/obj/machinery/papershredder
	name               = "paper shredder"
	desc               = "For those documents you don't want seen."
	icon               = 'icons/obj/machines/paper_shredder.dmi'
	icon_state         = "papershredder0"
	density            = TRUE
	anchored           = TRUE
	atom_flags         = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags          = OBJ_FLAG_ANCHORABLE
	idle_power_usage   = 0
	stat_immune        = NOSCREEN | NOINPUT
	waterproof         = FALSE
	construct_state    = /decl/machine_construction/default/panel_closed
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc = 1,
	)
	var/list/shredder_bin                                 //List of shreded material type to matter amount
	var/cached_total_matter  = 0                          //Total of all the matter units we put in the shredder so far
	var/tmp/max_total_matter = SHEET_MATERIAL_AMOUNT * 10 //Maximum amount of matter that can be stored inside the bin

/obj/machinery/papershredder/Initialize()
	. = ..()
	update_icon()

/obj/machinery/papershredder/on_component_failure(obj/item/stock_parts/component)
	. = ..()

	if(istype(component, /obj/item/stock_parts/circuitboard))
		spark_at(get_turf(src), 30, FALSE, src)
		empty_bin(violent = TRUE)

/**Shreds the given object. */
/obj/machinery/papershredder/proc/shred(var/obj/item/I, var/mob/user)
	if(inoperable())
		to_chat(user, SPAN_WARNING("\The [src] doesn't seem to work."))
		return
	if(is_bin_full())
		visible_message(SPAN_WARNING("The \"bin full\" warning light is flashing on \the [src]!"))
		return
	//#TODO: Uncomment this once the bug is fixed, so we check for available power before actually working
	// if(!powered() || can_use_power_oneoff(60) <= 0)
	// 	to_chat(user, SPAN_WARNING("\The [src] seems to be lacking power..."))
	// 	return
	use_power_oneoff(60)
	user.try_unequip(I, src)

	//If the material is too hard damage the shredder
	var/decl/material/M = I.material
	if(M.hardness > MAT_VALUE_FLEXIBLE && M.hardness < MAT_VALUE_RIGID)
		audible_message(SPAN_WARNING("You hear a loud mechanical grinding!"))
		take_damage(1, BRUTE, TRUE)
		spark_at(get_turf(src), 1, FALSE, src)
		. = TRUE

	else if(M.hardness >= MAT_VALUE_RIGID)
		audible_message(SPAN_DANGER("You hear rattling and then a loud bang!"))
		use_power_oneoff(200)
		take_damage(25, BRUTE, TRUE)
		set_broken(TRUE, MACHINE_BROKEN_GENERIC)
		. = FALSE

	else
		visible_message(SPAN_NOTICE("\The [src] happily consumes \the [I]."))
		. = TRUE

	if(.)
		//Move over the matter
		for(var/key in I.matter)
			if(I.matter[key] < 1)
				continue
			var/new_matter = LAZYACCESS(shredder_bin, key) + I.matter[key]
			cached_total_matter += new_matter
			LAZYSET(shredder_bin, key, new_matter)

		I.physically_destroyed()
		playsound(get_turf(src), 'sound/items/pshred.ogg', 50, TRUE)
	else
		I.dropInto(get_turf(user))
		playsound(get_turf(src), 'sound/effects/metalscrape1.ogg', 40, TRUE)
	update_icon()

/obj/machinery/papershredder/proc/is_bin_full()
	return cached_total_matter >= max_total_matter

/obj/machinery/papershredder/proc/is_bin_empty()
	return !(length(shredder_bin) > 0 && cached_total_matter)

/obj/machinery/papershredder/proc/can_shred(var/obj/item/I, var/mob/user = null)
	if(!istype(I))
		if(user)
			to_chat(user, SPAN_WARNING("\The [I] cannot be shredded by \the [src]!"))
		return

	//Being one of those types bypasses the checks
	if(istype(I, /obj/item/paper) || istype(I, /obj/item/paper_bundle) || istype(I, /obj/item/folder) || istype(I, /obj/item/newspaper) || istype(I, /obj/item/photo))
		return TRUE

	//Generic tests for random objects
	if(I.w_class > ITEM_SIZE_TINY)
		if(user)
			to_chat(user, SPAN_WARNING("\The [I] is too big to be inserted into \the [src]!"))
		return

	var/decl/material/M = I.material
	if(!istype(M) || M.hardness >= MAT_VALUE_HARD)
		if(user)
			to_chat(user, SPAN_WARNING("\The [I] is obviously not shreddable."))
		return
	return TRUE

/obj/machinery/papershredder/attackby(var/obj/item/W, var/mob/user)
	if(!has_extension(W, /datum/extension/tool)) //Silently skip tools
		var/trying_to_smack = !(W.item_flags & ITEM_FLAG_NO_BLUDGEON) && user && user.a_intent == I_HURT
		if(istype(W, /obj/item/storage))
			empty_bin(user, W)
			return TRUE

		else if(!trying_to_smack && can_shred(W))
			shred(W, user)
			return TRUE
	return ..()

/**Creates shredded products, and empty the matter bin */
/obj/machinery/papershredder/proc/create_shredded()
	for(var/key in shredder_bin)
		var/decl/material/M = GET_DECL(key)
		var/amt_per_shard = atom_info_repository.get_matter_for(M.shard_type, key, 1)
		if(shredder_bin[key] > amt_per_shard)
			LAZYADD(., M.place_cuttings(src, shredder_bin[key]))

	//Anything leftover we just assume the machine ate or something
	cached_total_matter = 0
	LAZYCLEARLIST(shredder_bin)

/**Empties the paper bin into the given container, and/or on the floor. If violent is on, and there's no container passed, we're going to throw around the trash. */
/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/storage/empty_into, var/violent = FALSE)
	if(is_bin_empty())
		if(user)
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return
	if(empty_into && !istype(empty_into)) // Make sure we can store paper in the thing
		if(user)
			to_chat(user, SPAN_NOTICE("You cannot put shredded paper into the [empty_into]."))
		return

	//If we got a container put what we can into it
	var/list/shredded = create_shredded()
	if(empty_into)
		for(var/obj/item/I in shredded)
			if(empty_into.can_be_inserted(I, user, !isnull(user)))
				empty_into.handle_item_insertion(I, TRUE)
				LAZYREMOVE(shredded, I)

		// Report on how we did
		if(user)
			if(length(shredded) < 1)
				to_chat(user, SPAN_NOTICE("You empty \the [src] into \the [empty_into]."))
			else
				to_chat(user, SPAN_NOTICE("\The [empty_into] will not fit any more shredded paper."))

	//Drop the leftovers
	if(LAZYLEN(shredded))
		var/turf/T = get_turf(user? user : src)
		for(var/obj/item/I in shredded)
			I.dropInto(T)
			if(violent)
				I.throw_at(get_edge_target_turf(src, pick(global.alldirs)), I.throw_range, I.throw_speed)

	update_icon()
	return TRUE

/obj/machinery/papershredder/on_update_icon()
	cut_overlays()
	var/ratio = ((cached_total_matter * 5) / max_total_matter)
	icon_state = "papershredder[clamp(0, CEILING(ratio), 5)]"
	if(!is_unpowered())
		add_overlay("papershredder_power")
		if(is_broken() || is_bin_full())
			add_overlay("papershredder_bad")

/obj/machinery/papershredder/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/empty/paper_shredder)

//////////////////////////////////////////////////////////////////
// Empty Bin Interaction
//////////////////////////////////////////////////////////////////
/decl/interaction_handler/empty/paper_shredder
	name = "Empty Bin"
	expected_target_type = /obj/machinery/papershredder

/decl/interaction_handler/empty/paper_shredder/is_possible(obj/machinery/papershredder/target, mob/user, obj/item/prop)
	return ..() && !target.is_bin_empty()

/decl/interaction_handler/empty/paper_shredder/invoked(obj/machinery/papershredder/target, mob/user)
	target.empty_bin(user)

//////////////////////////////////////////////////////////////////
// Shredded Paper
//////////////////////////////////////////////////////////////////
/obj/item/shreddedp
	name         = "shredded"
	icon         = 'icons/obj/bureaucracy.dmi'
	icon_state   = "shredp"
	randpixel    = 5
	throw_range  = 3
	throw_speed  = 2
	throwforce   = 0
	w_class      = ITEM_SIZE_TINY
	material     = /decl/material/solid/paper
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/shreddedp/get_matter_amount_modifier()
	return 0.2

/obj/item/shreddedp/set_material(new_material)
	. = ..()
	if(material)
		SetName("[initial(name)] [material.solid_name]")

/obj/item/shreddedp/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/flame/lighter))
		burnpaper(W, user)
		return TRUE
	return ..()

/obj/item/shreddedp/proc/burnpaper(var/obj/item/flame/lighter/P, var/mob/user)
	if(!CanPhysicallyInteractWith(user, src) && material?.fuel_value)
		return
	if(!P.lit)
		to_chat(user, SPAN_WARNING("\The [P] is not lit."))
		return
	var/decl/pronouns/G = user.get_pronouns()
	user.visible_message(\
		SPAN_WARNING("\The [user] holds \the [P] up to \the [src]. It looks like [G.he] [G.is] trying to burn it!"), \
		SPAN_WARNING("You hold \the [P] up to \the [src], burning it slowly."))
	if(!do_after(user,20, src))
		to_chat(user, SPAN_WARNING("You must hold \the [P] steady to burn \the [src]."))
		return
	user.visible_message( \
		SPAN_DANGER("\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."), \
		SPAN_DANGER("You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."))
	fire_act()

/obj/item/shreddedp/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	physically_destroyed()

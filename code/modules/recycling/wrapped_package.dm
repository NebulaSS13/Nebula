/////////////////////////////////////////////////////////////////////
// Parcel
/////////////////////////////////////////////////////////////////////

/**
 * A parcel wrapper for items and structures that can be wrapped in wrapping paper.
 */
/obj/item/parcel
	name              = "parcel"
	desc              = "A wrapped package."
	icon              = 'icons/obj/items/storage/deliverypackage.dmi'
	icon_state        = "parcel"
	obj_flags         = OBJ_FLAG_HOLLOW
	material          = /decl/material/solid/paper
	attack_verb       = list("delivered a hit", "expedited on", "shipped at", "went postal on")
	base_parry_chance = 40 //Boxes tend to be good at parrying
	///A text note attached to the parcel that shows on examine
	var/attached_note
	///The first part of the icon_state names
	var/tmp/icon_state_prefix = "parcel"
	///Color of the dropped paper trash on unwrapping.
	var/tmp/trash_color = "#b97644"

/obj/item/parcel/Initialize(ml, material_key, var/atom/movable/contained_object = null, var/_attached_note = null)
	. = ..(ml, material_key)

	if(contained_object && !make_parcel(contained_object))
		log_warning("[src] ([x], [y], [z]) failed to set its package content. Deleting!")
		return INITIALIZE_HINT_QDEL

	if(length(_attached_note))
		attached_note = _attached_note

	update_icon()

/obj/item/parcel/on_update_icon()
	. = ..()
	if(w_class < ITEM_SIZE_NO_CONTAINER)
		icon_state = "[icon_state_prefix]_[clamp(round(w_class), ITEM_SIZE_MIN, ITEM_SIZE_HUGE)]"
	else
		//If its none of the smaller items, default to crate-sized package
		icon_state = "[icon_state_prefix]_crate"
		//Try to see if we got a better icon state for whatever we contain
		if(length(contents))
			if(istype(contents?[1], /obj/structure/closet) && !istype(contents?[1], /obj/structure/closet/crate))
				icon_state = "[icon_state_prefix]_closet"
			else if(ishuman(contents?[1]))
				icon_state = "[icon_state_prefix]_human"

	//Apply the sorting tag icon on top of our sprite. The extension does it for us.
	var/datum/extension/sorting_tag/S = get_extension(src, /datum/extension/sorting_tag)
	if(S)
		S.apply_tag_overlay()

	//Put a label on if we added a note
	if(length(attached_note) && icon_state != "[icon_state_prefix]_1")
		var/off_x = 0
		var/off_y = 0
		if(icon_state == "[icon_state_prefix]_5")
			off_y = -1
		else if(icon_state == "[icon_state_prefix]_crate")
			off_x = rand(-8, 6)
			off_y = -3
		else if(icon_state == "[icon_state_prefix]_closet")
			off_x = 2
			off_y = rand(-6, 11)
		else if(icon_state == "[icon_state_prefix]_human")
			off_x = rand(-3, 3)
			off_y = rand(-6, 11)

		//Keep the full icon path, since subclasses may not have the label in their icon file
		var/image/I = image('icons/obj/items/storage/deliverypackage.dmi', "delivery_label", pixel_x = off_x, pixel_y = off_y)
		add_overlay(I)

/obj/item/parcel/examine(mob/user, distance)
	. = ..()
	if(distance < 3)
		var/datum/extension/sorting_tag/S = get_extension(src, /datum/extension/sorting_tag)
		if(S)
			to_chat(user, S.tag_description())
		if(length(attached_note))
			to_chat(user, "It has a note attached, which reads:'[attached_note]'.")

/obj/item/parcel/get_mechanics_info()
	. = ..()
	. += "<BR/>It can be opened by applying any sharp item, with help intent."
	. += "<BR/>It can opened by using it while held, if its small enough."

/obj/item/parcel/proc/make_parcel(var/atom/movable/AM, var/mob/user)
	if(!is_type_in_list(AM, get_whitelist()))
		log_warning("[src] ([x], [y], [z]) was passed an invalid atom type to contain[istype(AM, /datum)? " '[AM.type]'" : ", value: [AM]"].")
		return
	var/parcel_name
	var/parcel_size
	var/obj/O = AM

	if(istype(O))
		parcel_size = round(O.w_class)
	else if(ismob(AM))
		var/mob/M = AM
		//#FIXME: These will almost 100% be badly named for their size. Since according to scale crab, cat and corgis are bigger than gargantuan for example.
		parcel_size = round(M.mob_size)
	else
		CRASH("Make parcel got passed an invalid atom type '[AM?.type]'.")

	//Name the parcel based on its size
	switch(parcel_size)
		if(ITEM_SIZE_TINY)
			parcel_name = "tiny [initial(name)]"
		if(ITEM_SIZE_SMALL)
			parcel_name = "small [initial(name)]"
		if(ITEM_SIZE_NORMAL)
			parcel_name = "normal-sized [initial(name)]"
		if(ITEM_SIZE_LARGE)
			parcel_name = "large [initial(name)]"
		if(ITEM_SIZE_HUGE, ITEM_SIZE_GARGANTUAN)
			parcel_name = "huge [initial(name)]"
		else
			parcel_name = "enormous [initial(name)]"

	SetName(parcel_name)
	w_class = parcel_size
	density = AM.density
	opacity = AM.opacity

	if(AM.atom_flags & ATOM_FLAG_CLIMBABLE)
		atom_flags |= ATOM_FLAG_CLIMBABLE
	else
		atom_flags &= ~ATOM_FLAG_CLIMBABLE

	if(user)
		add_fingerprint(user)
		AM.add_fingerprint(user)

	//Notify properly whatever we're taking the thing from
	//And then put it in the user's hands if it makes sense
	if(ismob(AM.loc))
		var/mob/M = AM.loc
		if(!M.try_unequip(AM, src))
			CRASH("Tried to make a parcel from an item in a mob's inventory that cannot be unequipped. Should have been filtered out before. [log_info_line(src)]")
		if(M == user)
			user.put_in_hands(src)

	if(istype(AM.loc, /obj/item/storage))
		var/obj/item/storage/S = AM.loc
		S.remove_from_storage(AM, src)
		S.handle_item_insertion(src, TRUE)
	else
		AM.forceMove(src)

	//Make sure we contain exactly the amount of paper sheets used to wrap ourselves
	LAZYSET(matter, material.type, (AM.wrapping_paper_needed_to_wrap() * SHEET_MATERIAL_AMOUNT))
	update_icon()
	update_held_icon()
	return TRUE

/obj/item/parcel/proc/unwrap(var/mob/user)
	visible_message(SPAN_NOTICE("\The [user] starts tearing the wrapping off \the [src]."), SPAN_NOTICE("You start tearing the wrapping off \the [src]."))
	//I guess cargo techs would definitely be faster at opening packages.
	if(user.do_skilled(3 SECONDS, SKILL_HAULING, src))
		visible_message(SPAN_NOTICE("\The [user] unwrapped \the [src]!"), SPAN_NOTICE("You unwrapped \the [src]!"))
		if(!length(contents))
			to_chat(user, SPAN_WARNING("\The [src] was empty!"))
		playsound(src, 'sound/items/poster_ripped.ogg', 50, TRUE)
		physically_destroyed()
		return TRUE
	return FALSE

/obj/item/parcel/attack_robot(mob/user)
	unwrap(user)

/obj/item/parcel/attack_self(mob/user)
	unwrap(user)

/obj/item/parcel/attack_hand(mob/user)
	if(w_class >= ITEM_SIZE_NO_CONTAINER)
		return TRUE
	return ..()

/obj/item/parcel/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/destTagger))
		user.setClickCooldown(attack_cooldown)
		var/obj/item/destTagger/O = W
		if(length(O.current_tag))
			to_chat(user, SPAN_NOTICE("You have labeled the destination as '[O.current_tag]'."))
			attach_destination_tag(O, user)
		else
			to_chat(user, SPAN_WARNING("You need to set a destination tag first!"))
		return TRUE

	else if(IS_PEN(W))
		var/old_note = attached_note
		var/new_note = sanitize(input(user, "What note would you like to add to \the [src]?", "Add Note", attached_note))
		if((new_note != old_note) && user.Adjacent(src) && W.do_tool_interaction(TOOL_PEN, user, src, 2 SECONDS) && user.Adjacent(src))
			attached_note = new_note
			update_icon()
		return TRUE

	else if(W.sharp && user.a_intent == I_HELP)
		//You can alternative cut the wrapper off with a sharp item
		unwrap(user)
		return TRUE

	return ..()

///Attach a destination tag for the sorting machine to route the parcel to its destination.
//#TODO: Eventually should probably be moved somewhere more sensible within the sorting_tag extension?
/obj/item/parcel/proc/attach_destination_tag(var/obj/item/destTagger/T, var/mob/user)
	var/off_x = 0
	var/off_y = 0
	if(icon_state == "[icon_state_prefix]_1")
		off_y = -5
	else if(icon_state == "[icon_state_prefix]_2")
		off_y = -2
	else if(icon_state == "[icon_state_prefix]_4")
		off_x = rand(0,5)
		off_y = 3
	else if(icon_state == "[icon_state_prefix]_5")
		off_y = -3
	else if(icon_state == "[icon_state_prefix]_closet")
		off_x = rand(-2, 3)
		off_y = 9
	else if(icon_state == "[icon_state_prefix]_crate")
		off_x = rand(-8, 6)
		off_y = -3
	else if(icon_state == "[icon_state_prefix]_human")
		off_x = rand(-2, 2)
		off_y = 10

	//Update or create the tag extension
	var/datum/extension/sorting_tag/S = get_or_create_extension(src, /datum/extension/sorting_tag)
	S.destination    = T.current_tag
	S.tag_icon_state = "delivery_tag"
	S.tag_x          = off_x
	S.tag_y          = off_y
	update_icon()
	playsound(src, 'sound/effects/checkout.ogg', 40, TRUE, 2)

/obj/item/parcel/physically_destroyed(skip_qdel)
	if(istype(material) && LAZYACCESS(matter, material.type))
		var/list/cuttings = material.place_cuttings(get_turf(src), matter[material.type])
		//Make the bits of paper the right color
		for(var/obj/item/C in cuttings)
			C.material_alteration &= ~(MAT_FLAG_ALTERATION_COLOR) //Prevents the update_icon code from recoloring this white
			C.set_color(trash_color)
	. = ..()

/obj/item/parcel/dump_contents()
	for(var/thing in get_contained_external_atoms())
		var/atom/movable/AM = thing

		//If the parcel is broken in someone's hands or bag, make sure its not just dumped on the ground.
		if(ismob(loc))
			var/mob/M = loc
			M.put_in_hands(AM)
		else if(istype(loc, /obj/item/storage))
			var/obj/item/storage/S = loc
			S.handle_item_insertion(AM, TRUE)
		else
			AM.dropInto(loc)

		if(ismob(AM))
			var/mob/M = AM
			M.reset_view()

///list of atom types that can be wrapped. Includes subtypes of the specified types.
/obj/item/parcel/proc/get_whitelist()
	var/static/list/type_whitelist = list(
		/obj/item,
		/obj/structure,
		/obj/machinery,
		/mob/living/carbon/human,
	)
	return type_whitelist

/////////////////////////////////////////////////////////////////////
// Gift
/////////////////////////////////////////////////////////////////////
/obj/item/parcel/gift
	name              = "gift"
	desc              = "A carefully wrapped box. How thoughtful!"
	icon              = 'icons/obj/items/gift_wrapped.dmi'
	icon_state        = "gift"
	item_state        = "gift"
	icon_state_prefix = "gift"
	w_class           = ITEM_SIZE_NORMAL
	attack_verb       = list("surprised", "gifted", "spoiled", "expressed their grattitude towards")
	trash_color       = "#009900"

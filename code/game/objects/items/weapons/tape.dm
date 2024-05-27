///////////////////////////////////////////////
// Tape Roll
///////////////////////////////////////////////
/**Base class for all things tape, with a limit amount of uses. */
/obj/item/stack/tape_roll
	name              = "roll of tape"
	gender            = NEUTER
	singular_name     = "length of tape"
	plural_name       = "lengths of tape"
	amount            = 32
	max_amount        = 32
	w_class           = ITEM_SIZE_SMALL
	material          = /decl/material/solid/organic/plastic
	current_health    = 10
	max_health        = 10
	matter_multiplier = 0.25

/obj/item/stack/tape_roll/can_split()
	return FALSE
/obj/item/stack/tape_roll/can_merge_stacks(var/obj/item/stack/other)
	return FALSE

///////////////////////////////////////////////
// Duct Tape
///////////////////////////////////////////////
/obj/item/stack/tape_roll/duct_tape
	name       = "duct tape roll"
	desc       = "A roll of durable, one-sided sticky tape. Possibly for taping ducks... or was that ducts?"
	icon       = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	item_flags = ITEM_FLAG_NO_BLUDGEON

/obj/item/stack/tape_roll/duct_tape/Initialize(mapload, amount, material)
	. = ..()
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_BONE_GEL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SUTURES =  TOOL_QUALITY_BAD
	))

/obj/item/stack/tape_roll/duct_tape/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(user.get_target_zone() == BP_R_HAND || user.get_target_zone() == BP_L_HAND)
		if(!can_use(4))
			to_chat(user, SPAN_WARNING("There's not enough [plural_name] in your [src] to tape \the [target]'s hands! You need at least 4 [plural_name]."))
			return TRUE
		use(4)
		playsound(src, 'sound/effects/tape.ogg',25)
		var/obj/item/handcuffs/cable/tape/T = new(user)
		if(!T.place_handcuffs(target, user))
			qdel(T)
		return TRUE

	if(user.get_target_zone() == BP_CHEST)
		var/obj/item/clothing/suit/space/suit = target.get_equipped_item(slot_wear_suit_str)
		if(istype(suit))
			suit.attackby(src, user)//everything is handled by attackby
		else
			to_chat(user, SPAN_WARNING("\The [target] isn't wearing a spacesuit for you to reseal."))
		return TRUE

	if(!target?.should_have_organ(BP_HEAD))
		return ..()

	if(user.get_target_zone() == BP_EYES)
		if(!GET_EXTERNAL_ORGAN(target, BP_HEAD))
			to_chat(user, SPAN_WARNING("\The [target] doesn't have a head."))
			return TRUE

		if(!target.check_has_eyes())
			to_chat(user, SPAN_WARNING("\The [target] doesn't have any eyes."))
			return TRUE

		if(target.get_equipped_item(slot_glasses_str))
			to_chat(user, SPAN_WARNING("\The [target] is already wearing something on their eyes."))
			return TRUE

		var/obj/item/head = target.get_equipped_item(slot_head_str)
		if(head && (head.body_parts_covered & SLOT_FACE))
			to_chat(user, SPAN_WARNING("Remove their [head] first."))
			return TRUE

		if(!can_use(2))
			to_chat(user, SPAN_WARNING("There's not enough [plural_name] in your [src] to tape \the [target]'s eyes! You need at least 2 [plural_name]."))
			return TRUE

		user.visible_message(SPAN_WARNING("\The [user] begins taping over \the [target]'s eyes!"))
		if(!do_mob(user, target, 30))
			return TRUE

		// Repeat failure checks.
		if(!target || !src || !GET_EXTERNAL_ORGAN(target, BP_HEAD) || !target.check_has_eyes() || target.get_equipped_item(slot_glasses_str))
			return TRUE

		head = target.get_equipped_item(slot_head_str)
		if(head && (head.body_parts_covered & SLOT_FACE))
			return TRUE

		use(2)
		playsound(src, 'sound/effects/tape.ogg',25)
		user.visible_message(SPAN_WARNING("\The [user] has taped up \the [target]'s eyes!"))
		target.equip_to_slot_or_del(new /obj/item/clothing/glasses/blindfold/tape(target), slot_glasses_str)
		return TRUE

	if(user.get_target_zone() == BP_MOUTH || user.get_target_zone() == BP_HEAD)

		if(!GET_EXTERNAL_ORGAN(target, BP_HEAD))
			to_chat(user, SPAN_WARNING("\The [target] doesn't have a head."))
			return TRUE

		if(!target.check_has_mouth())
			to_chat(user, SPAN_WARNING("\The [target] doesn't have a mouth."))
			return TRUE

		if(target.get_equipped_item(slot_wear_mask_str))
			to_chat(user, SPAN_WARNING("\The [target] is already wearing a mask."))
			return TRUE

		var/obj/item/head = target.get_equipped_item(slot_head_str)
		if(head && (head.body_parts_covered & SLOT_FACE))
			to_chat(user, SPAN_WARNING("Remove their [head] first."))
			return TRUE

		if(!can_use(2))
			to_chat(user, SPAN_WARNING("There's not enough [plural_name] in your [src] to tape \the [target]'s mouth! You need at least 2 [plural_name]."))
			return TRUE

		playsound(src, 'sound/effects/tape.ogg',25)
		user.visible_message(SPAN_WARNING("\The [user] begins taping up \the [target]'s mouth!"))

		if(!do_mob(user, target, 30))
			return TRUE

		// Repeat failure checks.
		if(!target || !src || !GET_EXTERNAL_ORGAN(target, BP_HEAD) || !target.check_has_mouth() || target.get_equipped_item(slot_wear_mask_str))
			return TRUE

		head = target.get_equipped_item(slot_head_str)
		if(head && (head.body_parts_covered & SLOT_FACE))
			return TRUE

		use(2)
		playsound(src, 'sound/effects/tape.ogg',25)
		user.visible_message(SPAN_WARNING("\The [user] has taped up \the [target]'s mouth!"))
		target.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(target), slot_wear_mask_str)
		return TRUE

	return ..()

/obj/item/stack/tape_roll/duct_tape/proc/stick(var/obj/item/W, mob/user)
	if(!(W.item_flags & ITEM_FLAG_CAN_TAPE) || !user.try_unequip(W))
		return
	if(!can_use(1))
		return
	use(1)
	var/obj/item/duct_tape/tape = new(get_turf(src))
	tape.attach(W)
	user.put_in_hands(tape)
	return TRUE

///////////////////////////////////////////////////////////
// Piece of Duct Tape
///////////////////////////////////////////////////////////
/obj/item/duct_tape
	name               = "piece of tape"
	desc               = "A piece of sticky tape."
	icon               = 'icons/obj/bureaucracy.dmi'
	icon_state         = "tape"
	w_class            = ITEM_SIZE_TINY
	layer              = ABOVE_OBJ_LAYER
	material           = /decl/material/solid/organic/plastic
	var/obj/item/stuck = null
	var/crumpled       = FALSE   //If crumpled we become useless trash

/obj/item/duct_tape/Initialize(ml, material_key)
	. = ..()
	item_flags |= ITEM_FLAG_NO_BLUDGEON

/obj/item/duct_tape/get_matter_amount_modifier()
	return 0.2

/obj/item/duct_tape/attack_hand(var/mob/user)
	if(user.check_dexterity(DEXTERITY_HOLD_ITEM))
		anchored = FALSE // Unattach it from whereever it's on, if anything.
	return ..()

/obj/item/duct_tape/attackby(obj/item/W, mob/user)
	return stuck? stuck.attackby(W, user) : ..()

/obj/item/duct_tape/examine()
	return stuck ? stuck.examine(arglist(args)) : ..()

/obj/item/duct_tape/proc/attach(var/obj/item/W)
	stuck      = W
	anchored   = TRUE
	SetName("[W.name] (taped)")
	W.forceMove(src)
	playsound(src, 'sound/effects/tape.ogg', 25)
	update_icon()

/obj/item/duct_tape/on_update_icon()
	. = ..()
	underlays.Cut()
	if(stuck)
		icon_state = "tape_short"
		var/mutable_appearance/MA = new(stuck)
		switch(dir)
			if(NORTH)
				MA.pixel_x = 0
				MA.pixel_y = 8
			if(SOUTH)
				MA.pixel_x = 0
				MA.pixel_y = -8
			if(EAST)
				MA.pixel_x = 8
				MA.pixel_y = 0
			if(WEST)
				MA.pixel_x = -8
				MA.pixel_y = 0
		underlays += MA

	else if(crumpled)
		icon_state = "tape_crumpled"
	else
		icon_state = "tape"

/obj/item/duct_tape/attack_self(mob/user)
	if(!stuck)
		return
	SetName(initial(name))
	to_chat(user, "You remove \the [name] from [stuck].")
	user.put_in_hands(stuck)
	stuck = null
	crumpled = TRUE
	user.try_unequip(src, get_turf(user))

/obj/item/duct_tape/afterattack(atom/target, mob/user, proximity_flag, click_parameters)

	if(!CanPhysicallyInteractWith(user, target) || istype(target, /obj/machinery/door) || !stuck || crumpled)
		return

	var/turf/target_turf = get_turf(target)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in global.cardinal))
			to_chat(user, "You cannot reach that from here.")// can only place stuck papers in cardinal directions, to
			return											// reduce papers around corners issue.

	if(!user.try_unequip(src, source_turf))
		return
	playsound(src, 'sound/effects/tape.ogg',25)

	set_dir(dir_offset)
	layer = ABOVE_WINDOW_LAYER

	if(click_parameters)
		var/list/mouse_control = params2list(click_parameters)
		if(mouse_control["icon-x"])
			default_pixel_x = text2num(mouse_control["icon-x"]) - 16
			if(dir_offset & EAST)
				default_pixel_x += 32
			else if(dir_offset & WEST)
				default_pixel_x -= 32
		if(mouse_control["icon-y"])
			default_pixel_y = text2num(mouse_control["icon-y"]) - 16
			if(dir_offset & NORTH)
				default_pixel_y += 32
			else if(dir_offset & SOUTH)
				default_pixel_y -= 32
		reset_offsets(0)

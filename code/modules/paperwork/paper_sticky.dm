////////////////////////////////////////////////
// Sticky Note Pad
////////////////////////////////////////////////
/obj/item/sticky_pad
	name               = "sticky note pad"
	desc               = "A pad of densely packed sticky notes."
	color              = COLOR_YELLOW
	icon               = 'icons/obj/stickynotes.dmi'
	icon_state         = "pad_full"
	item_state         = "paper"
	w_class            = ITEM_SIZE_SMALL
	material           = /decl/material/solid/paper
	var/papers         = 50
	var/tmp/max_papers = 50
	var/paper_type     = /obj/item/paper/sticky
	var/obj/item/paper/top                        //The instanciated paper on the top of the pad, if there's one

/obj/item/sticky_pad/Initialize(ml, material_key)
	. = ..()
	update_top_paper()

/obj/item/sticky_pad/proc/update_matter()
	matter = list(
		/decl/material/solid/paper = round((papers * SHEET_MATERIAL_AMOUNT) * 0.2)
	)

/obj/item/sticky_pad/create_matter()
	update_matter()

/obj/item/sticky_pad/on_update_icon()
	. = ..()
	if(papers <= 15)
		icon_state = "pad_empty"
	else if(papers <= 50)
		icon_state = "pad_used"
	else
		icon_state = "pad_full"

	if(top?.info)
		icon_state = "[icon_state]_writing"

/obj/item/sticky_pad/attackby(var/obj/item/thing, var/mob/user)
	if(IS_PEN(thing) || istype(thing, /obj/item/stamp))
		. = top?.attackby(thing, user)
		update_icon()
		return .
	return ..()

/obj/item/sticky_pad/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [papers] sticky note\s left."))
	to_chat(user, SPAN_NOTICE("You can click it on grab intent to pick it up."))

/obj/item/sticky_pad/dragged_onto(mob/user)
	user.put_in_hands(top)
	. = ..()

/obj/item/sticky_pad/attack_hand(var/mob/user)
	if(user.a_intent == I_GRAB)
		return ..()
	if(!top)
		return TRUE
	user.put_in_active_hand(top)
	top = null
	papers--
	update_top_paper()
	to_chat(user, SPAN_NOTICE("You pull \the [top] off \the [src]."))
	if(papers <= 0)
		qdel(src)
	else
		update_top_paper()
		update_icon()
	return TRUE

/**Creates the paper the user can write on, if there's any paper left. */
/obj/item/sticky_pad/proc/update_top_paper()
	if(!top && papers > 0)
		top = new paper_type(src)
		top.set_color(color)

/obj/item/sticky_pad/random/Initialize()
	. = ..()
	color = pick(COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_ORANGE, COLOR_PINK)

////////////////////////////////////////////////
// Sticky Note Sheet
////////////////////////////////////////////////
/obj/item/paper/sticky
	name            = "sticky note"
	desc            = "Note to self: buy more sticky notes."
	icon            = 'icons/obj/stickynotes.dmi'
	color           = COLOR_YELLOW
	slot_flags      = 0
	layer           = ABOVE_WINDOW_LAYER
	persist_on_init = FALSE
	item_flags      = ITEM_FLAG_CAN_TAPE

/obj/item/paper/sticky/Initialize()
	. = ..()
	events_repository.register(/decl/observ/moved, src, src, /obj/item/paper/sticky/proc/reset_persistence_tracking)

/obj/item/paper/sticky/proc/reset_persistence_tracking()
	SSpersistence.forget_value(src, /decl/persistence_handler/paper/sticky)
	pixel_x = 0
	pixel_y = 0

/obj/item/paper/sticky/Destroy()
	reset_persistence_tracking()
	events_repository.unregister(/decl/observ/moved, src, src)
	. = ..()

/obj/item/paper/sticky/update_contents_overlays()
	if(length(info))
		add_overlay("sticky_words")

// Copied from duct tape.
/obj/item/paper/sticky/attack_hand()
	. = ..()
	if(!isturf(loc))
		reset_persistence_tracking()

/obj/item/paper/sticky/can_bundle()
	return FALSE // Would otherwise lead to buggy interaction

/obj/item/paper/sticky/afterattack(var/A, var/mob/user, var/flag, var/params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || istype(A, /obj/item/storage) || is_crumpled)
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in global.cardinal))
			to_chat(user, SPAN_WARNING("You cannot reach that from here."))
			return

	if(user.try_unequip(src, source_turf))
		SSpersistence.track_value(src, /decl/persistence_handler/paper/sticky)
		if(params)
			var/list/mouse_control = params2list(params)
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

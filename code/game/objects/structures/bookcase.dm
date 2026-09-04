#define GET_BOOK_POS(STORAGE, X, Y) (((Y)*STORAGE.book_slots_x)+(X)+1)

var/global/list/station_bookcases = list()

/datum/storage/bookcase
	can_hold = list(/obj/item/book)
	max_w_class = ITEM_SIZE_LARGE
	var/book_slots_x = 5
	var/book_slots_y = 3
	var/book_pos_origin_x = 6
	var/book_pos_origin_y = 2
	var/book_size_x = 4
	var/book_size_y = 8
	var/list/book_positions

/datum/storage/bookcase/New(atom/_holder)
	storage_slots = book_slots_x * book_slots_y
	book_positions = new /list(storage_slots)
	refresh_book_positions()
	..()

/datum/storage/bookcase/update_ui_after_item_insertion(obj/item/inserted, click_params)
	. = ..()

	if(!click_params || !istype(inserted) || QDELETED(inserted))
		return

	var/list/click_data = params2list(click_params)
	if(!length(click_data))
		return

	var/click_x = text2num(click_data["icon-x"])
	var/click_y = text2num(click_data["icon-y"])
	if(click_x < book_pos_origin_x || click_x > book_pos_origin_x + (book_slots_x * book_size_x))
		return
	if(click_y < book_pos_origin_y || click_y > book_pos_origin_y + (book_slots_y * book_size_y))
		return

	var/place_x = floor((click_x - book_pos_origin_x) / book_size_x)
	var/place_y = floor((click_y - book_pos_origin_y) / book_size_y)
	if(place_x < 0 || place_x >= book_slots_x || place_y < 0 || place_y >= book_slots_y)
		return

	var/place_key = GET_BOOK_POS(src, place_x, place_y)

	if(isnull(book_positions[place_key]))
		book_positions[place_key] = weakref(inserted)

/datum/storage/bookcase/update_ui_after_item_removal(obj/item/removed)
	. = ..()
	if(!istype(removed) || QDELETED(removed))
		return
	for(var/bX = 0 to (book_slots_x-1))
		for(var/bY = 0 to (book_slots_y-1))
			var/bK = GET_BOOK_POS(src, bX, bY)
			var/weakref/potential_book = book_positions[bK]
			if(IS_WEAKREF_OF(potential_book, removed))
				book_positions[bK] = null
				return

/datum/storage/bookcase/proc/refresh_book_positions()

	if(!istype(holder))
		return

	for(var/bX = 0 to (book_slots_x-1))
		for(var/bY = 0 to (book_slots_y-1))
			var/bK = GET_BOOK_POS(src, bX, bY)
			var/weakref/book_ref = book_positions[bK]
			var/obj/item/thing = book_ref?.resolve()
			if(!isnull(thing) && (QDELING(thing) || thing.loc != holder)) // QDELING because it might be deleting but hasn't been moved to nullspace yet
				book_positions[bK] = null

	for(var/obj/item/thing in holder.get_stored_inventory())

		var/positioned = FALSE
		// Avoid moving us if we're already positioned
		for(var/bX = 0 to (book_slots_x-1))
			for(var/bY = 0 to (book_slots_y-1))
				var/weakref/potential_book = book_positions[GET_BOOK_POS(src, bX, bY)]
				if(IS_WEAKREF_OF(potential_book, thing))
					positioned = TRUE
					break
			if(positioned)
				break

		if(positioned)
			continue

		// Otherwise, find a new position
		for(var/bX = 0 to (book_slots_x-1))
			for(var/bY = 0 to (book_slots_y-1))
				var/bK = GET_BOOK_POS(src, bX, bY)
				if(isnull(book_positions[bK]))
					book_positions[bK] = weakref(thing)
					positioned = TRUE
					break
			if(positioned)
				break
		// No position, fall on the ground!
		if(!positioned)
			thing.dropInto(holder.loc)

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/structures/bookcase.dmi'
	icon_state = "bookcase"
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	material_alteration = MAT_FLAG_ALTERATION_ALL
	storage = /datum/storage/bookcase

/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
	if(isStationLevel(z))
		global.station_bookcases += src
	get_or_create_extension(src, /datum/extension/labels/single)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD

/obj/structure/bookcase/LateInitialize()
	..()
	if(storage && length(contents) > storage.storage_slots)
		storage.storage_slots = length(contents)
		storage.max_storage_space = storage.storage_slots * storage.max_w_class
	update_icon()

/obj/structure/bookcase/Destroy()
	global.station_bookcases -= src
	. = ..()

/obj/structure/bookcase/on_update_icon()

	. = ..()

	// TODO: Handle repair, drop book contents when too damaged?
	// At the very least, should probably add an update_icon() call on take_damage()...
	if(get_health_ratio() < 0.5)
		icon_state = "[initial(icon_state)]-damaged"
		return // No storage contents while damaged.

	var/datum/storage/bookcase/book_storage = storage
	if(!istype(book_storage) || !length(contents))
		return

	book_storage.refresh_book_positions() // Assigns any loose items a position.

	for(var/bX = 0 to (book_storage.book_slots_x-1))
		for(var/bY = 0 to (book_storage.book_slots_y-1))
			var/bK = (bY * book_storage.book_slots_x) + bX + 1

			var/weakref/book_ref = book_storage.book_positions[bK]
			var/obj/item/book = book_ref?.resolve()
			if(!istype(book) || !check_state_in_icon("bookcase", book.icon))
				continue

			var/use_lying_state = "bookcase"
			if(bX < (book_storage.book_slots_x-1) && !isnull(book_storage.book_positions[bK+1]) && check_state_in_icon("bookcase_flat", book.icon))
				use_lying_state = "bookcase_flat"

			var/image/book_overlay = overlay_image(book.icon, use_lying_state, book.get_color(), RESET_COLOR)
			book_overlay.pixel_x = book_storage.book_pos_origin_x + (book_storage.book_size_x * bX)
			book_overlay.pixel_y = book_storage.book_pos_origin_y + (book_storage.book_size_y * bY)
			add_overlay(book_overlay)

			var/page_state = "[book_overlay.icon_state]-pages"
			if(check_state_in_icon(page_state, book_overlay.icon))
				var/image/page_overlay = overlay_image(book_overlay.icon, page_state, COLOR_WHITE, RESET_COLOR)
				page_overlay.pixel_x = book_overlay.pixel_x
				page_overlay.pixel_y = book_overlay.pixel_y
				add_overlay(page_overlay)

/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/WillContain()
	return list(
		/obj/item/book/manual/medical_diagnostics_manual = 3,
		/obj/item/book/manual/chemistry_recipes          = 1
	)

/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

/obj/structure/bookcase/manuals/engineering/WillContain()
	return list(
		/obj/item/book/manual/engineering_construction,
		/obj/item/book/manual/engineering_particle_accelerator,
		/obj/item/book/manual/engineering_hacking,
		/obj/item/book/manual/engineering_guide,
		/obj/item/book/manual/atmospipes,
		/obj/item/book/manual/engineering_singularity_safety,
		/obj/item/book/manual/evaguide,
		/obj/item/book/manual/rust_engine
	)

/obj/structure/bookcase/cart
	name = "book cart"
	anchored = FALSE
	opacity = FALSE
	icon_state = "book-0"
	desc = "A mobile cart for carrying books around."
	movable_flags = MOVABLE_FLAG_WHEELED
	icon = 'icons/obj/structures/book_cart.dmi'
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	obj_flags = 0
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/structure/bookcase/cart/on_update_icon()
	// We don't (can't) call parent, so we have to do this here
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		update_material_color()
	cut_overlays()
	if(istype(lock))
		update_lock_overlay()
	// End boilerplate
	var/used_space_ratio = storage.storage_space_used() / storage.max_storage_space
	icon_state = "book-[round(used_space_ratio * 5)]"

/obj/structure/bookcase/ebony
	material = /decl/material/solid/organic/wood/ebony
	color =    /decl/material/solid/organic/wood/ebony::color

/obj/structure/bookcase/fancy
	icon_state = "fancy"

/obj/structure/bookcase/fancy/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

#undef GET_BOOK_POS

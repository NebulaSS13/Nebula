#define MAX_PHOTO_OVERLAYS  10  //Maximum amount of photo overlays displayed on the paper bundle
#define MAX_PAPER_UNDERLAYS 20  //Maximum amount of paper underlays displayed under the bundle icon

///////////////////////////////////////////////////////////////////////////
// Paper Bundle
///////////////////////////////////////////////////////////////////////////
/obj/item/paper_bundle
	name              = "paper bundle"
	icon              = 'icons/obj/bureaucracy.dmi'
	icon_state        = "paper"
	item_state        = "paper"
	layer             = ABOVE_OBJ_LAYER
	randpixel         = 8
	throwforce        = 0
	throw_range       = 2
	throw_speed       = 1
	w_class           = ITEM_SIZE_SMALL
	attack_verb       = list("bapped")
	drop_sound        = 'sound/foley/paperpickup1.ogg'
	pickup_sound      = 'sound/foley/paperpickup2.ogg'
	item_flags        = ITEM_FLAG_CAN_TAPE
	health            = 10
	max_health        = 10
	var/tmp/cur_page  = 1           // current page
	var/tmp/max_pages = 100         //Maximum number of papers that can be in the bundle
	var/list/pages                  // Ordered list of pages as they are to be displayed. Can be different order than src.contents.
	var/static/list/cached_overlays //Cached images used by all paper bundles for generating the overlays and underlays

/**Creates frequently used images globally, so we can re-use them. */
/obj/item/paper_bundle/proc/cache_overlays()
	if(LAZYLEN(cached_overlays))
		return
	LAZYSET(cached_overlays, "clip",   image('icons/obj/bureaucracy.dmi', "clip"))
	LAZYSET(cached_overlays, "paper",  image('icons/obj/bureaucracy.dmi', "paper"))
	LAZYSET(cached_overlays, "photo",  image('icons/obj/bureaucracy.dmi', "photo"))
	LAZYSET(cached_overlays, "refill", image('icons/obj/bureaucracy.dmi', "paper_refill_label"))

/obj/item/paper_bundle/Destroy()
	LAZYCLEARLIST(pages) //Get rid of refs
	return ..()

/obj/item/paper_bundle/attackby(obj/item/W, mob/user)

	// adding sheets
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		var/obj/item/paper/paper = W
		if(istype(paper) && !paper.can_bundle())
			return //non-paper or bundlable paper only
		merge(W, user, cur_page)
		return TRUE

	// merging bundles
	else if(istype(W, /obj/item/paper_bundle) && merge(W, user, cur_page))
		to_chat(user, SPAN_NOTICE("You add \the [W.name] to \the [name]."))
		return TRUE

	// burning
	else if(istype(W, /obj/item/flame))
		burnpaper(W, user)
		return TRUE

	else if(istype(W, /obj/item/stack/tape_roll/duct_tape))
		var/obj/P = pages[cur_page]
		. = P.attackby(W, user)
		update_icon()
		updateUsrDialog()
		return TRUE

	else if(IS_PEN(W) || istype(W, /obj/item/stamp))
		close_browser(user, "window=[name]")
		var/obj/P = pages[cur_page]
		. = P.attackby(W, user)
		update_icon()
		updateUsrDialog()
		return .

	return ..()

/**Check if the bundle should break itself down, and does it if needed. */
/obj/item/paper_bundle/proc/reevaluate_existence(var/mob/user)
	if(LAZYLEN(pages) < 2)
		break_bundle(user)

/**Insert the given item into the bundle, optionally at the index specified, or otherwise at the end. */
/obj/item/paper_bundle/proc/insert_sheet_at(var/mob/user, var/obj/item/sheet, var/index = null)
	if (user && !user.try_unequip(sheet, src))
		return
	else if(!user)
		sheet.forceMove(src)

	if(isnull(index))
		LAZYDISTINCTADD(pages, sheet)
		index = length(pages)
	else
		LAZYINSERT(pages, sheet, index)

	//Make sure the cur_page stays valid, and pointing at the right index
	cur_page = clamp((index <= cur_page)? (cur_page + 1) : cur_page, 1, length(pages))

	if(user)
		to_chat(user, SPAN_NOTICE("You add \the [sheet] as the [get_ordinal_string(index)] page in \the [name]."))
	updateUsrDialog()
	update_icon()
	return TRUE

/obj/item/paper_bundle/proc/remove_sheet(var/obj/item/I, var/mob/user, var/skip_qdel = FALSE)
	var/found = -1
	for(var/i = 1 to length(pages))
		if(pages[i] == I)
			found = i
			break
	if(found == -1)
		return
	return remove_sheet_at(found, user, skip_qdel)

/**Indiscriminatly remove sheets from the bundle */
/obj/item/paper_bundle/proc/remove_sheets(var/amount, var/mob/user, var/delete_pages = TRUE)
	if(LAZYLEN(pages) <= 0 || amount > LAZYLEN(pages))
		return //Not a user error

	for(var/i = 1 to amount)
		var/obj/item/I = pages[pages.len]
		pages -= I
		if(delete_pages)
			qdel(I)
		else
			I.dropInto(loc)
	reevaluate_existence(user)

	if(!QDELETED(src))
		cur_page = 1 //Reset current page
		updateUsrDialog()
		update_icon()
	return TRUE

/obj/item/paper_bundle/proc/remove_sheet_at(var/index, var/mob/user, var/skip_qdel = FALSE)
	var/obj/item/I = LAZYACCESS(pages, index)
	if(!I)
		return

	LAZYREMOVE(pages, I)
	if(user)
		user.put_in_hands(I)
		to_chat(user, SPAN_NOTICE("You remove the [I.name] from the bundle."))
	else
		I.dropInto(loc)

	if(!skip_qdel)
		reevaluate_existence(user)
		if(QDELETED(src))
			return TRUE

	//Make sure the cur_page stays valid, and pointing at the right index
	cur_page = clamp((cur_page >= index)? (cur_page - 1) : cur_page, 1, length(pages))

	updateUsrDialog()
	update_icon()
	return TRUE

/**Delete the bundle and drop all pages */
/obj/item/paper_bundle/proc/break_bundle(var/mob/user)
	if(user && user == loc)
		user.drop_from_inventory(src)

	close_browser(user, "window=[name]")
	for(var/obj/item/I in src)
		if(user && user.get_empty_hand_slot())
			user.put_in_hands(I)
		else
			I.add_fingerprint(user)
			I.dropInto(loc)
	qdel(src)
	return TRUE

/obj/item/paper_bundle/proc/burn_callback(var/obj/item/flame/P, var/mob/user, var/span_class)
	if(QDELETED(P) || QDELETED(user))
		return
	if(!Adjacent(user) || user.get_active_hand() != P || !P.lit)
		to_chat(user, SPAN_WARNING("You must hold \the [P] steady to burn \the [src]."))
		return
	user.visible_message( \
		"<span class='[span_class]'>\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
		"<span class='[span_class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")
	new /obj/effect/decal/cleanable/ash(loc)
	qdel(src)

/obj/item/paper_bundle/proc/burnpaper(var/obj/item/flame/P, var/mob/user)
	if(!P.lit || user.incapacitated())
		return
	var/span_class = istype(P, /obj/item/flame/lighter/zippo) ? "rose" : "warning"
	var/decl/pronouns/G = user.get_pronouns()
	user.visible_message( \
		"<span class='[span_class]'>\The [user] holds \the [P] up to \the [src]. It looks like [G.he] [G.is] trying to burn it!</span>", \
		"<span class='[span_class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")
	addtimer(CALLBACK(src, .proc/burn_callback, P, user, span_class), 2 SECONDS)

/obj/item/paper_bundle/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		interact(user)
	else
		to_chat(user, SPAN_WARNING("It's too far away."))

/obj/item/paper_bundle/interact(mob/user)
	var/dat
	var/obj/item/W = pages[cur_page]

	//Header
	dat = "<TABLE STYLE='white-space:nowrap; overflow:clip; width:100%; height:2em; table-layout:fixed;'><TR>"
	dat += "<TD style='text-align:center;'>"
	if(cur_page > 1)
		dat += "<A href='?src=\ref[src];first_page=1'>First</A>"
	else
		dat += "First"
	dat += "</TD>"

	dat += "<TD style='text-align:center;'>"
	if(cur_page > 1)
		dat += "<A href='?src=\ref[src];prev_page=1'>Previous</A>"
	else
		dat += "Previous"
	dat += "</TD>"

	dat += "<TD style='text-align:center;'><A href='?src=\ref[src];jump_to=1;'><B>[cur_page]/[length(pages)]</B></A> <A href='?src=\ref[src];remove=1'>Remove</A></TD>"

	dat += "<TD style='text-align:center;'>"
	if(cur_page < pages.len)
		dat += "<A href='?src=\ref[src];next_page=1'>Next</A>"
	else
		dat += "Next"
	dat += "</TD>"

	dat += "<TD style='text-align:center;'>"
	if(cur_page < pages.len)
		dat += "<A href='?src=\ref[src];last_page=1'>Last</A>"
	else
		dat += "Last"
	dat += "</TD>"
	dat += "</TR></TABLE><HR>"

	//Contents
	if(istype(W, /obj/item/paper))
		var/obj/item/paper/P = W
		dat += "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamp_text]</BODY></HTML>"
		show_browser(user, dat, "window=[name]")
		onclose(user, name)

	else if(istype(W, /obj/item/photo))
		var/obj/item/photo/P = W
		dat += {"
			<html><head><title>[P.name]</title></head><body style='overflow:hidden'>
			<div> <img src='tmp_photo.png' width = '180'[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null ]</body></html>
		"}
		send_rsc(user, P.img, "tmp_photo.png")
		show_browser(user, dat, "window=[name]")
		onclose(user, name)
	user.set_machine(src)
	return TRUE

/obj/item/paper_bundle/attack_self(mob/user)
	return interact(user)

/obj/item/paper_bundle/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()

	//Handle page turning
	if(href_list["next_page"] && (cur_page < LAZYLEN(pages)))
		cur_page = clamp(cur_page + 1, 1, length(pages))
		playsound(src.loc, "pageturn", 50, 1)
		. = TOPIC_REFRESH

	if(href_list["prev_page"] && (cur_page > 1))
		cur_page = clamp(cur_page - 1, 1, length(pages))
		playsound(src.loc, "pageturn", 50, 1)
		. = TOPIC_REFRESH

	if(href_list["first_page"] && (cur_page > 1))
		cur_page = 1
		playsound(src.loc, "pageturn", 50, TRUE)
		spawn(5)
			playsound(src.loc, "pageturn", 20, TRUE)
		. = TOPIC_REFRESH

	if(href_list["last_page"] && (cur_page < LAZYLEN(pages)))
		cur_page = length(pages)
		playsound(src.loc, "pageturn", 50, TRUE)
		spawn(5)
			playsound(src.loc, "pageturn", 20, TRUE)
		. = TOPIC_REFRESH

	if(href_list["jump_to"])
		var/newpage = input(user, "Page: ", "Which page?", cur_page) as num
		if(!CanPhysicallyInteractWith(user, src))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]."))
		else if(newpage > 0 && newpage <= length(pages))
			cur_page = newpage
			playsound(src.loc, "pageturn", 50, TRUE)
		. = TOPIC_REFRESH

	if(href_list["remove"] && remove_sheet_at(cur_page, user) && !QDELETED(src))
		. = TOPIC_REFRESH

	if(. & TOPIC_REFRESH)
		update_icon()
		updateUsrDialog()

/obj/item/paper_bundle/on_update_icon()
	. = ..()
	if(!LAZYLEN(cached_overlays))
		cache_overlays()
	underlays.Cut()

	var/obj/item/paper/P = pages[1]
	icon       = P.icon
	icon_state = P.icon_state
	copy_overlays(P.overlays)

	var/paper_count = 0
	var/photo_count = 0

	for(var/obj/O in pages)
		if(istype(O, /obj/item/paper) && (paper_count < MAX_PAPER_UNDERLAYS))
			//We can't even see them, so don't bother create appearences form each paper's icon, and use a generic one
			var/mutable_appearance/img = new(cached_overlays["paper"])
			img.color       = O.color
			img.pixel_x     -= min(paper_count, 2)
			img.pixel_y     -= min(paper_count, 2)
			default_pixel_x = min(0.5 * paper_count, 1)
			default_pixel_y = min(paper_count, 2)
			reset_offsets(0)
			underlays += img
			paper_count++

		else if(istype(O, /obj/item/photo) && (photo_count < MAX_PHOTO_OVERLAYS))
			var/obj/item/photo/Ph = O
			if(photo_count < 1)
				add_overlay(Ph.tiny)
			else
				add_overlay(cached_overlays["photo"]) //We can't even see them, so don't bother create new unique appearences
			photo_count++

		//Break if we have nothing else to do
		if((paper_count >= MAX_PAPER_UNDERLAYS) && (photo_count >= MAX_PHOTO_OVERLAYS))
			break

	if(paper_count > 1)
		desc =  "[paper_count] papers clipped to each other."
	else
		desc = "A single sheet of paper."

	if(photo_count > 1)
		desc += "\nThere are [photo_count] photos attached to it."
	else if(photo_count > 0)
		desc += "\nThere is a photo attached to it."

	add_overlay(cached_overlays["clip"])

/**
 * Merge another bundle or paper into us.
 */
/obj/item/paper_bundle/proc/merge(var/obj/item/I, var/mob/user, var/at_hint = null)

	//Merge lone paper
	if(istype(I, /obj/item/paper) || istype(I, /obj/item/photo))
		var/obj/item/paper/P = I
		if(is_full() || (istype(P) && !P.can_bundle())) //Only paper check if they can be bundled apparently
			return FALSE
		//Merge the thing
		insert_sheet_at(user, I, at_hint)
		if(user)
			if(!user.try_unequip(I, src))
				to_chat(user, SPAN_WARNING("You can't unequip \the [I]!"))
				return
			I.add_fingerprint(user)
		else
			I.forceMove(src)

		//Update
		update_icon()
		updateUsrDialog()
		return TRUE

	//Merge paper bundle
	else if(istype(I, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = I
		if(LAZYLEN(B.pages) <= 0)
			return FALSE

		var/cur_num_pages = LAZYLEN(pages)
		if(cur_num_pages == max_pages)
			return FALSE

		//Merge the paper lists
		var/num_added = min(max_pages, LAZYLEN(pages) + LAZYLEN(B.pages)) - cur_num_pages
		var/insert_index =  ((!isnull(at_hint) && (at_hint >= 0) && (at_hint <= length(pages)))? at_hint : length(pages) + 1)
		LAZYINSERT(pages, B.pages, insert_index)
		if(length(pages) > max_pages)
			pages.Cut(max_pages)
		B.pages.Cut(1, num_added + 1)

		//Make sure to move all the things we grabbed from the old stack
		for(var/obj/item/O in pages)
			if(O.loc != src)
				O.forceMove(src)
			if(user)
				O.add_fingerprint(user)

		//Update
		update_icon()
		updateUsrDialog()

		//If old stack now empty, delete it
		if(LAZYLEN(B.pages) <= 0)
			qdel(B)
		else
			B.cur_page = 1 //Make sure the other bundle won't runtime
			B.update_icon()
		return TRUE

	CRASH("Tried to merge \a [I] ([I?.type]), which has an unhandled type, into a paper bundle!")

/**Attempts to merge all mergeable papers in the specified location into src. */
/obj/item/paper_bundle/proc/merge_all_in_loc(var/atom/location, var/mob/user)
	if(is_full())
		return

	for(var/obj/item/I in location)
		if(is_full())
			break
		if(!QDELETED(I) && (istype(I, /obj/item/paper_bundle) || istype(I, /obj/item/paper) || istype(I, /obj/item/photo)))
			merge(I)

//Make sure we can be interacted with when inside a folder
/obj/item/paper_bundle/DefaultTopicState()
	return global.paper_topic_state

//We don't contain any matter, since we're not really a material thing..
/obj/item/paper_bundle/create_matter()
	UNSETEMPTY(matter)

/obj/item/paper_bundle/proc/get_amount_papers()
	return LAZYLEN(pages)

/obj/item/paper_bundle/proc/is_full()
	return LAZYLEN(pages) >= max_pages

/**Whether all the papers in the pile are blank /obj/item/paper */
/obj/item/paper_bundle/proc/is_blank()
	for(var/obj/item/I in pages)
		if(!istype(I, /obj/item/paper))
			return FALSE
		var/obj/item/paper/P = I
		if(!P.is_blank())
			return FALSE
	return TRUE

/obj/item/paper_bundle/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/rename/paper_bundle)
	LAZYADD(., /decl/interaction_handler/unbundle/paper_bundle)

/obj/item/paper_bundle/PopulateClone(obj/item/paper_bundle/clone)
	clone = ..()
	for(var/obj/item/I in pages)
		clone.merge(I.Clone())
	return clone

/obj/item/paper_bundle/verb/rename()
	set name = "Rename Bundle"
	set category = "Object"
	set src in usr
	if(!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You cannot do this currently!"))
		return

	var/n_name = sanitize_safe(input(usr, "What would you like to name \the [src]? (Leave empty to reset name.)", "Renaming", name) as text, MAX_NAME_LEN)
	if(CanPhysicallyInteractWith(usr, src) && !QDELETED(src))
		SetName("[length(n_name) ? "[n_name]" : initial(name)]")
	add_fingerprint(usr)

///////////////////////////////////////////////////////////////////////////
// Paper Refill
///////////////////////////////////////////////////////////////////////////
/obj/item/paper_bundle/refill
	name = "paper refill"
	desc = "A bundle of blank sheets of paper."
	var/tmp/bundle_size = 30 //Amount of paper sheets in this bundle

/obj/item/paper_bundle/refill/Initialize(ml, material_key)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		setup_contents()

/obj/item/paper_bundle/refill/proc/setup_contents()
	for(var/i=1 to bundle_size)
		var/obj/item/paper/P = new /obj/item/paper(src)
		LAZYADD(pages, P)
	update_icon()

/obj/item/paper_bundle/refill/attack_self(mob/user)
	return break_bundle(user)

/obj/item/paper_bundle/refill/interact(mob/user)
	return //We don't show the menu

/obj/item/paper_bundle/refill/insert_sheet_at(mob/user, obj/item/sheet, index)
	return //Don't let us insert

/obj/item/paper_bundle/refill/merge(obj/item/I, mob/user, at_hint)
	return //Don't merge

/obj/item/paper_bundle/refill/break_bundle(mob/user)
	user?.try_unequip(src)
	var/turf/T = get_turf(src)
	for(var/i = 1 to bundle_size)
		new /obj/item/paper(T)
	qdel(src)

/obj/item/paper_bundle/refill/on_update_icon()
	. = ..()
	add_overlay(cached_overlays["refill"])

///////////////////////////////////////////////////////////////////////////
// Interaction Rename
///////////////////////////////////////////////////////////////////////////
/decl/interaction_handler/rename/paper_bundle
	name = "Rename Bundle"
	expected_target_type = /obj/item/paper_bundle

/decl/interaction_handler/rename/paper_bundle/invoked(obj/item/paper_bundle/target, mob/user)
	target.rename()

///////////////////////////////////////////////////////////////////////////
// Interaction Break
///////////////////////////////////////////////////////////////////////////
/decl/interaction_handler/unbundle/paper_bundle
	name = "Unbundle"
	expected_target_type = /obj/item/paper_bundle

/decl/interaction_handler/unbundle/paper_bundle/invoked(obj/item/paper_bundle/target, mob/user)
	to_chat(user, SPAN_NOTICE("You loosen \the [target]."))
	target.break_bundle(user)

#undef MAX_PHOTO_OVERLAYS
#undef MAX_PAPER_UNDERLAYS

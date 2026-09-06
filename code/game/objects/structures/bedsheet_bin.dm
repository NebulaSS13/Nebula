/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft bedsheet."
	icon = 'icons/obj/bedsheets/bedsheet.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = "bedsheet"
	randpixel = 0
	slot_flags = SLOT_BACK
	layer = ABOVE_STRUCTURE_LAYER // layer below other objects but above beds
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/cloth

/obj/item/bedsheet/attackby(obj/item/used_item, mob/user)
	if(used_item.is_sharp() || used_item.has_edge())
		user.visible_message("<span class='notice'>\The [user] begins cutting up \the [src] with \a [used_item].</span>", "<span class='notice'>You begin cutting up \the [src] with \the [used_item].</span>")
		if(do_after(user, 5 SECONDS, src))
			to_chat(user, "<span class='notice'>You cut \the [src] into pieces!</span>")
			for(var/i in 1 to rand(2,5))
				new /obj/item/chems/rag(get_turf(src))
			qdel(src)
		return TRUE
	return ..()

/obj/item/bedsheet/yellowed
	desc = "A surprisingly soft bedsheet. This one is old and yellowed."
	paint_color = COLOR_BEIGE
	paint_verb = "stained"

/obj/item/bedsheet/blue
	icon = 'icons/obj/bedsheets/bedsheet_blue.dmi'

/obj/item/bedsheet/green
	icon = 'icons/obj/bedsheets/bedsheet_green.dmi'

/obj/item/bedsheet/orange
	icon = 'icons/obj/bedsheets/bedsheet_orange.dmi'

/obj/item/bedsheet/purple
	icon = 'icons/obj/bedsheets/bedsheet_purple.dmi'

/obj/item/bedsheet/rainbow
	icon = 'icons/obj/bedsheets/bedsheet_rainbow.dmi'

/obj/item/bedsheet/red
	icon = 'icons/obj/bedsheets/bedsheet_red.dmi'

/obj/item/bedsheet/yellow
	icon = 'icons/obj/bedsheets/bedsheet_yellow.dmi'

/obj/item/bedsheet/mime
	icon = 'icons/obj/bedsheets/bedsheet_mime.dmi'

/obj/item/bedsheet/clown
	icon = 'icons/obj/bedsheets/bedsheet_clown.dmi'

/obj/item/bedsheet/captain
	icon = 'icons/obj/bedsheets/bedsheet_captain.dmi'

/obj/item/bedsheet/rd
	icon = 'icons/obj/bedsheets/bedsheet_rd.dmi'

/obj/item/bedsheet/medical
	icon = 'icons/obj/bedsheets/bedsheet_medical.dmi'

/obj/item/bedsheet/hos
	icon = 'icons/obj/bedsheets/bedsheet_hos.dmi'

/obj/item/bedsheet/hop
	icon = 'icons/obj/bedsheets/bedsheet_hop.dmi'

/obj/item/bedsheet/ce
	icon = 'icons/obj/bedsheets/bedsheet_ce.dmi'

/obj/item/bedsheet/brown
	icon = 'icons/obj/bedsheets/bedsheet_brown.dmi'

/obj/item/bedsheet/ian
	icon = 'icons/obj/bedsheets/bedsheet_ian.dmi'

//////////////////////////////////////////
// Bedsheet bin
//////////////////////////////////////////
/obj/structure/bedsheetbin
	name                   = "linen bin"
	desc                   = "A linen bin. It looks rather cosy."
	icon                   = 'icons/obj/structures/linen_bin.dmi'
	icon_state             = "linenbin-full"
	anchored               = TRUE
	w_class                = ITEM_SIZE_STRUCTURE
	material               = /decl/material/solid/organic/plastic
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	var/stored             = 0  //Currently stored unspawned bedsheets, mainly used by mapped bins
	var/max_stored         = 20 //Maximum amount of bedsheets that can be put in here
	var/list/sheets             //Currently spawned bedsheets it contains
	var/obj/item/hidden         //Object hidden amidst the bedsheets

/obj/structure/bedsheetbin/mapped/Initialize(ml, _mat, _reinf_mat)
	stored = max_stored //Mapped ones start with some unspawned sheets
	. = ..()

/obj/structure/bedsheetbin/dump_contents(atom/forced_loc = loc, mob/user)
	//Dump all sheets, even unspawned ones
	for(var/i = 1 to get_amount())
		remove_sheet(forced_loc)
	. = ..()

/**Returns the total amount of sheets contained, including unspawned ones. */
/obj/structure/bedsheetbin/proc/get_amount()
	return stored + LAZYLEN(sheets)

/obj/structure/bedsheetbin/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/curamount = get_amount()
	if(curamount < 1)
		. += "There are no bed sheets in the bin."
		return
	if(curamount == 1)
		. += "There is one bed sheet in the bin."
		return
	. += "There are [curamount] bed sheets in the bin."

/obj/structure/bedsheetbin/on_update_icon()
	..()
	var/curamount = get_amount()
	if(curamount < 1)
		icon_state = "linenbin-empty"
	else if(curamount <= (max_stored/2))
		icon_state = "linenbin-half"
	else
		icon_state = "linenbin-full"

/obj/structure/bedsheetbin/attackby(obj/item/used_item, mob/user)
	var/curamount = get_amount()
	if(istype(used_item, /obj/item/bedsheet))
		if(curamount >= max_stored)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return TRUE
		if(!user.try_unequip(used_item, src))
			return TRUE
		LAZYDISTINCTADD(sheets, used_item)
		update_icon()
		to_chat(user, SPAN_NOTICE("You put [used_item] in [src]."))
		return TRUE

	//Let the parent attackby run to handle tool interactions
	. = ..()

	if(!.)
		if(curamount && !hidden && used_item.w_class < w_class)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
			if(!user.try_unequip(used_item, src))
				return TRUE
			hidden = used_item
			to_chat(user, SPAN_NOTICE("You hide [used_item] among the sheets."))
			return TRUE
		else if(hidden)
			to_chat(user, SPAN_WARNING("There's not enough space to hide \the [used_item]!"))
		else if(used_item.w_class >= w_class)
			to_chat(user, SPAN_WARNING("\The [used_item] is too big to hide in \the [src]!"))
		else if(curamount < 1)
			to_chat(user, SPAN_WARNING("You can't hide anything if there's no sheets to cover it!"))

/obj/structure/bedsheetbin/attack_hand(var/mob/user)
	var/obj/item/bedsheet/B = remove_sheet()
	if(!B)
		return ..()
	user.put_in_hands(B)
	to_chat(user, SPAN_NOTICE("You take \a [B] out of \the [src]."))
	add_fingerprint(user)
	return TRUE

/obj/structure/bedsheetbin/do_simple_ranged_interaction(var/mob/user)
	remove_sheet()
	return TRUE

/obj/structure/bedsheetbin/proc/remove_sheet(atom/drop_loc = loc)
	if(get_amount() < 1)
		return

	//Pick our sheet source
	var/obj/item/bedsheet/B
	if(LAZYLEN(sheets))
		B = sheets[sheets.len]
		LAZYREMOVE(sheets, B)
	else if(stored > 0)
		stored--
		B = new /obj/item/bedsheet(drop_loc)
	B.dropInto(drop_loc)
	update_icon()

	//Drop the hidden thingie
	if(hidden)
		hidden.dropInto(drop_loc)
		visible_message(SPAN_NOTICE("\The [hidden] falls out!"))
		hidden = null

	return B
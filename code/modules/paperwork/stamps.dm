/obj/item/stamp
	name        = "rubber stamp"
	desc        = "A rubber stamp for stamping important documents."
	icon        = 'icons/obj/items/rubber_stamps.dmi'
	icon_state  = "stamp-deckchief"
	item_state  = "stamp"
	throwforce  = 0
	w_class     = ITEM_SIZE_TINY
	throw_speed = 7
	throw_range = 15
	material    = /decl/material/solid/metal/steel
	matter      = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
	)
	attack_verb = list("stamped")

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"
	attack_verb = list("stamped", "denied")

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/stamp/boss
	name = "boss' rubber stamp"
	icon_state = "stamp-boss"

/obj/item/stamp/boss/Initialize()
	name = "[global.using_map.boss_name]'s' rubber stamp"
	. = ..()

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user)

	var/list/stamp_types = typesof(/obj/item/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S

	var/list/show_stamps = list("EXIT" = null) + sortTim(stamps, /proc/cmp_text_asc) // the list that will be shown to the user to pick from

	var/input_stamp = input(user, "Choose a stamp to disguise as.", "Choose a stamp.") in show_stamps

	if(user && (src in user.contents))

		var/obj/item/stamp/chosen_stamp = stamps[capitalize(input_stamp)]

		if(chosen_stamp)
			SetName(chosen_stamp.name)
			icon_state = chosen_stamp.icon_state

/obj/item/stamp
	name        = "rubber stamp"
	desc        = "A rubber stamp for stamping important documents."
	icon        = 'icons/obj/items/stamps/stamp_deckchief.dmi'
	icon_state  = ICON_STATE_WORLD
	w_class     = ITEM_SIZE_SMALL
	throw_speed = 7
	throw_range = 15
	material    = /decl/material/solid/metal/steel
	matter      = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
	)
	attack_verb = list("stamped")

/obj/item/stamp/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_STAMP = TOOL_QUALITY_DEFAULT))

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon = 'icons/obj/items/stamps/stamp_deny.dmi'

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon = 'icons/obj/items/stamps/stamp_clown.dmi'

/obj/item/stamp/boss
	name = "boss' rubber stamp"
	icon = 'icons/obj/items/stamps/stamp_boss.dmi'

/obj/item/stamp/boss/Initialize()
	name = "[global.using_map.boss_name]'s' rubber stamp"
	. = ..()

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user)
	var/list/stamps = list()
	// Generate them into a list
	for(var/stamp_type in typesof(/obj/item/stamp)-type) // Don't include our own type.
		var/obj/item/stamp/S = stamp_type
		if(!TYPE_IS_ABSTRACT(S))
			stamps[capitalize(initial(S.name))] = S
	var/list/show_stamps = list("EXIT" = null) + sortTim(stamps, /proc/cmp_text_asc) // the list that will be shown to the user to pick from
	var/input_stamp = input(user, "Choose a stamp to disguise as.", "Choose a stamp.") in show_stamps
	if(input_stamp && !QDELETED(user) && !QDELETED(src) && user.get_active_held_item() == src)
		var/obj/item/stamp/chosen_stamp = stamps[capitalize(input_stamp)]
		if(chosen_stamp)
			appearance = chosen_stamp
			SetName(atom_info_repository.get_name_for(chosen_stamp)) // needed for dynamic centcomm stamp

#define WARDROBE_BLIND_MESSAGE(fool) "\The [src] flashes a light at \the [fool] as it states a message."

/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/undies_wardrobe.dmi'
	icon_state = "closed"
	density = TRUE
	var/static/list/amount_of_underwear_by_id_card

/obj/structure/undies_wardrobe/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/underwear))
		var/obj/item/underwear/underwear = used_item
		if(!user.try_unequip(underwear))
			return TRUE
		qdel(underwear)
		var/decl/pronouns/user_pronouns = user.get_pronouns()
		user.visible_message("<span class='notice'>\The [user] inserts [user_pronouns.his] [underwear.name] into \the [src].</span>", "<span class='notice'>You insert your [underwear.name] into \the [src].</span>")

		var/id = user.GetIdCard()
		var/message
		if(id)
			message = "ID card detected. Your underwear quota for this shift has been increased, if applicable."
		else
			message = "No ID card detected. Thank you for your contribution."

		audible_message(message, WARDROBE_BLIND_MESSAGE(user))

		var/number_of_underwear = LAZYACCESS(amount_of_underwear_by_id_card, id) - 1
		if(number_of_underwear)
			LAZYSET(amount_of_underwear_by_id_card, id, number_of_underwear)
			events_repository.register(/decl/observ/destroyed, id, src, TYPE_PROC_REF(/obj/structure/undies_wardrobe, remove_id_card))
		else
			remove_id_card(id)
		return TRUE
	else
		return ..()

/obj/structure/undies_wardrobe/proc/remove_id_card(var/id_card)
	LAZYREMOVE(amount_of_underwear_by_id_card, id_card)
	events_repository.unregister(/decl/observ/destroyed, id_card, src, TYPE_PROC_REF(/obj/structure/undies_wardrobe, remove_id_card))

/obj/structure/undies_wardrobe/attack_hand(var/mob/user)
	if(!human_who_can_use_underwear(user))
		return ..()
	interact(user)
	return TRUE

/obj/structure/undies_wardrobe/interact(var/mob/living/human/H)
	var/id = H.GetIdCard()

	var/dat = list()
	dat += "<b>Underwear</b><br><hr>"
	dat += "You may claim [id ? length(global.underwear.categories) - LAZYACCESS(amount_of_underwear_by_id_card, id) : 0] more article\s this shift.<br><br>"
	dat += "<b>Available Categories</b><br><hr>"
	for(var/datum/category_group/underwear/UWC in global.underwear.categories)
		dat += "[UWC.name] <a href='byond://?src=\ref[src];select_underwear=[UWC.name]'>(Select)</a><br>"
	dat = jointext(dat,null)
	show_browser(H, dat, "window=wardrobe;size=400x250")

/obj/structure/undies_wardrobe/proc/human_who_can_use_underwear(var/mob/living/human/H)
	if(!istype(H) || !(H.get_bodytype()?.appearance_flags & HAS_UNDERWEAR))
		return FALSE
	return TRUE

/obj/structure/undies_wardrobe/CanUseTopic(var/user)
	if(!human_who_can_use_underwear(user))
		return STATUS_CLOSE

	return ..()

/obj/structure/undies_wardrobe/OnTopic(mob/user, href_list, state)
	if((. = ..()))
		return

	if(href_list["select_underwear"])
		var/datum/category_group/underwear/UWC = global.underwear.categories_by_name[href_list["select_underwear"]]
		if(!UWC)
			return TOPIC_HANDLED
		var/datum/category_item/underwear/UWI = input(user, "Select your desired underwear:", "Choose underwear") as null|anything in exclude_none(UWC.items)
		if(!UWI)
			return TOPIC_HANDLED

		var/list/metadata_list = list()
		for(var/tweak in UWI.tweaks)
			var/datum/gear_tweak/gt = tweak
			var/metadata = gt.get_metadata(user, title = "Adjust underwear")
			if(!metadata)
				return TOPIC_HANDLED
			metadata_list["[gt]"] = metadata

		if(!CanInteract(user, state))
			return TOPIC_HANDLED

		var/id = user.GetIdCard()
		if(!id)
			audible_message("No ID card detected. Unable to acquire your underwear quota for this shift.", WARDROBE_BLIND_MESSAGE(user))
			return TOPIC_HANDLED

		var/current_quota = LAZYACCESS(amount_of_underwear_by_id_card, id)
		if(current_quota >= length(global.underwear.categories))
			audible_message("You have already used up your underwear quota for this shift. Please return previously acquired items to increase it.", WARDROBE_BLIND_MESSAGE(user))
			return TOPIC_HANDLED
		LAZYSET(amount_of_underwear_by_id_card, id, ++current_quota)

		var/obj/UW = UWI.create_underwear(user, metadata_list)
		UW.dropInto(loc)
		user.put_in_hands(UW)
		. = TOPIC_REFRESH

/obj/structure/undies_wardrobe/proc/exclude_none(var/list/L)
	. = L.Copy()
	for(var/e in .)
		var/datum/category_item/underwear/UWI = e
		if(!UWI.underwear_type)
			. -= UWI

#undef WARDROBE_BLIND_MESSAGE

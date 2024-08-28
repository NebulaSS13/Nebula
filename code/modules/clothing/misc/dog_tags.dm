/obj/item/clothing/dog_tags
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. They are stamped with a variety of informational details."
	gender = PLURAL
	icon = 'icons/clothing/accessories/jewelry/dogtags.dmi'
	material = /decl/material/solid/metal/stainlesssteel
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_INSIGNIA

	var/owner_rank
	var/owner_name
	var/owner_branch

/obj/item/clothing/dog_tags/attack_self(mob/user)
	if(user.a_intent != I_HURT)
		user.visible_message(SPAN_NOTICE("\The [user] displays \the [src]."))
		if(owner_name)
			user.visible_message(SPAN_NOTICE("They read: \"[owner_name] - [owner_rank] - [owner_branch].\""))
		else
			user.visible_message(SPAN_NOTICE("They are blank."))
		return TRUE
	return ..()

/obj/item/clothing/dog_tags/loadout_setup(mob/wearer, metadata)
	owner_name = wearer.real_name

	var/mob/living/human/H = wearer
	if(!istype(H))
		return

	var/decl/background_detail/background = H.get_background_datum_by_flag(BACKGROUND_FLAG_CITIZENSHIP)
	var/pob = background ? background.name : "Unset"

	background = H.get_background_datum_by_flag(BACKGROUND_FLAG_RELIGION)
	var/religion = background ? background.name : "Unset"

	owner_rank = H.char_rank && H.char_rank.name
	owner_name = H.real_name
	owner_branch = H.char_branch && H.char_branch.name

	desc = "[initial(desc)]\nName: [H.real_name] ([H.get_species_name()])[H.char_branch ? "\nBranch: [H.char_branch.name]" : ""]\nReligion: [religion]\nBlood type: [H.get_blood_type()]\nPlace Of Origin: [pob]"

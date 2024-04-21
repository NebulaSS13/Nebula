/obj/item/clothing/badge/tags
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. They are stamped with a variety of informational details."
	gender = PLURAL
	icon = 'icons/clothing/accessories/jewelry/dogtags.dmi'
	slot_flags = SLOT_FACE
	badge_string = null
	material = /decl/material/solid/metal/stainlesssteel
	var/owner_rank
	var/owner_name
	var/owner_branch

/obj/item/clothing/badge/tags/get_initial_accessory_hide_on_states()
	return null

/obj/item/clothing/badge/tags/proc/loadout_setup(mob/M)
	set_name(M.real_name)
	set_desc(M)

/obj/item/clothing/badge/tags/set_desc(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/decl/cultural_info/culture = H.get_cultural_value(TAG_HOMEWORLD)
	var/pob = culture ? culture.name : "Unset"

	culture = H.get_cultural_value(TAG_RELIGION)
	var/religion = culture ? culture.name : "Unset"

	owner_rank = H.char_rank && H.char_rank.name
	owner_name = H.real_name
	owner_branch = H.char_branch && H.char_branch.name

	badge_string = pob

	desc = "[initial(desc)]\nName: [H.real_name] ([H.get_species_name()])[H.char_branch ? "\nBranch: [H.char_branch.name]" : ""]\nReligion: [religion]\nBlood type: [H.get_blood_type()]"

/decl/species/shapeshifter
	abstract_type = /decl/species/shapeshifter
	available_bodytypes = list(/decl/bodytype/shapeshifter)
	inherent_verbs = list(
		/mob/living/human/proc/shapeshifter_select_shape,
		/mob/living/human/proc/shapeshifter_select_hair,
		/mob/living/human/proc/shapeshifter_select_gender,
		/mob/living/human/proc/shapeshifter_select_colour
	)

/decl/species/shapeshifter/get_pain_emote(var/mob/living/human/H, var/pain_power)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		var/decl/species/species = get_species_by_key(bodytype.associated_root_species_name)
		if(istype(species))
			return species.get_pain_emote(H, pain_power)
	return ..()

// Verbs follow.
/mob/living/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(1 SECOND)

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	var/decl/bodytype/shapeshifter/root_bodytype = get_bodytype()
	if(!istype(root_bodytype))
		return
	var/decl/bodytype/shifted_bodytype = global.wrapped_bodytypes_by_ref["\ref[src]"]
	if(!shifted_bodytype)
		return
	var/decl/species/bodytype_species = get_bodytype_species_pairs()[shifted_bodytype]
	var/list/hairstyles = bodytype_species.get_available_accessories(shifted_bodytype, SAC_HAIR)
	if(length(hairstyles))
		var/decl/sprite_accessory/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in hairstyles
		if(new_hair)
			set_organ_sprite_accessory_by_category(new_hair || /decl/sprite_accessory/hair/bald, SAC_HAIR, root_bodytype.monochromatic ? list(SAM_COLOR = get_skin_colour()) : null, preserve_type = FALSE, organ_tag = BP_HEAD)

	var/list/beardstyles = bodytype_species.get_available_accessories(shifted_bodytype, SAC_FACIAL_HAIR)
	if(length(beardstyles))
		var/decl/sprite_accessory/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in beardstyles
		if(new_hair)
			set_organ_sprite_accessory_by_category(new_hair || /decl/sprite_accessory/facial_hair/shaved, SAC_FACIAL_HAIR, root_bodytype.monochromatic ? list(SAM_COLOR = get_skin_colour()) : null, preserve_type = FALSE, organ_tag = BP_HEAD)

/mob/living/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(5 SECONDS)

	var/new_gender = input("Please select a gender.", "Shapeshifter Gender") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL)
	if(!new_gender)
		return

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	set_gender(new_gender, TRUE)

/mob/living/human/proc/shapeshifter_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	var/decl/bodytype/shapeshifter/shifter = get_bodytype()
	if(!istype(shifter) || stat ||is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(5 SECONDS)

	var/list/shifter_bodytypes = shifter.get_available_shifter_bodytypes(src)

	var/decl/bodytype/new_bodytype = input("Please select a bodytype to emulate.", "Shapeshifter Body") as null|anything in shifter_bodytypes
	if(!new_bodytype)
		return
	new_bodytype = shifter_bodytypes[new_bodytype]
	if(!istype(new_bodytype) || global.wrapped_bodytypes_by_ref["\ref[src]"] == new_bodytype)
		return

	global.wrapped_bodytypes_by_ref["\ref[src]"] = new_bodytype
	visible_message(SPAN_NOTICE("\The [src] shifts and contorts, taking the form of \a ["\improper [new_bodytype.associated_root_species_name]"]!"))
	try_refresh_visible_overlays()

/mob/living/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(5 SECONDS)

	var/new_skin = input("Please select a new body color.", "Shapeshifter Colour") as color
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/human/proc/shapeshifter_set_colour(var/new_skin)
	set_skin_colour(new_skin, skip_update = TRUE)
	var/decl/bodytype/shapeshifter/shifter = get_bodytype(src)
	if(istype(shifter) && shifter.monochromatic)
		var/skin_colour = get_skin_colour()
		SET_HAIR_COLOR(src, skin_colour, TRUE)
		SET_FACIAL_HAIR_COLOR(src, skin_colour, TRUE)
	for(var/obj/item/organ/external/E in get_external_organs())
		E.sync_colour_to_human(src)
	try_refresh_visible_overlays()

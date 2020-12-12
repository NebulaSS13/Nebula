// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/decl/species/shapeshifter

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
		)

	var/list/valid_transform_species = list()
	var/monochromatic
	var/default_form

/decl/species/shapeshifter/New()
	default_form = GLOB.using_map.default_species
	valid_transform_species |= default_form
	..()

/decl/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return valid_transform_species

/decl/species/shapeshifter/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_icobase(H, get_deform)

/decl/species/shapeshifter/get_icon_cache_uid(var/mob/H)
	. = ..()
	if(H)
		. = "[.]-[wrapped_species_by_ref["\ref[H]"]]"

/decl/species/shapeshifter/get_bodytype(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_bodytype(H)

/decl/species/shapeshifter/get_root_species_name(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_root_species_name(H)

/decl/species/shapeshifter/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_blood_mask(H)

/decl/species/shapeshifter/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_mask(H)

/decl/species/shapeshifter/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_overlays(H)

/decl/species/shapeshifter/get_tail(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail(H)

/decl/species/shapeshifter/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_animation(H)

/decl/species/shapeshifter/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_hair(H)

/decl/species/shapeshifter/get_husk_icon(var/mob/living/carbon/human/H)
	if(H)
		var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
		if(S) return S.get_husk_icon(H)
	 return ..()

/decl/species/shapeshifter/handle_pre_spawn(var/mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form

/decl/species/shapeshifter/handle_post_spawn(var/mob/living/carbon/human/H)
	if(monochromatic)
		H.hair_colour = H.skin_colour
		H.facial_hair_colour = H.skin_colour
	..()

/decl/species/shapeshifter/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	var/obj/item/organ/external/E = org
	if(H && istype(E))
		E.sync_colour_to_human(H)

/decl/species/shapeshifter/get_pain_emote(var/mob/living/carbon/human/H, var/pain_power)
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_pain_emote(H, pain_power)

// Verbs follow.
/mob/living/carbon/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	if(species.get_hair_styles())
		var/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in species.get_hair_styles()
		change_hair(new_hair ? new_hair : "Bald")
	if(species.get_facial_hair_styles(gender))
		var/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in species.get_facial_hair_styles(gender)
		change_facial_hair(new_hair ? new_hair : "Shaved")

/mob/living/carbon/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_gender = input("Please select a gender.", "Shapeshifter Gender") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL)
	if(!new_gender)
		return

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	change_gender(new_gender)

/mob/living/carbon/human/proc/shapeshifter_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = input("Please select a species to emulate.", "Shapeshifter Body") as null|anything in species.get_valid_shapeshifter_forms(src)
	if(!new_species || !get_species_by_key(new_species) || wrapped_species_by_ref["\ref[src]"] == new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	visible_message("<span class='notice'>\The [src] shifts and contorts, taking the form of \a ["\improper [new_species]"]!</span>")
	regenerate_icons()

/mob/living/carbon/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input("Please select a new body color.", "Shapeshifter Colour") as color
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/carbon/human/proc/shapeshifter_set_colour(var/new_skin)

	skin_colour = new_skin

	var/decl/species/shapeshifter/S = species
	if(S.monochromatic)
		hair_colour = skin_colour
		facial_hair_colour = skin_colour

	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()

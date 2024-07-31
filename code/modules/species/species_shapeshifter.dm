// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for other species later.
var/global/list/wrapped_species_by_ref = list()

/decl/species/shapeshifter
	available_bodytypes = list(/decl/bodytype/shapeshifter)
	inherent_verbs = list(
		/mob/living/human/proc/shapeshifter_select_shape,
		/mob/living/human/proc/shapeshifter_select_hair,
		/mob/living/human/proc/shapeshifter_select_gender,
		/mob/living/human/proc/shapeshifter_select_colour
	)
	var/list/valid_transform_species = list()
	var/monochromatic
	var/default_form

/decl/species/shapeshifter/Initialize()
	default_form = global.using_map.default_species
	valid_transform_species |= default_form
	. = ..()

/decl/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/human/H)
	return valid_transform_species

/decl/species/shapeshifter/get_root_species_name(var/mob/living/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_root_species_name(H)

/decl/species/shapeshifter/handle_pre_spawn(var/mob/living/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form

/decl/species/shapeshifter/handle_post_spawn(var/mob/living/human/H)
	if(monochromatic)
		var/skin_colour = H.get_skin_colour()
		SET_HAIR_COLOR(H, skin_colour, TRUE)
		SET_FACIAL_HAIR_COLOR(H, skin_colour, TRUE)
	..()

/decl/species/shapeshifter/get_pain_emote(var/mob/living/human/H, var/pain_power)
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_pain_emote(H, pain_power)

// Verbs follow.
/mob/living/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(1 SECOND)

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	var/decl/bodytype/root_bodytype = get_bodytype()
	var/list/hairstyles = species.get_available_accessory_types(root_bodytype, SAC_HAIR)
	if(length(hairstyles))
		var/decl/sprite_accessory/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in hairstyles
		SET_HAIR_STYLE(src, (new_hair ? new_hair.type : /decl/sprite_accessory/hair/bald), FALSE)

	var/list/beardstyles = species.get_available_accessory_types(root_bodytype, SAC_FACIAL_HAIR)
	if(length(beardstyles))
		var/decl/sprite_accessory/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in beardstyles
		SET_FACIAL_HAIR_STYLE(src, (new_hair ? new_hair.type : /decl/sprite_accessory/facial_hair/shaved), FALSE)

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

	if(stat ||is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(5 SECONDS)

	var/new_species = input("Please select a species to emulate.", "Shapeshifter Body") as null|anything in species.get_valid_shapeshifter_forms(src)
	if(!new_species || !get_species_by_key(new_species) || wrapped_species_by_ref["\ref[src]"] == new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	visible_message("<span class='notice'>\The [src] shifts and contorts, taking the form of \a ["\improper [new_species]"]!</span>")
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
	var/decl/species/shapeshifter/S = species
	if(S.monochromatic)
		var/skin_colour = get_skin_colour()
		SET_HAIR_COLOR(src, skin_colour, TRUE)
		SET_FACIAL_HAIR_COLOR(src, skin_colour, TRUE)
	for(var/obj/item/organ/external/E in get_external_organs())
		E.sync_colour_to_human(src)
	try_refresh_visible_overlays()

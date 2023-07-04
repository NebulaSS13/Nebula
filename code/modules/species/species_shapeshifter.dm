// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for other species later.
var/global/list/wrapped_species_by_ref = list()

/decl/species/shapeshifter
	available_bodytypes = list(/decl/bodytype/shapeshifter)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
	)
	var/list/valid_transform_species = list()
	var/monochromatic
	var/default_form

/decl/species/shapeshifter/Initialize()
	default_form = global.using_map.default_species
	valid_transform_species |= default_form
	. = ..()

/decl/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return valid_transform_species

/decl/species/shapeshifter/get_root_species_name(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_root_species_name(H)

/decl/species/shapeshifter/handle_pre_spawn(var/mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form

/decl/species/shapeshifter/handle_post_spawn(var/mob/living/carbon/human/H)
	if(monochromatic)
		H.hair_colour = H.skin_colour
		H.facial_hair_colour = H.skin_colour
	..()

/decl/species/shapeshifter/apply_species_organ_modifications(var/obj/item/organ/org)
	..()
	var/obj/item/organ/external/E = org
	if(istype(E) && E.owner)
		E.sync_colour_to_human(E.owner)

/decl/species/shapeshifter/get_pain_emote(var/mob/living/carbon/human/H, var/pain_power)
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.get_pain_emote(H, pain_power)

// Verbs follow.
/mob/living/carbon/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(1 SECOND)

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	var/list/hairstyles = species.get_hair_styles(bodytype.associated_gender)
	if(length(hairstyles))
		var/decl/sprite_accessory/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in hairstyles
		change_hair(new_hair ? new_hair.type : /decl/sprite_accessory/hair/bald)

	var/list/beardstyles = species.get_facial_hair_styles(bodytype.associated_gender)
	if(length(beardstyles))
		var/decl/sprite_accessory/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in beardstyles
		change_facial_hair(new_hair ? new_hair.type : /decl/sprite_accessory/facial_hair/shaved)

/mob/living/carbon/human/proc/shapeshifter_select_gender()

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

/mob/living/carbon/human/proc/shapeshifter_select_shape()

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
	refresh_visible_overlays()

/mob/living/carbon/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || is_on_special_ability_cooldown())
		return

	set_special_ability_cooldown(5 SECONDS)

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

	for(var/obj/item/organ/external/E in get_external_organs())
		E.sync_colour_to_human(src)

	refresh_visible_overlays()

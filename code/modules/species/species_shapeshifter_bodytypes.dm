// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for other species later.
var/global/list/wrapped_bodytypes_by_ref = list()

/decl/bodytype/shapeshifter
	abstract_type = /decl/bodytype/shapeshifter
	bodytype_category = BODYTYPE_HUMANOID
	limb_blend = ICON_MULTIPLY // everything is reindexed to be shades of white
	uid = "bodytype_shapeshifter"

	var/decl/bodytype/default_form
	var/retrieved_bodytypes = FALSE
	var/list/valid_transform_bodytypes = list()
	var/monochromatic

// we run this on first call to avoid circular dependencies in Initialize()
/decl/bodytype/shapeshifter/proc/retrieve_bodytypes()

	if(!retrieved_bodytypes)

		for(var/bodytype in valid_transform_bodytypes)
			if(istype(bodytype, /decl/bodytype))
				continue
			valid_transform_bodytypes -= bodytype
			if(ispath(bodytype, /decl/bodytype))
				var/decl/bodytype/the_bodytype = GET_DECL(bodytype)
				valid_transform_bodytypes["[the_bodytype.associated_root_species_name] - [the_bodytype.pref_name]"] = the_bodytype
			else if(istext(bodytype))
				var/decl/species/species = get_species_by_key(bodytype)
				for(var/decl/bodytype/some_bodytype in species.available_bodytypes)
					if(some_bodytype.is_robotic) // skip FBPs
						continue
					valid_transform_bodytypes["[some_bodytype.associated_root_species_name] - [some_bodytype.pref_name]"] = some_bodytype

		// A warning to the future, this might break if the default species has a shapeshifter bodytype.
		var/decl/species/species = get_species_by_key(global.using_map.default_species)
		default_form = species.default_bodytype
		valid_transform_bodytypes["[species.name] - [default_form.pref_name]"] = default_form

		retrieved_bodytypes = TRUE

	return valid_transform_bodytypes

/decl/bodytype/shapeshifter/proc/get_available_shifter_bodytypes(mob/living/human/H)
	return retrieve_bodytypes()

/decl/bodytype/shapeshifter/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	applying.MapColors("#4d4d4d","#969696","#1c1c1c", "#000000")
	applying.SetIntensity(limb_icon_intensity)
	applying += rgb(,,,180) // Makes the icon translucent, SO INTUITIVE TY BYOND
	return applying

/decl/bodytype/shapeshifter/check_dismember_type_override(var/disintegrate)
	if(disintegrate == DISMEMBER_METHOD_EDGE)
		return DISMEMBER_METHOD_BLUNT
	return ..()

/decl/bodytype/shapeshifter/get_base_icon(var/mob/living/human/H, var/get_deform)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		return bodytype.get_base_icon(H, get_deform)
	return ..()

/decl/bodytype/shapeshifter/get_blood_overlays(var/mob/living/human/H)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		return bodytype.get_blood_overlays(H)
	return ..()

/decl/bodytype/shapeshifter/get_damage_overlays(var/mob/living/human/H)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		return bodytype.get_damage_overlays(H)
	return ..()

/decl/bodytype/shapeshifter/get_husk_icon(var/mob/living/human/H)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		return bodytype.get_husk_icon(H)
	return ..()

/decl/bodytype/shapeshifter/get_icon_cache_uid(var/mob/H)
	. = ..()
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		. = "[.]-shifted_[bodytype.uid]"

/decl/bodytype/shapeshifter/apply_bodytype_organ_modifications(obj/item/organ/org)
	..()
	var/obj/item/organ/external/E = org
	if(istype(E) && E.owner)
		E.sync_colour_to_human(E.owner)

/decl/bodytype/shapeshifter/adjust_status(mob/living/target, condition, amount)
	return amount

/decl/bodytype/shapeshifter/get_root_species_name(var/mob/living/human/H)
	if(H)
		var/decl/bodytype/bodytype = global.wrapped_bodytypes_by_ref["\ref[H]"]
		return bodytype.associated_root_species_name
	return ..()

/decl/bodytype/shapeshifter/proc/track_mob(mob/living/owner)
	if(!owner)
		return
	retrieve_bodytypes() // This should not be being called pre-atom init, so hopefully all the references are setup by this point.
	global.wrapped_bodytypes_by_ref["\ref[owner]"] = default_form

/decl/bodytype/shapeshifter/handle_pre_set_bodytype(mob/living/owner)
	track_mob(owner)
	return ..()

/decl/bodytype/shapeshifter/create_missing_organs(mob/living/human/H, fully_replace = FALSE)
	track_mob(H)
	return ..()

/decl/bodytype/shapeshifter/handle_pre_organ_bodytype_set(mob/living/owner)
	track_mob(owner)
	return ..()

/decl/bodytype/shapeshifter/handle_post_set_bodytype(mob/living/owner)
	..()
	if(monochromatic)
		var/skin_colour = owner.get_skin_colour()
		SET_HAIR_COLOR(owner, skin_colour, TRUE)
		SET_FACIAL_HAIR_COLOR(owner, skin_colour, TRUE)

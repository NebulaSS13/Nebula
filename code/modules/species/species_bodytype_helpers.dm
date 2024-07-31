/decl/bodytype/proc/get_ignited_icon(var/mob/living/human/victim)
	return ignited_icon

/decl/bodytype/proc/get_ignited_icon_state(mob/living/victim)
	return "Standing"

/decl/bodytype/proc/get_icon_cache_uid(var/mob/H)
	if(!icon_cache_uid)
		icon_cache_uid = "[sequential_id(/decl/bodytype)]"
	return icon_cache_uid

/decl/bodytype/proc/get_bandages_icon(var/mob/living/human/H)
	return bandages_icon

/decl/bodytype/proc/get_blood_overlays(var/mob/living/human/H)
	return blood_overlays

/decl/bodytype/proc/get_damage_overlays(var/mob/living/human/H)
	return damage_overlays

/decl/bodytype/proc/get_husk_icon(var/mob/living/human/H)
	return husk_icon

/decl/bodytype/proc/get_skeletal_icon(var/mob/living/human/H)
	return skeletal_icon

/decl/bodytype/proc/get_cosmetics_icon(var/decl/sprite_accessory/cosmetics/cosmetics_style)
	return cosmetics_icon

/decl/bodytype/proc/get_vulnerable_location(var/mob/living/human/H)
	return vulnerable_location

/decl/bodytype/proc/get_base_icon(var/mob/living/human/H, var/get_deform)
	return get_deform ? icon_deformed : icon_base

/decl/bodytype/proc/handle_post_bodytype_pref_set(datum/preferences/pref)
	if(!pref)
		return
	// Markings used to be cleared outside of here, but it was always done before every call, so it was moved in here.
	// remove invalid accessories for our new bodytype. don't clear the list directly as we did before, to preserve in the case of no default
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	for(var/acc_cat in pref.sprite_accessories)
		if(!(acc_cat in mob_species.available_accessory_categories))
			pref.sprite_accessories -= acc_cat
			continue
		var/decl/sprite_accessory_category/accessory_category = GET_DECL(acc_cat)
		for(var/acc in pref.sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory = GET_DECL(acc)
			if(!istype(accessory, accessory_category.base_accessory_type) || !accessory.accessory_is_available(get_mannequin(pref.client?.ckey), mob_species, mob_bodytype))
				pref.sprite_accessories[acc_cat] -= acc
	// apply the defaults
	for(var/accessory_category in default_sprite_accessories)
		pref.sprite_accessories[accessory_category] = list()
		for(var/accessory in default_sprite_accessories[accessory_category])
			var/list/default_data = default_sprite_accessories[accessory_category][accessory]
			pref.sprite_accessories[accessory_category][accessory] = islist(default_data) ? default_data.Copy() : list()

/decl/bodytype/proc/apply_appearance(var/mob/living/human/H)
	if(base_color)
		H.set_skin_colour(base_color)

	if(z_flags)
		H.z_flags = z_flags
	else
		H.z_flags = initial(H.z_flags)

	if(!LAZYLEN(appearance_descriptors))
		H.appearance_descriptors = null
		return

	var/list/new_descriptors = list()
	//Add missing descriptors, and sanitize any existing ones
	for(var/desctype in appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = appearance_descriptors[desctype]
		if(H.appearance_descriptors && H.appearance_descriptors[descriptor.name])
			new_descriptors[descriptor.name] = descriptor.sanitize_value(H.appearance_descriptors[descriptor.name])
		else
			new_descriptors[descriptor.name] = descriptor.default_value
	//Make sure only supported descriptors are left
	H.appearance_descriptors = new_descriptors

/decl/bodytype/proc/adjust_status(mob/living/target, condition, amount)
	return amount

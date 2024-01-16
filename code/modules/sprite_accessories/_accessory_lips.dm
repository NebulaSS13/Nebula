/decl/sprite_accessory/lips
	icon                             = 'icons/mob/human_races/species/default_lips.dmi'
	body_parts                       = list(BP_HEAD)
	color_blend                      = ICON_MULTIPLY
	abstract_type                    = /decl/sprite_accessory/lips
	accessory_category_default_style = /decl/sprite_accessory/lips/default

/decl/sprite_accessory/lips/get_accessory_icon(obj/item/organ/external/organ)
	if(!organ || QDELETED(organ))
		return icon
	return organ.bodytype?.get_lip_icon(src)

/decl/sprite_accessory/lips/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_body()

/decl/sprite_accessory/lips/accessory_is_available(mob/owner, decl/species/species, decl/bodytype/bodytype)
	. = ..()
	if(.)
		if(!bodytype)
			bodytype = owner?.get_bodytype()
		return !isnull(bodytype?.get_lip_icon(src))

/decl/sprite_accessory/lips/validate()
	. = ..()
	var/list/all_bodytypes = decls_repository.get_decls_of_type(/decl/bodytype)
	for(var/bodytype_type in all_bodytypes)
		var/decl/bodytype/bodytype = all_bodytypes[bodytype_type]
		var/lip_icon = bodytype.get_lip_icon(src)
		if(lip_icon && !check_state_in_icon(icon_state, lip_icon))
			. += "missing icon_state [icon_state] for bodytype [bodytype.type] in icon [bodytype.lip_icon]"

/decl/sprite_accessory/lips/default
	name        = "Lipstick"
	icon_state  = "lips"
	required_gender = null
	species_allowed = null
	subspecies_allowed = null
	bodytype_categories_allowed = null
	bodytype_categories_denied = null
	body_flags_allowed = null
	body_flags_denied = null
	uid = "acc_lips_default"

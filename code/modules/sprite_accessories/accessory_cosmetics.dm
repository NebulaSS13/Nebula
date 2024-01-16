/decl/sprite_accessory_category/cosmetics
	name                = "Cosmetics"
	default_accessory   = /decl/sprite_accessory/cosmetics/nothing
	base_accessory_type = /decl/sprite_accessory/cosmetics

/decl/sprite_accessory/cosmetics
	icon                        = 'icons/mob/human_races/species/default_cosmetics.dmi'
	body_parts                  = list(BP_HEAD)
	color_blend                 = ICON_MULTIPLY
	abstract_type               = /decl/sprite_accessory/cosmetics
	required_gender             = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	accessory_category          = /decl/sprite_accessory_category/cosmetics

/decl/sprite_accessory/cosmetics/get_accessory_icon(obj/item/organ/external/organ)
	if(!organ || QDELETED(organ))
		return icon
	return organ.bodytype?.get_cosmetics_icon(src)

/decl/sprite_accessory/cosmetics/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_body()

/decl/sprite_accessory/cosmetics/accessory_is_available(mob/owner, decl/species/species, decl/bodytype/bodytype)
	. = ..()
	if(.)
		if(!bodytype)
			bodytype = owner?.get_bodytype()
		return !isnull(bodytype?.get_cosmetics_icon(src))

/decl/sprite_accessory/cosmetics/validate()
	. = ..()
	var/list/all_bodytypes = decls_repository.get_decls_of_type(/decl/bodytype)
	for(var/bodytype_type in all_bodytypes)
		var/decl/bodytype/bodytype = all_bodytypes[bodytype_type]
		var/cosmetics_icon = bodytype.get_cosmetics_icon(src)
		if(cosmetics_icon && !check_state_in_icon(icon_state, cosmetics_icon))
			. += "missing icon_state [icon_state] for bodytype [bodytype.type] in icon [bodytype.cosmetics_icon]"

// Subtypes.
/decl/sprite_accessory/cosmetics/nothing
	name        = "Nothing"
	icon_state  = "nothing"
	uid         = "acc_cosmetics_nothing"

/decl/sprite_accessory/cosmetics/lipstick
	name        = "Lipstick"
	icon_state  = "lips"
	uid         = "acc_cosmetics_lips"

/decl/sprite_accessory/cosmetics/eyeshadow
	name        = "Eyeshadow"
	icon_state  = "eyeshadow"
	uid         = "acc_cosmetics_eyeshadow"

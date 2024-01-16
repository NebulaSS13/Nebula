/decl/sprite_accessory/lips
	icon          = 'icons/mob/human_races/species/default_lips.dmi'
	color_blend   = ICON_MULTIPLY
	abstract_type = /decl/sprite_accessory/lips
	accessory_category_default_style = /decl/sprite_accessory/lips/default

/decl/sprite_accessory/lips/get_accessory_icon(obj/item/organ/external/organ)
	if(!organ || QDELETED(organ))
		return icon
	return organ.bodytype?.get_lip_icon(src)

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

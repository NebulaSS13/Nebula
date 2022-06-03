/decl/item_modifier
	var/name
	var/list/type_setups

/decl/item_modifier/Initialize()
	. = ..()
	for(var/prop_type in type_setups)
		var/obj/item/prop = atom_info_repository.get_instance_of(type_setups[prop_type])
		var/list/type_setup = list()
		type_setup[SETUP_NAME] = prop.name
		type_setup[SETUP_ICON] = prop.icon
		if(prop.sprite_sheets)
			type_setup[SETUP_SPRITE_SHEETS] = prop.sprite_sheets.Copy()
		type_setups[prop_type] = type_setup

/decl/item_modifier/proc/RefitItem(var/obj/item/I)
	if(!istype(I))
		return FALSE

	var/item_type = get_ispath_key(type_setups, I.type)
	if(!item_type)
		return FALSE

	var/type_setup = type_setups[item_type]
	if(!type_setup)
		return FALSE

	I.SetName(type_setup[SETUP_NAME])
	I.icon = type_setup[SETUP_ICON]
	if(istype(I, /obj/item/clothing))
		var/list/type_spritesheets = type_setup[SETUP_SPRITE_SHEETS]
		var/obj/item/clothing/C = I
		C.sprite_sheets = type_spritesheets?.Copy()
	I.reconsider_single_icon(TRUE)
	return TRUE

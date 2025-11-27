//Shoes
/obj/item/clothing/shoes/magboots/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/feet/magboots.dmi')

/obj/item/clothing/shoes/galoshes/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/feet/galoshes.dmi')

//Gloves
/obj/item/clothing/gloves/setup_equip_flags()
	. = ..()
	if(!isnull(bodytype_equip_flags) && !(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE))
		bodytype_equip_flags |= BODY_EQUIP_FLAG_AVIAN

/obj/item/clothing/gloves/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/gloves.dmi')

//Backpacks & tanks

/obj/item/backpack/satchel/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/satchel.dmi')

//Radsuits (theyre essential?)

/obj/item/clothing/head/radiation/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/head/rad_helm.dmi')

/obj/item/clothing/suit/radiation/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/suit/rad_suit.dmi')

//cloaks
/obj/item/clothing/suit/cloak/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/accessory/cloak.dmi')

/obj/item/clothing/suit/cloak/hide/setup_sprite_sheets()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/teshari/icons/clothing/accessory/cloak_hide.dmi')

//clothing
/obj/item/clothing/dress/teshari_smock
	name = "smock"
	desc = "A loose-fitting smock favoured by teshari."
	icon = 'mods/species/teshari/icons/clothing/under/smock.dmi'
	icon_state = ICON_STATE_WORLD
	bodytype_equip_flags = BODY_EQUIP_FLAG_AVIAN

/obj/item/clothing/dress/teshari_smock/worker
	name = "worker's smock"
	icon = 'mods/species/teshari/icons/clothing/under/smock_grey.dmi'

/obj/item/clothing/dress/teshari_smock/rainbow
	name = "rainbow smock"
	desc = "A brightly coloured, loose-fitting smock - the height of teshari fashion."
	icon = 'mods/species/teshari/icons/clothing/under/smock_rainbow.dmi'

/obj/item/clothing/dress/teshari_smock/security
	name = "armoured smock"
	desc = "A bright red smock with light armour insets, worn by teshari security personnel."
	icon = 'mods/species/teshari/icons/clothing/under/smock_red.dmi'

/obj/item/clothing/dress/teshari_smock/engineering
	name = "hazard smock"
	desc = "A high-visibility yellow smock with orange highlights light armour insets, worn by teshari engineering personnel."
	icon = 'mods/species/teshari/icons/clothing/under/smock_yellow.dmi'

/obj/item/clothing/dress/teshari_smock/utility
	name = "black uniform"
	icon = 'mods/species/teshari/icons/clothing/under/black_utility.dmi'

/obj/item/clothing/dress/teshari_smock/utility/gray
	name = "gray uniform"
	icon = 'mods/species/teshari/icons/clothing/under/gray_utility.dmi'

/obj/item/clothing/dress/teshari_smock/stylish_command
	name = "stylish uniform"
	icon = 'mods/species/teshari/icons/clothing/under/stylish_form.dmi'

/obj/item/clothing/shoes/teshari
	name = "small shoes"
	icon = 'mods/species/teshari/icons/clothing/feet/shoes.dmi'
	color = COLOR_GRAY
	bodytype_equip_flags = BODY_EQUIP_FLAG_AVIAN

/obj/item/clothing/shoes/teshari/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping feet."
	icon = 'mods/species/teshari/icons/clothing/feet/footwraps.dmi'
	item_flags = ITEM_FLAG_SILENT
	w_class = ITEM_SIZE_SMALL

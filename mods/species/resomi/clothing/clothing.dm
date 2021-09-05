//its very difficult to adapt every piece of clothing to resomiis
//so for now it just adds sprite sheet for certain cloths after init

/decl/species/resomi/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	. = ..()
	QDEL_NULL(H.shoes)
	H.equip_to_slot(new /obj/item/clothing/shoes/resomi, slot_shoes_str)    //since they cant wear hooman shoes
	H.equip_to_slot_or_del(new /obj/item/clothing/under/resomi, slot_w_uniform_str)

/obj/item/clothing/Initialize()
	. = ..()
	LAZYINITLIST(bodytype_restricted)
	if((sprite_sheets ? sprite_sheets[BODYTYPE_RESOMI] : FALSE) && bodytype_restricted.len) bodytype_restricted += BODYTYPE_RESOMI

//Head, Glasses, Masks

/obj/item/clothing/head/Initialize()
	LAZYINITLIST(bodytype_restricted)
	if(bodytype_restricted.len) bodytype_restricted |= BODYTYPE_RESOMI
	. = ..()

/obj/item/clothing/glasses/Initialize()
	LAZYINITLIST(bodytype_restricted)
	if(bodytype_restricted.len) bodytype_restricted |= BODYTYPE_RESOMI
	. = ..()

/obj/item/clothing/mask/Initialize()
	LAZYINITLIST(bodytype_restricted)
	if(bodytype_restricted.len) bodytype_restricted |= BODYTYPE_RESOMI
	. = ..()

//COOOULD probably make a macro for this
//this looks very bad, though thats the only way to do it right (yes i can add some resomivars or smthng else but..)

//Shoes

/obj/item/clothing/shoes/magboots/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/magboots.dmi'
	. = ..()

/obj/item/clothing/shoes/galoshes/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/galoshes.dmi'
	. = ..()

//Gloves

/obj/item/clothing/gloves/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/gloves.dmi'
	. = ..()

//ID

/obj/item/card/id/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/id.dmi'
	. = ..()

//Masks

/obj/item/clothing/mask/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/onmob_mask.dmi'
	. = ..()

//Backpacks & tanks

/obj/item/storage/backpack/satchel/Initialize()
	. = ..()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/satchel.dmi'

/obj/item/storage/backpack/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/backpack.dmi'
	. = ..()

/obj/item/tank/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/onmob_back.dmi'
	. = ..()

//Radsuits (theyre essential?)

/obj/item/clothing/head/radiation/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/rad_helm.dmi'
	. = ..()

/obj/item/clothing/suit/radiation/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/rad_suit.dmi'
	. = ..()
//material cloak
/obj/item/clothing/accessory/cloak/hide/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/cloak_hide.dmi'
	. = ..()

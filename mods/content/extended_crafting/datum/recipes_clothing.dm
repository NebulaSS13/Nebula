//
// Simple clothing
//
/datum/stack_recipe/clothing
	difficulty = MAT_VALUE_EASY_DIY

/datum/stack_recipe/clothing/bandana
	title = "head bandana"
	result_type = /obj/item/clothing/head/bandana
	req_amount = 1
/datum/stack_recipe/clothing/bandana/green
	title = "head green bandana"
	result_type = /obj/item/clothing/head/bandana/green

//Bandana masks
/datum/stack_recipe/clothing/bandana_mask
	req_amount = 1

/datum/stack_recipe/clothing/bandana_mask/black
	title = "black bandana mask"
	result_type = /obj/item/clothing/mask/bandana

#define DEFINE_BANDANA_MASK(COLOR) \
/datum/stack_recipe/clothing/bandana_mask/##COLOR {\
	title = #COLOR + " bandana mask"; \
	result_type = /obj/item/clothing/mask/bandana/##COLOR; \
}

DEFINE_BANDANA_MASK(red)
DEFINE_BANDANA_MASK(blue)
DEFINE_BANDANA_MASK(green)
DEFINE_BANDANA_MASK(gold)
DEFINE_BANDANA_MASK(orange)
DEFINE_BANDANA_MASK(purple)
DEFINE_BANDANA_MASK(botany)
DEFINE_BANDANA_MASK(camo)
DEFINE_BANDANA_MASK(skull)
#undef DEFINE_BANDANA_MASK

/datum/stack_recipe/clothing/turban
	title = "turban"
	result_type = /obj/item/clothing/head/turban
	req_amount = 1

/datum/stack_recipe/clothing/hijab
	title = "hijab"
	result_type = /obj/item/clothing/head/hijab
	req_amount = 4

/datum/stack_recipe/clothing/balaclava
	title = "balaclava"
	result_type = /obj/item/clothing/mask/balaclava

//ponchos
/datum/stack_recipe/clothing/poncho
	req_amount = 4

/datum/stack_recipe/clothing/poncho/classic
	title = "poncho"
	result_type = /obj/item/clothing/suit/poncho/colored
/datum/stack_recipe/clothing/poncho/green
	title = "green poncho"
	result_type = /obj/item/clothing/suit/poncho/colored/green
/datum/stack_recipe/clothing/poncho/red
	title = "red poncho"
	result_type = /obj/item/clothing/suit/poncho/colored/red
/datum/stack_recipe/clothing/poncho/purple
	title = "purple poncho"
	result_type = /obj/item/clothing/suit/poncho/colored/purple
/datum/stack_recipe/clothing/poncho/blue
	title = "blue poncho"
	result_type = /obj/item/clothing/suit/poncho/colored/blue
/datum/stack_recipe/clothing/poncho/security
	title = "security poncho"
	result_type = /obj/item/clothing/suit/poncho/roles/security
/datum/stack_recipe/clothing/poncho/medical
	title = "medical poncho"
	result_type = /obj/item/clothing/suit/poncho/roles/medical
/datum/stack_recipe/clothing/poncho/engineering
	title = "engineering poncho"
	result_type = /obj/item/clothing/suit/poncho/roles/engineering
/datum/stack_recipe/clothing/poncho/cargo
	title = "cargo poncho"
	result_type = /obj/item/clothing/suit/poncho/roles/cargo

/datum/stack_recipe/clothing/roughspun_robe
	title = "roughspun robes"
	result_type = /obj/item/clothing/suit/robe
	req_amount = 4
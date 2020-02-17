/obj/item/clothing/suit/storage/toggle/redcoat/yinglet
	desc = "The signature uniform of Tradehouse guardsmen. This one seems to be sized for a yinglet."
	species_restricted = list(SPECIES_YINGLET)
	icon = 'maps/tradeship/icons/suit_yinglet.dmi'

/obj/item/clothing/suit/storage/toggle/redcoat/yinglet/officer
	name = "\improper Tradehouse officer's coat"
	desc = "The striking uniform of a Tradehouse guard officer, complete with gold collar, buttons and trim. This one seems to be sized for a yinglet."
	has_badge =   "badge"
	has_buttons = "buttons_gold"
	has_collar =  "collar_gold"
	has_buckle =  "buckle_gold"

/obj/item/clothing/under/yinglet
	name = "small loincloth"
	desc = "A few rags that wrap around the legs and crotch for a semblance of modesty."
	species_restricted = list(SPECIES_YINGLET)
	icon = 'maps/tradeship/icons/under_yinglet.dmi'
	icon_state = "loincloth"
	sprite_sheets = list(SPECIES_YINGLET = 'maps/tradeship/icons/onmob_under_yinglet.dmi')
	color = COLOR_BEIGE
	var/detail_color

/obj/item/clothing/under/yinglet/matriarch
	name = "matriarch robe"
	desc = "An expensive and well-made garment for the enclave matriarch."
	icon_state = "matriarch_robe"
	color = null

/obj/item/clothing/under/yinglet/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(detail_color && slot == slot_w_uniform_str)
		var/image/I = image('maps/tradeship/icons/onmob_under_yinglet.dmi', "[icon_state]_detail")
		I.color = detail_color
		I.appearance_flags |= RESET_COLOR
		ret.overlays += I
	. = ret

/obj/item/clothing/under/yinglet/scout
	name = "scout loincloth"
	desc = "A layered loincloth and skirtlike garment worn by enclave scouts."
	color = "#917756"
	detail_color = "#698a71"

/obj/item/clothing/head/yinglet
	name = "small hood"
	desc = "A yinglet-sized cloth hood and mantle. It has ear holes."
	icon = 'maps/tradeship/icons/head_yinglet.dmi'
	icon_state = "ying_hood"
	flags_inv = BLOCKHAIR
	species_restricted = list(SPECIES_YINGLET)
	sprite_sheets = list(SPECIES_YINGLET = 'maps/tradeship/icons/onmob_head_yinglet.dmi')
	color = COLOR_BEIGE
	var/detail_color

/obj/item/clothing/head/yinglet/matriarch
	name = "matriarch hood"
	desc = "The well-crafted and heavily decorated hood of an enclave matriarch."
	icon_state = "matriarch_hood"
	color = null

/obj/item/clothing/head/yinglet/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(detail_color && slot == slot_head_str)
		var/image/I = image('maps/tradeship/icons/onmob_head_yinglet.dmi', "[icon_state]_detail")
		I.color = detail_color
		I.appearance_flags |= RESET_COLOR
		ret.overlays += I
	. = ret

/obj/item/clothing/head/yinglet/scout
	name = "scout hood"
	desc = "A layered hood and mantle worn by enclave scouts."
	color = "#917756"
	detail_color = "#698a71"

/obj/item/clothing/suit/yinglet
	name = "small cape"
	desc = "A short length of cloth worked into a cape. Some people would say it looks stupid."
	species_restricted = list(SPECIES_YINGLET)
	icon = 'maps/tradeship/icons/suit_yinglet.dmi'
	icon_state = "cape"
	color = COLOR_DARK_RED
	sprite_sheets = list(SPECIES_YINGLET = 'maps/tradeship/icons/onmob_suit_yinglet.dmi')

/obj/item/clothing/shoes/sandal/yinglet
	name = "small sandals"
	desc = "A pair of rather plain wooden sandals. They seem to be the right size and shape for a yinglet."
	species_restricted = list(SPECIES_YINGLET)
	item_icons = list(
		slot_shoes_str = 'maps/tradeship/icons/onmob_shoes_yinglet.dmi'
	)

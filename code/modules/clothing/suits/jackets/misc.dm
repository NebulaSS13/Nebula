/obj/item/clothing/suit/jacket/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/suit/jacket/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon = 'icons/clothing/suit/leather_jacket/bomber.dmi'
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	material = /decl/material/solid/organic/leather

/obj/item/clothing/suit/jacket/leather
	name = "black leather jacket"
	desc = "A black leather coat."
	icon = 'icons/clothing/suit/leather_jacket/black.dmi'

//This one has buttons for some reason
/obj/item/clothing/suit/jacket/brown
	name = "leather jacket"
	desc = "A brown leather coat."
	icon = 'icons/clothing/suit/leather_jacket/brown.dmi'

/obj/item/clothing/suit/jacket/agent
	name = "agent jacket"
	desc = "A black leather jacket belonging to an agent of the Sol Federal Police."
	icon = 'icons/clothing/suit/leather_jacket/agent.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/jacket/captain
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/clothing/suit/jacket/captain.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS

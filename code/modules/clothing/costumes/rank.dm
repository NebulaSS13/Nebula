/obj/item/clothing/costume/captain_suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon = 'icons/clothing/suits/suit_green.dmi'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/costume/head_of_personnel_suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon = 'icons/clothing/suits/suit_teal.dmi'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/costume/head_of_personnel_whimsy
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	name = "head of personnel's suit"
	icon = 'icons/clothing/uniform_hop_whimsy.dmi'

/obj/item/clothing/costume/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon = 'icons/clothing/uniform_hos_formal.dmi'

/obj/item/clothing/costume/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon = 'icons/clothing/uniform_assistant_formal.dmi'

/obj/item/clothing/costume/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon = 'icons/clothing/uniform_dispatch.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)


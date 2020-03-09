/obj/item/clothing/under/pcrc
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon_state = "pcrc"
	item_state = "jensensuit"
	worn_state = "pcrc"
	gender_icons = 1

/obj/item/clothing/under/pcrcsuit
	name = "\improper PCRC suit"
	desc = "A suit belonging to Proxima Centauri Risk Control, a private security firm. This one looks more formal than its utility counterpart."
	icon_state = "pcrcsuit"
	item_state = "jensensuit"
	worn_state = "pcrcsuit"
	gender_icons = 1

/obj/item/clothing/under/rank/guard
	name = "green security guard uniform"
	desc = "A durable uniform worn by Expeditionary Corps Organisation security."
	icon_state = "guard"
	item_state = "w_suit"
	worn_state = "guard"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1

/obj/item/clothing/under/rank/guard/heph
	name = "cyan security guard uniform"
	desc = "A durable uniform worn by subcontracted Hephaestus Industries security."
	icon_state = "guard_heph"
	worn_state = "guard_heph"

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	worn_state = "sec_corporate"

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	worn_state = "warden_corporate"

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	worn_state = "hos_corporate"

/obj/item/clothing/under/rank/guard/nanotrasen
	name = "red security guard uniform"
	desc = "A durable uniform worn by subcontracted NanoTrasen security."
	icon_state = "guard_nt"
	worn_state = "guard_nt"
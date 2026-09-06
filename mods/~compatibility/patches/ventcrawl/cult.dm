// Vent crawling whitelisted items, whoo
/mob/living/Initialize()
	. = ..()
	can_enter_vent_with += list(
		/obj/item/clothing/head/culthood,
		/obj/item/clothing/suit/cultrobes,
		/obj/item/book/tome,
		/obj/item/sword/cultblade
	)
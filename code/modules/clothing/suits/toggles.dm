//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/toggle
	abstract_type = /obj/item/clothing/suit/toggle
	storage = /datum/storage/pockets/suit
	replaced_in_loadout = FALSE

/obj/item/clothing/suit/toggle/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

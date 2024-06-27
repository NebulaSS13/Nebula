/obj/item/clothing/shirt/flannel
	name = "flannel shirt"
	desc = "A comfy, plaid flannel shirt."
	icon = 'icons/clothing/shirts/flannel.dmi'

/obj/item/clothing/shirt/flannel/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves),
		GET_DECL(/decl/clothing_state_modifier/tucked_in)
	)
	return expected_state_modifiers

/obj/item/clothing/shirt/flannel/red
	paint_color = "#bd2b20"

/obj/item/clothing/shirt/flannel/red/outfit
	starting_accessories = list(

	)
/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name        = "engagement ring"
	desc        = "An engagement ring. It certainly looks expensive."
	material    = /decl/material/solid/metal/silver
	decorations = list(/obj/item/gemstone/round)

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_action_message("get", "down on one knee, presenting \the [src].", dangerous = ACTION_DANGER_OTHERS)

/obj/item/clothing/gloves/ring/cti
	name        = "\improper CTI ring"
	desc        = "A ring commemorating graduation from CTI."
	material    = /decl/material/solid/metal/silver
	decorations = list(/obj/item/gemstone/round/sapphire)
	use_material_name = FALSE

/obj/item/clothing/gloves/ring/mariner
	name        = "\improper Mariner University ring"
	desc        = "A ring commemorating graduation from Mariner University."
	material    = /decl/material/solid/metal/gold
	decorations = list(/obj/item/gemstone/round/ruby)
	use_material_name = FALSE

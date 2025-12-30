/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name        = "engagement ring"
	desc        = "An engagement ring. It certainly looks expensive."
	material    = /decl/material/solid/metal/silver
	decorations = list(/obj/item/gemstone/round)

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_message(SPAN_WARNING("\The [user] gets down on one knee, presenting \the [src]."), SPAN_WARNING("You get down on one knee, presenting \the [src]."))

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

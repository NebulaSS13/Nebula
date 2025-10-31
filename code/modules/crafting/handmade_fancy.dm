/obj/item/chems/glass/handmade/fancy
	abstract_type = /obj/item/chems/glass/handmade/fancy
	material = /decl/material/solid/metal/silver

/obj/item/chems/glass/handmade/fancy/get_single_monetary_worth()
	. = ..() * 1.5 // Crafting value, todo proper crafting skill modifying sale price.

/obj/item/chems/glass/handmade/fancy/decanter
	name = "decanter"
	desc = "A masterfully made decanter with a fluted neck and graceful handle."
	icon = 'icons/obj/items/handmade/decanter.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 120
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/glass/handmade/fancy/goblet
	name = "goblet"
	desc = "An elegant goblet with a flared base, likely handmade by some master artisan."
	icon = 'icons/obj/items/handmade/cup_fancy.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 60

/obj/item/chems/glass/handmade/fancy/bowl
	name = "bowl"
	desc = "A sleek, polished bowl, likely handmade by some master artisan."
	icon = 'icons/obj/items/handmade/bowl_fancy.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 60

/obj/item/chems/glass/handmade/fancy/vase
	name = "vase"
	desc = "An elegant masterwork vase."
	icon = 'icons/obj/items/handmade/vase_fancy.dmi'
	amount_per_transfer_from_this = 20
	chem_volume = 240
	material = /decl/material/solid/stone/ceramic

/obj/item/chems/glass/handmade/fancy/vase/fluted
	desc = "An elegant masterwork vase with a fluted neck."
	icon = 'icons/obj/items/handmade/vase_fancy_fluted.dmi'

/obj/item/chems/glass/handmade/fancy/vase/fluted/update_name()
	. = ..()
	SetName("fluted [name]")

// Decorated subtypes for mapping/
/obj/item/chems/glass/handmade/fancy/vase/mapped
	decorations = list(/decl/material/solid/organic/bone)

/obj/item/chems/glass/handmade/fancy/vase/fluted/mapped
	decorations = list(/decl/material/solid/organic/bone)

/obj/item/chems/glass/handmade/fancy/goblet/mapped
	material = /decl/material/solid/metal/gold
	decorations = list(/obj/item/gemstone/octagon/ruby)

/obj/item/chems/glass/handmade/fancy/bowl/mapped
	decorations = list(/obj/item/gemstone/octagon/sapphire)

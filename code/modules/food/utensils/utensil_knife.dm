/obj/item/utensil/knife
	name         = "table knife"
	desc         = "A simple table knife, used to cut up individual portions of food."
	icon         = 'icons/obj/food/utensils/steak_knife.dmi'
	utensil_flags = UTENSIL_FLAG_SLICE | UTENSIL_FLAG_SPREAD

/obj/item/utensil/knife/plastic
	material = /decl/material/solid/organic/plastic

/obj/item/utensil/knife/steak
	name  = "steak knife"
	desc  = "It's a steak knife with a serrated edge."
	icon  = 'icons/obj/food/utensils/steak_knife.dmi'
	sharp = TRUE
	edge  = TRUE
	utensil_flags = UTENSIL_FLAG_SLICE
	material = /decl/material/solid/metal/steel
	_base_attack_force = 6

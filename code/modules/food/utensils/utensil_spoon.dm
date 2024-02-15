/obj/item/utensil/spoon
	name                      = "spoon"
	desc                      = "It's a spoon. You can see your own upside-down face in it."
	icon                      = 'icons/obj/food/utensils/spoon.dmi'
	attack_verb               = list("attacked", "poked")
	material_force_multiplier = 0.1 //2 when wielded with weight 20 (steel)
	utensil_flags              = UTENSIL_FLAG_SCOOP

/obj/item/utensil/spoon/plastic
	material = /decl/material/solid/organic/plastic

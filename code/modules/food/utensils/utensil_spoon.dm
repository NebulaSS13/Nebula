/obj/item/utensil/spoon
	name                      = "spoon"
	desc                      = "It's a spoon. You can see your own upside-down face in it."
	icon                      = 'icons/obj/food/utensils/spoon.dmi'
	attack_verb               = list("attacked", "poked")
	utensil_flags              = UTENSIL_FLAG_SCOOP

/obj/item/utensil/spoon/Initialize()
	. = ..()
	if(!has_extension(src, /datum/extension/tool) && w_class > ITEM_SIZE_TINY)
		set_extension(src, /datum/extension/tool, list(
			// yes, this is entirely so you can dig normally with a comically large spoon
			// a tiny spoon cannot be used to dig, a small spoon has a very slow multiplier, a huge spoon is basically a shovel
			TOOL_SHOVEL = Interpolate(TOOL_QUALITY_WORST / 10, TOOL_QUALITY_MEDIOCRE, (w_class - ITEM_SIZE_SMALL) / (ITEM_SIZE_HUGE - ITEM_SIZE_SMALL))
		))

/obj/item/utensil/spoon/plastic
	material = /decl/material/solid/organic/plastic

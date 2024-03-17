/obj/item/chems/food/worm
	name = "worm"
	desc = "A wriggling worm."
	icon = 'icons/obj/worm.dmi'
	icon_state = ICON_STATE_WORLD
	color = "#835673"
	w_class = ITEM_SIZE_TINY
	nutriment_type = null
	nutriment_amt = 0
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/worm/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 5)

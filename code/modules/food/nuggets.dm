/obj/item/food/nugget
	name           = "chicken nugget"
	icon           = 'icons/obj/food/nuggets/nugget.dmi'
	icon_state     = ICON_STATE_WORLD
	nutriment_desc = list("mild battered chicken")
	nutriment_amt  = 6
	nutriment_type = /decl/material/solid/organic/meat/chicken
	material       = /decl/material/solid/organic/meat/chicken
	bitesize       = 3
	var/shape      = null
	var/static/list/nugget_icons = list(
		"lump"   = 'icons/obj/food/nuggets/nugget.dmi',
		"star"   = 'icons/obj/food/nuggets/nugget_star.dmi',
		"lizard" = 'icons/obj/food/nuggets/nugget_lizard.dmi',
		"corgi"  = 'icons/obj/food/nuggets/nugget_corgi.dmi'
	)

/obj/item/food/nugget/Initialize()
	. = ..()
	if(isnull(shape))
		shape = pick(nugget_icons)
		set_icon(nugget_icons[shape])
	desc = "A chicken nugget vaguely shaped like a [shape]."
	add_allergen_flags(ALLERGEN_GLUTEN) // flour

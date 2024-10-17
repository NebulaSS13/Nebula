/obj/item/food/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon = 'icons/obj/food/donuts/donut.dmi'
	icon_state = ICON_STATE_WORLD
	filling_color = "#d9c386"
	center_of_mass = @'{"x":19,"y":16}'
	nutriment_desc = list("sweetness", "donut")
	nutriment_amt = 3
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	var/iced_icon = 'icons/obj/food/donuts/donut_iced.dmi'

/obj/item/food/donut/populate_reagents()
	. = ..()
	if(iced_icon && prob(30) && icon != iced_icon)
		icon = iced_icon
		SetName("frosted [name]")
		add_to_reagents(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/food/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	filling_color = "#ed11e6"
	nutriment_amt = 2
	bitesize = 10

/obj/item/food/donut/chaos/proc/get_random_fillings()
	. = list(
		/decl/material/liquid/nutriment,
		/decl/material/liquid/capsaicin,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nutriment/sprinkles,
		/decl/material/gas/chlorine,
		/decl/material/liquid/nutriment/coco,
		/decl/material/liquid/nutriment/banana_cream,
		/decl/material/liquid/nutriment/cherryjelly,
		/decl/material/liquid/fuel,
		/decl/material/liquid/regenerator
	)

/obj/item/food/donut/chaos/populate_reagents()
	. = ..()
	add_to_reagents(pick(get_random_fillings()), 3)

/obj/item/food/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon = 'icons/obj/food/donuts/donut_jelly.dmi'
	iced_icon = 'icons/obj/food/donuts/donut_jelly_iced.dmi'
	filling_color = "#ed1169"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_amt = 3
	bitesize = 5
	nutriment_type = /decl/material/liquid/nutriment/bread
	var/jelly_type = /decl/material/liquid/nutriment/cherryjelly

/obj/item/food/donut/jelly/populate_reagents()
	. = ..()
	add_to_reagents(jelly_type, 5)


/obj/item/food/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon = 'icons/obj/food/chocolatebar.dmi'
	filling_color = "#7d5f46"
	center_of_mass = @'{"x":15,"y":15}'
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/food/chocolatebar/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/coco,  2)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 2)

/obj/item/food/chocolateegg
	name = "chocolate egg"
	desc = "Such sweet, fattening food."
	icon = 'icons/obj/food/eggs/egg_chocolate.dmi'
	filling_color = "#7d5f46"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/food/chocolateegg/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/coco,  2)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 2)

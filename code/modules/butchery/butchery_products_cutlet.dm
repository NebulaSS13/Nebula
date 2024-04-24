/obj/item/chems/food/butchery/cutlet
	name           = "cutlet"
	desc           = "A tasty meat slice."
	icon           = 'icons/obj/items/butchery/cutlet.dmi'
	bitesize       = 2
	center_of_mass = @'{"x":17,"y":20}'
	material       = /decl/material/solid/organic/meat
	nutriment_type = /decl/material/solid/organic/meat
	nutriment_amt  = 1
	material_alteration = MAT_FLAG_ALTERATION_NONE

/obj/item/chems/food/butchery/cutlet/Initialize()
	. = ..()
	slice_path = null
	slice_num = null

/obj/item/chems/food/butchery/cutlet/raw
	desc                           = "A thin piece of raw meat."
	icon                           = 'icons/obj/items/butchery/rawcutlet.dmi'
	cooked_food                    = FOOD_RAW
	backyard_grilling_product      = /obj/item/chems/food/butchery/cutlet
	backyard_grilling_announcement = "sizzles as it is grilled through."
	drying_wetness                 = 30
	dried_type                     = /obj/item/chems/food/jerky/cutlet
	nutriment_amt                  = 2

/obj/item/chems/food/butchery/cutlet/raw/set_meat_name(new_meat_name)
	. = ..()
	SetName("raw [name]")

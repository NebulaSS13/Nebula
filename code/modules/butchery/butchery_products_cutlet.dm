/obj/item/food/butchery/cutlet
	name                = "cutlet"
	desc                = "A tasty meat slice."
	icon                = 'icons/obj/items/butchery/cutlet.dmi'
	bitesize            = 2
	nutriment_amt       = 1
	center_of_mass      = @'{"x":17,"y":20}'
	material_alteration = MAT_FLAG_ALTERATION_NONE
	slice_path          = /obj/item/food/butchery/chopped
	slice_num           = 1
	cooked_food         = FOOD_COOKED
	w_class             = ITEM_SIZE_SMALL

/obj/item/food/butchery/cutlet/raw
	desc                           = "A thin piece of raw meat."
	icon                           = 'icons/obj/items/butchery/rawcutlet.dmi'
	cooked_food                    = FOOD_RAW
	backyard_grilling_product      = /obj/item/food/butchery/cutlet
	backyard_grilling_announcement = "sizzles as it is grilled through."
	drying_wetness                 = 30
	dried_type                     = /obj/item/food/jerky/cutlet
	nutriment_amt                  = 2

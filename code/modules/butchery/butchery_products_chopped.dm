/obj/item/food/butchery/chopped
	name          = "chopped meat"
	desc          = "A handful of chopped meat."
	icon          = 'icons/obj/food/butchery/chopped.dmi'
	bitesize      = 2
	nutriment_amt = 1
	w_class       = ITEM_SIZE_TINY

/obj/item/food/butchery/chopped/Initialize(mapload, material_key, skip_plate = FALSE)
	. = ..()
	slice_path = null
	slice_num = null

/obj/item/food/butchery/chopped/set_meat_name(new_meat_name)
	. = ..()
	if(cooked_food == FOOD_RAW)
		SetName("chopped raw [new_meat_name]")
	else
		SetName("chopped [new_meat_name]")

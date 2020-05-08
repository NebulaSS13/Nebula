/obj/item/clothing/get_base_value()
	. = 10

/obj/item/clothing/head/collectable/get_value_multiplier()
	. = 5

/obj/item/clothing/get_base_value()
	. = ..()
	if(!holographic && flash_protection > 0)
		. += flash_protection * 25

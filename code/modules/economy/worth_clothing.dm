/obj/item/clothing/get_base_value()
	. = max(..(), 10)
	if(!holographic && flash_protection > 0)
		. += flash_protection * 25

/obj/item/clothing/head/collectable/get_value_multiplier()
	. = 5

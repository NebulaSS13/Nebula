/obj/item/clothing/get_base_value()
	. = 10

/obj/item/clothing/head/collectable/get_value_multiplier()
	. = 5

/obj/item/clothing/get_single_monetary_worth()
	. = ..()
	switch(flash_protection)
		if(FLASH_PROTECTION_MINOR)
			. += 10
		if(FLASH_PROTECTION_MODERATE)
			. += 50
		if(FLASH_PROTECTION_MAJOR)
			. += 100

/obj/item/clothing/get_base_value()
	. = 10

/obj/item/clothing/head/collectable/get_value_multiplier()
	. = 5

/obj/item/clothing/get_single_monetary_worth()
	. = ..()
	if(!holographic)
		if(flash_protection > 0)
			. += flash_protection * SSfabrication.flash_protection_value

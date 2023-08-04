/obj/item/clothing/price()
	. = max(..(), 10)
	if(flash_protection > 0)
		. += flash_protection * 25

/obj/item/clothing/head/collectable/price()
	. = ..() * 5

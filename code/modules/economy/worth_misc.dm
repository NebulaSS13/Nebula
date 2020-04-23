/obj/item/disk/survey/get_single_monetary_worth()
	. = holographic ? 0 : (sqrt(data) * SSfabrication.data_value_modifier)

/obj/item/cash/get_single_monetary_worth()
	. = holographic ? 0 : absolute_worth 

/obj/item/slime_extract/get_single_monetary_worth()
	. = ..() * Uses

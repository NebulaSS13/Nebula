/obj/item/disk/survey/get_single_monetary_worth()
	if(data < 10000)
		return 0.07*data
	if(data < 30000)
		return 0.1*data
	return 0.15*data

/obj/item/cash/get_single_monetary_worth()
	. = absolute_worth

/obj/item/slime_extract/get_single_monetary_worth()
	. = ..() * Uses

/obj/item/disk/survey/get_base_value()
	. = holographic ? 0 : (sqrt(data) * SSfabrication.data_value_modifier)

/obj/item/slime_extract/get_base_value()
	. = ..() * Uses

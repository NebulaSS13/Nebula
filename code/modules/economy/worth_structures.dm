/obj/structure/get_single_monetary_worth()
	. = ..()
	if(material)
		. *= material.value

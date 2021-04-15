/obj/item/stack/get_value_multiplier()
	. = istype(get_material_composition(), /datum/materials) ? ..() : amount

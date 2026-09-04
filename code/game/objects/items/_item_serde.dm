/obj/item/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(paint_verb, /obj/item)

/obj/item/stack/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(amount, /obj/item/stack)

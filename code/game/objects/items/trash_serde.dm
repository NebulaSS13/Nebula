/obj/item/trash/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(age, /obj/item/trash)

/obj/item/trash/ShouldSerialize(_age)
	return ..() && (isnull(_age) || age < _age)

/obj/item/trash/Deserialize(list/instance_map)
	..()
	return SERDE_HINT_POSTINIT

/obj/item/trash/DeserializePostInit(list/instance_map)
	. = ..()
	for(var/obj/item/trash/thing in loc)
		if(thing != src && thing.type == type)
			qdel(src)
			return
	var/too_much_trash = 0
	for(var/obj/item/trash/trash in loc)
		if(trash == src)
			too_much_trash++
			if(too_much_trash >= 5)
				qdel(src)
				return

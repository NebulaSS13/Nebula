/obj/item/book/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(last_modified_ckey, /obj/item/book)
	SERIALIZE_IF_MODIFIED(dat, /obj/item/book)
	SERIALIZE_IF_MODIFIED(title, /obj/item/book)
	SERIALIZE_IF_MODIFIED(author, /obj/item/book)
	SERIALIZE_IF_MODIFIED(icon_state, /atom)

/obj/item/book/Deserialize()
	. = ..()
	SSpersistence.track_value(src, /decl/persistence_handler/book)

/obj/item/book/GetPossiblySerializableInstances()
	. = ..()
	if(istype(loc, /obj/structure/bookcase))
		LAZYDISTINCTADD(., loc)

/obj/item/book/Deserialize(list/instance_map)
	..()
	return SERDE_HINT_POSTINIT

/obj/item/book/DeserializePostInit(list/instance_map)
	. = ..()
	var/area/area = get_area(src)
	if(!area || (area.area_flags & AREA_FLAG_NO_LEGACY_PERSISTENCE))
		forceMove(null)
	if(isnull(loc))
		if(length(global.station_bookcases))
			forceMove(pick(global.station_bookcases))
		else
			forceMove(get_random_spawn_turf(SPAWN_FLAG_PERSISTENCE_CAN_SPAWN))

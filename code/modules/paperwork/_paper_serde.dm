/obj/item/paper/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(age, /obj/item/paper)
	SERIALIZE_IF_MODIFIED(is_crumpled, /obj/item/paper)
	SERIALIZE_IF_MODIFIED(last_modified_ckey, /obj/item/paper)
	SERIALIZE_IF_MODIFIED(name, /obj/item/paper)
	SERIALIZE_IF_MODIFIED(info, /obj/item/paper)

/obj/item/paper/Deserialize()
	. = ..()
	SSpersistence.track_value(src, /decl/persistence_handler/paper)

/obj/item/paper/ShouldSerialize(_age)
	return ..() && (isnull(_age) || age < _age)

/obj/item/paper/GetPossiblySerializableInstances()
	. = ..()
	if(istype(loc, /obj/structure/noticeboard))
		LAZYDISTINCTADD(., loc)

// If it's old enough we start to trim down any textual information and scramble strings.
#define SERDE_MESSAGE nameof(/obj/item/paper::info)
/obj/item/paper/HandlePersistentDecay(entries_decay_at, entry_decay_weight)
	__deserialization_payload[SERDE_MESSAGE] = apply_serde_message_decay(
		__deserialization_payload[SERDE_MESSAGE],
		__deserialization_payload[nameof(/obj/item/paper::age)],
		entry_decay_weight,
		entries_decay_at
	)
#undef SERDE_MESSAGE

/obj/effect/decal/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(age, /obj/effect/decal)

/obj/effect/decal/Deserialize(list/instance_map)
	. = ..()
	age++

/obj/effect/decal/ShouldSerialize(_age)
	return simulated && (isnull(_age) || age < _age)

// Prevent all mob serde for the time being.
// Equipment handling and the like needs a lot of work to implement.
/mob/ShouldSerialize(_age)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/GetPossiblySerializableInstances()
	return null

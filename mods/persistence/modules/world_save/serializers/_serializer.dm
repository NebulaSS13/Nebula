#define IS_PROC(X) (findtext("\ref[X]", "0x26"))

/serializer
	var/datum/persistence/load_cache/resolver/resolver = new()

	var/list/thing_map = list()
	var/list/reverse_map = list()
	var/list/list_map = list()
	var/list/reverse_list_map = list()

// Serializes an object. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/proc/Serialize(var/object, var/object_parent)
	if(islist(object))
		return SerializeList(object, object_parent)
	return SerializeDatum(object, object_parent)

// Serialize an object datum. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/proc/SerializeDatum(var/datum/object, var/object_parent)

// Serialize a list. Returns the appropriate serialized form of the list. What's outputted depends on the serializer.
/serializer/proc/SerializeList(var/list/list, var/list_parent)

/serializer/proc/DeserializeDatum(var/datum/persistence/load_cache/thing/object)

/serializer/proc/DeserializeList(var/raw_list)

/serializer/proc/QueryAndDeserializeDatum(var/object_id)
	var/datum/existing = reverse_map["[object_id]"]
	if(!isnull(existing))
		return existing
	return DeserializeDatum(resolver.things["[object_id]"])

/serializer/proc/QueryAndDeserializeList(var/list_id)
	var/list/existing = reverse_list_map["[list_id]"]
	if(!isnull(existing))
		return existing
	var/list/result = DeserializeList(resolver.lists["[list_id]"])
	reverse_list_map["[list_id]"] = result
	return result

/serializer/proc/should_flatten(var/datum/object)
	if(isnull(object))
		return FALSE
	return object.type in GLOB.flatten_types
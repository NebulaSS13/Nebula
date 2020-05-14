#define IS_PROC(X) (findtext("\ref[X]", "0x26"))

/serializer
	var/datum/persistence/load_cache/resolver/resolver = new()

	var/list/thing_map = list()
	var/list/reverse_map = list()
	var/list/list_map = list()
	var/list/reverse_list_map = list()

	var/list/z_map = list() // This map lists key (game's z_index) to the zindex used by the database (value).
	var/z_index = -1
	var/nongreedy_serialize = TRUE // Only serialize objects whitelist by z_map.

// Serializes an object. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
// object: A thing to serialize.
// object_parent: That object's parent. Could be a container or other. Optional.
// z: The z_level of this object. Also optional. Used for reordering z_levels in world saves
/serializer/proc/Serialize(var/object, var/object_parent, var/z)
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

/serializer/proc/Clear()
	z_index = -1
	z_levels.Cut(1)
	thing_map.Cut(1)
	reverse_map.Cut(1)
	list_map.Cut(1)
	reverse_list_map.Cut(1)
/serializer/json
	var/serializer/sql/sql

/serializer/json/New(var/serializer/sql/sql_serializer)
	sql = sql_serializer

// Serializes an object. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/json/Serialize(var/object, var/object_parent)
	if(islist(object))
		return SerializeList(object, object_parent)
	return SerializeDatum(object, object_parent)

// Serialize an object datum. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/json/SerializeDatum(var/datum/object, var/object_parent)
	if(!object.should_save())
		return
	var/list/results = list()
	object.before_save()
	for(var/V in object.get_saved_vars())
		if(!issaved(object.vars[V]))
			continue
		var/VV = object.vars[V]
		if(VV == initial(object.vars[V]))
			continue
		if(islist(VV))
			results[V] = SerializeList(VV)
		else if(istext(VV) || isnum(VV) || isnull(VV))
			results[V] = VV
		else if(istype(VV, /datum))
			if(should_flatten(VV))
				results[V] = "FLAT_OBJ#[SerializeDatum(VV)]"
			else
				results[V] = "OBJ#[sql.SerializeDatum(VV)]"
	object.after_save()
	return "[object.type]|[json_encode(results)]"

// Serialize a list. Returns the appropriate serialized form of the list. What's outputted depends on the serializer.
/serializer/json/SerializeList(var/list/_list, var/list_parent)
	var/list/final_list = list()
	for(var/K in _list)
		var/F_K // Final key
		var/F_V // Final value

		// Serialize the key.
		if(islist(K))
			F_K = SerializeList(K)
		else if(istext(K) || isnum(K) || isnull(K))
			F_K = K
		else if(istype(K, /datum))
			if(should_flatten(K))
				F_K = "FLAT_OBJ#[SerializeDatum(K)]"
			else
				F_K = "OBJ#[sql.SerializeDatum(K)]"
		
		// All byond lists are dicts. Check if this KVP is a dict. or a null type ref.
		try
			var/V = _list[K] // Type value?
			// There was a type value.
			if(islist(V))
				F_V = SerializeList(V)
			else if(istext(V) || isnum(V) || isnull(V))
				F_V = V
			else if(istype(V, /datum))
				if(should_flatten(V))
					F_V = "FLAT_OBJ#[SerializeDatum(V)]"
				else
					F_V = "OBJ#[sql.SerializeDatum(V)]"
			
			// Add the list value.
			final_list[F_K] = F_V
		catch
			// It's just a list element. No type value.
			final_list.Add(F_K)
	return final_list


/serializer/json/DeserializeDatum(var/datum/persistence/load_cache/thing/object)
	throw EXCEPTION("Do not use DeserializeDatum for the JSON Serializer. Use QueryAndDeserializeDatum.")

/serializer/proc/JsonDeserializeDatum(var/datum/thing, var/list/thing_vars)
	for(var/V in thing_vars)
		var/encoded_value = thing_vars[V]
		if(istext(encoded_value) && findtext(encoded_value, "OBJ#", 1, 5))
			// This is an object reference.
			thing.vars[V] = QueryAndDeserializeDatum(copytext(encoded_value, 5))
			continue
		if(islist(encoded_value))
			thing.vars[V] = DeserializeList(encoded_value)
			continue
		thing.vars[V] = encoded_value
	thing.after_deserialize()
	return thing

/serializer/json/DeserializeList(var/raw_list)
	var/list/final_list = list()
	for(var/K in raw_list)
		var/key = K
		if(istext(K) && findtext(K, "OBJ#", 1, 2))
			key = sql.QueryAndDeserializeDatum(copytext(K, 5))
		else if(istext(K) && findtext(K, "FLAT_OBJ#", 1, 2))
			key = QueryAndDeserializeDatum(copytext(K, 10))
		else if(islist(K))
			key = DeserializeList(K)
		try
			var/V = raw_list[K]
			if(istext(V) && findtext(V, "OBJ#", 1, 2))
				V = sql.QueryAndDeserializeDatum(copytext(V, 5))
			else if(istext(K) && findtext(K, "FLAT_OBJ#", 1, 2))
				V = QueryAndDeserializeDatum(copytext(V, 10))
			else if(islist(V))
				V = DeserializeList(V)
			final_list[key] = V
		catch
			final_list.Add(key)
	return final_list

/serializer/json/QueryAndDeserializeDatum(var/thing_json)
	var/list/tokens = splittext(thing_json, "|")
	var/thing_type = text2path(tokens[1])
	var/datum/existing = new thing_type
	var/list/vars = json_decode(jointext(tokens.Copy(2), "|"))
	return JsonDeserializeDatum(existing, vars)
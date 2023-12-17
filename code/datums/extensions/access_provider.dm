/datum/extension/access_provider
	base_type = /datum/extension/access_provider
	expected_type = /atom/movable
	var/list/atom/movable/registered_ids

/datum/extension/access_provider/Destroy()
	LAZYCLEARLIST(registered_ids)
	. = ..()

/datum/extension/access_provider/proc/register_id(atom/movable/to_register)
	LAZYDISTINCTADD(registered_ids, to_register)

/datum/extension/access_provider/proc/unregister_id(atom/movable/to_unregister)
	LAZYREMOVE(registered_ids, to_unregister)

/datum/extension/access_provider/proc/GetIdCards(list/exceptions)
	for(var/atom/movable/registered_id in registered_ids)
		LAZYDISTINCTADD(., registered_id.GetIdCards(exceptions))

SUBSYSTEM_DEF(managed_instances)
	name = "Managed Instances"
	flags = SS_NO_FIRE | SS_NO_INIT
	var/list/_managed_instance_cache = list()

/datum/controller/subsystem/managed_instances/proc/get_category(var/cache_category)
	var/list/category = _managed_instance_cache[cache_category]
	if(category)
		return category.Copy() // avoid mutating the cache.

/datum/controller/subsystem/managed_instances/proc/get(var/instance_type, var/cache_id, var/cache_category = "default", var/list/instance_args)
	if(!cache_id)
		cache_id = instance_type
	if(isnull(cache_id)) // No type and no id supplied, no point going further.
		CRASH("Attempted to retrieve a managed instance with no supplied type or ID.")
	if(isnum(cache_id)) // The cache is an assoc list of id to instance, so numerical IDs are out.
		CRASH("Attempted to retrieve a managed instance with numerical ID ([cache_id]).")

	var/category_list = _managed_instance_cache[cache_category]
	if(category_list)
		. = category_list[cache_id]
	else
		category_list = list()
		_managed_instance_cache[cache_category] = category_list

	if(!.)
		// arglist() passed to New() will runtime without at least one list entry.
		var/datum/managed_instance = length(instance_args) ? (new instance_type(arglist(instance_args))) : (new instance_type)
		category_list[cache_id] = managed_instance
		LAZYINITLIST(instance_args)
		instance_args.Insert(1, cache_id)
		managed_instance.ManagedInstanceInitialize(arglist(instance_args)) // We do this after storing to avoid circular creation loops.
		if(QDELETED(managed_instance))
			PRINT_STACK_TRACE("Managed instance was queued for deletion during init! [managed_instance]")
			category_list[cache_id] -= managed_instance
		else
			events_repository.register(/decl/observ/destroyed, managed_instance, src, /datum/controller/subsystem/managed_instances/proc/clear)
			. = managed_instance

// This is costly, but it also shouldn't be common for managed instances to get qdeleted post-storage.
/datum/controller/subsystem/managed_instances/proc/clear(var/datum/destroyed_instance)
	if(!destroyed_instance)
		return
	PRINT_STACK_TRACE("Managed instance was destroyed! [destroyed_instance]")
	for(var/category in _managed_instance_cache)
		var/list/category_data = _managed_instance_cache[category]
		for(var/cache_id in category_data)
			if(category_data[cache_id] == destroyed_instance)
				category_data -= cache_id

/datum/proc/ManagedInstanceInitialize(var/cache_id, ...)
	return

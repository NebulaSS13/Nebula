// /decl is a subtype used for singletons that should never have more than one instance
// in existence at a time. If you want to use a /decl you should use a pattern like:
//     var/decl/somedecl/mydecl = GET_DECL(/decl/somedecl)

// /decls are created the first time they are fetched from decls_repository and will
// automatically call Initialize() and such when created in this way.

// decls_repository.get_decls_of_type() and decls_repository.get_decls_of_subtype()
// can be used similarly to typesof() and subtypesof(), returning assoc instance lists.

// decls_repository.get_decl_by_id() will retrieve a decl based on a string UID - at time
// of writing this is only set for materials and is used by omni devices to populate their
// mapped port settings.

// The /decl commandments:
//     I.   Thou shalt not create a /decl with new().
//     II.  Thou shalt not del() or qdel() a /decl.
//     III. Thou shalt not write a decl that relies on arguments supplied to New().
//     IV.  Thou shalt not call Initialize() on a /decl.

var/global/repository/decls/decls_repository = new

/repository/decls
	var/list/fetched_decls =                 list()
	var/list/fetched_decl_ids =              list()
	var/list/fetched_decl_types =            list()
	var/list/fetched_decl_instances =        list()
	var/list/fetched_decl_subtypes =         list()
	var/list/fetched_decl_subinstances =     list()
	var/list/fetched_decl_paths_by_type =    list()
	var/list/fetched_decl_paths_by_subtype = list()

/repository/decls/New()
	..()
	for(var/decl_type in typesof(/decl))
		var/decl/decl = decl_type
		var/decl_uid = initial(decl.uid)
		if(decl_uid && (!TYPE_IS_ABSTRACT(decl) || (initial(decl.decl_flags) & DECL_FLAG_ALLOW_ABSTRACT_INIT)))
			fetched_decl_ids[decl_uid] = decl

/repository/decls/proc/get_decl_by_id(var/decl_id, var/validate_decl_type = TRUE)
	RETURN_TYPE(/decl)
	. = get_decl(fetched_decl_ids[decl_id], validate_decl_type)

// This proc and get_decl_by_id_or_var() are being added solely to grandfather in decls saved to player saves under name
// rather than UID. They should be considered deprecated for this purpose - uid and get_decl_by_id() should be used instead.
/repository/decls/proc/get_decl_by_var(var/decl_value, var/decl_prototype, var/check_var = "name")
	var/list/all_decls = get_decls_of_type(decl_prototype)
	var/decl/prototype = all_decls[all_decls[1]] // Can't just grab the prototype as it may be abstract
	if(!(check_var in prototype.vars))
		CRASH("Attempted to retrieve a decl by a var that does not exist on the decl type ('[check_var]')")
	for(var/decl_type in all_decls)
		var/decl/decl = all_decls[decl_type]
		if(decl.vars[check_var] == decl_value)
			return decl

/repository/decls/proc/get_decl_by_id_or_var(var/decl_id, var/decl_prototype, var/check_var = "name")
	RETURN_TYPE(/decl)
	return get_decl_by_id(decl_id, validate_decl_type = FALSE) || get_decl_by_var(decl_id, decl_prototype, check_var)

/repository/decls/proc/get_decl_path_by_id(decl_id)
	. = fetched_decl_ids[decl_id]

/repository/decls/proc/get_decl(var/decl/decl_type, var/validate_decl_type = TRUE)

	RETURN_TYPE(/decl)

	if(!ispath(decl_type, /decl))
		if(validate_decl_type)
			CRASH("Invalid decl_type supplied to get_decl(): [decl_type || "NULL"]")
		return null

	if(TYPE_IS_ABSTRACT(decl_type) && !(initial(decl_type.decl_flags) & DECL_FLAG_ALLOW_ABSTRACT_INIT))
		return // We do not instantiate abstract decls.
	. = fetched_decls[decl_type]
	if(!.)
		var/decl/decl = new decl_type
		fetched_decls[decl_type] = decl // This needs to be done prior to calling Initialize() to avoid circular get_decl() calls by dependencies/children.
		// TODO: maybe implement handling for LATELOAD and QDEL init hints?
		var/init_result = decl.Initialize()
		switch(init_result)
			if(INITIALIZE_HINT_NORMAL)
				. = decl
			else
				if(fetched_decls[decl_type] == decl)
					fetched_decls -= decl_type
				PRINT_STACK_TRACE("Invalid return hint to [decl_type]/Initialize(): [init_result || "NULL"]")

/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		var/decl = get_decl(decl_type)
		if(decl)
			.[decl_type] = decl

/repository/decls/proc/get_decl_paths_of_type(var/decl_prototype)
	. = fetched_decl_paths_by_type[decl_prototype]
	if(!.)
		. = list()
		for(var/decl_path in get_decls_of_type(decl_prototype))
			. += decl_path
		fetched_decl_paths_by_type[decl_prototype] = .

/repository/decls/proc/get_decl_paths_of_subtype(var/decl_prototype)
	. = fetched_decl_paths_by_subtype[decl_prototype]
	if(!.)
		. = list()
		for(var/decl_path in get_decls_of_subtype(decl_prototype))
			. += decl_path
		fetched_decl_paths_by_subtype[decl_prototype] = .

/repository/decls/proc/get_decls_unassociated(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		var/decl = get_decl(decl_type)
		if(decl)
			. += decl

/repository/decls/proc/get_decls_of_type_unassociated(var/decl_prototype)
	RETURN_TYPE(/list)
	. = fetched_decl_instances[decl_prototype]
	if(!.)
		. = get_decls_unassociated(typesof(decl_prototype))
		fetched_decl_instances[decl_prototype] = .

/repository/decls/proc/get_decls_of_subtype_unassociated(var/decl_prototype)
	RETURN_TYPE(/list)
	. = fetched_decl_subinstances[decl_prototype]
	if(!.)
		. = get_decls_unassociated(subtypesof(decl_prototype))
		fetched_decl_subinstances[decl_prototype] = .

/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	RETURN_TYPE(/list)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	RETURN_TYPE(/list)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/decl
	abstract_type = /decl
	var/uid
	var/decl_flags = null // DECL_FLAG_ALLOW_ABSTRACT_INIT, DECL_FLAG_MANDATORY_UID
	var/initialized = FALSE

/decl/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(initialized)
		CRASH("[type] initialized more than once!")
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/decl/proc/validate()
	SHOULD_CALL_PARENT(TRUE)
	var/list/failures = list()
	if((decl_flags & DECL_FLAG_MANDATORY_UID) && !istext(uid))
		failures += "non-text UID '[uid || "(NULL)"]' on mandatory type"
	else if(uid && !istext(uid))
		failures += "non-null, non-text UID '[uid]'"
	return failures

/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	PRINT_STACK_TRACE("Prevented attempt to delete a /decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE

/decl/CanClone()
	return FALSE //Don't allow cloning since we're singletons
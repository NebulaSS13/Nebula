/mob/proc/get_ability_handler(handler_type, create_if_missing)
	var/datum/extension/abilities/abilities
	if(create_if_missing)
		abilities = get_or_create_extension(src, /datum/extension/abilities)
	else if(has_extension(src, /datum/extension/abilities))
		abilities = get_extension(src, /datum/extension/abilities)
	if(!abilities)
		return null
	var/datum/ability_handler/handler = locate(handler_type) in abilities.ability_handlers
	if(!handler && create_if_missing)
		handler = add_ability_handler(handler_type)
	return handler

/mob/proc/add_ability_handler(handler_type)
	var/datum/extension/abilities/abilities = get_or_create_extension(src, /datum/extension/abilities)
	var/datum/ability_handler/handler = locate(handler_type) in abilities.ability_handlers
	if(handler)
		return FALSE
	handler = new handler_type(abilities, src)
	LAZYADD(abilities.ability_handlers, handler)
	return handler

/mob/proc/remove_ability_handler(handler_type)
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(!abilities)
		return FALSE
	var/datum/ability_handler/handler = locate(handler_type) in abilities.ability_handlers
	if(!handler)
		return FALSE
	LAZYREMOVE(abilities.ability_handlers, handler)
	if(!LAZYLEN(abilities.ability_handlers))
		remove_extension(src, /datum/extension/abilities)
	return TRUE

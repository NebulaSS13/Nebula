/mob/proc/get_ability_handler(handler_type, create_if_missing)

	var/datum/extension/abilities/abilities
	if(create_if_missing)
		abilities = get_or_create_extension(src, /datum/extension/abilities)
	else
		abilities = get_extension(src, /datum/extension/abilities)
		if(!abilities)
			return null

	var/datum/ability_handler/handler = locate(handler_type) in abilities.ability_handlers
	if(!handler && create_if_missing)
		handler = new handler_type(abilities, src)
		LAZYADD(abilities.ability_handlers, handler)

	return handler

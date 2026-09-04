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
	handler.finalize_ability_handler()
	return handler

/mob/proc/remove_ability_handler(handler_type)
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(!abilities)
		return FALSE
	var/datum/ability_handler/handler = locate(handler_type) in abilities.ability_handlers
	if(!handler)
		return FALSE
	LAZYREMOVE(abilities.ability_handlers, handler)
	qdel(handler)
	if(!LAZYLEN(abilities.ability_handlers))
		remove_extension(src, /datum/extension/abilities)
	return TRUE

/mob/living/proc/copy_abilities_from(mob/living/donor)
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(!abilities)
		return FALSE
	. = FALSE
	for(var/datum/ability_handler/handler in abilities.ability_handlers)
		if(handler.copy_abilities_to(src))
			. = TRUE

/mob/living/proc/disable_abilities(var/amount = 0)
	if(amount < 0)
		return
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	for(var/datum/ability_handler/handler in abilities?.ability_handlers)
		handler.disable_abilities(amount)

/mob/living/proc/copy_abilities_to(mob/living/target)
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	for(var/datum/ability_handler/handler in abilities?.ability_handlers)
		handler.copy_abilities_to(target)

/mob/proc/add_ability(ability_type, list/metadata)
	var/decl/ability/ability = GET_DECL(ability_type)
	if(!istype(ability) || !ability.associated_handler_type)
		return FALSE
	var/datum/ability_handler/handler = get_ability_handler(ability.associated_handler_type, create_if_missing = TRUE)
	return handler.add_ability(ability_type, metadata)

/mob/proc/remove_ability(ability_type)
	var/decl/ability/ability = GET_DECL(ability_type)
	if(!istype(ability) || !ability.associated_handler_type)
		return FALSE
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	var/datum/ability_handler/handler = locate(ability.associated_handler_type) in abilities?.ability_handlers
	return handler?.remove_ability(ability_type)

/mob/proc/get_ability_metadata(ability_type)
	var/decl/ability/ability = GET_DECL(ability_type)
	if(!istype(ability) || !ability.associated_handler_type)
		return null
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	var/datum/ability_handler/handler = locate(ability.associated_handler_type) in abilities?.ability_handlers
	return handler?.get_metadata(ability_type, create_if_missing = TRUE)

/mob/proc/has_ability(ability_type)
	var/decl/ability/ability = GET_DECL(ability_type)
	if(!istype(ability) || !ability.associated_handler_type)
		return null
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	var/datum/ability_handler/handler = locate(ability.associated_handler_type) in abilities?.ability_handlers
	return handler?.provides_ability(ability_type)

/mob/Stat()
	if((. = ..()) && client)
		var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
		for(var/datum/ability_handler/handler in abilities?.ability_handlers)
			handler.show_stat_string(src)

/mob/proc/get_all_abilities()
	var/datum/extension/abilities/abilities_extension = get_extension(src, /datum/extension/abilities)
	if(!istype(abilities_extension))
		return
	for(var/datum/ability_handler/handler as anything in abilities_extension.ability_handlers)
		for(var/ability_type in handler.known_abilities)
			var/decl/ability/ability = GET_DECL(ability_type)
			if(istype(ability))
				LAZYDISTINCTADD(., ability)

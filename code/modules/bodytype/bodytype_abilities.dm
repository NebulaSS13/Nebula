/decl/bodytype
	var/list/ability_handlers

/decl/bodytype/proc/grant_abilities(mob/living/subject)
	if(!istype(subject) || !length(ability_handlers))
		return
	for(var/handler in ability_handlers)
		subject.add_ability_handler(handler)

/decl/bodytype/proc/remove_abilities(mob/living/subject)
	if(!istype(subject) || !length(ability_handlers))
		return
	if(!has_extension(subject, /datum/extension/abilities))
		return
	for(var/handler in ability_handlers)
		subject.remove_ability_handler(handler)

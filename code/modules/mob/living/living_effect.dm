/mob/living
	VAR_PROTECTED/list/datum/effect/effect/system/attached_effect_systems
	var/const/MOB_EFFECT_DEFAULT    = 1
	var/const/MOB_EFFECT_SMOKECREEN = 2

/mob/living/proc/get_attached_effect(effect_index = MOB_EFFECT_DEFAULT)
	RETURN_TYPE(/datum/effect/effect/system)
	if(!attached_effect_systems)
		return null
	. = LAZYACCESS(attached_effect_systems, effect_index)
	if(!. && effect_index != MOB_EFFECT_DEFAULT)
		. = LAZYACCESS(attached_effect_systems, MOB_EFFECT_DEFAULT)
	if(. && !istype(., /datum/effect/effect/system))
		return null

/mob/living/Initialize()
	. = ..()
	if(attached_effect_systems)
		if(ispath(attached_effect_systems, /datum/effect/effect/system))
			attached_effect_systems = alist((MOB_EFFECT_DEFAULT) = new attached_effect_systems)
		else if(istype(attached_effect_systems, /alist))
			for(var/ability_index in attached_effect_systems)
				var/ability_type = attached_effect_systems[ability_index]
				if(ispath(ability_type, /datum/effect/effect/system))
					attached_effect_systems[ability_index] = new ability_type
				else
					attached_effect_systems -= ability_index
		if(!istype(attached_effect_systems, /alist))
			attached_effect_systems = null

/mob/living/Destroy()
	if(attached_effect_systems)
		for(var/effect in attached_effect_systems)
			qdel(attached_effect_systems[effect])
		attached_effect_systems = null
	. = ..()

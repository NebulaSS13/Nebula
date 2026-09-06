/mob/proc/can_use_codex()
	return FALSE

/mob/new_player/can_use_codex()
	return TRUE

/mob/living/silicon/can_use_codex()
	return TRUE

/mob/observer/can_use_codex()
	return TRUE

/mob/living/human/can_use_codex()
	if(get_config_value(/decl/config/toggle/codex_requires_implant))
		for(var/obj/item/implant/codex/codex_implant in contents)
			if(codex_implant.implanted && !codex_implant.malfunction)
				return TRUE
	return TRUE

/mob/living/human/get_codex_value()
	return "[lowertext(species.name)] (species)"
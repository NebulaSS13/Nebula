/decl/ability/cult/construct/harvest
	name               = "Harvest"
	desc               = "Back to where I come from, and you're coming with me."
	cooldown_time      = 200
	overlay_icon       = 'icons/effects/effects.dmi'
	overlay_icon_state = "rune_teleport"
	overlay_lifespan   = 0
	ability_icon_state = "const_harvest"

/*
/decl/ability/cult/construct/harvest/cast(list/targets, mob/user)
	..()
	var/destination = null
	for(var/obj/effect/narsie/N in global.narsie_list)
		destination = N.loc
		break
	if(!destination)
		to_chat(user, SPAN_DANGER("...something's wrong!"))
		return
	var/prey = FALSE
	for(var/mob/living/M in targets)
		if(!M.get_null_rod())
			M.forceMove(destination)
			if(M != user)
				prey = TRUE
	to_chat(user, SPAN_SINISTER("You warp back to Nar-Sie[prey ? " along with your prey" : ""]."))
*/

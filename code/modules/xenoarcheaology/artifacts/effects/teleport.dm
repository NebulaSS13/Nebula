/datum/artifact_effect/teleport
	name = "teleport"
	origin_type = EFFECT_PSIONIC

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	teleport_away(user)

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effect_range,T))
			teleport_away(M)

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effect_range, T))
			teleport_away(M)

/datum/artifact_effect/teleport/proc/teleport_away(mob/living/M)
	var/weakness = GetAnomalySusceptibility(M)
	if(prob(100 * weakness))
		to_chat(M, "<span class='warning'>You are displaced by a strange force!</span>")
		if(M.buckled)
			M.buckled.unbuckle_mob()
		if(M.anchored)
			return
		spark_at(get_turf(M))
		var/turf/teleport_loc = get_turf(holder)
		M.forceMove(pick(RANGE_TURFS(teleport_loc, effect_range * 2)))
		spark_at(get_turf(M))
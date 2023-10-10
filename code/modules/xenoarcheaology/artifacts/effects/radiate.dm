/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_strength

/datum/artifact_effect/radiate/New()
	..()
	radiation_strength = rand(10, 50)
	origin_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(istype(user))
		user.apply_radiation(radiation_strength * 2)
		return 1

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		SSradiation.radiate(holder, radiation_strength)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		SSradiation.radiate(holder, radiation_strength * rand(5, 10)) //Need to get feedback on this
		return 1

/datum/ailment/fault/elec_discharge
	name = "electrical discharge"
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ gives you a static shock when you touch it!"

/datum/ailment/fault/elec_discharge/on_ailment_event()
	organ.owner.custom_pain("Shock jolts through your [organ.name], staggering you!", 50, affecting = organ.owner)
	spark_at(get_turf(organ.owner))
	SET_STATUS_MAX(organ.owner, STAT_STUN, 2)

/datum/ailment/fault/elec_discharge/on_malfunction()
	organ.owner.custom_pain("Pain jolts through your broken [organ], staggering you!", 50, affecting = organ.owner)
	organ.owner.Stun(2)
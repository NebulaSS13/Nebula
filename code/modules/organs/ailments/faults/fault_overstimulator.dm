/datum/ailment/fault/overstimulator/on_malfunction()
	organ.owner.emote("collapse")
	organ.owner.Stun(rand(2, 4))
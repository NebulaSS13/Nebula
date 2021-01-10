/datum/ailment/fault/overstimulation
	name = "motor control overstimulation"

/datum/ailment/fault/overstimulation/on_ailment_event()
	organ.owner.emote("collapse")
	organ.owner.Stun(rand(2, 4))
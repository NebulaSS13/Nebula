/obj/item/organ/internal/augment/boost/reflex
	name = "synapse interceptor"
	desc = "A miniature computer with a primitive AI, this piece of engineering uses predictive algorithms and machine learning to provide near-instant response to any close combat situation."
	buffs = list(SKILL_COMBAT = 1)
	injury_debuffs = list(SKILL_COMBAT = -1)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)

/obj/item/organ/internal/augment/boost/reflex/buff()
	if((. = ..()))
		to_chat(owner, SPAN_NOTICE("Notice: Close combat heuristics recalibrated."))

/obj/item/organ/internal/augment/boost/reflex/debuff()
	if((. = ..()))
		to_chat(owner, SPAN_WARNING("E%r00r: dAmage detect-ted to synapse connections."))
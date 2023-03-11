/obj/item/organ/internal/augment/boost/shooting
	name = "gunnery booster"
	desc = "The AIM-4 module improves gun accuracy by filtering unnecessary nerve signals."
	buffs = list(SKILL_WEAPONS = 1)
	injury_debuffs = list(SKILL_WEAPONS = -1)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":4,"magnets":3,"biotech":3}'

/obj/item/organ/internal/augment/boost/reflex/buff()
	if((. = ..()))
		to_chat(owner, SPAN_NOTICE("Notice: AIM-4 finished reboot."))

/obj/item/organ/internal/augment/boost/reflex/debuff()
	if((. = ..()))
		to_chat(owner, SPAN_WARNING("Catastrophic damage detected: AIM-4 shutting down."))
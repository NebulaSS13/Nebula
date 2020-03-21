/obj/item/organ/internal/augment/boost/shooting
	name = "gunnery booster"
	desc = "The AIM-4 module improves gun accuracy by filtering unnecessary nerve signals."
	buffs = list(SKILL_WEAPONS = 1)
	injury_debuffs = list(SKILL_WEAPONS = -1)
	matter = list(MAT_STEEL = 750, MAT_GLASS = 750, MAT_SILVER = 100)

/obj/item/organ/internal/augment/boost/reflex/buff()
	if((. = ..()))
		to_chat(owner, SPAN_NOTICE("Notice: AIM-4 finished reboot."))

/obj/item/organ/internal/augment/boost/reflex/debuff()
	if((. = ..()))
		to_chat(owner, SPAN_WARNING("Catastrophic damage detected: AIM-4 shutting down."))
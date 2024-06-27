/datum/phenomena/warp
	name = "Warp Body"
	desc = "Corrupt a mortal being, causing their DNA to break and their body to fail on them."
	cost = 90
	cooldown = 300
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/warp/activate(var/mob/living/L)
	..()
	L.take_damage(20, CLONE)
	SET_STATUS_MAX(L, STAT_WEAK, 2)
	to_chat(L, SPAN_DANGER("You feel your body warp and change underneath you!"))

/datum/phenomena/rock_form
	name = "Rock Form"
	desc = "Convert your mortal followers into immortal stone beings."
	cost = 300
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_FOLLOWER
	expected_type = /mob/living/human

/datum/phenomena/rock_form/activate(var/mob/living/human/H)
	..()
	to_chat(H, SPAN_DANGER("You feel your body harden as it rapidly is transformed into living crystal!"))
	H.change_species(SPECIES_GOLEM)
	SET_STATUS_MAX(H, STAT_WEAK, 5)
/spell/targeted/shatter
	name = "Shatter Mind"
	desc = "Assaults the mind of the target with fear of the unknown, shattering their sanity and causing brain damage."
	feedback = "SM"
	school = "illusion"
	charge_max = 300
	spell_flags = 0
	invocation_type = SpI_NONE
	range = 5
	max_targets = 1
	compatible_mobs = list(/mob/living/human)

	time_between_channels = 150
	number_of_channels = 0

	hud_state = "wiz_statue"

/spell/targeted/shatter/cast(var/list/targets, var/mob/user)
	var/mob/living/human/H = targets[1]
	if(prob(50))
		sound_to(user, get_sfx("swing_hit"))
	if(prob(5))
		to_chat(H, "<span class='warning'>You feel unhinged.</span>")
	H.adjust_hallucination(5,5)
	ADJ_STATUS(H, STAT_CONFUSE, 2)
	ADJ_STATUS(H, STAT_DIZZY, 2)
	if(H.hallucination_power > 50)
		H.take_damage(5, BRAIN)
		to_chat(H, "<span class='danger'>You feel your mind tearing apart!</span>")
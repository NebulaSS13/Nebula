/decl/ability/wizard/conjure/faithful_hound
	name = "Faithful Hound"
	desc = "Summon a spectral watchdog with a special password. Anyone without the password is in for a barking and a biting."
	feedback = "FH"

	charge_max = 600
	invocation = "Du korilath tangus"
	invocation_type = SpI_WHISPER
	range = 0

	summon_amt = 1
	summon_type = list(/mob/living/simple_animal/faithful_hound)
	ability_icon_state = "wiz_hound"

	var/temp_password

/decl/ability/wizard/conjure/faithful_hound/apply_vars(atom/summoned_object, mob/caster)
	. = ..()
	var/mob/living/simple_animal/faithful_hound/hound = summoned_object
	if(istype(hound) && istype(hound.ai))
		hound.ai.add_friend(caster)
		hound.ai.memorise(caster, temp_password)
		temp_password = null

/decl/ability/wizard/conjure/faithful_hound/before_cast()
	..()
	temp_password = sanitize(input("What password will this beast listen to?") as text, MAX_NAME_LEN)

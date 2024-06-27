/spell/targeted/torment
	name = "Torment"
	desc = "Darkness stabs at the bodies of those around you. All within a medium range will suffer significant pain."
	feedback = "TM"
	school = "illusion"
	charge_max = 150
	spell_flags = NOFACTION
	invocation = "Rai Di-Kaal!"
	invocation_type = SpI_SHOUT
	range = 5
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)
	cooldown_min = 50
	message = "<span class='danger'>So much pain! All you can hear is screaming!</span>"

	max_targets = 0
	compatible_mobs = list(/mob/living/human)

	var/loss = 30

	hud_state = "wiz_horse"
	cast_sound = 'sound/magic/cowhead_curse.ogg'

/spell/targeted/torment/cast(var/list/targets, var/mob/user)
	user.spawn_gibber()
	for(var/mob/living/human/H in targets)
		H.take_damage(loss, PAIN)

/spell/targeted/torment/empower_spell()
	if(!..())
		return 0

	loss += 30

	return "[src] will now cause more pain."
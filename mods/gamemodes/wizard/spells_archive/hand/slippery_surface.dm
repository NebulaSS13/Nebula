/spell/hand/slippery_surface
	name = "Slippery Surface"
	desc = "More of a practical joke than an actual spell."
	school = "transmutation"
	feedback = "su"
	range = 5
	requires_wizard_garb = FALSE
	invocation_type = SpI_NONE
	show_message = " snaps their fingers."
	spell_delay = 50
	ability_icon_state = "gen_ice"
	cast_sound = 'sound/magic/summonitems_generic.ogg'

/spell/hand/slippery_surface/cast_hand(var/atom/a, var/mob/user)
	for(var/turf/T in view(1,a))
		if(T.simulated)
			T.wet_floor(50)
			new /obj/effect/temporary(T, 3, 'icons/effects/effects.dmi', "sonar_ping")
	return ..()

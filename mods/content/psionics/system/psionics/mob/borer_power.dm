/mob/living/simple_animal/borer
	var/image/aura_image

/mob/living/simple_animal/borer/Initialize(var/mapload, var/gen=1)

	if(!SSmodpacks.loaded_modpacks["Cortical Borers"]) // Borer module not included.
		log_debug("Attempted spawn of stubbed mobtype [type].")
		return INITIALIZE_HINT_QDEL

	. = ..()
	aura_image = create_aura_image(src)
	aura_image.color = "#aaffaa"
	aura_image.blend_mode = BLEND_SUBTRACT
	aura_image.alpha = 125
	var/matrix/M = matrix()
	M.Scale(0.33)
	aura_image.transform = M

/mob/living/simple_animal/borer/death(gibbed, deathmessage, show_dead_message)
	if(aura_image)
		destroy_aura_image(aura_image)
		aura_image = null
	. = ..()

/mob/living/simple_animal/borer/Destroy()
	if(aura_image)
		destroy_aura_image(aura_image)
		aura_image = null
	. = ..()

/mob/living/simple_animal/borer/RangedAttack(atom/A, var/params)
	. = ..()
	if(!. && a_intent == I_DISARM && isliving(A) && !neutered && can_do_special_ranged_attack(FALSE))
		var/mob/living/M = A
		if(locate(/mob/living/simple_animal/borer) in M.contents)
			to_chat(src, SPAN_WARNING("You cannot dominate a host who already has a passenger!"))
		else
			visible_message(SPAN_DANGER("\The [src] extends a writhing pseudopod towards \the [M]..."))

			if(M.deflect_psionic_attack())
				return TRUE

			sound_to(src, sound('sound/effects/psi/power_evoke.ogg'))
			sound_to(M, sound('sound/effects/psi/power_evoke.ogg'))

			if(do_psionics_check(5, src))
				to_chat(src, SPAN_DANGER("You try to focus on [M], but you cannot expel any psionic power!"))
				return TRUE

			if(M.do_psionics_check(5, src))
				to_chat(src, SPAN_DANGER("You focus on [M], but your psionic assault skates across them like glass."))
				return TRUE

			to_chat(src, SPAN_DANGER("You focus on [M] and freeze their limbs with a wave of terrible psionic dread."))
			to_chat(M, SPAN_DANGER("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
			M.Weaken(10)
			set_ability_cooldown(15 SECONDS)

		return TRUE

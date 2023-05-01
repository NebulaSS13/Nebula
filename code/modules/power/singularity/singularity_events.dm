/decl/singularity_event
	abstract_type = /decl/singularity_event

/decl/singularity_event/proc/handle_event(obj/effect/singularity/source)
	return

/decl/singularity_event/nothing // Nothing happens.

/decl/singularity_event/empulse/handle_event(obj/effect/singularity/source)
	if(source.current_stage.stage_size != STAGE_SUPER)
		empulse(source, 8, 10)
	else
		empulse(source, 12, 16)

/decl/singularity_event/toxins
	var/toxrange = 10

/decl/singularity_event/toxins/handle_event(obj/effect/singularity/source)
	var/toxdamage = 4
	var/radiation = 15
	if (source.energy > 200)
		toxdamage = round(((source.energy-150)/50)*4,1)
		radiation = round(((source.energy-150)/50)*5,1)
	SSradiation.radiate(source, radiation) //Always radiate at max, so a decent dose of radiation is applied
	for(var/mob/living/M in view(toxrange, source.loc))
		M.apply_damage(toxdamage, TOX, null, damage_flags = DAM_DISPERSED)

/decl/singularity_event/mesmerize/handle_event(obj/effect/singularity/source)
	for(var/mob/living/carbon/M in oviewers(8, source))
		if(istype(M, /mob/living/carbon/brain)) //Ignore brains
			continue
		if(M.status_flags & GODMODE)
			continue
		if(M.stat == CONSCIOUS)
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.get_equipped_item(slot_glasses_str), /obj/item/clothing/glasses/meson))
					if(source.current_stage.stage_size != STAGE_SUPER)
						to_chat(H, SPAN_WARNING("You look directly into \the [source]. Good thing you had your protective eyewear on!"))
						continue
					to_chat(H, SPAN_WARNING("Your eyewear does absolutely nothing to protect you from \the [source]"))
		to_chat(M, SPAN_DANGER("You look directly into \the [source] and feel [source.current_stage.stage_size == STAGE_SUPER ? "helpless" : "weak"]."))
		M.apply_effect(3, STUN)
		M.visible_message(SPAN_DANGER("\The [M] stares blankly at \the [source]!"))

/decl/singularity_event/supermatter_wave/handle_event(obj/effect/singularity/source)
	for(var/mob/living/M in view(10, source.loc))
		to_chat(M, SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat."))
		if(prob(67))
			to_chat(M, SPAN_NOTICE("Miraculously, it fails to kill you."))
		else
			to_chat(M, SPAN_DANGER("You don't even have a moment to react as you are reduced to ashes by the intense radiation."))
			M.dust()
	SSradiation.radiate(source, rand(source.energy))

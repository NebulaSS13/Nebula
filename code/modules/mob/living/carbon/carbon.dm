/mob/living/carbon/Initialize()
	//setup reagent holders
	if(!bloodstr)
		bloodstr = new/datum/reagents/metabolism(120, src, CHEM_INJECT)
	if(!reagents)
		reagents = bloodstr
	if(!touching)
		touching = new/datum/reagents/metabolism(mob_size * 100, src, CHEM_TOUCH)

	if (!default_language && species_language)
		default_language = species_language
	. = ..()

/mob/living/carbon/Destroy()
	QDEL_NULL(touching)
	QDEL_NULL(bloodstr)
	reagents = null //We assume reagents is a reference to bloodstr here
	if(loc)
		for(var/mob/M in contents)
			M.dropInto(loc)
	else
		for(var/mob/M in contents)
			qdel(M)
	return ..()

/mob/living/carbon/rejuvenate()
	set_nutrition(400)
	set_hydration(400)
	..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return

	if(stat != DEAD)
		var/nut_removed = DEFAULT_HUNGER_FACTOR/10
		var/hyd_removed = DEFAULT_THIRST_FACTOR/10
		if (move_intent.flags & MOVE_INTENT_EXERTIVE)
			nut_removed *= 2
			hyd_removed *= 2
		adjust_nutrition(-nut_removed)
		adjust_hydration(-hyd_removed)

	// Moving around increases germ_level faster
	if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
		germ_level++

/mob/living/carbon/relaymove(var/mob/living/user, direction)
	if(!istype(user) || !(user in contents) || user.is_on_special_ability_cooldown())
		return
	user.set_special_ability_cooldown(5 SECONDS)
	visible_message(SPAN_DANGER("You hear something rumbling inside [src]'s stomach..."))
	var/obj/item/I = user.get_active_held_item()
	if(!I?.force)
		return
	var/d = rand(round(I.force / 4), I.force)
	visible_message(SPAN_DANGER("\The [user] attacks [src]'s stomach wall with \the [I]!"))
	playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)
	var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(src, BP_CHEST)
	if(istype(organ))
		organ.take_external_damage(d, 0)
	else
		take_organ_damage(d)
	if(prob(get_damage(BRUTE) - 50))
		gib()

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode

	shock_damage = apply_shock(shock_damage, def_zone, siemens_coeff)

	if(!shock_damage)
		return 0

	stun_effect_act(agony_amount=shock_damage, def_zone=def_zone)

	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	switch(shock_damage)
		if(11 to 15)
			SET_STATUS_MAX(src, STAT_STUN, 1)
		if(16 to 20)
			SET_STATUS_MAX(src, STAT_STUN, 2)
		if(21 to 25)
			SET_STATUS_MAX(src, STAT_WEAK, 2)
		if(26 to 30)
			SET_STATUS_MAX(src, STAT_WEAK, 5)
		if(31 to INFINITY)
			SET_STATUS_MAX(src, STAT_WEAK, 10) //This should work for now, more is really silly and makes you lay there forever

	set_status(STAT_JITTER, min(shock_damage*5, 200))

	spark_at(loc, amount=5, cardinal_only = TRUE)

	return shock_damage

/mob/living/carbon/proc/apply_shock(var/shock_damage, var/def_zone, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if(shock_damage < 0.5)
		return 0
	if(shock_damage < 1)
		shock_damage = 1
	apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	return(shock_damage)

/mob/proc/swap_hand()
	SHOULD_CALL_PARENT(TRUE)

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(!is_asystole())
		if (on_fire)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if (M.on_fire)
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames, but to no avail!</span>",
				"<span class='warning'>You try to pat out [src]'s flames, but to no avail! Put yourself out first!</span>")
			else
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames!</span>",
				"<span class='warning'>You try to pat out [src]'s flames! Hot!</span>")
				if(do_mob(M, src, 15))
					src.fire_stacks -= 0.5
					if (prob(10) && (M.fire_stacks <= 0))
						M.fire_stacks += 1
					M.IgniteMob()
					if (M.on_fire)
						M.visible_message("<span class='danger'>The fire spreads from [src] to [M]!</span>",
						"<span class='danger'>The fire spreads to you as well!</span>")
					else
						src.fire_stacks -= 0.5 //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
						if (src.fire_stacks <= 0)
							M.visible_message("<span class='warning'>[M] successfully pats out [src]'s flames.</span>",
							"<span class='warning'>You successfully pat out [src]'s flames.</span>")
							src.ExtinguishMob()
							src.fire_stacks = 0
		else
			var/t_him = "it"
			if (src.gender == MALE)
				t_him = "him"
			else if (src.gender == FEMALE)
				t_him = "her"

			var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
			if(uniform)
				uniform.add_fingerprint(M)

			var/show_ssd = get_species_name()
			if(show_ssd && ssd_check())
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
				"<span class='notice'>You shake [src], but they do not respond... Maybe they have S.S.D?</span>")
			else if(current_posture.prone ||HAS_STATUS(src, STAT_ASLEEP) || player_triggered_sleeping)
				player_triggered_sleeping = 0
				ADJ_STATUS(src, STAT_ASLEEP, -5)
				if(!HAS_STATUS(src, STAT_ASLEEP))
					set_posture(/decl/posture/standing)
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
									"<span class='notice'>You shake [src] trying to wake [t_him] up!</span>")
			else
				M.attempt_hug(src)

			if(stat != DEAD)
				ADJ_STATUS(src, STAT_PARA, -3)
				ADJ_STATUS(src, STAT_STUN, -3)
				ADJ_STATUS(src, STAT_WEAK, -3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(eyecheck() < intensity || override_blindness_check)
		return ..()

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/restrained()
	return get_equipped_item(slot_handcuffed_str)

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(alert("Are you sure you want to [player_triggered_sleeping ? "wake up?" : "sleep for a while? Use 'sleep' again to wake up"]", "Sleep", "No", "Yes") == "Yes")
		player_triggered_sleeping = !player_triggered_sleeping

/mob/living/carbon/Bump(var/atom/movable/AM, yes)
	if(now_pushing || !yes)
		return
	..()

/mob/living/carbon/slip(slipped_on, stun_duration = 8)
	if(has_gravity() && !buckled && !current_posture.prone)
		to_chat(src, SPAN_DANGER("You slipped on [slipped_on]!"))
		playsound(loc, 'sound/misc/slip.ogg', 50, 1, -3)
		SET_STATUS_MAX(src, STAT_WEAK, stun_duration)
		. = TRUE

/mob/living/carbon/get_satiated_nutrition()
	return 350

/mob/living/carbon/get_max_nutrition()
	return 400

/mob/living/carbon/get_max_hydration()
	return 400

/mob/living/carbon/fluid_act(var/datum/reagents/fluids)
	..()
	if(QDELETED(src) || !fluids?.total_volume || !touching || fluids.total_volume <= touching.total_volume)
		return
	// TODO: review saturation logic so we can end up with more than like 15 water in our contact reagents.
	var/saturation =  min(fluids.total_volume, round(mob_size * 1.5 * reagent_permeability()) - touching.total_volume)
	if(saturation > 0)
		fluids.trans_to_holder(touching, saturation)

/mob/living/carbon/get_species()
	RETURN_TYPE(/decl/species)
	return species

/mob/living/carbon/get_contact_reagents()
	return touching

/mob/living/carbon/get_injected_reagents()
	return bloodstr

/mob/living/carbon/get_admin_job_string()
	return "Carbon-based"

/mob/living/carbon/handle_flashed(var/obj/item/flash/flash, var/flash_strength)

	var/safety = eyecheck()
	if(safety >= FLASH_PROTECTION_MODERATE || flash_strength <= 0) // May be modified by human proc.
		return FALSE

	flash_eyes(FLASH_PROTECTION_MODERATE - safety)
	SET_STATUS_MAX(src, STAT_STUN, (flash_strength / 2))
	SET_STATUS_MAX(src, STAT_BLURRY, flash_strength)
	SET_STATUS_MAX(src, STAT_CONFUSE, (flash_strength + 2))
	if(flash_strength > 3)
		drop_held_items()
	if(flash_strength > 5)
		SET_STATUS_MAX(src, STAT_WEAK, 2)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_held_item()
	if(I && I.simulated)
		I.showoff(src)

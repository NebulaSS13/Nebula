/mob/living/carbon/Initialize()
	//setup reagent holders
	if(!bloodstr)
		bloodstr = new/datum/reagents/metabolism(120, src, CHEM_INJECT)
	if(!reagents)
		reagents = bloodstr
	if(!touching)
		touching = new/datum/reagents/metabolism(1000, src, CHEM_TOUCH)

	if (!default_language && species_language)
		default_language = species_language
	. = ..()

/mob/living/carbon/Destroy()
	QDEL_NULL(touching)
	QDEL_NULL(bloodstr)
	reagents = null //We assume reagents is a reference to bloodstr here
	delete_organs()
	QDEL_NULL_LIST(hallucinations)
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
	var/obj/item/I = user.get_active_hand()
	if(!I?.force)
		return
	var/d = rand(round(I.force / 4), I.force)
	visible_message(SPAN_DANGER("\The [user] attacks [src]'s stomach wall with \the [I]!"))
	playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)
	var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(src, BP_CHEST)
	if(istype(organ))
		organ.take_external_damage(d, 0)
		updatehealth()
	else
		take_organ_damage(d)
	if(prob(getBruteLoss() - 50))
		gib()

/mob/living/carbon/gib(anim="gibbed-m",do_gibs)
	for(var/mob/M in contents)
		M.dropInto(loc)
		visible_message(SPAN_DANGER("\The [M] bursts out of \the [src]!"))
	..()

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
			else if(lying ||HAS_STATUS(src, STAT_ASLEEP) || player_triggered_sleeping)
				player_triggered_sleeping = 0
				ADJ_STATUS(src, STAT_ASLEEP, -5)
				if(!HAS_STATUS(src, STAT_ASLEEP))
					resting = FALSE
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

//Throwing stuff
/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target, obj/item/item)
	src.throw_mode_off()
	if(src.stat || !target)
		return
	if(target.type == /obj/screen)
		return

	if(!item)
		item = get_active_hand()

	if(!istype(item) || !(item in get_held_items()))
		return

	var/throw_range = item.throw_range
	var/itemsize
	if (istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item

			//limit throw range by relative mob size
			throw_range = round(M.throw_range * min(src.mob_size/M.mob_size, 1))
			itemsize = round(M.mob_size/4)
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T && usr == src)
				var/start_T_descriptor = "<font color='#6b5d00'>[start_T] \[[start_T.x],[start_T.y],[start_T.z]\] ([start_T.loc])</font>"
				var/end_T_descriptor = "<font color='#6b4400'>[start_T] \[[end_T.x],[end_T.y],[end_T.z]\] ([end_T.loc])</font>"
				admin_attack_log(usr, M, "Threw the victim from [start_T_descriptor] to [end_T_descriptor].", "Was from [start_T_descriptor] to [end_T_descriptor].", "threw, from [start_T_descriptor] to [end_T_descriptor], ")

	else if (istype(item, /obj/item/))
		var/obj/item/I = item
		itemsize = I.w_class

	if(!try_unequip(item, play_dropsound = FALSE))
		return
	if(!item || !isturf(item.loc))
		return

	var/message = "\The [src] has thrown \the [item]!"
	var/skill_mod = 0.2
	if(!skill_check(SKILL_HAULING, min(round(itemsize - ITEM_SIZE_HUGE) + 2, SKILL_MAX)))
		if(prob(30))
			SET_STATUS_MAX(src, STAT_WEAK, 2)
			message = "\The [src] barely manages to throw \the [item], and is knocked off-balance!"
	else
		skill_mod += 0.2

	skill_mod += 0.8 * (get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)
	throw_range *= skill_mod

	//actually throw it!
	src.visible_message("<span class='warning'>[message]</span>", range = min(itemsize*2,world.view))

	if(!src.lastarea)
		src.lastarea = get_area(src.loc)
	if(!check_space_footing())
		if(prob((itemsize * itemsize * 10) * MOB_SIZE_MEDIUM/src.mob_size))
			var/direction = get_dir(target, src)
			step(src,direction)
			space_drift(direction)

	item.throw_at(target, throw_range, item.throw_speed * skill_mod, src)

	playsound(src, 'sound/effects/throw.ogg', 50, 1)
	animate_throw(src)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(get_equipped_item(slot_handcuffed_str))
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

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
	if(has_gravity() && !buckled && !lying)
		to_chat(src, SPAN_DANGER("You slipped on [slipped_on]!"))
		playsound(loc, 'sound/misc/slip.ogg', 50, 1, -3)
		SET_STATUS_MAX(src, STAT_WEAK, stun_duration)
		. = TRUE

/**
 *  Return FALSE if victim can't be devoured, DEVOUR_FAST if they can be devoured quickly, DEVOUR_SLOW for slow devour
 */
/mob/living/carbon/proc/can_devour(atom/movable/victim)
	return FALSE

/mob/living/carbon/can_feel_pain(var/check_organ)
	if(isSynthetic())
		return FALSE
	return !(species && species.species_flags & SPECIES_FLAG_NO_PAIN)

/mob/living/carbon/proc/need_breathe()
	return

/mob/living/carbon/check_has_mouth()
	// carbon mobs have mouths by default
	// behavior of this proc for humans is overridden in human.dm
	return 1

/mob/living/carbon/proc/check_mouth_coverage()
	// carbon mobs do not have blocked mouths by default
	// overridden in human_defense.dm
	return null

/mob/living/carbon/get_max_nutrition()
	return 400

/mob/living/carbon/get_max_hydration()
	return 400

/mob/living/carbon/proc/set_nutrition(var/amt)
	nutrition = clamp(amt, 0, get_max_nutrition())

/mob/living/carbon/get_nutrition(var/amt)
	return nutrition

/mob/living/carbon/adjust_nutrition(var/amt)
	set_nutrition(nutrition + amt)

/mob/living/carbon/get_hydration(var/amt)
	return hydration

/mob/living/carbon/proc/set_hydration(var/amt)
	hydration = clamp(amt, 0, get_max_hydration())

/mob/living/carbon/adjust_hydration(var/amt)
	set_hydration(hydration + amt)

/mob/living/carbon/has_dexterity(var/dex_level)
	. = ..() && (species.get_manual_dexterity() >= dex_level)

/mob/living/carbon/fluid_act(var/datum/reagents/fluids)
	var/saturation =  min(fluids.total_volume, round(mob_size * 1.5 * reagent_permeability()) - touching.total_volume)
	if(saturation > 0)
		fluids.trans_to_holder(touching, saturation)
	if(fluids.total_volume)
		..()

/mob/living/carbon/get_species()
	return species

/mob/living/carbon/get_species_name()
	return species.name

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

	var/obj/item/I = get_active_hand()
	if(I && I.simulated)
		I.showoff(src)

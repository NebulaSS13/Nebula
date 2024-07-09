/mob/living/Life()
	set invisibility = FALSE
	set background = BACKGROUND_ENABLED

	..()

	if (HasMovementHandler(/datum/movement_handler/mob/transformation))
		return

	// update the current life tick, can be used to e.g. only do something every 4 ticks
	// This is handled before the loc check as unit tests use this to delay until the mob
	// has processed a few times. Not really sure why but heigh ho.
	life_tick++

	if(!loc)
		return

	if(machine && (machine.CanUseTopic(src, machine.DefaultTopicState()) == STATUS_CLOSE)) // unsure if this is a good idea, but using canmousedrop was ???
		machine = null

	//Handle temperature/pressure differences between body and environment
	handle_environment(loc.return_air())
	handle_regular_status_updates() // Status & health update, are we dead or alive etc.
	handle_stasis()

	if(stat != DEAD)
		if(!is_in_stasis())
			. = handle_living_non_stasis_processes()
		aura_check(AURA_TYPE_LIFE)

	for(var/obj/item/grab/G in get_active_grabs())
		G.Process()

	//Check if we're on fire
	handle_fire()
	handle_actions()
	UpdateLyingBuckledAndVerbStatus()
	handle_regular_hud_updates()
	handle_status_effects()

	return 1

/mob/living/proc/handle_living_non_stasis_processes()
	SHOULD_CALL_PARENT(TRUE)
	// hungy
	handle_nutrition_and_hydration()
	// Breathing, if applicable
	handle_breathing()
	// Mutations and radiation
	handle_mutations_and_radiation()
	// Chemicals in the body
	handle_chemicals_in_body()
	// Random events (vomiting etc)
	handle_random_events()
	// eye, ear, brain damages
	handle_disabilities()
	handle_immunity()
	//Body temperature adjusts itself (self-regulation)
	stabilize_body_temperature()
	// Only handle AI stuff if we're not being played.
	if(!key)
		handle_legacy_ai()
	return TRUE

/mob/living/proc/experiences_hunger_and_thirst()
	return TRUE

/mob/living/proc/get_hunger_factor()
	var/decl/species/my_species = get_species()
	if(my_species)
		return my_species.hunger_factor
	return 0

/mob/living/proc/get_thirst_factor()
	var/decl/species/my_species = get_species()
	if(my_species)
		return my_species.hunger_factor
	return 0

// Used to handle non-datum AI.
/mob/living/proc/handle_legacy_ai()
	return

/mob/living/proc/handle_nutrition_and_hydration()
	SHOULD_CALL_PARENT(TRUE)
	if(!experiences_hunger_and_thirst())
		return
	if(get_nutrition() > 0)
		var/hunger_factor = get_hunger_factor()
		if(hunger_factor)
			adjust_nutrition(-(hunger_factor))
	if(get_hydration() > 0)
		var/thirst_factor = get_thirst_factor()
		if(thirst_factor)
			adjust_hydration(-(thirst_factor))

#define RADIATION_SPEED_COEFFICIENT 0.025
/mob/living/proc/handle_mutations_and_radiation()
	SHOULD_CALL_PARENT(TRUE)

	radiation = clamp(radiation,0,500)
	var/decl/bodytype/my_bodytype = get_bodytype()
	if(my_bodytype?.appearance_flags & RADIATION_GLOWS)
		if(radiation)
			set_light(max(1,min(10,radiation/10)), max(1,min(20,radiation/20)), get_flesh_color())
		else
			set_light(0)

	if(radiation <= 0)
		return

	var/damage = 0
	radiation -= 1 * RADIATION_SPEED_COEFFICIENT
	if(prob(25))
		damage = 2

	if (radiation > 50)
		damage = 2
		radiation -= 2 * RADIATION_SPEED_COEFFICIENT
		if(!isSynthetic())
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
				radiation -= 5 * RADIATION_SPEED_COEFFICIENT
				to_chat(src, "<span class='warning'>You feel weak.</span>")
				SET_STATUS_MAX(src, STAT_WEAK, 3)
				if(!lying)
					emote(/decl/emote/visible/collapse)
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
				lose_hair()

	if (radiation > 75)
		damage = 3
		radiation -= 3 * RADIATION_SPEED_COEFFICIENT
		if(!isSynthetic())
			if(prob(5))
				take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
			if(prob(1))
				to_chat(src, "<span class='warning'>You feel strange!</span>")
				adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
				emote(/decl/emote/audible/gasp)
	if(radiation > 150)
		damage = 8
		radiation -= 4 * RADIATION_SPEED_COEFFICIENT

	var/decl/species/my_species = get_species()
	damage = FLOOR(damage * (my_species ? my_species.get_radiation_mod(src) : 1))
	if(damage)
		immunity = max(0, immunity - damage * 15 * RADIATION_SPEED_COEFFICIENT)
		adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
		var/list/limbs = get_external_organs()
		if(!isSynthetic() && LAZYLEN(limbs))
			var/obj/item/organ/external/O = pick(limbs)
			if(istype(O))
				O.add_autopsy_data("Radiation Poisoning", damage)

#undef RADIATION_SPEED_COEFFICIENT

// Get valid, unique reagent holders for metabolizing. Avoids metabolizing the same holder twice in a tick.
/mob/living/proc/get_unique_metabolizing_reagent_holders()
	for(var/datum/reagents/metabolism/holder in list(get_contact_reagents(), get_ingested_reagents(), get_injected_reagents(), get_inhaled_reagents()))
		LAZYDISTINCTADD(., holder)

/mob/living/proc/handle_chemicals_in_body()
	SHOULD_CALL_PARENT(TRUE)
	chem_effects = null

	// TODO: handle isSynthetic() properly via Psi's metabolism modifiers for contact reagents like acid.
	if((status_flags & GODMODE) || isSynthetic())
		return FALSE

	// Metabolize any reagents currently in our body and keep a reference for chem dose checking.
	var/list/metabolizing_holders = get_unique_metabolizing_reagent_holders()
	if(length(metabolizing_holders))
		var/list/tick_dosage_tracker = list() // Used to check if we're overdosing on anything.
		for(var/datum/reagents/metabolism/holder as anything in metabolizing_holders)
			holder.metabolize(tick_dosage_tracker)
		// Check for overdosing.
		var/size_modifier = (MOB_SIZE_MEDIUM / mob_size)
		for(var/decl/material/R as anything in tick_dosage_tracker)
			if(tick_dosage_tracker[R] > (R.overdose * ((R.flags & IGNORE_MOB_SIZE) ? 1 : size_modifier)))
				R.affect_overdose(src)

	// Update chem dosage.
	// TODO: refactor chem dosage above isSynthetic() and GODMODE checks.
	if(length(chem_doses))
		for(var/T in chem_doses)

			var/still_processing_reagent = FALSE
			for(var/datum/reagents/holder as anything in metabolizing_holders)
				if(holder.has_reagent(T))
					still_processing_reagent = TRUE
					break
			if(still_processing_reagent)
				continue
			var/decl/material/R = GET_DECL(T)
			var/dose = LAZYACCESS(chem_doses, T) - R.metabolism*2
			LAZYSET(chem_doses, T, dose)
			if(LAZYACCESS(chem_doses, T) <= 0)
				LAZYREMOVE(chem_doses, T)
	if(apply_chemical_effects())
		update_health()

	return TRUE

/mob/living/proc/apply_chemical_effects()
	var/burn_regen = GET_CHEMICAL_EFFECT(src, CE_REGEN_BURN)
	var/brute_regen = GET_CHEMICAL_EFFECT(src, CE_REGEN_BRUTE)
	if(burn_regen || brute_regen)
		heal_organ_damage(brute_regen, burn_regen, FALSE) // apply_chemical_effects() calls update_health() if it returns true; don't do it unnecessarily.
		return TRUE
	return FALSE

/mob/living/proc/handle_random_events()
	return

/mob/living
	var/weakref/last_weather

/mob/living/proc/is_outside()
	var/turf/T = loc
	return istype(T) && T.is_outside()

/mob/living/proc/get_affecting_weather()
	var/turf/my_turf = get_turf(src)
	if(!istype(my_turf))
		return
	var/turf/actual_loc = loc
	// If we're standing in the rain, use the turf weather.
	. = istype(actual_loc) && actual_loc.weather
	if(!.) // If we're under or inside shelter, use the z-level rain (for ambience)
		. = SSweather.weather_by_z[my_turf.z]

/* Accidentally copied from dev - leaving commented for easier merge resolution when this commit goes back up to dev.
/mob/living/proc/handle_contact_reagent_dripping()
	// TODO: process dripping outside of Life() so corpses don't become sponges.
	// TODO: factor temperature and vapor into this so warmer locations dry you off.
	// TODO: apply a dripping overlay a la fire to show someone is saturated.
	if(!loc)
		return
	var/datum/reagents/touching_reagents = get_contact_reagents()
	if(!touching_reagents?.total_volume)
		return
	var/drip_amount = max(1, round(touching_reagents.total_volume * 0.1))
	if(drip_amount)
		touching_reagents.trans_to(loc, drip_amount)
*/

/mob/living/proc/handle_weather_effects(obj/abstract/weather_system/weather)
	// Handle physical effects of weather.
	if(!istype(weather))
		return
	var/decl/state/weather/weather_state = weather.weather_system.current_state
	if(istype(weather_state))
		weather_state.handle_exposure(src, get_weather_exposure(weather), weather)

/mob/living/proc/handle_weather_ambience(obj/abstract/weather_system/weather)
	// Refresh weather ambience.
	// Show messages and play ambience.
	if(!istype(weather) || !client || get_preference_value(/datum/client_preference/play_ambiance) != PREF_YES)
		return

	// Work out if we need to change or cancel the current ambience sound.
	var/send_sound
	var/mob_ref = weakref(src)
	var/decl/state/weather/weather_state = weather.weather_system.current_state
	if(istype(weather_state))
		var/ambient_sounds = !is_outside() ? weather_state.ambient_indoors_sounds : weather_state.ambient_sounds
		var/ambient_sound = length(ambient_sounds) && pick(ambient_sounds)
		if(global.current_mob_ambience[mob_ref] == ambient_sound)
			return
		send_sound = ambient_sound
		global.current_mob_ambience[mob_ref] = send_sound
	else if(mob_ref in global.current_mob_ambience)
		global.current_mob_ambience -= mob_ref
	else
		return

	// Push sound to client. Pipe dream TODO: crossfade between the new and old weather ambience.
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.weather_channel))
	if(send_sound)
		sound_to(src, sound(send_sound, repeat = TRUE, wait = 0, volume = 30, channel = sound_channels.weather_channel))

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	SHOULD_CALL_PARENT(TRUE)
	//handle_contact_reagent_dripping() // See comment on proc definition
	var/weather = get_affecting_weather()
	handle_weather_effects(weather)
	handle_weather_ambience(weather)

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()

	SHOULD_CALL_PARENT(TRUE)

	// Check if we are (or should be) dead at this point.
	update_health()

	if(!handle_some_updates())
		return FALSE

	// Godmode just skips most of this processing.
	if(status_flags & GODMODE)
		set_stat(CONSCIOUS)
		germ_level = 0
		return TRUE

	// TODO: move hallucinations into a status condition decl.
	if(hallucination_power)
		handle_hallucinations()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++
	// If you're dirty, your gloves will become dirty, too.
	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves && germ_level > gloves.germ_level && prob(10))
		gloves.germ_level++

	// If we're dead, don't continue further.
	if(stat == DEAD)
		return FALSE

	// Handle some general state updates.
	if(HAS_STATUS(src, STAT_PARA))
		set_stat(UNCONSCIOUS)
	else if (status_flags & FAKEDEATH)
		set_stat(UNCONSCIOUS)
	else
		set_stat(CONSCIOUS)
	return TRUE

/mob/living/proc/handle_disabilities()
	handle_impaired_vision()
	handle_impaired_hearing()

/mob/living/proc/handle_impaired_vision()
	SHOULD_CALL_PARENT(TRUE)
	if(stat == DEAD)
		SET_STATUS_MAX(src, STAT_BLIND, 0)
	if(stat != CONSCIOUS && (sdisabilities & BLINDED)) //blindness from disability or unconsciousness doesn't get better on its own
		SET_STATUS_MAX(src, STAT_BLIND, 2)
	else
		return TRUE
	return FALSE

/mob/living/proc/handle_impaired_hearing()
	if((sdisabilities & DEAFENED) || stat) //disabled-deaf, doesn't get better on its own
		SET_STATUS_MAX(src, STAT_TINNITUS, 2)

/mob/living/proc/should_do_hud_updates()
	return client

//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	SHOULD_CALL_PARENT(TRUE)
	if(!should_do_hud_updates())
		return FALSE
	handle_hud_icons()
	handle_vision()
	handle_low_light_vision()
	return TRUE

/mob/living/proc/handle_low_light_vision()

	// No client means nothing to update.
	if(!client || !lighting_master)
		return

	// No loc or species means we should just assume no adjustment.
	var/decl/bodytype/my_bodytype = get_bodytype()
	var/turf/my_turf = get_turf(src)
	if(!isturf(my_turf) || !my_bodytype)
		lighting_master.set_alpha(255)
		return

	// TODO: handling for being inside atoms.
	var/target_value = 255 * (1-my_bodytype.eye_base_low_light_vision)
	var/loc_lumcount = my_turf.get_lumcount()
	if(loc_lumcount < my_bodytype.eye_low_light_vision_threshold)
		target_value = round(target_value * (1-my_bodytype.eye_low_light_vision_effectiveness))

	if(lighting_master.alpha == target_value)
		return

	var/difference = round((target_value-lighting_master.alpha) * my_bodytype.eye_low_light_vision_adjustment_speed)
	if(abs(difference) > 1)
		target_value = lighting_master.alpha + difference
	lighting_master.set_alpha(target_value)

/mob/living/proc/handle_vision()
	update_sight()
	if(stat == DEAD)
		return
	if(is_blind())
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")
		set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
		set_fullscreen(GET_STATUS(src, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
		set_fullscreen(GET_STATUS(src, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)
	set_fullscreen(stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)
	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(viewflags)
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else if(z_eye)
		return
	else if(client && !client.adminobs)
		reset_view(null)

/mob/living/proc/update_sight()
	set_sight(0)
	set_see_in_dark(0)
	if(stat == DEAD || (eyeobj && !eyeobj.living_eye))
		update_dead_sight()
	else
		update_living_sight()

	var/list/vision = get_accumulated_vision_handlers()
	set_sight(sight | vision[1])
	set_see_invisible(max(vision[2], see_invisible))

/mob/living/proc/update_living_sight()
	var/set_sight_flags = sight & ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
	if(stat & UNCONSCIOUS)
		set_sight_flags |= BLIND
	else
		set_sight_flags &= ~BLIND

	set_sight(set_sight_flags)
	set_see_in_dark(initial(see_in_dark))
	set_see_invisible(initial(see_invisible))

/mob/living/proc/update_dead_sight()
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	handle_hud_glasses()

/mob/living/proc/handle_hud_icons_health()
	return

/mob/living/singularity_act()
	if(!simulated)
		return 0
	investigate_log("has been consumed by a singularity", "singulo")
	gib()
	return 20

/mob/living/singularity_pull(S, current_size)
	if(simulated)
		if(current_size >= STAGE_THREE)
			for(var/obj/item/hand in get_held_items())
				if(prob(current_size*5) && hand.w_class >= (11-current_size)/2 && try_unequip(hand))
					to_chat(src, SPAN_WARNING("\The [S] pulls \the [hand] from your grip!"))
					hand.singularity_pull(S, current_size)
			var/obj/item/shoes = get_equipped_item(slot_shoes_str)
			if(!lying && !(shoes?.item_flags & ITEM_FLAG_NOSLIP))
				var/decl/species/my_species = get_species()
				if(!my_species?.check_no_slip(src) && prob(current_size*5))
					to_chat(src, SPAN_DANGER("A strong gravitational force slams you to the ground!"))
					SET_STATUS_MAX(src, STAT_WEAK, current_size)
		apply_damage(current_size * 3, IRRADIATE, damage_flags = DAM_DISPERSED)
	return ..()

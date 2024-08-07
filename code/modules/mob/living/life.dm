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

	CLEAR_HUD_ALERTS(src) // These will be set again in the various update procs below.
	handle_hud_glasses() // Clear HUD overlay images. Done early so that organs, etc. can add them back.

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
	update_posture()
	handle_grasp()
	handle_stance()
	handle_regular_hud_updates()
	handle_status_effects()
	return 1

/mob/living/proc/handle_grasp()
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		if(!inv_slot?.requires_organ_tag)
			continue
		var/holding = inv_slot?.get_equipped_item()
		if(holding)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, inv_slot.requires_organ_tag)
			if((!E || !E.is_usable() || E.is_parent_dislocated()) && try_unequip(holding))
				grasp_damage_disarm(E)

/mob/living/proc/grasp_damage_disarm(var/obj/item/organ/external/affected)

	var/list/drop_held_item_slots
	if(istype(affected))
		for(var/grasp_tag in (list(affected.organ_tag) | affected.children))
			var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(grasp_tag)
			if(inv_slot?.get_equipped_item())
				LAZYDISTINCTADD(drop_held_item_slots, inv_slot)
	else if(istype(affected, /datum/inventory_slot))
		drop_held_item_slots = list(affected)

	if(!LAZYLEN(drop_held_item_slots))
		return

	for(var/datum/inventory_slot/inv_slot in drop_held_item_slots)
		if(!try_unequip(inv_slot.get_equipped_item()))
			continue
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, inv_slot.slot_id)
		if(!E)
			continue
		if(E.is_robotic())
			var/decl/pronouns/G = get_pronouns()
			visible_message("<B>\The [src]</B> drops what [G.he] [G.is] holding, [G.his] [E.name] malfunctioning!")
			spark_at(src, 5, holder=src)
			continue

		var/grasp_name = E.name
		if((E.body_part in list(SLOT_ARM_LEFT, SLOT_ARM_RIGHT)) && LAZYLEN(E.children))
			var/obj/item/organ/external/hand = pick(E.children)
			grasp_name = hand.name

		if(E.can_feel_pain())
			var/emote_scream = pick("screams in pain", "lets out a sharp cry", "cries out")
			var/emote_scream_alt = pick("scream in pain", "let out a sharp cry", "cry out")
			visible_message(
				"<B>\The [src]</B> [emote_scream] and drops what they were holding in their [grasp_name]!",
				null,
				"You hear someone [emote_scream_alt]!"
			)
			custom_pain("The sharp pain in your [E.name] forces you to drop what you were holding in your [grasp_name]!", 30)
		else
			visible_message("<B>\The [src]</B> drops what they were holding in their [grasp_name]!")

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
		return my_species.thirst_factor
	return 0

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
				if(!current_posture.prone)
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
				take_damage(5 * RADIATION_SPEED_COEFFICIENT, CLONE)
				emote(/decl/emote/audible/gasp)
	if(radiation > 150)
		damage = 8
		radiation -= 4 * RADIATION_SPEED_COEFFICIENT

	var/decl/species/my_species = get_species()
	damage = floor(damage * (my_species ? my_species.get_radiation_mod(src) : 1))
	if(damage)
		immunity = max(0, immunity - damage * 15 * RADIATION_SPEED_COEFFICIENT)
		take_damage(damage * RADIATION_SPEED_COEFFICIENT, TOX)
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
				R.affect_overdose(src, tick_dosage_tracker[R])

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

/mob/living/process_weather(obj/abstract/weather_system/weather, decl/state/weather/weather_state)
	// Handle physical effects of weather. Ambience is handled in handle_environment with a
	// client check as mobs with no clients don't need to handle ambient messages and sounds.
	weather_state?.handle_exposure(src, get_weather_exposure(weather), weather)

/mob/living/proc/handle_weather_ambience(obj/abstract/weather_system/weather)
	// Refresh weather ambience.
	// Show messages and play ambience.
	if(!istype(weather) || !client)
		return

	// Send strings if we're outside.
	if(is_outside() && !weather.show_weather(src))
		weather.show_wind(src)

	if(get_preference_value(/datum/client_preference/play_ambiance) == PREF_NO)
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
	handle_contact_reagent_dripping() // See comment on proc definition
	handle_weather_ambience(get_affecting_weather())

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

	// Should we be asleep?
	var/decl/species/my_species = get_species()
	if(player_triggered_sleeping || (ssd_check() && my_species?.get_ssd(src)))
		SET_STATUS_MAX(src, STAT_ASLEEP, 2)

	// Handle some general state updates.
	if(HAS_STATUS(src, STAT_PARA))
		set_stat(UNCONSCIOUS)
	else if (status_flags & FAKEDEATH)
		set_stat(UNCONSCIOUS)
	else
		set_stat(CONSCIOUS)

	update_furniture_comfort()
	return TRUE

/mob/living
	var/furniture_comfort_time

/mob/living/proc/update_furniture_comfort()

	if(!istype(buckled, /obj/structure))
		furniture_comfort_time = null
		return

	var/obj/structure/struct = buckled
	if(abs(struct.user_comfort) < 0.5)
		furniture_comfort_time = null
		return

	var/list/remove_stressors = list(
		/datum/stressor/comfortable_very,
		/datum/stressor/comfortable,
		/datum/stressor/uncomfortable_very,
		/datum/stressor/uncomfortable
	)
	var/keep_stressor
	switch(struct.user_comfort)
		if(1 to INFINITY)
			keep_stressor = /datum/stressor/comfortable_very
		if(0.5 to 1)
			keep_stressor = /datum/stressor/comfortable
		if(-1 to -0.5)
			keep_stressor = /datum/stressor/uncomfortable
		if(-(INFINITY) to -1)
			keep_stressor = /datum/stressor/uncomfortable_very

	if(keep_stressor)
		for(var/stressor in remove_stressors)
			if(stressor == keep_stressor)
				continue
			remove_stressor(stressor)
		add_stressor(keep_stressor, 5 SECONDS)

	var/effective_comfort = struct.user_comfort
	if(locate(/obj/item/bedsheet) in loc)
		effective_comfort += 0.3
	if(effective_comfort > 0 && HAS_STATUS(src, STAT_ASLEEP))
		if(isnull(furniture_comfort_time))
			furniture_comfort_time = world.time
		else if((world.time - furniture_comfort_time) > clamp((30 SECONDS) - ((15 SECONDS) * effective_comfort), 0, 30 SECONDS))
			remove_stressor(/datum/stressor/fatigued)
			add_stressor(/datum/stressor/well_rested, 30 MINUTES)

/mob/living/proc/handle_disabilities()
	handle_impaired_vision()
	handle_impaired_hearing()

/mob/living/proc/handle_impaired_vision()
	SHOULD_CALL_PARENT(TRUE)
	if(stat == DEAD)
		SET_STATUS_MAX(src, STAT_BLIND, 0)
	if(stat != CONSCIOUS && has_genetic_condition(GENE_COND_BLINDED)) //blindness from disability or unconsciousness doesn't get better on its own
		SET_STATUS_MAX(src, STAT_BLIND, 2)
	else
		return TRUE
	return FALSE

/mob/living/proc/handle_impaired_hearing()
	if(has_genetic_condition(GENE_COND_DEAFENED) || stat) //disabled-deaf, doesn't get better on its own
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
		set_fullscreen(has_genetic_condition(GENE_COND_NEARSIGHTED), "impaired", /obj/screen/fullscreen/impaired, 1)
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
			if(!current_posture.prone && !(shoes?.item_flags & ITEM_FLAG_NOSLIP))
				var/decl/species/my_species = get_species()
				if(!my_species?.check_no_slip(src) && prob(current_size*5))
					to_chat(src, SPAN_DANGER("A strong gravitational force slams you to the ground!"))
					SET_STATUS_MAX(src, STAT_WEAK, current_size)
		apply_damage(current_size * 3, IRRADIATE, damage_flags = DAM_DISPERSED)
	return ..()

#define LIMB_UNUSABLE 2
#define LIMB_DAMAGED  1
#define LIMB_IMPAIRED 0.5


/mob/living/proc/handle_stance()
	set waitfor = FALSE // Can sleep in emotes.
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && current_posture.prone && (life_tick % 4) != 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/bed))
		return

	// Can't fall if nothing pulls you down
	if(!has_gravity())
		return

	// If we don't have a bodytype, all the limb checking below is going to be nonsensical.
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype)
		return

	var/static/list/all_stance_limbs = list(ORGAN_CATEGORY_STANCE, ORGAN_CATEGORY_STANCE_ROOT)
	var/expected_limbs_for_bodytype = root_bodytype.get_expected_organ_count_for_categories(all_stance_limbs)
	if(expected_limbs_for_bodytype <= 0)
		return // we don't care about stance for whatever reason.

	// Is there something in our loc we can prop ourselves on?
	if(length(loc?.contents))
		for(var/obj/thing in loc.contents)
			if(thing.obj_flags & OBJ_FLAG_SUPPORT_MOB)
				return

	var/found_limbs = 0
	var/had_limb_pain = FALSE
	for(var/obj/item/organ/external/limb in get_organs_by_categories(all_stance_limbs))
		found_limbs++
		var/add_stance_damage = 0
		if(limb.is_malfunctioning())
			// malfunctioning only happens intermittently so treat it as a missing limb when it procs
			add_stance_damage = LIMB_UNUSABLE
			if(prob(10))
				visible_message("\The [src]'s [limb.name] [pick("twitches", "shudders")] and sparks!")
				spark_at(src, amount = 5, holder = src)
		else if(!limb.is_usable())
			add_stance_damage = LIMB_UNUSABLE
		else if (limb.is_broken())
			add_stance_damage = LIMB_DAMAGED
		else if (limb.is_dislocated())
			add_stance_damage = LIMB_IMPAIRED

		if(add_stance_damage > 0)
			// Keep track of if any of our limbs can feel pain and has failed,
			// so we don't scream if it's a prosthetic that has broken.
			had_limb_pain = had_limb_pain || limb.can_feel_pain()
			stance_damage += add_stance_damage

	// Add missing limbs as unusable.
	stance_damage += max(0, expected_limbs_for_bodytype - found_limbs) * LIMB_UNUSABLE

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// Two canes are needed for a lost leg. If you are missing both legs, canes aren't gonna help you.
	for(var/obj/item/cane/C in get_held_items())
		stance_damage -= LIMB_UNUSABLE // Counts for a single functional limb.

	// Calculate the expected and actual number of functioning legs we have.
	var/has_sufficient_working_legs = TRUE
	var/list/root_limb_tags  = root_bodytype.organ_tags_by_category[ORGAN_CATEGORY_STANCE_ROOT]
	var/minimum_working_legs = ceil(length(root_limb_tags) * 0.5)
	if(minimum_working_legs > 0)
		var/leg_count = 0
		has_sufficient_working_legs = FALSE
		for(var/organ_tag in root_limb_tags)
			var/obj/item/organ/external/stance_root = GET_EXTERNAL_ORGAN(src, organ_tag)
			if(!stance_root || !stance_root.is_usable())
				continue
			if(!length(stance_root.children))
				continue
			// In theory a leg may have multiple children in the future; this
			// will need to be revisited for fork-legged insect people or whatever.
			var/has_usable_child = FALSE
			for(var/child_tag in stance_root.children)
				var/obj/item/organ/external/stance_child = GET_EXTERNAL_ORGAN(src, child_tag)
				if(stance_child?.is_usable())
					has_usable_child = TRUE
					break
			if(has_usable_child)
				leg_count++
				if(leg_count >= minimum_working_legs)
					has_sufficient_working_legs = TRUE
					break

	// Having half or more of our expected number of working legs allows us to mitigate some stance damage.
	if(has_sufficient_working_legs)
		if(find_mob_supporting_object()) //it helps to lean on something if you've got another leg to stand on
			stance_damage -= LIMB_UNUSABLE
		else
			stance_damage -= LIMB_DAMAGED

	// standing is poor
	if(stance_damage >= expected_limbs_for_bodytype || (!MOVING_DELIBERATELY(src) && ((stance_damage >= (expected_limbs_for_bodytype*0.75) && prob(8)) || (stance_damage >= (expected_limbs_for_bodytype*0.5) && prob(2)))))
		if(!current_posture.prone)
			if(had_limb_pain)
				emote(/decl/emote/audible/scream)
			custom_emote(VISIBLE_MESSAGE, "collapses!")
		SET_STATUS_MAX(src, STAT_WEAK, 3) //can't emote while weakened, apparently.

/mob/living/proc/stance_damage_prone(var/obj/item/organ/external/affected)

	if(affected && (!BP_IS_PROSTHETIC(affected) || affected.is_robotic()))
		switch(affected.body_part)
			if(SLOT_FOOT_LEFT, SLOT_FOOT_RIGHT)
				if(!BP_IS_PROSTHETIC(affected))
					to_chat(src, SPAN_WARNING("You lose your footing as your [affected.name] spasms!"))
				else
					to_chat(src, SPAN_WARNING("You lose your footing as your [affected.name] [pick("twitches", "shudders")]!"))
			if(SLOT_LEG_LEFT, SLOT_LEG_RIGHT)
				if(!BP_IS_PROSTHETIC(affected))
					to_chat(src, SPAN_WARNING("Your [affected.name] buckles from the shock!"))
				else
					to_chat(src, SPAN_WARNING("You lose your balance as [affected.name] [pick("malfunctions", "freezes","shudders")]!"))
			else
				return
	SET_STATUS_MAX(src, STAT_WEAK, 4)

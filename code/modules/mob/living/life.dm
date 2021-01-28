/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	..()

	if (HasMovementHandler(/datum/movement_handler/mob/transformation/))
		return
	if (!loc)
		return

	if(machine && (machine.CanUseTopic(src, machine.DefaultTopicState()) == STATUS_CLOSE)) // unsure if this is a good idea, but using canmousedrop was ???
		machine = null

	//Handle temperature/pressure differences between body and environment
	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		handle_environment(environment)

	blinded = 0 // Placing this here just show how out of place it is.
	// human/handle_regular_status_updates() needs a cleanup, as blindness should be handled in handle_disabilities()
	handle_regular_status_updates() // Status & health update, are we dead or alive etc.

	if(stat != DEAD)
		aura_check(AURA_TYPE_LIFE)

	//Check if we're on fire
	handle_fire()

	for(var/obj/item/grab/G in get_active_grabs())
		G.Process()

	handle_actions()

	UpdateLyingBuckledAndVerbStatus()

	handle_regular_hud_updates()

	handle_status_effects()

	return 1

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	SHOULD_CALL_PARENT(TRUE)
	chem_effects = null

	// TODO: handle isSynthetic() properly via Psi's metabolism modifiers for contact reagents like acid.
	if((status_flags & GODMODE) || isSynthetic())
		return FALSE

	// Metabolize any reagents currently in our body and keep a reference for chem dose checking.
	var/datum/reagents/metabolism/touching_reagents = metabolize_touching_reagents()
	var/datum/reagents/metabolism/bloodstr_reagents = metabolize_injected_reagents()
	var/datum/reagents/metabolism/ingested_reagents = metabolize_ingested_reagents()

	// Update chem dosage.
	// TODO: refactor chem dosage above isSynthetic() and GODMODE checks.
	if(length(chem_doses))
		for(var/T in chem_doses)
			if(bloodstr_reagents?.has_reagent(T) || ingested_reagents?.has_reagent(T) || touching_reagents?.has_reagent(T))
				continue
			var/decl/material/R = T
			var/dose = LAZYACCESS(chem_doses, T) - initial(R.metabolism)*2
			LAZYSET(chem_doses, T, dose)
			if(LAZYACCESS(chem_doses, T) <= 0)
				LAZYREMOVE(chem_doses, T)
	return TRUE

/mob/living/proc/metabolize_touching_reagents()
	var/datum/reagents/metabolism/touching_reagents = get_contact_reagents()
	if(istype(touching_reagents))
		touching_reagents.metabolize()
		return touching_reagents
		
/mob/living/proc/metabolize_injected_reagents()
	var/datum/reagents/metabolism/injected_reagents = get_injected_reagents()
	if(istype(injected_reagents))
		injected_reagents.metabolize()
		return injected_reagents
		
/mob/living/proc/metabolize_ingested_reagents()
	var/datum/reagents/metabolism/ingested_reagents = get_ingested_reagents()
	if(istype(ingested_reagents))
		ingested_reagents.metabolize()
		return ingested_reagents

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()
	updatehealth()
	if(stat != DEAD)
		if(HAS_STATUS(src, STAT_PARA))
			set_stat(UNCONSCIOUS)
		else if (status_flags & FAKEDEATH)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
		return 1

/mob/living/proc/handle_disabilities()
	handle_impaired_vision()
	handle_impaired_hearing()

/mob/living/proc/handle_impaired_vision()
	if((sdisabilities & BLINDED) || stat) //blindness from disability or unconsciousness doesn't get better on its own
		SET_STATUS_MAX(src, STAT_BLIND, 2)

/mob/living/proc/handle_impaired_hearing()
	if((sdisabilities & DEAFENED) || stat) //disabled-deaf, doesn't get better on its own
		SET_STATUS_MAX(src, STAT_TINNITUS, 1)

//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	if(!client)	return 0

	handle_hud_icons()
	handle_vision()

	return 1

/mob/living/proc/calculate_visibility_radius()
	if(stat == UNCONSCIOUS)
		return 0
	if(stat == DEAD)
		return INFINITY
	. = is_blind() ? 1 : INFINITY

/mob/living/proc/calculate_visibility_quality()
	. = (stat == CONSCIOUS && !is_blind()) ? INFINITY : 0
	
/mob/living/proc/handle_vision()
	update_sight()

	if(stat == DEAD)
		return

	if(!GET_STATUS(src, STAT_BLIND))
		set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
		set_fullscreen(GET_STATUS(src, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
		set_fullscreen(GET_STATUS(src, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)

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
	set_visibility_radius(calculate_visibility_radius(), calculate_visibility_quality())
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

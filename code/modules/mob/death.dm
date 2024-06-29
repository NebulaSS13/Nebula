/mob/proc/handle_existence_failure(dusted)

	// Make sure they're actually dead.
	if(stat != DEAD)
		death(gibbed = TRUE)
		if(stat != DEAD)
			return FALSE

	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)

	var/animation_state = get_gibbed_state(dusted)
	var/animation_icon  = get_gibbed_icon() // Needs to be done before nulling icon below.

	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	dump_contents()
	QDEL_IN(src, 1.5 SECONDS)

	if(animation_state && animation_icon)
		var/atom/movable/overlay/animation
		animation = new(loc)
		animation.icon_state = "blank"
		animation.icon = animation_icon
		animation.master = src
		flick(animation_state, animation)
		QDEL_IN(animation, 1.5 SECONDS)

	return TRUE

/mob/proc/get_dusted_remains()
	var/decl/species/my_species = get_species()
	return my_species ? my_species.remains_type : /obj/effect/decal/cleanable/ash

/mob/proc/get_gibbed_state(dusted)
	var/decl/species/my_species = get_species()
	if(dusted)
		return my_species ? my_species.dusted_anim : "dust-m"
	return my_species ? my_species.gibbed_anim : "gibbed-m"

/mob/proc/get_gibbed_icon()
	return 'icons/mob/mob.dmi'

//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(do_gibs = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	set waitfor = FALSE
	var/lastloc = loc
	. = handle_existence_failure(dusted = FALSE)
	if(. && do_gibs)
		spawn_gibber(lastloc)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the brain, so it's a bit more powerful than gib() /N
/mob/proc/dust()
	SHOULD_CALL_PARENT(TRUE)
	set waitfor = FALSE
	var/lastloc = loc
	. = handle_existence_failure(dusted = TRUE)
	if(. && lastloc)
		var/remains = get_dusted_remains()
		if(remains)
			new remains(lastloc)

/mob/proc/get_death_message(gibbed)
	return SKIP_DEATH_MESSAGE

/mob/proc/get_self_death_message(gibbed)
	return "You have died."

/mob/proc/death(gibbed)

	SHOULD_CALL_PARENT(TRUE)

	if(stat == DEAD)
		return FALSE

	stop_automove()
	facing_dir = null

	if(!gibbed)
		var/death_message = get_death_message(gibbed)
		if(death_message != SKIP_DEATH_MESSAGE)
			visible_message("<b>\The [src]</b> [death_message]")

	for(var/obj/item/organ/O in get_organs())
		O.on_holder_death(gibbed)

	set_stat(DEAD)
	adjust_stamina(-100)
	reset_plane_and_layer()
	update_posture()
	if(!gibbed)
		clear_status_effects()

	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	drop_held_items()

	SSstatistics.report_death(src)

	//TODO:  Change death state to health_dead for all these icon files.  This is a stop gap.
	if(healths)
		healths.overlays.Cut() // This is specific to humans but the relevant code is here; shouldn't mess with other mobs.
		if("health7" in icon_states(healths.icon))
			healths.icon_state = "health7"
		else
			healths.icon_state = "health6"
			log_debug("[src] ([src.type]) died but does not have a valid health7 icon_state (using health6 instead). report this error to Ccomp5950 or your nearest Developer")

	timeofdeath = world.time
	if(mind)
		mind.StoreMemory("Time of death: [stationtime2text()]", /decl/memory_options/system)
	switch_from_living_to_dead_mob_list()

	update_icon()

	if(SSticker.mode)
		SSticker.mode.check_win()

	var/show_dead_message = get_self_death_message(gibbed)
	if(show_dead_message)
		to_chat(src,"<span class='deadsay'>[show_dead_message]</span>")

	return TRUE

//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m",do_gibs)

	set waitfor = FALSE

	death(gibbed = TRUE)
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	UpdateLyingBuckledAndVerbStatus()
	remove_from_dead_mob_list()
	dump_contents()

	var/atom/movable/overlay/animation = new(src)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'

	flick(anim, animation)
	if(do_gibs)
		gibs()

	QDEL_IN(animation, 15)
	QDEL_IN(src, 15)


//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the brain, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/effect/decal/cleanable/ash)
	death(gibbed = TRUE)
	var/atom/movable/overlay/animation = null
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	remove_from_dead_mob_list()
	QDEL_IN(animation, 15)
	QDEL_IN(src, 15)

/mob/proc/get_death_message(gibbed)
	return SKIP_DEATH_MESSAGE

/mob/proc/get_self_death_message(gibbed)
	return "You have died."

/mob/proc/death(gibbed)

	SHOULD_CALL_PARENT(TRUE)

	if(stat == DEAD)
		return FALSE

	walk(src, 0)
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
	UpdateLyingBuckledAndVerbStatus()
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

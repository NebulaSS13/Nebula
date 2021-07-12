//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim = "gibbed-m", do_gibs)
	set waitfor = FALSE
	death(1)
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(101)
	UpdateLyingBuckledAndVerbStatus()
	remove_from_dead_mob_list()

	var/atom/movable/overlay/animation = new(src)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'

	flick(anim, animation)
	if(do_gibs) gibs(loc, dna)

	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)

/mob/proc/check_delete(atom/movable/overlay/animation)
	if(animation)
		qdel(animation)
	if(src)
		qdel(src)

/mob/proc/dust(remains = /obj/effect/decal/cleanable/ash)
	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)

	var/icon/I = build_disappear_icon(src)
	var/atom/movable/overlay/animation = null
	animation = new(get_turf(src))
	animation.master = src
	flick(I, animation)

	death(1)
	icon = null
	set_invisibility(101)
	remove_from_dead_mob_list()
	
	addtimer(CALLBACK(src, .proc/post_dust_process, remains), 15)
	QDEL_IN(animation, 2 SECONDS)
	QDEL_IN(src, 2 SECONDS)

/mob/proc/post_dust_process(remains)
	if(remains)
		new remains(get_turf(src))

/mob/proc/death(gibbed, deathmessage = "seizes up and falls limp...", show_dead_message = "You have died.")

	if(stat == DEAD)
		return 0

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	set_stat(DEAD)
	adjust_stamina(-100)
	reset_plane_and_layer()
	UpdateLyingBuckledAndVerbStatus()
	clear_status_effects()

	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	drop_held_items()

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable?.hat)
		hattable.hat.dropInto(get_turf(src))
		hattable.hat = null

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
	to_chat(src,"<span class='deadsay'>[show_dead_message]</span>")
	return 1

/datum/universal_state/jump
	name = "FTL Jump"
	var/list/duplicated = list()
	var/list/bluegoasts = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels

/datum/universal_state/jump/New(var/list/zlevels)
	affected_levels = zlevels

/datum/universal_state/jump/OnEnter()
	var/datum/level_data/space_zlevel = SSmapping.increment_world_z_size(/datum/level_data/space) //get a place for stragglers
	for(var/mob/living/M in SSmobs.mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel.level_z)
				if(T)
					M.forceMove(T)
			else
				create_duplicate(M)
	for(var/mob/goast in global.ghost_mob_list)
		goast.mouse_opacity = MOUSE_OPACITY_UNCLICKABLE	//can't let you click that Dave
		goast.set_invisibility(SEE_INVISIBLE_LIVING)
		goast.alpha = 255
	old_accessible_z_levels = SSmapping.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		SSmapping.accessible_z_levels -= num2text(z) //not accessible during the jump

/datum/universal_state/jump/OnExit()
	for(var/mob/M in duplicated)
		if(!QDELETED(M))
			clear_duplicated(M)

	duplicated.Cut()
	SSmapping.accessible_z_levels = old_accessible_z_levels
	old_accessible_z_levels = null

/datum/universal_state/jump/OnPlayerLatejoin(var/mob/living/M)
	if(M.z in affected_levels)
		create_duplicate(M)

/datum/universal_state/jump/OnTouchMapEdge(var/atom/A)
	if((A.z in affected_levels) && (A in duplicated))
		if(ismob(A))
			to_chat(A, SPAN_WARNING("You drift away into the shifting expanse, never to be seen again."))
		qdel(A) //lost beyond spacetime
		return FALSE
	return TRUE

/datum/universal_state/jump/proc/create_duplicate(var/mob/living/M)
	duplicated += M
	if(M.client)
		to_chat(M,"<span class='notice'>You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly.</span>")
		M.overlay_fullscreen("wormhole", /obj/screen/fullscreen/wormhole_overlay)
	M.set_status(STAT_CONFUSE, 20)
	bluegoasts += new/obj/effect/bluegoast/(get_turf(M),M)

/datum/universal_state/jump/proc/clear_duplicated(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		M.clear_fullscreen("wormhole")
	M.set_status(STAT_CONFUSE, 0)
	for(var/mob/goast in global.ghost_mob_list)
		goast.mouse_opacity = initial(goast.mouse_opacity)
		goast.set_invisibility(initial(goast.invisibility))
		goast.alpha = initial(goast.alpha)
	for(var/G in bluegoasts)
		qdel(G)
	bluegoasts.Cut()

/obj/effect/bluegoast
	name = "echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/human/daddy
	anchored = TRUE
	var/reality = 0
	simulated = 0

/obj/effect/bluegoast/Initialize(mapload, ndaddy)
	. = ..(mapload)
	if(!ndaddy)
		return INITIALIZE_HINT_QDEL
	daddy = ndaddy
	set_dir(daddy.dir)
	appearance = daddy.appearance
	events_repository.register(/decl/observ/moved, daddy, src, TYPE_PROC_REF(/obj/effect/bluegoast, mirror))
	events_repository.register(/decl/observ/dir_set, daddy, src, TYPE_PROC_REF(/obj/effect/bluegoast, mirror_dir))
	events_repository.register(/decl/observ/destroyed, daddy, src, TYPE_PROC_REF(/datum, qdel_self))

/obj/effect/bluegoast/Destroy()
	events_repository.unregister(/decl/observ/destroyed, daddy, src)
	events_repository.unregister(/decl/observ/dir_set, daddy, src)
	events_repository.unregister(/decl/observ/moved, daddy, src)
	daddy = null
	. = ..()

/obj/effect/bluegoast/proc/mirror(var/atom/movable/am, var/old_loc, var/new_loc)
	var/ndir = get_dir(new_loc,old_loc)
	appearance = daddy.appearance
	var/nloc = get_step(src, ndir)
	if(nloc)
		forceMove(nloc)
	if(nloc == new_loc)
		reality++
		if(reality > 5)
			to_chat(daddy, SPAN_NOTICE("Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended..."))
			blueswitch()
		else if(reality > 3)
			to_chat(daddy, SPAN_DANGER("Something is definitely wrong. Why do you think YOU are the original?"))
		else
			to_chat(daddy, SPAN_WARNING("You feel a bit less real. Which one of you two was original again...?"))

/obj/effect/bluegoast/proc/mirror_dir(var/atom/movable/am, var/old_dir, var/new_dir)
	set_dir(global.reverse_dir[new_dir])

/obj/effect/bluegoast/examine()
	SHOULD_CALL_PARENT(FALSE)
	return daddy.examine(arglist(args))

/obj/effect/bluegoast/proc/blueswitch()
	var/mob/living/human/H
	if(ishuman(daddy))
		H = new(get_turf(src), daddy.species.name, daddy.get_mob_snapshot(force = TRUE), daddy.get_bodytype())
		for(var/obj/item/entry in daddy.get_equipped_items(TRUE))
			daddy.remove_from_mob(entry) //steals instead of copies so we don't end up with duplicates
			H.equip_to_appropriate_slot(entry)
	else
		H = new daddy.type(get_turf(src))
		H.appearance = daddy.appearance

	H.real_name = daddy.real_name
	H.flavor_text = daddy.flavor_text
	daddy.dust()
	qdel(src)

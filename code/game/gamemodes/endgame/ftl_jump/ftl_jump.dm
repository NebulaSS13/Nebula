/datum/universal_state/jump
	name = "FTL Jump"
	var/list/duplicated = list()
	var/list/bluegoasts = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels

/datum/universal_state/jump/New(var/list/zlevels)
	affected_levels = zlevels

/datum/universal_state/jump/OnEnter()
	var/space_zlevel = GLOB.using_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in SSmobs.mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel)
				if(T)
					M.forceMove(T)
			else
				create_duplicate(M)
	for(var/mob/goast in GLOB.ghost_mob_list)
		goast.mouse_opacity = 0	//can't let you click that Dave
		goast.set_invisibility(SEE_INVISIBLE_LIVING)
		goast.alpha = 255
	old_accessible_z_levels = GLOB.using_map.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		GLOB.using_map.accessible_z_levels -= "[z]" //not accessible during the jump

/datum/universal_state/jump/OnExit()
	for(var/mob/M in duplicated)
		if(!QDELETED(M))
			clear_duplicated(M)

	duplicated.Cut()
	GLOB.using_map.accessible_z_levels = old_accessible_z_levels
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
	M.confused = 20
	bluegoasts += new/obj/effect/bluegoast/(get_turf(M),M)

/datum/universal_state/jump/proc/clear_duplicated(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		M.clear_fullscreen("wormhole")
	M.confused = 0
	for(var/mob/goast in GLOB.ghost_mob_list)
		goast.mouse_opacity = initial(goast.mouse_opacity)
		goast.set_invisibility(initial(goast.invisibility))
		goast.alpha = initial(goast.alpha)
	for(var/G in bluegoasts)
		qdel(G)
	bluegoasts.Cut()

/obj/effect/bluegoast
	name = "echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/carbon/human/daddy
	anchored = 1
	var/reality = 0
	simulated = 0

/obj/effect/bluegoast/Initialize(mapload, ndaddy)
	. = ..(mapload)
	if(!ndaddy)
		return INITIALIZE_HINT_QDEL
	daddy = ndaddy
	set_dir(daddy.dir)
	appearance = daddy.appearance
	GLOB.moved_event.register(daddy, src, /obj/effect/bluegoast/proc/mirror)
	GLOB.dir_set_event.register(daddy, src, /obj/effect/bluegoast/proc/mirror_dir)
	GLOB.destroyed_event.register(daddy, src, /datum/proc/qdel_self)

/obj/effect/bluegoast/Destroy()
	GLOB.destroyed_event.unregister(daddy, src)
	GLOB.dir_set_event.unregister(daddy, src)
	GLOB.moved_event.unregister(daddy, src)
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
	set_dir(GLOB.reverse_dir[new_dir])

/obj/effect/bluegoast/examine()
	SHOULD_CALL_PARENT(FALSE)
	return daddy.examine(arglist(args))

/obj/effect/bluegoast/proc/blueswitch()
	var/mob/living/carbon/human/H = new(get_turf(src), daddy.species.name)
	H.real_name = daddy.real_name
	H.dna = daddy.dna.Clone()
	H.sync_organ_dna()
	H.flavor_text = daddy.flavor_text
	H.UpdateAppearance()
	var/datum/job/job = SSjobs.get_by_title(daddy.job)
	if(job)
		job.equip(H)
	daddy.dust()
	qdel(src)

/obj/screen/fullscreen/wormhole_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = ui_entire_screen
	color = "#ff9900"
	alpha = 100
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER
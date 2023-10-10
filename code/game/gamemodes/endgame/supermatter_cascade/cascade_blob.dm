// QUALITY COPYPASTA
/turf/unsimulated/wall/cascade
	name = "unravelling spacetime"
	desc = "THE END IS right now actually."

	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

	//luminosity = 5
	//l_color="#0066ff"
	plane = ABOVE_LIGHTING_PLANE
	layer = SUPERMATTER_WALL_LAYER

	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST,UP,DOWN)

/turf/unsimulated/wall/cascade/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSturf, src)

	// Nom.
	for(var/atom/movable/A in src)
		try_supermatter_consume(null, A, src)

/turf/unsimulated/wall/cascade/Destroy()
	STOP_PROCESSING(SSturf, src)
	. = ..()

/turf/unsimulated/wall/cascade/Process(wait, tick)
	// Only check infrequently.
	var/how_often = max(round(5 SECONDS/wait), 1)
	if(tick % how_often)
		return

	// No more available directions? Stop processing.
	if(!avail_dirs.len)
		return PROCESS_KILL

	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T = get_zstep(src,pdir)

	// EXPAND
	if(T && !istype(T,type))
		// Do pretty fadeout animation for 1s.
		new /obj/effect/overlay/bluespacify(T)
		spawn(1 SECOND)
			if(istype(T,type)) // In case another blob came first, don't create another blob
				return
			T.ChangeTurf(type)

/turf/unsimulated/wall/cascade/attack_robot(mob/user)
	. = attack_hand_with_interaction_checks(user)
	if(!.)
		user.examinate(src)

// /vg/: Don't let ghosts fuck with this.
/turf/unsimulated/wall/cascade/attack_ghost(mob/user)
	user.examinate(src)

/turf/unsimulated/wall/cascade/attack_ai(mob/living/silicon/ai/user)
	user.examinate(src)

/turf/unsimulated/wall/cascade/attack_hand(mob/user)
	if(try_supermatter_consume(null, user, src, TRUE))
		return TRUE
	return ..()

/turf/unsimulated/wall/cascade/attackby(obj/item/W, mob/user)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W)
	Bumped(W)
	return TRUE

/turf/unsimulated/wall/cascade/Entered(var/atom/movable/AM)
	Bumped(AM)

/turf/unsimulated/wall/cascade/Bumped(var/atom/movable/AM)
	if(!try_supermatter_consume(null, AM, src))
		return ..()

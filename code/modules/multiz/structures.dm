//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures/ladders.dmi'
	density =  FALSE
	opacity =  FALSE
	anchored = TRUE
	obj_flags = OBJ_FLAG_NOFALL
	material = /decl/material/solid/metal/aluminium
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT | TOOL_INTERACTION_ANCHOR
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

	var/base_icon = "ladder"
	var/draw_shadow = TRUE
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down
	var/climb_time = 2 SECONDS
	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')

	var/static/radial_ladder_down = image(icon = 'icons/screen/radial.dmi', icon_state = "radial_ladder_down")
	var/static/radial_ladder_up = image(icon = 'icons/screen/radial.dmi', icon_state = "radial_ladder_up")

	var/static/list/radial_options = list("up" = radial_ladder_up, "down" = radial_ladder_down)

/obj/structure/ladder/handle_default_wrench_attackby()
	var/last_anchored = anchored
	. = ..()
	if(anchored != last_anchored)
		find_connections()

/obj/structure/ladder/Initialize(maploading, material)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/LateInitialize(maploading, material)
	if(maploading)
		for(var/obj/structure/ladder/ladder in loc)
			if(ladder != src)
				qdel(ladder)
		if(HasBelow(z) && (locate(/obj/structure/ladder) in GetBelow(src)))
			var/turf/T = get_turf(src)
			T.ReplaceWithLattice()
	find_connections()
	set_extension(src, /datum/extension/turf_hand)

/obj/structure/ladder/proc/find_connections()

	if(target_down)
		if(target_down.target_up == src)
			target_down.target_up = null
			target_down.update_icon()
		target_down = null
	if(target_up)
		if(target_up.target_down == src)
			target_up.target_down = null
			target_up.update_icon()
		target_up = null

	if(anchored)
		var/turf/L = loc
		if(HasBelow(z) && istype(L) && L.is_open())
			var/failed
			for(var/obj/structure/catwalk/catwalk in loc)
				if(catwalk.plated_tile)
					failed = TRUE
					break
			if(!failed)
				for(var/obj/structure/ladder/ladder in GetBelow(src))
					if(ladder.anchored && !ladder.target_up)
						target_down = ladder
						target_down.target_up = src
						target_down.update_icon()
						break
		if(HasAbove(z))
			var/turf/T = GetAbove(src)
			if(istype(T) && T.is_open())
				var/failed
				for(var/obj/structure/catwalk/catwalk in T)
					if(catwalk.plated_tile)
						failed = TRUE
						break
				if(!failed)
					for(var/obj/structure/ladder/ladder in T)
						if(ladder.anchored && !ladder.target_down)
							target_up = ladder
							target_up.target_down = src
							target_up.update_icon()
							break
	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		if(target_down.target_up == src)
			target_down.target_up = null
			target_down.update_icon()
		target_down = null
	if(target_up)
		if(target_up.target_down == src)
			target_up.target_down = null
			target_up.update_icon()
		target_up = null
	var/turf/T = get_turf(src)
	if(T)
		for(var/atom/movable/M in T.contents)
			addtimer(CALLBACK(M, /atom/movable/proc/fall, T), 0)
	return ..()

/obj/structure/ladder/attackby(obj/item/I, mob/user)
	. = ..()
	if(!.)
		climb(user, I)

/turf/hitby(atom/movable/AM)
	..()
	if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)

/obj/structure/ladder/hitby(obj/item/I)
	..()
	if(!target_down)
		return
	if(!has_gravity())
		return
	var/atom/blocker
	var/turf/landing = get_turf(target_down)
	if(!istype(landing))
		return
	for(var/atom/A in landing)
		if(!A.CanPass(I, I.loc, 1.5, 0))
			blocker = A
			break
	if(!blocker)
		visible_message(SPAN_DANGER("\The [I] goes down \the [src]!"))
		I.forceMove(landing)
		landing.visible_message(SPAN_DANGER("\The [I] falls from the top of \the [target_down]!"))

/obj/structure/ladder/attack_hand(var/mob/M)
	climb(M)

/obj/structure/ladder/attack_ai(var/mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/attack_robot(var/mob/M)
	climb(M)

/obj/structure/ladder/proc/instant_climb(var/mob/M)
	var/atom/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.dropInto(target_ladder.loc)

/obj/structure/ladder/proc/climb(mob/M, obj/item/I)
	if(!M.may_climb_ladders(src))
		return

	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return

	if(!M.Move(get_turf(src)))
		to_chat(M, SPAN_NOTICE("You fail to reach \the [src]."))
		return

	add_fingerprint(M)

	for(var/obj/item/grab/G in M.get_active_grabs())
		G.adjust_position()

	var/direction = target_ladder == target_up ? "up" : "down"
	M.visible_message(SPAN_NOTICE("\The [M] begins climbing [direction] \the [src]."))
	target_ladder.audible_message(SPAN_NOTICE("You hear something coming [direction] \the [src]."))
	if(do_after(M, climb_time, src))
		climbLadder(M, target_ladder, I)
		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/attack_ghost(var/mob/M)
	instant_climb(M)

/obj/structure/ladder/proc/getTargetLadder(var/mob/M)
	if(!anchored)
		to_chat(M, SPAN_WARNING("\The [src] is not anchored in place and cannot be climbed."))
		return
	find_connections()
	if(!target_up && !target_down)
		to_chat(M, SPAN_WARNING("\The [src] does not seem to lead anywhere."))
	else if(target_down && target_up)
		var/direction = show_radial_menu(M, src,  radial_options, require_near = !(isEye(M) || isobserver(M)))
		if(!direction)
			return
		if(!M.may_climb_ladders(src))
			return
		. = (direction == "up") ? target_up : target_down
	else
		. = target_down || target_up

	if(.)
		if(. == target_up)
			var/turf/T = target_up.loc
			if(!istype(T) || !T.is_open())
				to_chat(M, SPAN_WARNING("The ceiling is in the way!"))
				return null
			for(var/obj/structure/catwalk/catwalk in target_up.loc)
				if(catwalk.plated_tile)
					to_chat(M, SPAN_WARNING("\The [catwalk] is in the way!"))
					return null
		if(. == target_down)
			var/turf/T = loc
			if(!istype(T) || !T.is_open())
				to_chat(M, SPAN_WARNING("\The [loc] is in the way!"))
				return null
			for(var/obj/structure/catwalk/catwalk in loc)
				if(catwalk.plated_tile)
					to_chat(M, SPAN_WARNING("\The [catwalk] is in the way!"))
					return null

/mob/proc/may_climb_ladders(var/ladder)
	if(!Adjacent(ladder))
		to_chat(src, SPAN_WARNING("You need to be next to \the [ladder] to start climbing."))
		return FALSE
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You are physically unable to climb \the [ladder]."))
		return FALSE
	var/carry_count = 0
	for(var/obj/item/grab/G in get_active_grabs())
		to_chat(src, SPAN_WARNING("You can't carry \the [G.affecting] up \the [ladder]."))
		return FALSE
	if(carry_count > 1)
		to_chat(src, SPAN_WARNING("You can't carry more than one person up \the [ladder]."))
		return FALSE

	return TRUE

/mob/observer/ghost/may_climb_ladders(var/ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(mob/user, target_ladder, obj/item/I = null)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(user, user.loc, 1.5, 0))
			to_chat(user, SPAN_NOTICE("\The [A] is blocking \the [src]."))
			//We cannot use the ladder, but we probably can remove the obstruction
			var/atom/movable/M = A
			if(istype(M) && M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
				if(isnull(I))
					M.attack_hand(user)
				else
					M.attackby(I, user)
			return FALSE
	playsound(src, pick(climbsounds), 50)
	playsound(target_ladder, pick(climbsounds), 50)
	return user.Move(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/on_update_icon()
	. = ..()
	if(!anchored)
		icon_state = "[base_icon]00"
	else
		icon_state = "[base_icon][!!target_up][!!target_down]"
	if(target_down && draw_shadow)
		var/image/I = image(icon, "downward_shadow")
		I.appearance_flags |= RESET_COLOR
		underlays = list(I)
	else
		underlays.Cut()

/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	density = 0
	opacity = 0
	anchored = 1
	layer = RUNE_LAYER

/obj/structure/stairs/Initialize()
	for(var/turf/turf in locs)
		var/turf/above = GetAbove(turf)
		if(!istype(above))
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		if(!above.is_open())
			above.ChangeTurf(/turf/simulated/open)
	. = ..()

/obj/structure/stairs/CheckExit(atom/movable/mover, turf/target)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/target = get_step(GetAbove(A), dir)
	var/turf/source = A.loc
	var/turf/above = GetAbove(A)
	if(above.CanZPass(source, UP) && target.Enter(A, src))
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(target)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.has_footsteps())
				playsound(source, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)
	else
		to_chat(A, SPAN_WARNING("Something blocks the path."))

/obj/structure/stairs/proc/upperStep(var/turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

// type paths to make mapping easier.
/obj/structure/stairs/north
	dir = NORTH
	bound_height = 64
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs/east
	dir = EAST
	bound_width = 64
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/west
	dir = WEST
	bound_width = 64

/obj/structure/stairs/short
	bound_height = 32
	bound_width = 32

/obj/structure/stairs/short/west
	dir = WEST
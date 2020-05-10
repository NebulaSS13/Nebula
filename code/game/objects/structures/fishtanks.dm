GLOBAL_LIST_INIT(fishtank_cache, new)

/obj/effect/glass_tank_overlay
	name = ""
	mouse_opacity = 0
	var/obj/structure/glass_tank/AQ

/obj/effect/glass_tank_overlay/Initialize(ml, aquarium)
	. = ..()
	AQ = aquarium
	verbs.Cut()

/obj/effect/glass_tank_overlay/Destroy()
	if(!QDELETED(AQ))
		if(!QDELETED(AQ.AO))
			QDEL_NULL(AQ.AO)
		QDEL_NULL(AQ)
	. = ..()

/obj/structure/glass_tank
	name = "terrarium"
	desc = "A clear glass box for keeping specimens in."
	icon_state = "preview"
	icon = 'icons/obj/structures/fishtanks.dmi'
	anchored = 1
	density = 1
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	mob_offset = TRUE
	maxhealth = 50

	var/deleting
	var/fill_type
	var/fill_amt
	var/obj/effect/glass_tank_overlay/AO // I don't like this, but there's no other way to get a mouse-transparent overlay :(

/obj/structure/glass_tank/aquarium
	name = "aquarium"
	desc = "A clear glass box for keeping specimens in. This one is full of water."
	fill_type = /decl/reagent/water
	fill_amt = 300

/obj/structure/glass_tank/Initialize()
	. = ..()
	initial_fill()
	AO = new(loc, src)
	update_icon(1)

/obj/structure/glass_tank/Destroy()
	if(!QDELETED(AO))
		QDEL_NULL(AO)
	var/oldloc = loc
	. = ..()
	for(var/obj/structure/glass_tank/A in orange(1, oldloc))
		A.update_icon()

/obj/structure/glass_tank/proc/initial_fill()
	if(fill_type && fill_amt)
		create_reagents(fill_amt)
		reagents.add_reagent(fill_type, fill_amt)

/obj/structure/glass_tank/attack_hand(var/mob/user)
	visible_message(SPAN_NOTICE("\The [user] taps on \the [src]."))

/obj/structure/glass_tank/attackby(var/obj/item/W, var/mob/user)
	if(W.force < 5 || user.a_intent != I_HURT)
		attack_animation(user)
		visible_message(SPAN_NOTICE("\The [user] taps \the [src] with \the [W]."))
	else
		. = ..()

/obj/structure/glass_tank/destroyed(var/silent)
	deleting = 1
	var/turf/T = get_turf(src)
	playsound(T, "shatter", 70, 1)
	new /obj/item/material/shard(T)
	if(!silent)
		if(contents.len || reagents.total_volume)
			visible_message(SPAN_DANGER("\The [src] shatters, spilling its contents everywhere!"))
		else
			visible_message(SPAN_DANGER("\The [src] shatters!"))
	dump_contents()
	for(var/obj/structure/glass_tank/A in orange(1, src))
		if(!A.deleting && A.type == type)
			A.destroyed(TRUE)
	qdel(src)

/obj/structure/glass_tank/proc/dump_contents()
	for(var/atom/movable/AM in contents)
		if(AM.simulated)
			AM.dropInto(get_turf(src))
	if(reagents && reagents.total_volume)
		var/turf/T = get_turf(src)
		if(T)
			T.add_fluid(reagents.total_volume * TANK_WATER_MULTIPLIER)
		reagents.clear_reagents()

GLOBAL_LIST_INIT(aquarium_states_and_layers, list(
	"b" = FLY_LAYER - 0.02,
	"w" = FLY_LAYER - 0.01,
	"f" = FLY_LAYER,
	"z" = FLY_LAYER + 0.01
))

/obj/structure/glass_tank/on_update_icon(propagate = 0)
	var/list/connect_dirs = list()
	for(var/obj/structure/glass_tank/A in orange(1, src))
		if(A.type == type)
			connect_dirs |= get_dir(src, A)
	var/list/c_states = dirs_to_unified_corner_states(connect_dirs)

	icon_state = "base"
	var/new_overlays
	for(var/i = 1 to 4)
		for(var/key_mod in GLOB.aquarium_states_and_layers)
			if(key_mod == "w" && (!reagents || !reagents.total_volume))
				continue
			var/cache_key = "[c_states[i]][key_mod]-[i]"
			if(!GLOB.fishtank_cache[cache_key])
				var/image/I = image(icon, icon_state = "[c_states[i]][key_mod]", dir = 1 << (i-1))
				if(GLOB.aquarium_states_and_layers[key_mod])
					I.layer = GLOB.aquarium_states_and_layers[key_mod]
				GLOB.fishtank_cache[cache_key] = I
			LAZYADD(new_overlays, GLOB.fishtank_cache[cache_key])
	AO.overlays = new_overlays

	// Update overlays with contents.
	new_overlays = null
	for(var/atom/movable/AM in contents)
		if(AM.simulated)
			LAZYADD(new_overlays, AM)
	overlays = new_overlays

	if(propagate)
		for(var/obj/structure/glass_tank/A in orange(1, src))
			if(A.type == type)
				A.update_icon()

/obj/structure/glass_tank/can_climb(var/mob/living/user, post_climb_check=0)
	if (!user.can_touch(src) || !(atom_flags & ATOM_FLAG_CLIMBABLE) || (!post_climb_check && (user in climbers)))
		return 0

	if (!Adjacent(user))
		to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DANGER("There's \a [occupied] in the way."))
		return 0
	return 1

/obj/structure/glass_tank/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return
	usr.visible_message(SPAN_WARNING("\The [user] starts climbing into \the [src]!"))
	if(!do_after(user,50))
		return
	if (!can_climb(user))
		return
	usr.forceMove(src.loc)
	if (get_turf(user) == get_turf(src))
		usr.visible_message(SPAN_WARNING("\The [user] climbs into \the [src]!"))

/obj/structure/glass_tank/verb/climb_out()
	set name = "Climb Out Of Tank"
	set desc = "Climbs out of a fishtank."
	set category = "Object"
	set src in oview(0) // Same turf.

	if(!isliving(usr))
		return

	var/list/valid_turfs = list()

	for(var/turf/T in orange(1))
		if(Adjacent(T) && !(locate(/obj/structure/glass_tank) in T))
			valid_turfs |= T

	if(valid_turfs.len)
		do_climb_out(usr, pick(valid_turfs))
	else
		to_chat(usr, SPAN_WARNING("There's nowhere to climb out to!"))

/mob/living/MouseDrop(atom/over)
	if(usr == src && isturf(over))
		var/turf/T = over
		var/obj/structure/glass_tank/A = locate() in usr.loc
		if(A && A.Adjacent(usr) && A.Adjacent(T))
			A.do_climb_out(usr, T)
			return
	return ..()

/obj/structure/glass_tank/proc/do_climb_out(mob/living/user, turf/target)
	if(get_turf(user) != get_turf(src))
		return
	if(!Adjacent(target))
		return
	usr.visible_message(SPAN_WARNING("\The [user] starts climbing out of \the [src]!"))
	if(!do_after(user,50))
		return
	if (!Adjacent(target))
		return
	usr.forceMove(target)
	usr.visible_message(SPAN_WARNING("\The [user] climbs out of \the [src]!"))

/obj/structure/glass_tank/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	. = locate(/obj/structure/glass_tank) in (target == loc) ? (mover && mover.loc) : target

/obj/structure/glass_tank/CheckExit(atom/movable/O, target)
	return locate(/obj/structure/glass_tank) in target

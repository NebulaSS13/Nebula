var/list/fishtank_cache = list()

/obj/effect/glass_tank_overlay
	name = ""
	mouse_opacity = 0
	var/obj/structure/glass_tank/aquarium

/obj/effect/glass_tank_overlay/Initialize(ml, _aquarium)
	. = ..()
	aquarium = _aquarium
	verbs.Cut()

/obj/effect/glass_tank_overlay/Destroy()
	if(!QDELETED(aquarium))
		QDEL_NULL(aquarium)
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
	var/obj/effect/glass_tank_overlay/tank_overlay // I don't like this, but there's no other way to get a mouse-transparent overlay :(

/obj/structure/glass_tank/aquarium
	name = "aquarium"
	desc = "A clear glass box for keeping specimens in. This one is full of water."
	fill_type = /decl/material/liquid/water
	fill_amt = 300

/obj/structure/glass_tank/Initialize()
	tank_overlay = new(loc, src)
	initial_fill()
	. = ..()
	update_icon(TRUE)

/obj/structure/glass_tank/Destroy()
	if(!QDELETED(tank_overlay))
		QDEL_NULL(tank_overlay)
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

/obj/structure/glass_tank/physically_destroyed(var/silent)
	SHOULD_CALL_PARENT(FALSE)
	deleting = TRUE
	var/turf/T = get_turf(src)
	playsound(T, "shatter", 70, 1)
	new /obj/item/shard(T)
	if(!silent)
		if(contents.len || reagents.total_volume)
			visible_message(SPAN_DANGER("\The [src] shatters, spilling its contents everywhere!"))
		else
			visible_message(SPAN_DANGER("\The [src] shatters!"))
	dump_contents()
	for(var/obj/structure/glass_tank/A in orange(1, src))
		if(!A.deleting && A.type == type)
			A.physically_destroyed(TRUE)
	qdel(src)

/obj/structure/glass_tank/dump_contents()
	. = ..()
	if(reagents && reagents.total_volume)
		var/turf/T = get_turf(src)
		var/obj/effect/fluid/F = locate() in T
		if(!F) F = new(T)
		reagents.trans_to_holder(F.reagents, reagents.total_volume)

var/list/global/aquarium_states_and_layers = list(
	"b" = FLY_LAYER - 0.02,
	"w" = FLY_LAYER - 0.01,
	"f" = FLY_LAYER,
	"z" = FLY_LAYER + 0.01
)

/obj/structure/glass_tank/on_update_icon(propagate = 0)
	var/list/connect_dirs = list()
	for(var/obj/structure/glass_tank/A in orange(1, src))
		if(A.type == type)
			connect_dirs |= get_dir(src, A)
	var/list/c_states = dirs_to_unified_corner_states(connect_dirs)

	if(tank_overlay)
		tank_overlay.cut_overlays()
		for(var/i = 1 to 4)
			for(var/key_mod in global.aquarium_states_and_layers)
				if(key_mod == "w" && (!reagents || !reagents.total_volume))
					continue
				var/cache_key = "[c_states[i]][key_mod]-[i]"
				if(!global.fishtank_cache[cache_key])
					var/image/I = image(icon, icon_state = "[c_states[i]][key_mod]", dir = 1<<(i-1))
					if(global.aquarium_states_and_layers[key_mod])
						I.layer = global.aquarium_states_and_layers[key_mod]
					global.fishtank_cache[cache_key] = I
				tank_overlay.add_overlay(global.fishtank_cache[cache_key])

	// Update overlays with contents.
	icon_state = "base"
	cut_overlays()
	for(var/atom/movable/AM in contents)
		if(AM.simulated)
			add_overlay(AM)

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

	for(var/turf/T in RANGE_TURFS(loc, 1))
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

/obj/structure/droppod_door
	name = "pod door"
	desc = "A drop pod door. Opens rapidly using explosive bolts."
	icon = 'icons/obj/structures/droppod_door.dmi'
	icon_state = "droppod_door_closed"
	anchored = 1
	density = 1
	opacity = 1
	layer = ABOVE_DOOR_LAYER
	var/deploying
	var/deployed

/obj/structure/droppod_door/Initialize(mapload, var/autoopen)
	. = ..(mapload)
	if(autoopen)
		deploy(null, 10 SECONDS)

/obj/structure/droppod_door/attack_ai(var/mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/droppod_door/attack_hand(var/mob/user)
	if(deploying)
		return ..()
	deploy(user, 3 SECONDS)
	return TRUE

/obj/structure/droppod_door/proc/deploy(var/mob/user, var/delay)
	set waitfor = FALSE

	if(deployed)
		return

	if(user)
		to_chat(user, SPAN_DANGER("You prime the explosive bolts. Better get clear!"))
	deployed = TRUE

	if(delay)
		sleep(delay)

	if(QDELETED(src))
		return

	visible_message(SPAN_DANGER("The explosive bolts on \the [src] detonate, throwing it open!"))
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)

	// This is shit but it will do for the sake of testing.
	for(var/obj/structure/droppod_door/D in orange(1,src))
		if(D.deployed)
			continue
		D.deploy(null, 0)

	// Overwrite turfs.
	var/turf/origin = get_turf(src)
	origin.ChangeTurf(/turf/simulated/floor/reinforced)
	origin.set_light(0) // Forcing updates
	var/turf/T = get_step(origin, src.dir)
	T.ChangeTurf(/turf/simulated/floor/reinforced)
	T.set_light(0) // Forcing updates

	// Destroy turf contents.
	for(var/obj/O in origin)
		if(!O.simulated)
			continue
		qdel(O) //crunch
	for(var/obj/O in T)
		if(!O.simulated)
			continue
		qdel(O) //crunch

	// Hurl the mobs away.
	for(var/mob/living/M in T)
		M.throw_at(get_edge_target_turf(T,src.dir),rand(0,3),50)
	for(var/mob/living/M in origin)
		M.throw_at(get_edge_target_turf(origin,src.dir),rand(0,3),50)

	// Create a decorative ramp bottom and flatten out our current ramp.
	set_density(0)
	set_opacity(0)
	icon_state = "ramptop"
	var/obj/structure/droppod_door/door_bottom = new(T)
	door_bottom.deployed = 1
	door_bottom.set_density(0)
	door_bottom.set_opacity(0)
	door_bottom.set_dir(src.dir)
	door_bottom.icon_state = "rampbottom"
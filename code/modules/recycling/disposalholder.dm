
// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/structure/disposalholder
	invisibility = INVISIBILITY_ABSTRACT
	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	var/active = 0	// true if the holder is moving, otherwise inactive
	dir = 0
	var/count = 4096 //*** can travel 4096 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/hasmob = 0 //If it contains a mob
	var/speed = 2

	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.

	// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(var/obj/machinery/disposal/disposal_unit, var/datum/gas_mixture/flush_gas)
	gas = flush_gas// transfer gas resv. into holder object -- let's be explicit about the data this proc consumes, please.
	var/stuff = disposal_unit.get_contained_external_atoms()
	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	hasmob = length(check_mob(stuff))

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for(var/atom/movable/AM in stuff)
		AM.forceMove(src)
		var/datum/extension/sorting_tag/ST = get_extension(AM, /datum/extension/sorting_tag)
		if(ST)
			destinationTag = ST.destination

/obj/structure/disposalholder/proc/check_mob(list/stuff, max_depth = 1)
	. = list()
	if(max_depth > 0)
		for(var/mob/living/victim in stuff)
			if (!isdrone(victim))
				. += victim
		for(var/obj/container in stuff)
			. += check_mob(container.contents, max_depth - 1)

	// start the movement process
	// argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(var/obj/machinery/disposal/disposal_unit)
	if(!disposal_unit.trunk)
		disposal_unit.expel(src)	// no trunk connected, so expel immediately
		return

	forceMove(disposal_unit.trunk)
	active = 1
	set_dir(DOWN)
	START_PROCESSING(SSdisposals, src)

	// movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/Process()
	for (var/i in 1 to speed)
		if(!(count--))
			active = 0
		if(!active || QDELETED(src))
			return PROCESS_KILL

		var/obj/structure/disposalpipe/last

		if(hasmob && prob(3))
			for(var/mob/living/victim in check_mob(src))
				victim.apply_damage(30, BRUTE, null, DAM_DISPERSED, "Blunt Trauma", ARMOR_MELEE_MAJOR)//horribly maim any living creature jumping down disposals.  c'est la vie

		var/obj/structure/disposalpipe/curr = loc
		if(!istype(curr))
			qdel(src)
			return PROCESS_KILL

		last = curr
		curr = curr.transfer(src)

		if(QDELETED(src))
			return PROCESS_KILL

		if(!curr)
			last.expel(src, loc, dir)

	// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc,dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(var/turf/containing_turf)
	if(!containing_turf)
		return null

	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/pipe in containing_turf)
		if(fdir & pipe.dpdir)		// find pipe direction mask that matches flipped dir
			return pipe
	// if no matching pipe, return null
	return null

// merge two holder objects
// used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(var/obj/structure/disposalholder/other)
	for(var/atom/movable/other_movable in other)
		other_movable.forceMove(src)		// move everything in other holder to this one
		if(ismob(other_movable))
			var/mob/other_mob = other_movable
			if(other_mob.client)	// if a client mob, update eye to follow this holder
				other_mob.client.eye = src
	qdel(other)

/obj/structure/disposalholder/proc/settag(var/new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(var/new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag

// called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/user)
	if(!isliving(user))
		return

	var/mob/living/living_user = user

	if (living_user.stat || living_user.is_on_special_ability_cooldown())
		return

	living_user.set_special_ability_cooldown(10 SECONDS)

	var/turf/our_turf = get_turf(src)
	if (our_turf)
		our_turf.audible_message("You hear a clanging noise.")
		playsound(our_turf, 'sound/effects/clang.ogg', 50, 0, 0)

// called to vent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(var/atom/location)
	if(location)
		location.assume_air(gas)  // vent all gas to turf

/obj/structure/disposalholder/Destroy()
	QDEL_NULL(gas)
	active = 0
	STOP_PROCESSING(SSdisposals, src)
	return ..()

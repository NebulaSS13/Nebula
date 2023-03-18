var/global/narsie_cometh = 0
var/global/list/narsie_list = list()
/obj/effect/narsie //Moving narsie to its own file for the sake of being clearer
	name = "Nar-Sie"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/narsie.dmi'
	icon_state = "narsie"//mobs perceive the geometer of blood through their see_narsie proc
	pixel_x = -236
	pixel_y = -256
	is_spawnable_type = FALSE

	var/mob/target
	light_range = 1
	light_color = "#3e0000"

	/// Are we going to move around? Set by admin and mappers.
	var/move_self = TRUE
	/// How many tiles out do we pull?
	var/consume_pull = 10
	/// How many tiles out do we eat
	var/consume_range = 3

/obj/effect/narsie/Initialize()
	. = ..()
	global.narsie_list.Add(src)
	announce_narsie()

/obj/effect/narsie/Destroy()
	target = null
	global.narsie_list.Remove(src)
	. = ..()

/obj/effect/narsie/Process()

	// Feed.
	for(var/atom/movable/consuming in range(consume_pull, src))
		if(get_dist(src, consuming) <= consume_range)
			consume(consuming)
		else
			consuming.singularity_pull(src, 9)

	// Find a target.
	if (!target || prob(5))
		pickcultist()

	// Move.
	if(move_self)

		// Get a direction to move.
		var/movement_dir
		if(target && prob(60))
			movement_dir = get_dir(src, target) //moves to a singulo beacon, if there is one
		else if(prob(16))
			var/list/available_vertical_moves = list()
			if(GetAbove(src))
				available_vertical_moves += UP
			if(GetBelow(src))
				available_vertical_moves += DOWN
			if(length(available_vertical_moves))
				movement_dir = pick(available_vertical_moves)
		if(!movement_dir)
			movement_dir = pick(global.alldirs)

		// Try to move in it.
		step(src, movement_dir)
		narsiefloor(get_turf(loc))
		for(var/mob/M in global.player_list)
			if(M.client)
				M.see_narsie(src, movement_dir)

	if(prob(25))
		for(var/mob/living/carbon/M in oviewers(8, src))
			if(!M.stat == CONSCIOUS || (M.status_flags & GODMODE) || iscultist(M))
				continue
			to_chat(M, SPAN_DANGER("You feel your sanity crumble away in an instant as you gaze upon [src.name]..."))
			M.apply_effect(3, STUN)

/obj/effect/narsie/Bump(atom/A)
	if(isturf(A))
		narsiewall(A)
	else if(istype(A, /obj/structure/cult))
		qdel(A)

/obj/effect/narsie/Bumped(atom/A)
	if(isturf(A))
		narsiewall(A)
	else if(istype(A, /obj/structure/cult))
		qdel(A)

/obj/effect/narsie/proc/announce_narsie()
	set waitfor = FALSE
	if(global.narsie_cometh)//so we don't initiate Hell more than one time.
		return
	to_world(SPAN_DANGER("<font size='15'>[uppertext(name)] HAS RISEN!</font>"))
	sound_to(world, sound('sound/effects/wind/wind_5_1.ogg'))
	narsie_spawn_animation()
	global.narsie_cometh = TRUE
	SetUniversalState(/datum/universal_state/hell)
	sleep(10 SECONDS)
	if(SSevac.evacuation_controller)
		SSevac.evacuation_controller.call_evacuation(null, TRUE, 1)
		SSevac.evacuation_controller.evac_no_return = 0 // Cannot recall

/obj/effect/narsie/proc/narsie_spawn_animation()
	set waitfor = FALSE
	icon = 'icons/obj/narsie_spawn_anim.dmi'
	set_dir(SOUTH)
	move_self = FALSE
	flick("narsie_spawn_anim",src)
	sleep(1 SECOND)
	move_self = TRUE
	icon = initial(icon)

/obj/effect/narsie/proc/narsiefloor(var/turf/T)//leaving "footprints"
	if(!(istype(T, /turf/simulated/wall/cult) || isspaceturf(T)))
		if(T.icon_state != "cult-narsie")
			T.desc = "something that goes beyond your understanding went this way"
			T.icon = 'icons/turf/flooring/cult.dmi'
			T.icon_state = "cult-narsie"
			T.set_light(1)

/obj/effect/narsie/proc/narsiewall(var/turf/T)
	T.desc = "An opening has been made on that wall, but who can say if what you seek truly lies on the other side?"
	T.icon = 'icons/turf/walls.dmi'
	T.icon_state = "cult-narsie"
	T.set_opacity(0)
	T.set_density(0)
	set_light(1)

/obj/effect/narsie/explosion_act(severity) //No throwing bombs at it either. --NEO
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/effect/narsie/proc/pickcultist() //Narsie rewards his cultists with being devoured first, then picks a ghost to follow. --NEO
	var/list/cultists = list()
	var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
	for(var/datum/mind/cult_nh_mind in cult.current_antagonists)
		if(!cult_nh_mind.current)
			continue
		if(cult_nh_mind.current.stat)
			continue
		if(get_z(cult_nh_mind.current) != z)
			continue
		cultists += cult_nh_mind.current
	if(cultists.len)
		acquire(pick(cultists))
		return
		//If there was living cultists, it picks one to follow.
	for(var/mob/living/carbon/human/food in global.living_mob_list_)
		if(food.stat)
			continue
		var/turf/pos = get_turf(food)
		if(!pos)	//Catches failure of get_turf.
			continue
		if(pos.z != src.z)
			continue
		cultists += food
	if(cultists.len)
		acquire(pick(cultists))
		return
		//no living cultists, pick a living human instead.
	for(var/mob/observer/ghost/ghost in global.player_list)
		if(!ghost.client)
			continue
		var/turf/pos = get_turf(ghost)
		if(pos.z != src.z)
			continue
		cultists += ghost
	if(cultists.len)
		acquire(pick(cultists))
		return
		//no living humans, follow a ghost instead.

/obj/effect/narsie/proc/acquire(const/mob/food)
	var/capname = uppertext(name)

	to_chat(target, "<span class='notice'><b>[capname] HAS LOST INTEREST IN YOU.</b></span>")
	target = food

	if (ishuman(target))
		to_chat(target, "<span class='danger'>[capname] HUNGERS FOR YOUR SOUL.</span>")
	else
		to_chat(target, "<span class='danger'>[capname] HAS CHOSEN YOU TO LEAD HIM TO HIS NEXT MEAL.</span>")

/obj/effect/narsie/proc/consume(const/atom/A) //Has its own consume proc because it doesn't need energy and I don't want BoHs to explode it. --NEO
	if (istype(A, /mob/) && (get_dist(A, src) <= 7))
		var/mob/M = A
		if(M.status_flags & GODMODE)
			return 0
		M.cultify()
//TURF PROCESSING
	else if (isturf(A))
		var/dist = get_dist(A, src)
		for (var/atom/movable/AM in A.contents)
			if (dist <= consume_range)
				consume(AM)
				continue
		if (dist <= consume_range && !isspaceturf(A))
			var/turf/T = A
			if(T.holy)
				T.holy = 0 //Nar-Sie doesn't give a shit about sacred grounds.
			T.cultify()

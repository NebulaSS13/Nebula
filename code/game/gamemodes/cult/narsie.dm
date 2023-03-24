// show_to() and hide_from() do not work, but I am leaving the committed and commented out
// so if in the future some brave soul wants to implement always-visible NarNar without having
// her get output to every single client every time the thing moves, they can do so.
/*
/mob/Login()
	..()
	for(var/obj/effect/narsie/narsie in global.narsie_list)
		narsie.show_to(src)

/obj/effect/narsie/proc/show_to(var/mob/M)
	if(override_image && M.client)
		M.client.images |= override_image

/obj/effect/narsie/proc/hide_from(var/mob/M)
	if(override_image && M.client)
		M.client.images -= override_image
*/

var/global/narsie_cometh = 0
var/global/list/narsie_list = list()

/obj/effect/narsie_footstep
	name = "mark of the Geometer"
	desc = "something that goes beyond your understanding went this way"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "narsie_footstep"
	light_color = COLOR_RED
	light_range = 1
	light_power = 1

/obj/effect/narsie
	name = "Nar-Sie"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/narsie.dmi'
	icon_state = "narsie"
	pixel_x = -236
	pixel_y = -256
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	light_range = 1
	light_color = "#3e0000"

	//is_spawnable_type = FALSE

	/// Our image to show to clients.
	var/image/override_image
	/// The current target we're pursuing.
	var/mob/target
	/// Are we going to move around? Set by admin and mappers.
	var/move_self = TRUE
	/// How many tiles out do we pull?
	var/consume_pull = 10
	/// How many tiles out do we eat
	var/consume_range = 6
	/// Sanity check for consuming.
	var/max_atoms_assessed_per_tick = 100

/obj/effect/narsie/Initialize()
	. = ..()
	global.narsie_list.Add(src)
	START_PROCESSING(SSobj, src)
	announce_narsie()
	update_icon()

/obj/effect/narsie/Destroy()
	target = null
	global.narsie_list.Remove(src)
	STOP_PROCESSING(SSobj, src)
	for(var/client/C)
		hide_from(C.mob)
	. = ..()

/obj/effect/narsie/Process_Spacemove(allow_movement)
	return TRUE

// See comment at the top of the file for why this sections of this are commented out.
/obj/effect/narsie/on_update_icon()
	. = ..()

/*
	if(override_image)
		for(var/client/C)
			hide_from(C.mob)

*/
	set_overlays("glow-narsie")
/*
	compile_overlays()
	override_image = image(null)
	override_image.appearance = src
	override_image.loc = src
	override_image.override = TRUE
	override_image.pixel_y = null
	override_image.pixel_x = null

	for(var/client/C)
		show_to(C.mob)
*/

/obj/effect/narsie/Process()

	// Feed.
	var/consumed = 0
	for(var/atom/consuming in range(consume_pull, src))
		if(get_dist(src, consuming) >= consume_range)
			consuming.singularity_pull(src, 9)
		else
			consuming.on_narsie_defile()
		if(consumed++ >= max_atoms_assessed_per_tick || TICK_CHECK)
			break

	if(TICK_CHECK)
		return

	// Find a target.
	if (!target || prob(5))
		var/list/targets = list()
		var/current_zs = SSmapping.get_connected_levels(z, include_lateral = FALSE) // can't really handle lateral connections
		var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
		for(var/datum/mind/cult_nh_mind in cult.current_antagonists)
			if(cult_nh_mind.current && !cult_nh_mind.current.stat &&  (get_z(cult_nh_mind.current) in current_zs))
				targets += cult_nh_mind.current
		// If we have no valid cultists, go for any human.
		if(!length(targets))
			for(var/mob/living/carbon/human/food in global.living_mob_list_)
				if(food.stat)
					var/turf/pos = get_turf(food)
					if(pos?.z in current_zs)
						targets += food
			// Go for ghosts if nothing else is available.
			if(!length(targets))
				for(var/mob/observer/G in global.dead_mob_list_)
					targets += G
		// Pick a random candidate.
		if(length(targets))
			target = pick(targets)
		var/capname = uppertext(name)
		to_chat(target, SPAN_NOTICE("<b>[capname] HAS LOST INTEREST IN YOU.</b>"))
		if (ishuman(target))
			to_chat(target, SPAN_DANGER("[capname] HUNGERS FOR YOUR SOUL."))
		else
			to_chat(target, SPAN_DANGER("[capname] HAS CHOSEN YOU TO LEAD HIM TO HIS NEXT MEAL."))

	// Move.
	if(move_self)

		// Get a direction to move.
		var/movement_dir
		if(target && prob(60))
			if(target.z == z)
				movement_dir = get_dir(src, target)
			else if(target.z > z && GetAbove(src))
				movement_dir = UP
			else if(target.z < z && GetBelow(src))
				movement_dir = DOWN
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
		var/turf/T = get_turf(loc)
		if(T && !T.is_open() && !(locate(/obj/effect/narsie_footstep) in T))
			new /obj/effect/narsie_footstep(T)

	if(prob(25))
		for(var/mob/living/carbon/M in oviewers(8, src))
			if(M.stat == CONSCIOUS && !(M.status_flags & GODMODE) && !iscultist(M))
				to_chat(M, SPAN_DANGER("You feel your sanity crumble away in an instant as you gaze upon [src.name]..."))
				M.apply_effect(3, STUN)

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

/obj/effect/narsie/explosion_act(severity) //No throwing bombs at it either. --NEO
	SHOULD_CALL_PARENT(FALSE)
	return

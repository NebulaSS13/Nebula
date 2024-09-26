/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in global.silicon_mob_list)
		if(D.key && D.client)
			drones++
	return drones

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."
	appearance_flags = 0

	density = TRUE
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 5000

	var/fabricator_tag
	var/fab_tag_modifier
	var/drone_progress = 0
	var/produce_drones = 1
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

/obj/machinery/drone_fabricator/Initialize()
	. = ..()
	if(isnull(fabricator_tag))
		fabricator_tag = "[global.using_map.station_short][fab_tag_modifier]"

/obj/machinery/drone_fabricator/maintenance
	name = "maintenance drone fabricator"
	fab_tag_modifier = " (Maintenance)"

/obj/machinery/drone_fabricator/construction
	name = "construction drone fabricator"
	desc = "A large automated factory for producing construction drones."
	fab_tag_modifier = " (Construction)"
	drone_type = /mob/living/silicon/robot/drone/construction

/obj/machinery/drone_fabricator/derelict
	name = "construction drone fabricator"
	fabricator_tag = "Derelict"
	drone_type = /mob/living/silicon/robot/drone/construction

/obj/machinery/drone_fabricator/power_change()
	. = ..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/Process()
	if(GAME_STATE < RUNLEVEL_GAME)
		return

	if(stat & NOPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower") icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/get_config_value(/decl/config/num/drone_build_time))*100)

	if(drone_progress >= 100)
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")

/obj/machinery/drone_fabricator/examine(mob/user)
	. = ..()
	if(produce_drones && drone_progress >= 100 && isghost(user) && get_config_value(/decl/config/toggle/on/allow_drone_spawn) && count_drones() < get_config_value(/decl/config/num/max_maint_drones))
		to_chat(user, "<BR><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>")

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)

	if(stat & NOPOWER)
		return

	if(!produce_drones || !get_config_value(/decl/config/toggle/on/allow_drone_spawn) || count_drones() >= get_config_value(/decl/config/num/max_maint_drones))
		return

	if(player && !isghost(player.mob))
		return

	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave",src)
	drone_progress = 0
	time_last_drone = world.time

	var/mob/living/silicon/robot/drone/new_drone = new drone_type(get_turf(src))
	if(player)
		announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
		if(player.mob && player.mob.mind) player.mob.mind.reset()
		new_drone.transfer_personality(player)

	return new_drone

/mob/observer/ghost/verb/join_as_drone()
	set category = "Ghost"
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."
	try_drone_spawn(src)

/proc/try_drone_spawn(var/mob/user, var/obj/machinery/drone_fabricator/fabricator)

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(user, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(get_config_value(/decl/config/enum/server_whitelist) == CONFIG_SERVER_JOIN_WHITELIST && !check_server_whitelist(user))
		to_chat(user, SPAN_WARNING("Non-whitelisted players cannot join rounds except as observers."))
		return

	if(!get_config_value(/decl/config/toggle/on/allow_drone_spawn))
		to_chat(user, SPAN_WARNING("That verb is not currently permitted."))
		return

	if(jobban_isbanned(user,ASSIGNMENT_ROBOT))
		to_chat(user, SPAN_WARNING("You are banned from playing synthetics and cannot spawn as a drone."))
		return

	if(get_config_value(/decl/config/num/use_age_restriction_for_jobs) && isnum(user.client.player_age))
		if(user.client.player_age <= 3)
			to_chat(user, SPAN_WARNING("Your account is not old enough to play as a maintenance drone."))
			return

	if(!user.MayRespawn(1, DRONE_SPAWN_DELAY))
		return

	if(!fabricator)

		var/list/all_fabricators = list()
		for(var/obj/machinery/drone_fabricator/DF in SSmachines.machinery)
			if((DF.stat & NOPOWER) || !DF.produce_drones || DF.drone_progress < 100)
				continue
			all_fabricators[DF.fabricator_tag] = DF

		if(!all_fabricators.len)
			to_chat(user, SPAN_WARNING("There are no available drone spawn points, sorry."))
			return

		var/choice = input(user,"Which fabricator do you wish to use?") as null|anything in all_fabricators
		if(!choice || !all_fabricators[choice])
			return
		fabricator = all_fabricators[choice]

	if(user && fabricator && !((fabricator.stat & NOPOWER) || !fabricator.produce_drones || fabricator.drone_progress < 100))
		log_and_message_admins("has joined the round as a maintenance drone.")
		var/mob/drone = fabricator.create_drone(user.client)
		if(drone)
			drone.status_flags |= NO_ANTAG
		return 1
	return

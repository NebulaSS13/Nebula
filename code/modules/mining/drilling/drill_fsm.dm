/datum/state_machine/drill
	current_state = /decl/state/drill/unpowered
	expected_type = /obj/machinery/mining_drill
	base_type = /datum/state_machine/drill


/decl/state/drill
	var/light_color = null
	var/light_icon_state = "blink_slow"
	var/entered_sound = null
	var/exited_sound = null
	var/power_usage = POWER_USE_IDLE

/decl/state/drill/entered_state(obj/machinery/mining_drill/drill)
	drill.queue_icon_update()
	if(entered_sound)
		playsound(drill, entered_sound, 40, FALSE)
	drill.update_use_power(power_usage)

/decl/state/drill/exited_state(obj/machinery/mining_drill/drill)
	if(exited_sound)
		playsound(drill, exited_sound, 40, FALSE)

/decl/state/drill/proc/process(obj/machinery/mining_drill/drill)


/decl/state_transition/drill/is_open(obj/machinery/mining_drill/drill)
	return drill.operable()


/// Unpowered state. Occurs when the battery dies or when turned off.
/decl/state/drill/unpowered
	light_color = "#00000000"
	power_usage = POWER_USE_OFF
	light_icon_state = null
	entered_sound = 'sound/mecha/mech-shutdown.ogg'
	exited_sound = 'sound/mecha/powerup.ogg'
	transitions = list(
		/decl/state_transition/drill/recover_from_unpowered
	)

/decl/state_transition/drill/unpowered
	target = /decl/state/drill/unpowered

/decl/state_transition/drill/unpowered/is_open(obj/machinery/mining_drill/drill)
	return drill.inoperable() || drill.use_power == POWER_USE_OFF


/decl/state_transition/drill/recover_from_unpowered
	target = /decl/state/drill/idle

/decl/state_transition/drill/recover_from_unpowered/is_open(obj/machinery/mining_drill/drill)
	return drill.operable() && drill.use_power != POWER_USE_OFF


/// Starting state for drills that are turned on or recovered from an issue.
/decl/state/drill/idle
	light_color = "#ffffff"
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error,
		/decl/state_transition/drill/storage_full,
		/decl/state_transition/drill/scanning,
		/decl/state_transition/drill/switching_target,
		/decl/state_transition/drill/mining,
		/decl/state_transition/drill/finished
	)

/decl/state/drill/idle/entered_state(obj/machinery/mining_drill/drill)
	. = ..()
	drill.reset_drill()


/// State that occurs if there is a problem with the drill setup, such as lacking braces.
/decl/state/drill/error
	light_color = "#ff0000"
	entered_sound = 'sound/machines/buzz-sigh.ogg'
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/recover_from_error
	)

/decl/state_transition/drill/error
	target = /decl/state/drill/error

/decl/state_transition/drill/error/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.supports) < drill.MINIMUM_SUPPORT_NUMBER


/decl/state_transition/drill/recover_from_error
	target = /decl/state/drill/idle

/decl/state_transition/drill/recover_from_error/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.supports) >= drill.MINIMUM_SUPPORT_NUMBER


/// State that follows the starting state, where it determines which turfs to mine, and gives a visual effect of it scanning the surrounding ground.
/decl/state/drill/scanning
	light_color = "#00ffff"
	entered_sound = 'sound/effects/scanbeep.ogg'
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error,
		/decl/state_transition/drill/switching_target,
		/decl/state_transition/drill/finished
	)

/decl/state/drill/scanning/process(obj/machinery/mining_drill/drill)
	drill.populate_turfs_to_mine()
	drill.scan_visuals()


/decl/state_transition/drill/scanning
	target = /decl/state/drill/scanning

/decl/state_transition/drill/scanning/is_open(obj/machinery/mining_drill/drill)
	return ..() && !length(drill.turfs_to_mine)


/// State where the drill is actively mining a specific turf.
/decl/state/drill/mining
	light_color = "#00ff00"
	light_icon_state = "blink_fast"
	power_usage = POWER_USE_ACTIVE
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error,
		/decl/state_transition/drill/storage_full,
		/decl/state_transition/drill/switching_target,
		/decl/state_transition/drill/finished
	)

/decl/state/drill/mining/process(obj/machinery/mining_drill/drill)
	drill.mine_ore(drill.current_turf)

/decl/state_transition/drill/mining
	target = /decl/state/drill/mining

/decl/state_transition/drill/mining/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.turfs_to_mine) && drill.current_turf


/// State which occurs when the currently mined turf is depleted, and there is another turf to mine from,
/// thus the drill visually targets the next spot and provides some feedback to the player on how fast the mining is going.
/decl/state/drill/switching_target
	light_color = "#008800"
	light_icon_state = "blink_fast"
	power_usage = POWER_USE_IDLE
	entered_sound = 'sound/machines/airlock_open_force.ogg'
	exited_sound = 'sound/machines/airlock_close_force.ogg'
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error,
		/decl/state_transition/drill/mining,
		/decl/state_transition/drill/finished
	)

/decl/state/drill/switching_target/process(obj/machinery/mining_drill/drill)
	drill.deplete_turf(drill.current_turf)
	if(length(drill.turfs_to_mine))
		drill.choose_turf_to_mine()
	else
		drill.current_turf = null

/decl/state_transition/drill/switching_target
	target = /decl/state/drill/switching_target

/decl/state_transition/drill/switching_target/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.turfs_to_mine) && !drill.turf_has_ore(drill.current_turf)


/// State which occurs when the ore storage is full, and the player needs to unload the ore for it to resume mining.
/decl/state/drill/storage_full
	light_color = "#ffff00"
	entered_sound = 'sound/machines/buzz-two.ogg'
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error,
		/decl/state_transition/drill/recover_from_storage_full
	)

/decl/state_transition/drill/storage_full
	target = /decl/state/drill/storage_full

/decl/state_transition/drill/storage_full/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.contained_ore) >= drill.ore_capacity

/decl/state_transition/drill/recover_from_storage_full
	target = /decl/state/drill/idle

/decl/state_transition/drill/recover_from_storage_full/is_open(obj/machinery/mining_drill/drill)
	return ..() && length(drill.contained_ore) < drill.ore_capacity


/// State which occurs when there is no more ore to mine from the surrounding tiles.
/decl/state/drill/finished
	light_color = "#0000ff"
	entered_sound = 'sound/machines/ping.ogg'
	transitions = list(
		/decl/state_transition/drill/unpowered,
		/decl/state_transition/drill/error
	)

/decl/state_transition/drill/finished
	target = /decl/state/drill/finished

/decl/state_transition/drill/finished/is_open(obj/machinery/mining_drill/drill)
	return ..() && !drill.current_turf && !length(drill.turfs_to_mine)
/datum/mob_controller
	var/list/known_commands
	var/list/command_buffer
	var/decl/mob_command/current_command

/datum/mob_command_metadata
	var/weakref/target_ref
	var/command_started

/datum/mob_command_metadata/New()
	. = ..()
	command_started = world.time

/decl/mob_command
	abstract_type = /decl/mob_command
	var/command_metadata_type = /datum/mob_command_metadata
	var/command
	var/keep_processing = FALSE

/decl/mob_command/proc/end_command(datum/mob_controller/controller)
	var/cmd = controller.known_commands[src]
	if(cmd)
		controller.known_commands[src] = null
		qdel(cmd)
	if(controller.current_command == src)
		controller.current_command = null

/decl/mob_command/proc/receive_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	if(islist(command))
		for(var/subcommand in command)
			if(findtext(command_string, subcommand))
				return TRUE
	else
		return !!findtext(command_string, command)
	return FALSE

/decl/mob_command/proc/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)

	// Create a metadata handler for our command so we can update it.
	if(command_metadata_type)
		. = controller.known_commands[src]
		if(!.)
			. = new command_metadata_type
			controller.known_commands[src] = .

	// Clear previous command metadata.
	for(var/command_decl in controller.known_commands)
		if(command_decl == src)
			continue
		var/metadata = controller.known_commands[command_decl]
		if(metadata)
			controller.known_commands[command_decl] = null
			qdel(metadata)

	return isnull(command_metadata_type) || .

/decl/mob_command/proc/do_process(mob/body, datum/mob_controller/controller, datum/mob_command_metadata/cmd)
	return FALSE

/decl/mob_command/stay
	command = "stay"
	sort_order = 1
	command_metadata_type = null
	keep_processing = TRUE

/decl/mob_command/stay/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	controller.set_target(null)
	controller.stop_wandering()
	body.stop_automove()

/decl/mob_command/stay/do_process(mob/body, datum/mob_controller/controller, datum/mob_command_metadata/cmd)
	return TRUE // We just hang out.

/decl/mob_command/stop
	command = "stop"
	sort_order = 2
	command_metadata_type = null

/decl/mob_command/stop/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	controller.clear_enemies()
	controller.set_stance(/decl/mob_controller_stance/idle)

/decl/mob_command/attack
	command = "attack"
	sort_order = 3
	command_metadata_type = null

/decl/mob_command/attack/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	controller.set_stance(/decl/mob_controller_stance/idle)
	if(findtext(command_string, "everyone") || findtext(command_string, "anybody") || findtext(command_string, "somebody") || findtext(command_string, "someone"))
		controller.add_enemy("everyone")
		return TRUE
	var/list/targets = controller.get_targets_by_string(command_string)
	if(length(targets))
		controller.add_enemies(targets)
		return TRUE
	return FALSE

/decl/mob_command/follow
	command = "follow"
	sort_order = 4
	keep_processing = TRUE

/decl/mob_command/follow/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	var/weakref/target
	if(findtext(command_string, "me"))
		target = weakref(speaker)
	else
		var/list/targets = controller.get_targets_by_string(command_string)
		if(length(targets == 1))
			target = targets[1]
	if(!target)
		return
	var/datum/mob_command_metadata/cmd = ..()
	if(istype(cmd))
		cmd.target_ref = target

/decl/mob_command/follow/do_process(mob/body, datum/mob_controller/controller, datum/mob_command_metadata/cmd)
	var/atom/target = cmd.target_ref?.resolve()
	if(target)
		body.start_automove(target)
		return TRUE
	return FALSE

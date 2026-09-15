/mob/living/simple_animal/hostile/commanded/nanomachine
	name = "swarm"
	desc = "A cloud of tiny, tiny robots."
	icon = 'icons/mob/simple_animal/nanomachines.dmi'
	natural_weapon = /obj/item/natural_weapon/nanomachine
	max_health = 10
	gene_damage = -1
	response_help_1p = "You wave your hand through $TARGET$."
	response_help_3p = "$USER$ waves $USER_THEIR$ hand through $TARGET$."
	response_harm =    "agitates"
	response_disarm =  "fans at"
	ai = /datum/mob_controller/commanded/nanomachines
	var/regen_time = 0

/datum/mob_controller/commanded/nanomachines
	expected_type = /mob/living/simple_animal/hostile/commanded/nanomachine
	known_commands = list(
		/decl/mob_command/stay,
		/decl/mob_command/stop,
		/decl/mob_command/attack,
		/decl/mob_command/follow,
		/decl/mob_command/heal,
		/decl/mob_command/emergency_protocol
	)
	ai_flags = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS | AI_FLAG_ESCAPE_BUCKLES | AI_FLAG_AGGRESSIVE | AI_FLAG_DESTROYER
	var/emergency_protocols = 0

/decl/mob_command/heal
	command = "heal"
	keep_processing = TRUE

/decl/mob_command/heal/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	var/datum/mob_command_metadata/cmd = ..()
	if(!istype(cmd))
		return
	if(findtext(command_string,"me")) //assumed want heals on master.
		cmd.target_ref = weakref(speaker)
	else
		var/list/targets = controller.get_targets_by_string(command_string)
		if(LAZYLEN(targets) != 1)
			body.say("ERROR. TARGET COULD NOT BE PARSED.")
			return FALSE
		cmd.target_ref = targets[1]
	return TRUE

/decl/mob_command/heal/do_process(mob/body, datum/mob_controller/controller, datum/mob_command_metadata/cmd)

	var/datum/mob_controller/commanded/nanomachines/nanomachines = controller
	if(!istype(nanomachines) || body.current_health <= 3 && !nanomachines.emergency_protocols) //dont die doing this.
		end_command(controller)
		return FALSE

	var/mob/living/target = cmd?.target_ref?.resolve()
	if(!istype(target) || !body.Adjacent(target) || controller.is_attackable(target))
		end_command(controller)
		return FALSE

	if(target.stat || target.current_health >= target.get_max_health()) //he's either dead or healthy, move along.
		end_command(controller)
		return FALSE

	body.visible_message("\The [body] glows green for a moment, healing \the [target]'s wounds.")
	body.take_damage(3)
	target.heal_damage(BRUTE, 5, do_update_health = FALSE)
	target.heal_damage(BURN, 5)
	return TRUE

/decl/mob_command/emergency_protocol
	command = "emergency protocol"
	command_metadata_type = null

/decl/mob_command/emergency_protocol/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	var/datum/mob_controller/commanded/nanomachines/nanomachines = controller
	if(!istype(nanomachines))
		return FALSE
	if(findtext(command_string,"deactivate"))
		if(nanomachines.emergency_protocols)
			body.say("EMERGENCY PROTOCOLS DEACTIVATED.")
		nanomachines.emergency_protocols = FALSE
		return TRUE
	if(findtext(command_string,"activate"))
		if(!nanomachines.emergency_protocols)
			body.say("EMERGENCY PROTOCOLS ACTIVATED.")
		nanomachines.emergency_protocols = TRUE
		return TRUE
	if(findtext(command_string,"check"))
		body.say("EMERGENCY PROTOCOLS [nanomachines.emergency_protocols ? "ACTIVATED" : "DEACTIVATED"].")
		return TRUE
	return FALSE

/obj/item/natural_weapon/nanomachine
	name = "decompilers"
	attack_verb = "swarmed"
	_base_attack_force = 2
	sharp = TRUE

/mob/living/simple_animal/hostile/commanded/nanomachine/get_death_message(gibbed)
	return "dissipates into thin air."

/mob/living/simple_animal/hostile/commanded/nanomachine/get_self_death_message(gibbed)
	return "You have been destroyed."

/mob/living/simple_animal/hostile/commanded/nanomachine/death(gibbed)
	. = ..()
	if(. && !gibbed)
		qdel(src)

/mob/living/simple_animal/hostile/commanded/nanomachine/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	regen_time++
	if(regen_time == 2 && current_health < get_max_health()) //slow regen
		regen_time = 0
		heal_overall_damage(1)

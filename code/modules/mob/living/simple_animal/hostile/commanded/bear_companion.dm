/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."
	icon = 'icons/mob/simple_animal/bear_brown.dmi'
	max_health = 75
	density = TRUE
	natural_weapon = /obj/item/natural_weapon/claws
	max_gas = list(
		/decl/material/gas/chlorine = 2,
		/decl/material/gas/carbon_dioxide = 5
	)
	base_animal_type = /mob/living/simple_animal/hostile/bear // used for language, ignore type
	ai = /datum/mob_controller/commanded/bear

/datum/mob_controller/commanded/bear
	retaliate_str = "$USER$ roars in rage at $TARGET$!"
	known_commands = list(
		/decl/mob_command/stay,
		/decl/mob_command/stop,
		/decl/mob_command/attack,
		/decl/mob_command/follow,
		/decl/mob_command/dance
	)
	ai_flags = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS | AI_FLAG_ESCAPE_BUCKLES | AI_FLAG_AGGRESSIVE | AI_FLAG_TIRES

/decl/mob_command/dance
	command = list("dance", "boogie", "boogy")
	keep_processing = TRUE

/decl/mob_command/dance/execute_command(mob/body, mob/speaker, command_string, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	controller.set_target(null)
	controller.stop_wandering()
	body.stop_automove()
	body.visible_message("\The [body] starts to dance!.")

/decl/mob_command/dance/do_process(mob/body, datum/mob_controller/controller, datum/mob_command_metadata/cmd)

	if(body.incapacitated())
		end_command(controller)
		return

	var/decl/pronouns/pronouns = body.get_pronouns()
	if(world.time >= cmd.command_started + 30 SECONDS)
		body.set_dir(SOUTH)
		body.visible_message("\The [body] bows, finished with [pronouns.his] dance.")
		end_command(controller)
		return TRUE

	var/message = pick(list(
		"moves [pronouns.his] head back and forth!",
		"bobs [pronouns.his] booty!",
		"shakes [pronouns.his] paws in the air!",
		"wiggles [pronouns.his] ears!",
		"taps [pronouns.his] foot!",
		"shrugs [pronouns.his] shoulders!",
		"dances like you've never seen!"
	))
	if(body.dir != WEST)
		body.set_dir(WEST)
	else
		body.set_dir(EAST)
	body.visible_message("\The [body] [message]")
	return TRUE

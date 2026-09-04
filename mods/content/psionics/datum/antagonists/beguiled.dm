/decl/special_role/beguiled
	name = "Beguiled"
	name_plural = "Beguiled"
	welcome_text = "Your mind is no longer solely your own..."
	flags = ANTAG_IMPLANT_IMMUNE

	var/list/minion_controllers = list()

/decl/special_role/beguiled/create_objectives(var/datum/mind/player)
	var/mob/living/controller = minion_controllers["\ref[player]"]
	if(!controller)
		return // Someone is playing with buttons they shouldn't be.
	var/datum/objective/obey = new
	obey.owner = player
	obey.explanation_text = "You are under [controller.real_name]'s glamour, and must follow their commands."
	player.objectives |= obey

/decl/special_role/beguiled/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance, var/mob/new_controller)
	if(!new_controller)
		return FALSE
	. = ..()
	if(.)
		minion_controllers["\ref[player]"] = new_controller

/decl/special_role/beguiled/greet(var/datum/mind/player)
	. = ..()
	var/mob/living/controller = minion_controllers["\ref[player]"]
	if(controller)
		to_chat(player, "<span class='danger'>You have been ensnared by [controller.real_name]'s glamour. Follow their commands.</span>")

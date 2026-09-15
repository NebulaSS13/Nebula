/decl/maneuver/smokescreen
	name = "Smokescreen"
	stamina_cost = 0
	selection_icon_state = "smoke"

/decl/maneuver/smokescreen/ai_should_use(mob/living/user, atom/target)
	return get_dist(user, target) < 5

/decl/maneuver/smokescreen/perform(mob/living/user, atom/target, strength, reflexively)
	if(!(. = ..()))
		return
	if(!istype(user, /mob/living/simple_animal))
		return
	var/mob/living/simple_animal/critter = user
	if(!istype(critter.ability_system))
		return
	critter.set_special_ability_cooldown(critter.ability_cooldown)
	critter.ability_system.set_up(7, 0, get_turf(user))
	critter.ability_system.start()
	return TRUE

/decl/maneuver/smokescreen/show_initial_message(var/mob/living/user, var/atom/target)
	var/decl/pronouns/pronouns = user.get_pronouns()
	user.visible_message(SPAN_DANGER("\The [user] shakes [pronouns.his] wings vigorously!"))

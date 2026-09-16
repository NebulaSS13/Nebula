/decl/maneuver/smokescreen
	name = "Smokescreen"
	stamina_cost = 0
	selection_icon_state = "smoke"

/decl/maneuver/smokescreen/ai_should_use(mob/living/user, atom/target)
	return get_dist(user, target) < 5

/decl/maneuver/smokescreen/perform(mob/living/user, atom/target, strength, reflexively)
	if(!(. = ..()))
		return
	var/datum/effect/effect/system/ability_effect = user.get_attached_effect(/mob/living::MOB_EFFECT_SMOKECREEN)
	if(istype(ability_effect))
		ability_effect.set_up(7, 0, get_turf(user))
		ability_effect.start()
	return TRUE

/decl/maneuver/smokescreen/show_initial_message(var/mob/living/user, var/atom/target)
	var/decl/pronouns/pronouns = user.get_pronouns()
	user.visible_message(SPAN_DANGER("\The [user] shakes [pronouns.his] wings vigorously!"))

/decl/maneuver/teleport/skathari
	teleport_distance = 5
	teleport_style = "danger"

/decl/maneuver/teleport/skathari/ai_should_use(mob/living/user, atom/target)
	return istype(target) && get_dist(user, target) <= max_teleport_range && !user.is_on_special_ability_cooldown()

/decl/maneuver/teleport/skathari/perform(mob/living/user, atom/target, strength, reflexively)
	if((. = ..()) && istype(user, /mob/living/simple_animal))
		var/mob/living/simple_animal/critter = user
		critter.set_special_ability_cooldown(critter.ability_cooldown)

/decl/maneuver/teleport/skathari/soldier
	teleport_distance = 1

/decl/maneuver/teleport/skathari/tyrant
	teleport_distance = 3 // Will encourage mix of ranged and melee attacks.

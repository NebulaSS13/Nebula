/datum/artifact_trigger/force
	name = "kinetic impact"

/datum/artifact_trigger/force/on_hit(obj/item/hit_with, mob/user)
	. = ..()
	if(istype(hit_with, /obj/item/projectile))
		var/obj/item/projectile/hit_projectile = hit_with
		return (hit_projectile.atom_damage_type == BRUTE)
	else if(istype(hit_with, /obj/item))
		return (hit_with.get_attack_force(user) >= 10)

/datum/artifact_trigger/force/on_explosion(severity)
	return TRUE

/datum/artifact_trigger/force/on_bump(atom/movable/bumper)
	. = ..()
	if(isobj(bumper))
		var/obj/bump_object = bumper
		if(bump_object.get_thrown_attack_force() >= 10)
			return TRUE

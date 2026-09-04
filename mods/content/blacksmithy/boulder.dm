/obj/structure/boulder/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/chip_anvil)

/decl/interaction_handler/chip_anvil
	name = "Chip Into Anvil"
	expected_target_type = /obj/structure/boulder
	var/work_skill = SKILL_CONSTRUCTION

/decl/interaction_handler/chip_anvil/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && istype(prop) && IS_PICK(prop) && prop.material?.hardness >= target.get_material()?.hardness && user.skill_check(work_skill, SKILL_BASIC)

/decl/interaction_handler/chip_anvil/invoked(atom/target, mob/user, obj/item/prop)
	user.visible_message(SPAN_NOTICE("\The [user] begins chipping \the [target] into a rough anvil using \the [prop]."))
	if(!user.do_skilled(10 SECONDS, work_skill, target))
		return FALSE
	if(QDELETED(user) || QDELETED(target) || QDELETED(prop) || user.get_active_held_item() != prop || !CanPhysicallyInteractWith(user, target))
		return FALSE
	if(!is_possible(target, user, prop))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] chips \the [target] into a rough anvil using \the [prop]."))
	new /obj/structure/anvil/boulder(get_turf(target), target.get_material()?.type)
	return TRUE

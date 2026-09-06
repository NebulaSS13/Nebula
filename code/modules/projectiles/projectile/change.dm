/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	atom_damage_type = BURN
	damage_flags = 0
	nodamage = 1

/obj/item/projectile/change/on_hit(var/atom/change)
	wabbajack(change)

/obj/item/projectile/change/proc/get_random_transformation_options(var/mob/living/victim)
	. = list()
	if(!isrobot(victim))
		. += "robot"
	for(var/decl/species/species as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/species))
		. += species.uid
	if(ishuman(victim))
		var/mob/living/human/human_victim = victim
		. -= human_victim.species.uid

/obj/item/projectile/change/proc/make_robot(var/mob/living/victim, robot_title = ASSIGNMENT_ROBOT)
	return victim.Robotize(robot_title, skip_qdel = TRUE)

/obj/item/projectile/change/proc/apply_transformation(var/mob/living/victim, var/choice)

	if(choice == "robot")
		return make_robot()

	if(decls_repository.get_decl_by_id(choice))
		var/mob/living/human/human_victim = victim
		if(!istype(human_victim))
			human_victim = new(get_turf(victim))
			human_victim.set_gender(victim.get_gender())
		human_victim.name = "unknown" // This will cause set_species() to randomize the mob name.
		human_victim.real_name = human_victim.name
		human_victim.change_species(choice)
		human_victim.universal_speak = TRUE
		var/datum/preferences/A = new()
		A.randomize_appearance_and_body_for(human_victim)
		return human_victim

/obj/item/projectile/change/proc/wabbajack(var/mob/living/victim)

	if(!isliving(victim) || victim.stat == DEAD)
		return

	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(victim))
		return

	victim.handle_pre_transformation()
	var/choice = pick(get_random_transformation_options(victim))
	var/mob/living/new_mob = apply_transformation(victim, choice)
	if(new_mob)
		new_mob.set_intent(I_FLAG_HARM)
		new_mob.copy_abilities_from(victim)
		transfer_key_from_mob_to_mob(victim, new_mob)
		to_chat(new_mob, "<span class='warning'>Your form morphs into that of \a [choice].</span>")
	else
		new_mob = victim
	if(new_mob)
		to_chat(new_mob, SPAN_WARNING("Your form morphs into that of \a [choice]."))

	if(new_mob != victim && !QDELETED(victim))
		qdel(victim)

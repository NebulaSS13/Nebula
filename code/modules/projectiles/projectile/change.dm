/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	damage_flags = 0
	nodamage = 1

/obj/item/projectile/change/on_hit(var/atom/change)
	wabbajack(change)

/obj/item/projectile/change/proc/get_random_transformation_options(var/mob/M)
	. = list()
	if(!isrobot(M))
		. += "robot"
	for(var/t in get_all_species())
		. += t
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		. -= H.species.name

/obj/item/projectile/change/proc/apply_transformation(var/mob/M, var/choice)

	if(choice == "robot")
		var/mob/living/silicon/robot/R = new(get_turf(M))
		R.set_gender(M.get_gender())
		R.job = ASSIGNMENT_ROBOT
		R.mmi = new /obj/item/mmi(R)
		R.mmi.transfer_identity(M)
		return R

	if(get_species_by_key(choice))
		var/mob/living/carbon/human/H = M
		if(!istype(H))
			H = new(get_turf(M))
			H.set_gender(M.get_gender())
		H.name = "unknown" // This will cause set_species() to randomize the mob name.
		H.real_name = H.name
		H.change_species(choice)
		H.universal_speak = TRUE
		var/datum/preferences/A = new()
		A.randomize_appearance_and_body_for(H)
		return H

/obj/item/projectile/change/proc/wabbajack(var/mob/M)
	if(istype(M, /mob/living) && M.stat != DEAD)
		if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(M))
			return
		M.handle_pre_transformation()
		var/choice = pick(get_random_transformation_options(M))
		var/mob/living/new_mob = apply_transformation(M, choice)
		if(new_mob)
			for (var/spell/S in M.mind.learned_spells)
				new_mob.add_spell(new S.type)
			new_mob.a_intent = "hurt"
			if(M.mind)
				M.mind.transfer_to(new_mob)
			else
				new_mob.key = M.key
			to_chat(new_mob, "<span class='warning'>Your form morphs into that of \a [choice].</span>")

			qdel(M)
		else
			to_chat(M, "<span class='warning'>Your form morphs into that of \a [choice].</span>")

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	scale_max_damage_to_species_health = TRUE
	var/tmp/alive_icon //icon to use when the organ is alive
	var/tmp/dead_icon // Icon to use when the organ has died.
	var/tmp/prosthetic_icon //Icon to use when the organ is robotic
	var/tmp/prosthetic_dead_icon //Icon to use when the organ is robotic and dead
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/damage_reduction = 0.5     //modifier for internal organ injury

/obj/item/organ/internal/Initialize(mapload, material_key, datum/dna/given_dna)
	if(!alive_icon)
		alive_icon = initial(icon_state)
	. = ..()

/obj/item/organ/internal/set_species(species_name)
	. = ..()
	if(species.organs_icon)
		icon = species.organs_icon

/obj/item/organ/internal/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()

	if(!affected)
		log_warning("'[src]' called obj/item/organ/internal/do_install(), but its expected parent organ is null!")

	//The organ may only update and etc if its being attached, or isn't cut away. 
	//Calls up the chain should have set the CUT_AWAY flag already
	if(status & ORGAN_CUT_AWAY)
		LAZYDISTINCTADD(affected.implants, src) //Add us to the detached organs list
		LAZYREMOVE(affected.internal_organs, src)
	else
		STOP_PROCESSING(SSobj, src)
		LAZYREMOVE(affected.implants, src) //Make sure we're not in the implant list anymore
		LAZYDISTINCTADD(affected.internal_organs, src)
		affected.cavity_max_w_class = max(affected.cavity_max_w_class, w_class)
		affected.update_internal_organs_cost()

/obj/item/organ/internal/do_uninstall(in_place, detach, ignore_children, update_icon)
	//Make sure we're removed from whatever parent organ we have, either in a mob or not
	var/obj/item/organ/external/affected
	if(owner)
		affected = GET_EXTERNAL_ORGAN(owner, parent_organ)
	else if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/E = loc
		if(E.organ_tag == parent_organ)
			affected = E
	//We can be removed from a mob even if we have no parents, if we're in a detached state
	if(affected)
		LAZYREMOVE(affected.internal_organs, src)
		affected.update_internal_organs_cost()
	. = ..()

	//Remove it from the implants if we are fully removing, or add it to the implants if we are detaching
	if(affected)
		if((status & ORGAN_CUT_AWAY) && detach)
			LAZYDISTINCTADD(affected.implants, src)
		else
			LAZYREMOVE(affected.implants, src) 

//#TODO: Remove rejuv hacks
/obj/item/organ/internal/remove_rejuv()
	do_uninstall()
	..()

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/robotize(var/company, var/skip_prosthetics = 0, var/keep_organs = 0, var/apply_material = /decl/material/solid/metal/steel, var/check_bodytype, var/check_species)
	. = ..()
	min_bruised_damage += 5
	min_broken_damage += 10

/obj/item/organ/internal/proc/getToxLoss()
	if(BP_IS_PROSTHETIC(src))
		return damage * 0.5
	return damage

/obj/item/organ/internal/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/internal/proc/is_damaged()
	return damage > 0

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/internal/proc/set_max_damage(var/ndamage)
	max_damage = FLOOR(ndamage)
	min_broken_damage = FLOOR(0.75 * max_damage)
	min_bruised_damage = FLOOR(0.25 * max_damage)

/obj/item/organ/internal/take_general_damage(var/amount, var/silent = FALSE)
	take_internal_damage(amount, silent)

/obj/item/organ/internal/proc/take_internal_damage(amount, var/silent=0)
	if(BP_IS_PROSTHETIC(src))
		damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

/obj/item/organ/internal/proc/get_visible_state()
	if(damage > max_damage)
		. = "bits and pieces of a destroyed "
	else if(is_broken())
		. = "broken "
	else if(is_bruised())
		. = "badly damaged "
	else if(damage > 5)
		. = "damaged "
	if(status & ORGAN_DEAD)
		if(can_recover())
			. = "decaying [.]"
		else
			. = "necrotic [.]"
	if(BP_IS_CRYSTAL(src))
		. = "crystalline "
	else if(BP_IS_PROSTHETIC(src))
		. = "mechanical "
	. = "[.][name]"

/obj/item/organ/internal/Process()
	..()
	handle_regeneration()

/obj/item/organ/internal/proc/handle_regeneration()
	if(!damage || BP_IS_PROSTHETIC(src) || !owner || GET_CHEMICAL_EFFECT(owner, CE_TOXIN) || owner.is_asystole())
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)

/obj/item/organ/internal/proc/surgical_fix(mob/user)
	if(damage > min_broken_damage)
		var/scarring = damage/max_damage
		scarring = 1 - 0.3 * scarring ** 2 // Between ~15 and 30 percent loss
		var/new_max_dam = FLOOR(scarring * max_damage)
		if(new_max_dam < max_damage)
			to_chat(user, "<span class='warning'>Not every part of [src] could be saved, some dead tissue had to be removed, making it more suspectable to damage in the future.</span>")
			set_max_damage(new_max_dam)
	heal_damage(damage)

/obj/item/organ/internal/proc/get_scarring_level()
	. = (absolute_max_damage - max_damage)/absolute_max_damage

/obj/item/organ/internal/get_scan_results()
	. = ..()
	var/scar_level = get_scarring_level()
	if(scar_level > 0.01)
		. += "[get_wound_severity(get_scarring_level())] scarring"

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_PROSTHETIC(src))
		return
	switch (severity)
		if (1)
			take_internal_damage(16)
		if (2)
			take_internal_damage(9)
		if (3)
			take_internal_damage(6.5)

/obj/item/organ/internal/on_update_icon()
	. = ..()
	if(BP_IS_PROSTHETIC(src) && prosthetic_icon)
		icon_state = ((status & ORGAN_DEAD) && prosthetic_dead_icon)? 	prosthetic_dead_icon : prosthetic_icon 
	else
		icon_state = ((status & ORGAN_DEAD) && dead_icon)? 				dead_icon : alive_icon

/obj/item/organ/internal/is_internal()
	return TRUE

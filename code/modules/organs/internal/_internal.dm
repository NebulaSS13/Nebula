/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	scale_max_damage_to_species_health = TRUE
	var/dead_icon // Icon to use when the organ has died.
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/damage_reduction = 0.5     //modifier for internal organ injury

/obj/item/organ/internal/Initialize(mapload, datum/dna/given_dna)
	if(max_damage)
		min_bruised_damage = FLOOR(max_damage / 4)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL && owner)
		var/obj/item/organ/external/E = owner.get_organ(parent_organ)
		if(!E)
			PRINT_STACK_TRACE("[src] spawned in [owner] without a parent organ: [parent_organ].")
			return INITIALIZE_HINT_QDEL
		E.cavity_max_w_class = max(E.cavity_max_w_class, w_class)
		E.update_contained_organs_cost()

/obj/item/organ/internal/Destroy()
	if(owner)
		var/obj/item/organ/external/E = owner.get_organ(parent_organ)
		if(istype(E))
			LAZYREMOVE(E.contained_organs, src)
	return ..()

/obj/item/organ/internal/set_dna(var/datum/dna/new_dna)
	..()
	if(species && species.organs_icon)
		icon = species.organs_icon

//disconnected the organ from it's owner but does not remove it, instead it becomes an implant that can be removed with implant surgery
//TODO move this to organ/internal once the FPB port comes through
/obj/item/organ/proc/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent) && remove_organ(user, FALSE)) //TODO ensure that we don't have to check parent.
		LAZYADD(parent.implants, src)

/obj/item/organ/internal/remove_organ(var/mob/living/user, var/drop_organ=1, var/detach=1)
	if(owner && owner.handle_internal_organ_removed(src, user) && detach)
		var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
		if(affected)
			LAZYREMOVE(affected.contained_organs, src)
			status |= ORGAN_CUT_AWAY
	. = ..()

/obj/item/organ/internal/replace_organ(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)

	if(!istype(target) || (status & ORGAN_CUT_AWAY))
		return FALSE //organs don't work very well in the body when they aren't properly attached

	. = ..()

	if(. && owner && owner.handle_internal_organ_replaced(src))
		// robotic organs emulate behavior of the equivalent flesh organ of the species
		if(BP_IS_PROSTHETIC(src) || !species)
			species = owner.get_species() || global.using_map.default_species
		STOP_PROCESSING(SSobj, src)
		if(!affected)
			affected = owner.get_organ(parent_organ)
		if(affected)
			LAZYDISTINCTADD(affected.contained_organs, src)

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/robotize_organ(var/company = /decl/prosthetics_manufacturer, var/keep_organs, var/apply_material = /decl/material/solid/metal/steel)
	..()
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
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
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
	else if(BP_IS_ASSISTED(src))
		. = "assisted "
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
	. = (initial(max_damage) - max_damage)/initial(max_damage)

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

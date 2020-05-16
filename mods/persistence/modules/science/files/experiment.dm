/datum/computer_file/data/experiment
	filetype = "EXP"
	do_not_edit = TRUE
	var/id				// A unique ID that identifies this experiment.
	var/multiplier		// 1-3. 1 being lesser, 3 being greater, 2 being moderate.
	var/attribute		// The target attribute. "instability", "efficiency", "speed", "compression", "power_efficiency"
	var/list/tech_levels = list()	// The list of required tech levels to complete this experiment.
	var/weakref/target_blueprint	// The blueprint this experiment is tailored for.
	var/in_progress		// Whether or not this is an active experiment.
	
/datum/computer_file/data/experiment/New()
	..()
	id = "[sequential_id("datum/computer_file/data/experiment")]"
	filename = replacetext(uniqueness_repository.Generate(/datum/uniqueness_generator/phrase), " ", "_")

// Validates that this experiment is now active.
/datum/computer_file/data/experiment/proc/begin()
	in_progress = TRUE
	size = calculate_size()

/datum/computer_file/data/experiment/calculate_size()
	if(!in_progress)
		return multiplier
	return multiplier ** 2

/datum/computer_file/data/experiment/should_save()
	return in_progress // Experiments in progress are saved.

/datum/computer_file/data/experiment/proc/experiment_meets_prereqs(var/obj/item/experiment/E)
	var/list/e_levels = E.get_tech_levels()
	for(var/e_level in e_levels)
		if(e_level in tech_levels)
			if(tech_levels[e_level] > e_levels[e_level])
				return FALSE
	return TRUE

/datum/computer_file/data/experiment/proc/finish(var/obj/item/experiment/E, var/mob/user)
	var/datum/computer_file/data/blueprint/blueprint = target_blueprint.resolve()
	if(!istype(blueprint))
		to_chat(user, SPAN_WARNING("The blueprint attached to this experiment is missing. Is it accessible on the network or deleted?"))
		return FALSE
	if(blueprint.holder.used_capacity >= blueprint.holder.max_capacity)
		to_chat(user, SPAN_WARNING("The device storing the blueprint has insufficient disk space to upgrade the blueprint."))
		return FALSE

	// Check instability
	var/overage = 0
	var/list/e_levels = E.get_tech_levels()
	for(var/e_level in e_levels)
		var/req_level = 0
		if(e_level in tech_levels)
			req_level = tech_levels[e_level]
		overage += abs(req_level - e_levels[e_level])
	overage = max(0, overage - user.get_skill_value(SKILL_SCIENCE))
	blueprint.instability += overage

	// Adjust other modifiers.
	var/modifier = multiplier + (multiplier * (user.get_skill_value(SKILL_SCIENCE) / 10))
	switch(attribute)
		if("instability")
			blueprint.instability = max(0, blueprint.instability - modifier)
		if("efficiency")
			blueprint.efficiency = min(10, blueprint.efficiency + modifier)
		if("speed")
			blueprint.speed = min(10, blueprint.speed + modifier)
		if("compression")
			blueprint.compression = min(10, blueprint.compression + modifier)
		if("power_efficiency")
			blueprint.power_efficiency = min(10, blueprint.power_efficiency + modifier)	
	blueprint.complexity += 1
	blueprint.calculate_size()
	return TRUE

	
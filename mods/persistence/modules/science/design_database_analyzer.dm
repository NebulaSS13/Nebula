/obj/machinery/destructive_analyzer/attackby(var/obj/item/O, var/mob/user)
	if(isrobot(user))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src] is busy right now."))
		return TRUE
	if(component_attackby(O, user))
		return TRUE
	if(loaded_item)
		to_chat(user, SPAN_WARNING("There is something already loaded into \the [src]."))
		return TRUE
	if(panel_open)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
		return TRUE
	if(!istype(O, /obj/item/experiment))
		if(!O.origin_tech)
			to_chat(user, SPAN_WARNING("Nothing can be learned from \the [O]."))
			return TRUE
		var/list/techlvls = json_decode(O.origin_tech)
		if(!length(techlvls) || O.holographic)
			to_chat(user, SPAN_WARNING("You cannot deconstruct this item."))
			return TRUE

	if(user.unEquip(O, src))
		busy = TRUE
		loaded_item = O
		to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]."))
		flick("d_analyzer_la", src)
		addtimer(CALLBACK(src, .proc/refresh_busy, 1 SECOND))
		return TRUE

/obj/machinery/destructive_analyzer/process_loaded(var/mob/user, var/datum/file_storage/file_source)
	if(!loaded_item)
		return
	// Process the item.
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(!network)
		return

	var/analyze_successful = FALSE
	if(istype(loaded_item, /obj/item/experiment))
		// Special handler. We need to disassemble the experiment.
		analyze_successful = process_experiment(loaded_item, user, file_source)
	else
		// This is just a normal item.
		if(!(loaded_item.type in SSfabrication.recipes_by_product_type))
			to_chat(user, SPAN_WARNING("Unable to analyze \the [loaded_item]. No valid recipe found."))
			return
		var/datum/fabricator_recipe/recipe = SSfabrication.recipes_by_product_type[loaded_item.type]
		if(!istype(recipe))
			to_chat(user, SPAN_WARNING("Unable to analyze \the [loaded_item]. Recipe corrupted."))
			return
		var/datum/computer_file/data/blueprint/BP = new(null, recipe)
		// for(var/datum/extension/network_device/mainframe/MF in network.get_mainframes_by_role(MF_ROLE_DESIGN, user))
		if(file_source.store_file(BP))
			analyze_successful = TRUE
			to_chat(user, SPAN_NOTICE("\The [src] pings and reports that through invention it managed to produce a blueprint for [BP.recipe.name]."))
		else
			to_chat(user, SPAN_WARNING("Insufficient disk space to store blueprint. Need at least [BP.size] GQ."))
		if(!analyze_successful)
			QDEL_NULL(BP)
	if(!analyze_successful)
		return
	busy = TRUE

	QDEL_NULL(loaded_item)
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, .proc/refresh_busy, 2 SECONDS))

/obj/machinery/destructive_analyzer/proc/process_experiment(var/obj/item/experiment/E, var/mob/user, var/datum/file_storage/file_source)
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(E.experiment_id)
		// This was a proper experiment.
		// Find the experiment first.
		var/datum/computer_file/data/experiment/experiment = file_source.get_file(E.experiment_id)
		if(!istype(experiment))
			for(var/datum/computer_file/data/experiment/e_file in network.get_all_files_of_type(/datum/computer_file/data/experiment, MF_ROLE_DESIGN, user))
				if(e_file.id != E.experiment_id)
					continue
				experiment = e_file
				break
		if(istype(experiment))
			// This is the matching file.
			if(!experiment.experiment_meets_prereqs(E))
				to_chat(user, SPAN_WARNING("Experiment does not meet prerequisites to complete research."))
				return FALSE
			return experiment.finish(E)
		// We didn't find the matching file.
		to_chat(user, SPAN_WARNING("Unable to find corresponding experiment. Was the file moved or deleted?"))
		return FALSE
	else
		// This was just invention.
		var/invention_technology = E.get_tech_levels()
		var/list/possible_recipes = list()
		for(var/fab_type in SSfabrication.all_recipes)
			for(var/datum/fabricator_recipe/recipe in SSfabrication.all_recipes[fab_type])
				for(var/req_tech in recipe.required_technology)
					if(!(req_tech in invention_technology))
						continue
					if(invention_technology[req_tech] < recipe.required_technology[req_tech])
						continue
					possible_recipes |= recipe
		var/datum/fabricator_recipe/acquired_recipe = pick(possible_recipes)
		if(!istype(acquired_recipe))
			to_chat(user, SPAN_NOTICE("\The [src] beeps and reports that no viable design was able to be made from the experiment."))
			return TRUE // No matching recipes found
		var/datum/computer_file/data/blueprint/BP = new(null, acquired_recipe)
		if(file_source.store_file(BP))
			to_chat(user, SPAN_NOTICE("\The [src] pings and reports that through invention it managed to produce a blueprint for [acquired_recipe.name]."))
			return TRUE
		else
			to_chat(user, SPAN_WARNING("\The [src] beeps, it has insufficient disk space to process its results. Need at least [BP.size] GQ."))
		return FALSE

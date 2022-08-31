/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_INJECT
	var/mob/living/parent
	var/last_metabolize_time = 0

/datum/reagents/metabolism/clear_reagent(var/reagent_type, var/defer_update = FALSE, var/force = FALSE)
	. = ..()
	if(.)
		var/decl/material/current = GET_DECL(reagent_type)
		current.on_leaving_metabolism(parent, metabolism_class)

/datum/reagents/metabolism/New(var/max = 100, mob/living/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	if(parent && world.time > last_metabolize_time)
		last_metabolize_time = world.time // prevents mobs that reuse a holder between functions (ingested/injected) from metabolizing twice in a tick
		for(var/decl/material/R as anything in reagent_volumes)
			R.on_mob_life(parent, metabolism_class, src)
		update_total()
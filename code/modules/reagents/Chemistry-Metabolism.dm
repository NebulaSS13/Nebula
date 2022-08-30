/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_INJECT
	var/mob/living/parent

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

/datum/reagents/metabolism/proc/metabolize(var/list/dosage_tracker)
	if(!parent || total_volume < MINIMUM_CHEMICAL_VOLUME || !length(reagent_volumes))
		return
	for(var/rtype in reagent_volumes)
		var/decl/material/current = GET_DECL(rtype)
		current.on_mob_life(parent, metabolism_class, src, dosage_tracker)
	update_total()

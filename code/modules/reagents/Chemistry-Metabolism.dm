/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_INJECT
	var/mob/living/parent

/datum/reagents/metabolism/clear_reagent(var/decl/material/reagent, var/defer_update = FALSE, var/force = FALSE)
	// Duplicated check so that reagent data is accessible in on_leaving_metabolism.
	reagent = RESOLVE_TO_DECL(reagent)
	if(force || !!(REAGENT_VOLUME(src, reagent) || REAGENT_DATA(src, reagent)))
		reagent.on_leaving_metabolism(src)
	. = ..()

/datum/reagents/metabolism/New(var/max = 100, mob/living/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/Destroy()
	parent = null
	return ..()

/datum/reagents/metabolism/proc/metabolize(list/dosage_tracker)
	if(!parent || total_volume < MINIMUM_CHEMICAL_VOLUME || !length(reagent_volumes))
		return
	for(var/decl/material/reagent as anything  in reagent_volumes)
		reagent.on_mob_life(parent, metabolism_class, src, dosage_tracker)
	update_total()

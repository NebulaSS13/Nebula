/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_INJECT
	var/mob/living/carbon/parent

/datum/reagents/metabolism/clear_reagent(var/reagent_type)
	if(REAGENT_VOLUME(src, reagent_type))
		var/decl/material/current = decls_repository.get_decl(reagent_type)
		current.on_leaving_metabolism(parent, metabolism_class)
	. = ..()

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	if(parent)
		var/metabolism_type = 0 //non-human mobs
		if(ishuman(parent))
			var/mob/living/carbon/human/H = parent
			metabolism_type = H.species.reagent_tag
		for(var/rtype in reagent_volumes)
			var/decl/material/current = decls_repository.get_decl(rtype)
			current.on_mob_life(parent, metabolism_type, metabolism_class, src)
		update_total()
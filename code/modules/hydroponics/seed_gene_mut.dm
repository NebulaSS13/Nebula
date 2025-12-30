/datum/seed/proc/diverge_mutate_gene(var/decl/plant_gene/gene, var/atom/location)
	if(!istype(gene))
		log_debug("Attempted to mutate [src] with a non-plantgene var.")
		return src

	var/datum/seed/seed = diverge()	//Let's not modify all of the seeds.
	location.visible_message("<span class='notice'>\The [seed.display_name] quivers!</span>")	//Mimicks the normal mutation.
	gene.mutate(seed, location)

	return seed


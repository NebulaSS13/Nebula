/datum/seed/proc/diverge_mutate_gene(var/decl/plant_gene/G, var/turf/T)
	if(!istype(G))
		log_debug("Attempted to mutate [src] with a non-plantgene var.")
		return src

	var/datum/seed/S = diverge()	//Let's not modify all of the seeds.
	T.visible_message("<span class='notice'>\The [S.display_name] quivers!</span>")	//Mimicks the normal mutation.
	G.mutate(S, T)

	return S


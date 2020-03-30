/datum/geosample
	var/age = 0
	var/age_thousand = 0
	var/age_million = 0
	var/age_billion = 0
	var/artifact_id = ""
	var/artifact_distance = -1
	var/source_mineral = /datum/reagent/toxin/chlorine
	var/list/find_presence = list()

/datum/geosample/New(var/turf/simulated/mineral/container)
	UpdateTurf(container)

/datum/geosample/proc/UpdateTurf(var/turf/simulated/mineral/container)
	if(!istype(container))
		return

	age = rand(1, 999)

	if(container.mineral)
		if(islist(container.mineral.xarch_ages))
			var/list/ages = container.mineral.xarch_ages
			if(ages["thousand"])
				age_thousand = rand(1, ages["thousand"])
			if(ages["million"])
				age_million = rand(1, ages["million"])
			if(ages["billion"])
				if(ages["billion_lower"])
					age_billion = rand(ages["billion_lower"], ages["billion"])
				else
					age_billion = rand(1, ages["billion"])
		if(container.mineral.xarch_source_mineral)
			source_mineral = container.mineral.xarch_source_mineral

	if(prob(75))
		find_presence[/datum/reagent/phosphorus] = rand(1, 500) / 100
	if(prob(25))
		find_presence[/datum/reagent/mercury] = rand(1, 500) / 100
	find_presence[/datum/reagent/toxin/chlorine] = rand(500, 2500) / 100

	for(var/datum/find/F in container.finds)
		var/responsive_reagent = get_responsive_reagent(F.find_type)
		find_presence[responsive_reagent] = F.dissonance_spread

	var/total_presence = 0
	for(var/carrier in find_presence)
		total_presence += find_presence[carrier]
	for(var/carrier in find_presence)
		find_presence[carrier] = find_presence[carrier] / total_presence

/datum/geosample/proc/UpdateNearbyArtifactInfo(var/turf/simulated/mineral/container)
	if(!container || !istype(container))
		return

	if(container.artifact_find)
		artifact_distance = rand()
		artifact_id = container.artifact_find.artifact_id
	else
		for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
			if(T.artifact_find)
				var/cur_dist = get_dist(container, T) * 2
				if( (artifact_distance < 0 || cur_dist < artifact_distance))
					artifact_distance = cur_dist + rand() * 2 - 1
					artifact_id = T.artifact_find.artifact_id
			else
				SSxenoarch.artifact_spawning_turfs.Remove(T)


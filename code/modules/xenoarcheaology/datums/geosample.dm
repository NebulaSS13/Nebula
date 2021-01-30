/datum/extension/geological_data
	base_type = /datum/extension/geological_data
	var/datum/geosample/geodata

/datum/extension/geological_data/proc/set_data(datum/geosample/new_data)
	geodata = new_data

/datum/extension/geological_data/New(datum/holder, datum/geosample/new_data)	
	..()
	if(new_data)
		set_data(new_data)
		return
	var/turf/exterior/wall/container = holder
	if(istype(container))
		geodata = new(container)

/datum/geosample
	var/age = 0
	var/artifact_id
	var/artifact_distance
	var/source_mineral = /decl/material/gas/chlorine
	var/list/find_presence = list()

/datum/geosample/New(var/turf/exterior/wall/container)
	if(!istype(container))
		return

	age = rand(1, 999)

	if(container?.reinf_material?.xarch_source_mineral)
		source_mineral = container.reinf_material.xarch_source_mineral

	var/total_presence = 0
	for(var/datum/find/F in container.finds)
		var/responsive_reagent = F.get_responsive_reagent()
		find_presence[responsive_reagent] = F.dissonance_spread
		total_presence += F.dissonance_spread
	for(var/carrier in find_presence)
		find_presence[carrier] = find_presence[carrier] / total_presence

/datum/geosample/proc/UpdateNearbyArtifactInfo(var/turf/exterior/wall/container)
	if(!istype(container))
		return

	if(container.artifact_find)
		artifact_distance = rand()
		artifact_id = container.artifact_find.artifact_id
	else
		var/list/artifact = SSxenoarch.get_nearest_artifact(container)
		if(artifact)
			artifact_id = artifact[1]
			artifact_distance = artifact[2]

/datum/geosample/proc/get_copy()
	var/datum/geosample/child = new()
	child.age = age
	child.artifact_id = artifact_id
	child.artifact_distance = artifact_distance
	child.source_mineral = source_mineral
	child.find_presence = find_presence.Copy()
	return child
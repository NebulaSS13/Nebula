/obj/structure/flora/plant/ShouldSerialize(_age)
	var/datum/seed/serde_plant = istext(plant) ? SSplants.seeds[plant] : plant
	return istype(serde_plant) && serde_plant.roundstart && ..(_age)

/obj/structure/flora/plant/Serialize()
	. = ..()
	if(istype(plant) && plant.name != initial(plant))
		.[nameof(/obj/structure/flora/plant::plant)] = plant.name

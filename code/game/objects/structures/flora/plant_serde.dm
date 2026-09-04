/obj/structure/flora/plant/ShouldSerialize(_age)
	return plant?.roundstart && ..(_age)

/obj/structure/flora/plant/Serialize()
	. = ..()
	if(plant && plant.name != initial(plant))
		.[nameof(/obj/structure/flora/plant::plant)] = plant.name

/obj/random/seaweed
	name = "random seaweed"
	desc = "This is some random seaweed."
	icon = 'icons/obj/structures/plants.dmi'
	icon_state = "seaweed"

/obj/random/seaweed/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/structure/flora/seaweed       = 3,
		/obj/structure/flora/seaweed/mid   = 3,
		/obj/structure/flora/seaweed/large = 2,
		/obj/structure/flora/seaweed/glow  = 1
	)
	return spawnable_choices

/obj/random/pottedplant
	name = "random potted plant"
	desc = "This is a random potted plant."
	icon = 'icons/obj/structures/potted_plants.dmi'
	icon_state = "plant-26"
	spawn_nothing_percentage = 0

/obj/random/pottedplant/spawn_choices()
	var/static/list/spawnable_choices = subtypesof(/obj/structure/flora/pottedplant) - list(/obj/structure/flora/pottedplant/unusual)
	return spawnable_choices

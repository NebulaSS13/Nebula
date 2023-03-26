/turf/exterior/meat
	name = "fleshy ground"
	icon = 'icons/turf/flooring/flesh.dmi'
	icon_state = "flesh"
	dirt_color = "#c40031"
	flooring_layers = /decl/flooring/meat

/decl/flooring/meat
	name = "fleshy ground"
	icon = 'icons/turf/flooring/flesh.dmi'
	icon_base = "flesh"
	desc = "It's disgustingly soft to the touch. And warm. Too warm."
	footstep_type = /decl/footsteps/mud
	diggable_resources = list(/obj/item/stack/material/ore/meat = list(3, 2))

/turf/exterior/meat/acid
	name         = "juices"
	desc         = "Half-digested chunks of vines are floating in the puddle of some liquid."
	gender       = PLURAL
	reagent_type = /decl/material/liquid/acid/stomach
	height       = -(FLUID_SHALLOW)

/decl/flooring/stomach_acid
	name = "juices"
	desc = "Half-digested chunks of vines are floating in the puddle of some liquid."
	color = "#c7c27c"
	icon = 'icons/turf/flooring/water_still.dmi'
	icon_base = "water"

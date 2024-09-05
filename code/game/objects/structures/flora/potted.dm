////////////////////////////////////////
// Potted Plants
////////////////////////////////////////
/obj/structure/flora/pottedplant
	name         = "potted plant"
	desc         = "Really brings the room together."
	icon         = 'icons/obj/structures/potted_plants.dmi'
	icon_state   = "plant-01"
	anchored     = FALSE
	layer        = ABOVE_HUMAN_LAYER
	w_class      = ITEM_SIZE_LARGE
	remains_type = /obj/effect/decal/cleanable/dirt
	hitsound     = 'sound/effects/glass_crack2.ogg'
	snd_cut      = 'sound/effects/break_ceramic.ogg'
	material     = /decl/material/solid/stone/pottery
	matter       = list(
		/decl/material/solid/clay                = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/sand                = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plantmatter = MATTER_AMOUNT_SECONDARY,     //#TODO: Maybe eventually drop the plant, or some seeds or something?
	)

/obj/structure/flora/pottedplant/get_material_health_modifier()
	return 0.80

//potted plants credit: Flashkirby
//potted plants 27-30: Cajoes
/obj/structure/flora/pottedplant/fern
	name = "potted fern"
	desc = "This is an ordinary looking fern. It looks like it could do with some water."
	icon_state = "plant-02"

/obj/structure/flora/pottedplant/overgrown
	name = "overgrown potted plants"
	desc = "This is an assortment of colourful plants. Some parts are overgrown."
	icon_state = "plant-03"

/obj/structure/flora/pottedplant/bamboo
	name = "potted bamboo"
	desc = "These are bamboo shoots. The tops looks like they've been cut short."
	icon_state = "plant-04"

/obj/structure/flora/pottedplant/largebush
	name = "large potted bush"
	desc = "This is a large bush. The leaves stick upwards in an odd fashion."
	icon_state = "plant-05"

/obj/structure/flora/pottedplant/thinbush
	name = "thin potted bush"
	desc = "This is a thin bush. It appears to be flowering."
	icon_state = "plant-06"

/obj/structure/flora/pottedplant/mysterious
	name = "mysterious potted bulbs"
	desc = "This is a mysterious looking plant. Touching the bulbs cause them to shrink."
	icon_state = "plant-07"

/obj/structure/flora/pottedplant/smalltree
	name = "small potted tree"
	desc = "This is a small tree. It is rather pleasant."
	icon_state = "plant-08"

/obj/structure/flora/pottedplant/unusual
	name = "unusual potted plant"
	desc = "This is an unusual plant. Its bulbous ends emit a soft blue light."
	icon_state = "plant-09"

/obj/structure/flora/pottedplant/unusual/Initialize()
	. = ..()
	set_light(l_range = 2, l_power = 2, l_color = "#007fff")

/obj/structure/flora/pottedplant/orientaltree
	name = "potted oriental tree"
	desc = "This is a rather oriental style tree. Its flowers are bright pink."
	icon_state = "plant-10"

/obj/structure/flora/pottedplant/smallcactus
	name = "small potted cactus"
	desc = "This is a small cactus. Its needles are sharp."
	icon_state = "plant-11"

/obj/structure/flora/pottedplant/tall
	name = "tall potted plant"
	desc = "This is a tall plant. Tiny pores line its surface."
	icon_state = "plant-12"

/obj/structure/flora/pottedplant/sticky
	name = "sticky potted plant"
	desc = "This is an odd plant. Its sticky leaves trap insects."
	icon_state = "plant-13"

/obj/structure/flora/pottedplant/smelly
	name = "smelly potted plant"
	desc = "This is some kind of tropical plant. It reeks of rotten eggs."
	icon_state = "plant-14"

/obj/structure/flora/pottedplant/small
	name = "small potted plant"
	desc = "This is a pot of assorted small flora. Some look familiar."
	icon_state = "plant-15"

/obj/structure/flora/pottedplant/aquatic
	name = "aquatic potted plant"
	desc = "This is apparently an aquatic plant. It's probably fake."
	icon_state = "plant-16"

/obj/structure/flora/pottedplant/shoot
	name = "small potted shoot"
	desc = "This is a small shoot. It still needs time to grow."
	icon_state = "plant-17"

/obj/structure/flora/pottedplant/flower
	name = "potted flower"
	desc = "This is a slim plant. Sweet smelling flowers are supported by spindly stems."
	icon_state = "plant-18"

/obj/structure/flora/pottedplant/crystal
	name = "crystalline potted plant"
	desc = "These are rather cubic plants. Odd crystal formations grow on the end."
	icon_state = "plant-19"

/obj/structure/flora/pottedplant/subterranean
	name = "subterranean potted plant"
	desc = "This is a subterranean plant. Its bulbous ends glow faintly."
	icon_state = "plant-20"

/obj/structure/flora/pottedplant/subterranean/Initialize()
	. = ..()
	set_light(l_range = 1, l_power = 0.5, l_color = "#ff6633")

/obj/structure/flora/pottedplant/minitree
	name = "potted tree"
	desc = "This is a miniature tree. Apparently it was grown to 1/5 scale."
	icon_state = "plant-21"

/obj/structure/flora/pottedplant/stoutbush
	name = "stout potted bush"
	desc = "This is a stout bush. Its leaves point up and outwards."
	icon_state = "plant-22"

/obj/structure/flora/pottedplant/drooping
	name = "drooping potted plant"
	desc = "This is a small plant. The drooping leaves make it look like its wilted."
	icon_state = "plant-23"

/obj/structure/flora/pottedplant/tropical
	name = "tropical potted plant"
	desc = "This is some kind of tropical plant. It hasn't begun to flower yet."
	icon_state = "plant-24"

/obj/structure/flora/pottedplant/dead
	name = "dead potted plant"
	desc = "This is the dried up remains of a dead plant. Someone should replace it."
	icon_state = "plant-25"

/obj/structure/flora/pottedplant/large
	name = "large potted plant"
	desc = "This is a large plant. Three branches support pairs of waxy leaves."
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/decorative
	name = "decorative potted plant"
	desc = "This is a decorative shrub. It's been trimmed into the shape of an apple."
	icon_state = "applebush"

/obj/structure/flora/pottedplant/deskfern
	name = "fancy ferny potted plant"
	desc = "This leafy desk fern could do with a trim."
	icon_state = "plant-27"

/obj/structure/flora/pottedplant/floorleaf
	name = "fancy leafy floor plant"
	desc = "This plant has remarkably waxy leaves."
	icon_state = "plant-28"

/obj/structure/flora/pottedplant/deskleaf
	name = "fancy leafy potted desk plant"
	desc = "A tiny waxy leafed plant specimen."
	icon_state = "plant-29"

/obj/structure/flora/pottedplant/deskferntrim
	name = "fancy trimmed ferny potted plant"
	desc = "This leafy desk fern seems to have been trimmed too much."
	icon_state = "plant-30"

/mob/living/simple_animal/passive/savik
	name = "savik"
	desc = "savik"
	icon = 'icons/mob/simple_animal/savik.dmi'

/mob/living/simple_animal/passive/kururak
	name = "kururak"
	desc = "A large animal with sleek fur."
	icon = 'icons/mob/simple_animal/kururak.dmi'
	default_pixel_x = -16
	max_health = 200
	var/instinct = 25 // weighting when selecting a leader

/mob/living/simple_animal/passive/kururak/leader
	max_health = 250
	instinct = 50

/mob/living/simple_animal/passive/kururak/hibernate
	instinct = 0

/mob/living/simple_mob/animal/sif/kururak/hibernate/Initialize()
	. = ..()
	set_posture(/decl/posture/lying)

/mob/living/simple_animal/passive/glitterfly
	name = "glitterfly"
	desc = "A large, shiny butterfly!"
	icon = 'icons/mob/simple_animal/glitterfly.dmi'

/mob/living/simple_animal/passive/glitterfly/rare
	name = "sparkling glitterfly"
	desc = "A large, incredibly shiny butterfly!"
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	max_health = 30

/mob/living/simple_animal/passive/frostfly
	name = "frostfly"
	desc = "A large insect with glittering wings."
	icon = 'icons/mob/simple_animal/frostfly.dmi'

/mob/living/simple_animal/passive/sakimm
	name = "sakimm"
	desc = "What appears to be an oversized rodent with hands."
	icon = 'icons/mob/simple_animal/sakimm.dmi'

/mob/living/simple_animal/passive/tymisian
	name = "\improper Tymisian moth"
	desc = "A huge, fuzzy insect with a disorienting dust."
	icon = 'icons/mob/simple_animal/tymisian.dmi'

/mob/living/simple_animal/passive/karik
	name = "karik"
	desc = "A fox-like creature from the coastal dunes of Meralar, known for its ear-piercing cry."
	icon = 'icons/mob/simple_animal/karik.dmi'

/mob/living/simple_animal/passive/penguin
	name = "penguin"
	desc = "An ungainly, waddling, cute, and VERY well-dressed bird."
	icon = 'icons/mob/simple_animal/penguin.dmi'

/mob/living/simple_animal/passive/crab/sif/Initialize()
	. = ..()
	set_scale(rand(5,12) / 10)

/mob/living/simple_animal/passive/crab/hooligan
	name = "hooligan crab"
	desc = "A large, hard-shelled crustacean. This one is mostly grey. You probably shouldn't mess with it."
	icon = 'icons/mob/simple_animal/hooligan_crab.dmi'

/mob/living/simple_animal/passive/crab/hooligan/Initialize()
	. = ..()
	set_scale(1.5)
// Dummy effects used for vis_contents on burning atoms.
/obj/effect/fire
	name             = ""
	simulated        = FALSE
	anchored         = TRUE
	density          = FALSE
	opacity          = FALSE
	mouse_opacity    = MOUSE_OPACITY_UNCLICKABLE
	icon             = 'icons/effects/fire.dmi'
	icon_state       = "atom_small"
	layer            = ABOVE_LIGHTING_LAYER
	plane            = ABOVE_LIGHTING_PLANE
	appearance_flags = RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA

/obj/effect/fire/medium
	icon_state = "atom_medium"

/obj/effect/fire/large
	icon_state = "atom_large"

/obj/effect/fire/turf_large
	icon_state = "turf_large"

/obj/effect/fire/ember
	icon_state = "spark"

/obj/effect/fire/ember/Initialize(var/ml, var/turf/target)
	. = ..()
	QDEL_IN(src, 1 SECOND)
	if(target)
		spawn(1)
			forceMove(target)

// Lighting and sound atom.
/atom/movable/fire_effects
	invisibility  = INVISIBILITY_SYSTEM
	simulated     = FALSE
	anchored      = TRUE
	density       = FALSE
	opacity       = FALSE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	var/datum/composite_sound/fire_crackles/soundloop

/atom/movable/fire_effects/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)
	set_light(3, 0.7, COLOR_ORANGE)

/obj/item/oar
	name = "oar"
	icon = 'icons/obj/items/oar.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL
	desc = "Used to provide propulsion to a boat."
	sharp = FALSE
	edge = FALSE
	_base_attack_force = 12 // bonk

/obj/item/oar/can_float_on_liquids()
	return TRUE

/obj/structure/vehicle/boat
	name = "boat"
	desc = "It's a wooden boat. Looks like it'll hold two people. Oars not included."
	icon = 'icons/obj/structures/boat.dmi'
	icon_state = ICON_STATE_WORLD
	max_health = 100
	pixel_x = -2
	layer = ABOVE_HUMAN_LAYER
	key_type = /obj/item/oar
	requires_fluid_depth = FLUID_SHALLOW
	pilot_verb = "pilot"
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/structure/vehicle/boat/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	buckle_pixel_shift = list(
		"[NORTH]" = list("x" = 0, "y" = 4, "z" = 0),
		"[SOUTH]" = list("x" = 0, "y" = 7, "z" = 0),
		"[EAST]"  = list("x" = 0, "y" = 7, "z" = 0),
		"[WEST]"  = list("x" = 0, "y" = 7, "z" = 0)
	)

/obj/structure/vehicle/boat/check_pilot_can_pilot(mob/pilot)
	return pilot.adjust_stamina(-10)

/obj/structure/vehicle/boat/can_float_on_liquids()
	return TRUE // Health check for damage causing leaks?

/obj/structure/vehicle/boat/dragon
	name = "dragon boat"
	desc = "It's a large wooden boat, carved to have a nordic-looking dragon on the front. Looks like it'll hold five people. Oars not included."
	max_health = 250
	icon = 'icons/obj/structures/boat_dragon.dmi'
	pixel_x = -16

/obj/structure/vehicle/boat/dragon/on_update_icon()
	. = ..()
	underlays.Cut()
	underlays += image(icon = icon, icon_state = "[icon_state]-underlay", layer = MOB_SHADOW_LAYER-0.01)

/*
 * Travois used to drag mobs in low-tech settings.
 */
/obj/structure/travois
	name = "travois"
	desc = "An assemblage of sticks, commonly used to make it easier to transport animal carcasses."
	anchored = FALSE
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/structures/travois.dmi'
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = TRUE
	buckle_sound = 'sound/effects/buckle.ogg'
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 6)
	obj_flags = OBJ_FLAG_SUPPORT_MOB
	movable_flags = MOVABLE_FLAG_WHEELED
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	user_comfort = 0
	parts_amount = 1
	parts_type = /obj/item/stack/material/log
	material_alteration = MAT_FLAG_ALTERATION_ALL
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color

/obj/structure/travois/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color
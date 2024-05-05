/obj/structure/reagent_dispensers/barrel
	name                = "barrel"
	desc                = "A stout barrel for storing large amounts of liquids or substances."
	icon                = 'icons/obj/structures/barrel.dmi'
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	atom_flags          = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	matter              = null
	material            = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	wrenchable          = FALSE
	storage             = /datum/storage/hopper/industrial

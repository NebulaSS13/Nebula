// Due to positioning and having a single-direction icon, this one shouldn't be constructable.
/obj/structure/wall_fountain
	name                = "wall fountain"
	desc                = "An intricately-constructed fountain set into a wall."
	icon                = 'icons/obj/structures/wall_fountain.dmi'
	icon_state          = ICON_STATE_WORLD
	density             = FALSE
	opacity             = FALSE
	anchored            = TRUE
	material            = /decl/material/solid/stone/marble
	color               = /decl/material/solid/stone/marble::color
	atom_flags          = ATOM_FLAG_OPEN_CONTAINER
	material_alteration = MAT_FLAG_ALTERATION_ALL
	default_pixel_y     = 24
	pixel_y             = 24

/obj/structure/wall_fountain/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	initialize_reagents()

/obj/structure/wall_fountain/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		add_overlay(overlay_image(icon, "[icon_state]-water", COLOR_WHITE, RESET_COLOR))

/obj/structure/wall_fountain/initialize_reagents(populate)
	create_reagents(500)
	. = ..()

/obj/structure/wall_fountain/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/wall_fountain/on_reagent_change()
	. = ..()
	if(reagents?.total_volume >= reagents?.maximum_volume)
		if(is_processing)
			STOP_PROCESSING(SSobj, src)
	else if(!is_processing)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/wall_fountain/Process()
	add_to_reagents(/decl/material/liquid/water, 5)

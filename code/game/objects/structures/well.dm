/obj/structure/reagent_dispensers/well
	name                      = "well"
	desc                      = "A deep pit lined with stone bricks, used to store water."
	icon                      = 'icons/obj/structures/well.dmi'
	icon_state                = ICON_STATE_WORLD
	anchored                  = TRUE
	density                   = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	matter                    = null
	material                  = /decl/material/solid/stone/granite
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_DESC
	wrenchable                = FALSE
	amount_dispensed          = 10
	possible_transfer_amounts = @"[10,25,50,100]"
	volume                    = 10000

/obj/structure/reagent_dispensers/well/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		add_overlay(overlay_image(icon, "[icon_state]-fluid", reagents.get_color(), (RESET_COLOR | RESET_ALPHA)))

/obj/structure/reagent_dispensers/well/mapped/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/well/mapped/Process()
	if(!reagents || (reagents.total_volume >= reagents.maximum_volume))
		return PROCESS_KILL
	reagents.add_reagent(/decl/material/liquid/water, rand(5, 10))
	if(reagents.total_volume >= reagents.maximum_volume)
		return PROCESS_KILL

/obj/structure/reagent_dispensers/well/mapped/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/reagent_dispensers/well/mapped/on_reagent_change()
	. = ..()
	update_icon()
	if(!is_processing)
		START_PROCESSING(SSobj, src)

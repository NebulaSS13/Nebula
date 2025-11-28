/obj/structure/reagent_dispensers/well
	name                      = "well"
	desc                      = "A deep pit lined with stone bricks, used to store water."
	icon                      = 'icons/obj/structures/well.dmi'
	icon_state                = ICON_STATE_WORLD
	opacity                   = FALSE
	anchored                  = TRUE
	density                   = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	matter                    = null
	material                  = /decl/material/solid/stone/granite
	color                     = /decl/material/solid/stone/granite::color
	material_alteration       = MAT_FLAG_ALTERATION_ALL
	wrenchable                = FALSE
	amount_dispensed          = 10
	possible_transfer_amounts = @"[10,25,50,100]"
	chem_volume               = 10000
	can_toggle_open           = FALSE
	var/auto_refill

// Override to skip open container check.
/obj/structure/reagent_dispensers/well/can_drink_from(mob/user)
	return REAGENT_TOTAL_VOLUME(reagents) && user.check_has_mouth()

/obj/structure/reagent_dispensers/well/populate_reagents()
	. = ..()
	if(auto_refill)
		add_to_reagents(auto_refill, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/well/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/reagent_dispensers/well/on_update_icon()
	. = ..()
	if(REAGENT_TOTAL_VOLUME(reagents))
		add_overlay(overlay_image(icon, "[icon_state]-fluid", reagents.get_color(), (RESET_COLOR | RESET_ALPHA)))
	if(istype(reinf_material)) // reinf_material -> roof and posts, at this point in time
		var/image/roof_image = overlay_image(icon, "[icon_state]-roof", reinf_material.color, RESET_COLOR | RESET_ALPHA | KEEP_APART)
		roof_image.pixel_y = 16 // we have to use 32x32 sprites but want this to be, effectively, 48x32
		add_overlay(roof_image)

/obj/structure/reagent_dispensers/well/on_reagent_change()
	if(!(. = ..()))
		return
	update_icon()
	if(!is_processing && auto_refill)
		START_PROCESSING(SSobj, src)

// Overrides due to wonky reagent_dispeners opencontainer flag handling.
/obj/structure/reagent_dispensers/well/can_be_poured_from(mob/user, atom/target)
	return (REAGENT_MAXIMUM_VOLUME(reagents) > 0)
/obj/structure/reagent_dispensers/well/can_be_poured_into(mob/user, atom/target)
	return (REAGENT_MAXIMUM_VOLUME(reagents) > 0)

/obj/structure/reagent_dispensers/well/get_standard_interactions(var/mob/user)
	. = ..()
	if(REAGENT_MAXIMUM_VOLUME(reagents))
		LAZYADD(., global._reagent_interactions)

/obj/structure/reagent_dispensers/well/Process()
	if(!reagents || !auto_refill) // if we're full, we only stop at the end of the proc; we need to check for contaminants first
		return PROCESS_KILL
	var/amount_to_add = rand(5, 10)
	if(length(REAGENT_VOLUMES(reagents)) > 1) // we have impurities!
		reagents.remove_any(amount_to_add, defer_update = TRUE, skip_reagents = list(auto_refill)) // defer update until the add_reagent call below
	if(REAGENT_TOTAL_VOLUME(reagents) < REAGENT_MAXIMUM_VOLUME(reagents))
		reagents.add_reagent(auto_refill, amount_to_add)
		return // don't stop processing
	else if(length(REAGENT_VOLUMES(reagents)) == 1 && reagents.get_primary_reagent_type() == auto_refill)
		// only one reagent and it's our auto_refill, our work is done here
		return PROCESS_KILL
	// if we get here, it means we have a full well with contaminants, so we keep processing

/obj/structure/reagent_dispensers/well/mapped
	auto_refill = /decl/material/liquid/water

/obj/structure/reagent_dispensers/well/mapped/covered
	reinf_material = /decl/material/solid/organic/wood/walnut

/obj/structure/reagent_dispensers/well/wall_fountain
	name            = "wall fountain"
	desc            = "An intricately-constructed fountain set into a wall."
	icon            = 'icons/obj/structures/wall_fountain.dmi'
	density         = FALSE
	default_pixel_y = 24
	pixel_y         = 24

/obj/structure/reagent_dispensers/well/wall_fountain/mapped
	auto_refill = /decl/material/liquid/water

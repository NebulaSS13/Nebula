/obj/structure/reagent_dispensers/barrel
	name                      = "barrel"
	desc                      = "A stout barrel for storing large amounts of liquids or substances."
	icon                      = 'icons/obj/structures/barrels/barrel.dmi'
	icon_state                = ICON_STATE_WORLD
	anchored                  = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE
	matter                    = null
	material                  = /decl/material/solid/organic/wood/oak
	color                     = /decl/material/solid/organic/wood/oak::color
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	wrenchable                = FALSE
	storage                   = /datum/storage/barrel
	amount_dispensed          = 10
	chem_volume               = 7500
	movable_flags             = MOVABLE_FLAG_WHEELED
	throwpass                 = TRUE
	tool_interaction_flags    = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	// Should we draw our lid and liquid contents as overlays?
	var/show_liquid_contents  = TRUE
	// Rivets, bands, etc. Currently just cosmetic unless the forging modpack is ticked.
	var/decl/material/metal_material = /decl/material/solid/metal/iron

// Stub type for crafting (forging modpack modifies metal_material)
/obj/structure/reagent_dispensers/barrel/crafted

// Overrides due to wonky reagent_dispeners opencontainer flag handling.
/obj/structure/reagent_dispensers/barrel/can_be_poured_from(mob/user, atom/target)
	return (REAGENT_MAXIMUM_VOLUME(reagents) > 0)
/obj/structure/reagent_dispensers/barrel/can_be_poured_into(mob/user, atom/target)
	return (REAGENT_MAXIMUM_VOLUME(reagents) > 0)

// Override to skip open container check.
/obj/structure/reagent_dispensers/barrel/can_drink_from(mob/user)
	return REAGENT_TOTAL_VOLUME(reagents) && user.check_has_mouth()

/obj/structure/reagent_dispensers/barrel/Initialize()
	if(ispath(metal_material))
		metal_material = GET_DECL(metal_material)
	if(!istype(metal_material))
		metal_material = null
	. = ..()
	if(. == INITIALIZE_HINT_NORMAL && storage)
		return INITIALIZE_HINT_LATELOAD //  we want to grab our turf contents.

/obj/structure/reagent_dispensers/barrel/LateInitialize(mapload, ...)
	..()
	if(mapload)
		for(var/obj/item/thing in loc)
			if(!thing.simulated || thing.anchored)
				continue
			if(storage.can_be_inserted(thing, null))
				storage.handle_item_insertion(null, thing)

/obj/structure/reagent_dispensers/barrel/on_reagent_change()
	if(!(. = ..()) || QDELETED(src))
		return
	var/primary_mat = reagents?.get_primary_reagent_name()
	if(primary_mat)
		update_material_name("[initial(name)] of [primary_mat]")
	else
		update_material_name()
	update_icon()

/obj/structure/reagent_dispensers/barrel/on_update_icon()

	. = ..()

	// Layer below lid/lid metal.
	if(metal_material)
		add_overlay(overlay_image(icon, "[icon_state]-metal", metal_material.color, RESET_COLOR))

	// Add lid/reagents overlay/lid metal.
	if(show_liquid_contents && ATOM_IS_OPEN_CONTAINER(src))
		if(reagents)
			var/overlay_amount = NONUNIT_CEILING(REAGENT_TOTAL_LIQUID_VOLUME(reagents) / REAGENT_MAXIMUM_VOLUME(reagents) * 100, 10)
			var/image/filling_overlay = overlay_image(icon, "[icon_state]-[overlay_amount]", reagents.get_color(), RESET_COLOR | RESET_ALPHA)
			add_overlay(filling_overlay)
		add_overlay(overlay_image(icon, "[icon_state]-lidopen", material?.color, RESET_COLOR))
		if(metal_material)
			add_overlay(overlay_image(icon, "[icon_state]-lidopen-metal", metal_material.color, RESET_COLOR))
	else
		add_overlay(overlay_image(icon, "[icon_state]-lidclosed", material?.color, RESET_COLOR))
		if(metal_material)
			add_overlay(overlay_image(icon, "[icon_state]-lidclosed-metal", metal_material.color, RESET_COLOR))

	if(istype(loc, /obj/structure/cask_rack))
		loc.update_icon()

/obj/structure/reagent_dispensers/barrel/get_standard_interactions(var/mob/user)
	. = ..()
	if(REAGENT_MAXIMUM_VOLUME(reagents))
		LAZYADD(., global._reagent_interactions)

	// Disambiguation actions, since barrels can have several different potential interactions for
	// the same item. It would be nice to enable this on /obj/structure in general but there are a
	// ton of really bespoke overrides of the standard tool methods (windows, AI core, etc.).
	if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
		LAZYADD(., /decl/interaction_handler/structure/unanchor)
	if(tool_interaction_flags & TOOL_INTERACTION_WIRING)
		LAZYADD(., /decl/interaction_handler/structure/wiring)
	if(tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT)
		LAZYADD(., /decl/interaction_handler/structure/dismantle)
	if(LAZYLEN(.) && storage)
		LAZYADD(., /decl/interaction_handler/put_in_storage)

// Copy of above - maybe we should just have a single 'get interactions' proc at this point?
/obj/structure/reagent_dispensers/barrel/get_alt_interactions(mob/user)
	. = ..()
	if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
		LAZYADD(., /decl/interaction_handler/structure/unanchor)
	if(tool_interaction_flags & TOOL_INTERACTION_WIRING)
		LAZYADD(., /decl/interaction_handler/structure/wiring)
	if(tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT)
		LAZYADD(., /decl/interaction_handler/structure/dismantle)

/obj/structure/reagent_dispensers/barrel/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/reagent_dispensers/barrel/ebony/water/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/water, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/ebony/beer/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/beer, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/ebony/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/wine, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/ebony/oil/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/oil, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/cask
	name                  = "cask"
	desc                  = "A small barrel used to store moderate amounts of liquids or substances."
	icon                  = 'icons/obj/structures/barrels/cask.dmi'
	anchored              = FALSE
	show_liquid_contents  = FALSE
	storage               = null // Intended for storing liquids.

// Stub type for crafting (forging modpack modifies metal_material)
/obj/structure/reagent_dispensers/barrel/cask/crafted

// Horrible workaround for physical interaction checks.
/obj/structure/reagent_dispensers/barrel/cask/nano_host()
	return istype(loc, /obj/structure/cask_rack) ? loc : src

/obj/structure/reagent_dispensers/barrel/cask/receive_mouse_drop(atom/dropping, mob/user, params)
	if(istype(loc, /obj/structure/cask_rack))
		return loc.receive_mouse_drop(dropping, user, params)
	return ..()

/obj/structure/reagent_dispensers/barrel/cask/handle_mouse_drop(atom/over, mob/user, params)
	var/obj/structure/cask_rack/rack = loc
	if(istype(rack) && isturf(over) && user.Adjacent(over) && rack.Adjacent(over) && rack.try_unstack_barrel(src, over, user))
		return
	return ..()

/obj/structure/reagent_dispensers/barrel/cask/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/reagent_dispensers/barrel/cask/ebony/water/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/water, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/cask/ebony/beer/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/beer, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/cask/ebony/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/wine, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/structure/reagent_dispensers/barrel/cask/ebony/oil/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/oil, REAGENT_MAXIMUM_VOLUME(reagents))

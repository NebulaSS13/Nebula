/obj/structure/reagent_dispensers/barrel
	name                      = "barrel"
	desc                      = "A stout barrel for storing large amounts of liquids or substances."
	icon                      = 'icons/obj/structures/barrel.dmi'
	icon_state                = ICON_STATE_WORLD
	anchored                  = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	matter                    = null
	material                  = /decl/material/solid/organic/wood
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	wrenchable                = FALSE
	storage                   = /datum/storage/barrel
	amount_dispensed          = 10
	possible_transfer_amounts = @"[10,25,50,100]"
	volume                    = 7500
	movable_flags             = MOVABLE_FLAG_WHEELED
	throwpass                 = TRUE

/obj/structure/reagent_dispensers/barrel/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/reagent_dispensers/barrel/attackby(obj/item/W, mob/user)
	. = ..()
	if(!. && user.a_intent == I_HELP && reagents?.total_volume > FLUID_PUDDLE)
		user.visible_message(SPAN_NOTICE("\The [user] dips \the [W] into \the [reagents.get_primary_reagent_name()]."))
		W.fluid_act(reagents)
		return TRUE

/obj/structure/reagent_dispensers/barrel/LateInitialize(mapload, ...)
	..()
	if(mapload)
		for(var/obj/item/thing in loc)
			if(!thing.simulated || thing.anchored)
				continue
			if(storage.can_be_inserted(thing, null))
				storage.handle_item_insertion(null, thing)

/obj/structure/reagent_dispensers/barrel/on_reagent_change()
	if(!(. = ..()))
		return
	var/primary_mat = reagents?.get_primary_reagent_name()
	if(primary_mat)
		SetName("[material.solid_name] [initial(name)] of [primary_mat]")
	else
		SetName("[material.solid_name] [initial(name)]")

/obj/structure/reagent_dispensers/barrel/ebony
	material = /decl/material/solid/organic/wood/ebony

/obj/structure/reagent_dispensers/barrel/ebony/water/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/barrel/ebony/beer/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/beer, reagents.maximum_volume)

/obj/structure/reagent_dispensers/barrel/ebony/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/wine, reagents.maximum_volume)

/obj/structure/reagent_dispensers/barrel/ebony/oil/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/plant_oil, reagents.maximum_volume)

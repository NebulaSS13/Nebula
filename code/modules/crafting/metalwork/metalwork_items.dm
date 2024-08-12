/datum/storage/crucible
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_LARGE)
	can_hold = list(
		/obj/item/debris,
		/obj/item/stack/material
	)

/obj/item/chems/crucible
	name = "crucible"
	desc = "A heavy, thick-walled vessel used for melting down ore."
	icon = 'icons/obj/metalworking/crucible.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	w_class = ITEM_SIZE_STRUCTURE
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	storage = /datum/storage/crucible
	obj_flags = OBJ_FLAG_NO_STORAGE
	var/max_held = 10

/obj/item/chems/crucible/attackby(obj/item/W, mob/user)

	// Fill a mould.
	if(istype(W, /obj/item/chems/mould))
		if(W.material?.hardness <= MAT_VALUE_MALLEABLE)
			to_chat(user, SPAN_WARNING("\The [W] is currently too soft to be used as a mould."))
			return TRUE
		if(standard_pour_into(user, W))
			return TRUE

	// Skim off any slag.
	if(istype(W, /obj/item/chems) && ATOM_IS_OPEN_CONTAINER(W) && W.reagents)

		// Pour contents into the crucible.
		if(W.reagents.total_volume)
			var/obj/item/chems/pouring = W
			if(pouring.standard_pour_into(user, src))
				return TRUE

		// Attempting to skim off slag.
		// TODO: check for appropriate vessel material? Check melting point against temperature of crucible?
		if(reagents?.total_volume && length(reagents.reagent_volumes) > 1)
			var/removing = min(amount_per_transfer_from_this, REAGENTS_FREE_SPACE(W.reagents))
			if(removing < length(reagents.reagent_volumes)-1)
				to_chat(user, SPAN_WARNING("\The [W] is full."))
				return TRUE
			// Remove a portion, excepting the primary reagent.
			var/old_amt = W.reagents.total_volume
			var/decl/material/primary_mat = reagents.get_primary_reagent_decl()
			reagents.trans_to_holder(W.reagents, removing, skip_reagents = list(primary_mat.type))
			to_chat(user, SPAN_NOTICE("You skim [W.reagents.total_volume-old_amt] unit\s of slag from the top of \the [primary_mat]."))
			return TRUE

	return ..()

/obj/item/chems/crucible/on_reagent_change()
	if((. = ..()))
		queue_icon_update()

/obj/item/chems/crucible/on_update_icon()
	. = ..()
	var/decl/material/primary_reagent = reagents?.get_primary_reagent_decl()
	if(primary_reagent)
		var/image/I = image(icon, "[icon_state]-filled")
		I.color = primary_reagent.color
		I.alpha = 255 * primary_reagent.opacity
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/chems/crucible/initialize_reagents()
	create_reagents(300 * REAGENT_UNITS_PER_MATERIAL_SHEET) // holds a single full stack of 200 ore
	return ..()

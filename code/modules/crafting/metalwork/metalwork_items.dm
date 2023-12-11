/obj/item/chems/crucible
	name = "crucible"
	desc = "A heavy, thick-walled vessel used for melting down ore."
	icon = 'icons/obj/metalworking/crucible.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	w_class = ITEM_SIZE_NO_CONTAINER
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
// TODO: storage datum when storage PR is merged.
//	max_w_class = ITEM_SIZE_LARGE
//	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_LARGE)
	var/max_held = 10

/obj/item/chems/crucible/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/chems/mould))
		if(W.material?.hardness <= MAT_VALUE_MALLEABLE)
			to_chat(user, SPAN_WARNING("\The [W] is currently too soft to be used as a mould."))
			return TRUE
		if(standard_pour_into(user, W))
			return TRUE

	if(istype(W, /obj/item/debris) || istype(W, /obj/item/stack/material))

		if(length(contents) >= max_held)
			to_chat(user, SPAN_WARNING("\The [src] is full."))
			return TRUE

		var/obj/item/transferring
		if(istype(W, /obj/item/stack))
			var/obj/item/stack/input = W
			if(input.get_amount() <= 5 && user.try_unequip(input))
				transferring = input
			else
				transferring = input.split(5)
		else if(user.try_unequip(W))
			transferring = W

		if(transferring)
			transferring.forceMove(src)
			visible_message(SPAN_NOTICE("\The [user] drops \the [transferring] into \the [src]."))
			return TRUE

	return ..()

/obj/item/chems/crucible/attack_hand(mob/user)
	if(length(contents))
		var/obj/item/stack = pick(contents)
		stack.dropInto(get_turf(src))
		user.put_in_hands(stack)
		return TRUE
	return ..()
// End placeholder interaction. Remove when storage PR is in.

/obj/item/chems/crucible/on_reagent_change()
	. = ..()
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
	create_reagents(15 * REAGENT_UNITS_PER_MATERIAL_SHEET)
	return ..()

/obj/structure/receive_mouse_drop(atom/dropping, mob/user, params)
	if((. = ..()) || user?.get_active_held_item() != dropping || !isitem(dropping) || isnull(get_possible_reagent_transfer_amounts()))
		return
	// Awful. Sorry.
	var/obj/item/item = dropping
	var/old_atom_flags = atom_flags
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	if(item.standard_pour_into(user, src))
		. = TRUE
	atom_flags = old_atom_flags

/obj/structure/proc/get_reagent_amount_dispensed()
	return null

/obj/structure/proc/set_reagent_amount_dispensed()
	return null

/obj/structure/proc/set_reagent_amount_dispensed_verb()
	set name = "Set amount dispensed"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!"))
		return
	var/new_amount = input("Amount dispensed:","[src]") as null|anything in get_possible_reagent_transfer_amounts()
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (new_amount)
		set_reagent_amount_dispensed(new_amount)

/obj/structure/proc/get_possible_reagent_transfer_amounts()
	return null

//Set amount dispensed. Added manually to querns and reagent dispensers.
/decl/interaction_handler/set_transfer/structure
	expected_target_type = /obj/structure

/decl/interaction_handler/set_transfer/structure/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/structure/dispenser = target
		return !isnull(dispenser.get_possible_reagent_transfer_amounts())

/decl/interaction_handler/set_transfer/structure/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/structure/dispenser = target
	dispenser.set_reagent_amount_dispensed_verb()

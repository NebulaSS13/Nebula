/decl/interaction_handler/set_transfer
	name = "Set Transfer Amount"

/decl/interaction_handler/set_transfer/reagent_dispenser
	expected_target_type = /obj/structure/reagent_dispensers

/decl/interaction_handler/set_transfer/reagent_dispenser/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/structure/reagent_dispensers/R = target
		return !!R.possible_transfer_amounts

/decl/interaction_handler/set_transfer/reagent_dispenser/invoked(var/atom/target, var/mob/user)
	var/obj/structure/reagent_dispensers/R = target
	R.set_amount_per_transfer_from_this()

/decl/interaction_handler/set_transfer/chems
	expected_target_type = /obj/item/chems

/decl/interaction_handler/set_transfer/chems/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/item/chems/C = target
		return !!C.possible_transfer_amounts

/decl/interaction_handler/set_transfer/chems/invoked(var/atom/target, var/mob/user)
	var/obj/item/chems/C = target
	C.set_amount_per_transfer_from_this()

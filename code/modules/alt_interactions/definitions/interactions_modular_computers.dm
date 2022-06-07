/decl/interaction_handler/laptop_open
	name = "Open Laptop"
	expected_target_type = /obj/item/modular_computer/laptop
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/laptop_open/invoked(atom/target, mob/user)
	var/obj/item/modular_computer/laptop/L = target
	L.anchored = !L.anchored
	var/datum/extension/assembly/modular_computer/assembly = get_extension(L, L.computer_type)
	if(assembly)
		assembly.screen_on = L.anchored
	L.update_icon()

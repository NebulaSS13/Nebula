/decl/interaction_handler/remove_disk
	name = "Eject Disk"

/decl/interaction_handler/remove_disk/designs
	expected_target_type = /obj/machinery/design_database

/decl/interaction_handler/remove_disk/designs/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/obj/machinery/design_database/D = target
		. = !!D.disk

/decl/interaction_handler/remove_disk/designs/invoked(atom/target, mob/user)
	var/obj/machinery/design_database/D = target
	D.eject_disk(user)

/decl/interaction_handler/remove_disk/console
	expected_target_type = /obj/machinery/computer/design_console

/decl/interaction_handler/remove_disk/console/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/obj/machinery/computer/design_console/D = target
		. = !!D.disk

/decl/interaction_handler/remove_disk/console/invoked(atom/target, mob/user)
	var/obj/machinery/computer/design_console/D = target
	D.eject_disk(user)

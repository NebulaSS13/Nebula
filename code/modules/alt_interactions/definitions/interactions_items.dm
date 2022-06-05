/decl/interaction_handler/paint_sprayer_colour
	name = "Change Color Preset"
	expected_target_type = /obj/item/paint_sprayer
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_INVENTORY

/decl/interaction_handler/paint_sprayer_colour/invoked(atom/target, mob/user)
	var/obj/item/paint_sprayer/sprayer = target
	sprayer.choose_preset_color()

/decl/interaction_handler/revolver_spin_cylinder
	name = "Spin Cylinder"
	expected_target_type = /obj/item/gun/projectile/revolver

/decl/interaction_handler/revolver_spin_cylinder/invoked(var/atom/target, var/mob/user)
	var/obj/item/gun/projectile/revolver/R = target
	R.spin_cylinder()

/decl/interaction_handler/clothing_set_sensors
	name = "Set Sensors Level"
	expected_target_type = /obj/item/clothing/under

/decl/interaction_handler/clothing_set_sensors/invoked(var/atom/target, var/mob/user)
	var/obj/item/clothing/under/U = target
	U.set_sensors(user)

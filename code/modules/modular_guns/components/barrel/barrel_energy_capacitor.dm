/decl/laser_wavelength
	var/name
	var/color
	var/light_color
	var/damage_multiplier
	var/armour_multiplier

/decl/laser_wavelength/red
	name = "638nm"
	color = COLOR_RED
	light_color = COLOR_RED_LIGHT
	damage_multiplier = 1
	armour_multiplier = 0.1

/decl/laser_wavelength/yellow
	name = "589nm"
	color = COLOR_GOLD
	light_color = COLOR_GOLD
	damage_multiplier = 0.9
	armour_multiplier = 0.2

/decl/laser_wavelength/green
	name = "515nm"
	color = COLOR_LIME
	light_color = COLOR_LIME
	damage_multiplier = 0.8
	armour_multiplier = 0.3

/decl/laser_wavelength/blue
	name = "473nm"
	color = COLOR_CYAN
	light_color = COLOR_BLUE_LIGHT
	damage_multiplier = 0.7
	armour_multiplier = 0.4

/decl/laser_wavelength/violet
	name = "405nm"
	color = "#ff00dc"
	light_color = "#ff00dc"
	damage_multiplier = 0.6
	armour_multiplier = 0.5
	
/obj/item/firearm_component/barrel/energy/capacitor
	projectile_type = /obj/item/projectile/beam/variable
	charge_cost = 100
	accuracy = 2

	var/wiring_color = COLOR_CYAN_BLUE
	var/decl/laser_wavelength/charging
	var/decl/laser_wavelength/selected_wavelength

/obj/item/firearm_component/barrel/energy/capacitor/show_examine_info(mob/user)
	. = ..()
	to_chat(user, "The wavelength selector is dialled to [selected_wavelength.name].")

/obj/item/firearm_component/barrel/energy/capacitor/Initialize()
	var/list/laser_wavelengths = decls_repository.get_decls_of_subtype(/decl/laser_wavelength)
	selected_wavelength = laser_wavelengths[pick(laser_wavelengths)]
	. = ..()

/obj/item/firearm_component/barrel/energy/capacitor/holder_attack_self(mob/user)
	var/list/laser_wavelengths = decls_repository.get_decls_of_subtype(/decl/laser_wavelength)
	var/list/choices = list()
	for(var/lwave in laser_wavelengths)
		choices += laser_wavelengths[lwave]
	var/new_wavelength = input("Select the desired laser wavelength.", "Set Laser Wavelength", selected_wavelength) as null|anything in choices
	if(!charging && new_wavelength != selected_wavelength && (holder?.loc == user || user.Adjacent(src)) && !user.incapacitated())
		selected_wavelength = new_wavelength
		to_chat(user, SPAN_NOTICE("You dial \the [holder || src]'s wavelength to [selected_wavelength.name]."))
		update_icon()
	return TRUE

/*
/obj/item/gun/long/linear_fusion/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		to_chat(user, SPAN_WARNING("\The [holder || src] is hermetically sealed; you can't get the components out."))
		return TRUE
	. = ..()
*/
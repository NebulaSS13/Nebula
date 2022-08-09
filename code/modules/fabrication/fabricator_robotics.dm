/obj/machinery/fabricator/robotics
	name = "robotics fabricator"
	desc = "A complex and flexible nanofabrication system for producing electronics and robotics."
	icon = 'icons/obj/machines/fabricators/robotics.dmi'
	icon_state = "robotics"
	base_icon_state = "robotics"
	idle_power_usage = 20
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/robotics
	fabricator_class = FABRICATOR_CLASS_ROBOTICS
	base_storage_capacity_mult = 100
	var/picked_prosthetic_species //Prosthetics will be printed with this species

/obj/machinery/fabricator/robotics/Initialize()
	. = ..()
	picked_prosthetic_species = global.using_map?.default_species //Set it by default to the base species to preserve earlier behavior for now

/obj/machinery/fabricator/robotics/make_order(datum/fabricator_recipe/recipe, multiplier)
	var/datum/fabricator_build_order/order = ..()
	order.set_data("species", picked_prosthetic_species)
	return order


/obj/machinery/fabricator/robotics/OnTopic(user, href_list, state)
	. = ..()
	if(href_list["pick_species"])
		var/chosen_species = input(user, "Choose a species to produce prosthetics for", "Target Species", null) in get_playable_species()
		if(chosen_species)
			picked_prosthetic_species = chosen_species
		. = TOPIC_REFRESH

/obj/machinery/fabricator/robotics/ui_data(mob/user, ui_key)
	. = ..()
	LAZYSET(., "species", picked_prosthetic_species)

/obj/machinery/fabricator/robotics/get_nano_template()
	return "fabricator_robot.tmpl"

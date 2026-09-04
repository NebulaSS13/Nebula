/obj/screen/warning/oxygen
	name        = "oxygen"
	icon        = 'icons/mob/screen/styles/status_oxy.dmi'
	icon_state  = "oxy0"
	screen_loc  = ui_temp
	base_state  = "oxy"
	check_alert = /decl/hud_element/oxygen

/obj/screen/warning/oxygen/handle_click(mob/user, params)
	if(icon_state == "oxy0")
		to_chat(user, SPAN_NOTICE("You are breathing easy."))
	else
		to_chat(user, SPAN_DANGER("You cannot breathe!"))

// Robots use this warning icon as an environment indicator, not based on our own tolerances.
/obj/screen/warning/oxygen/robot
	screen_loc = ui_oxygen

/obj/screen/warning/oxygen/robot/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		return
	var/datum/gas_mixture/environment = owner.loc?.return_air()
	if(!environment)
		return
	var/decl/species/species = decls_repository.get_decl_by_id(global.using_map.default_species)
	if(!species.breath_type || environment.gas[species.breath_type] > species.breath_pressure)
		for(var/gas in species.poison_types)
			if(environment.gas[gas])
				icon_state = "oxy1"
				return
		icon_state = "oxy0"
	else
		icon_state = "oxy1"

/datum/build_mode/lighting
	name = "Light Maker"
	icon_state = "buildmode8"
	click_interactions = list(
		/decl/build_mode_interaction/lighting/set_values,
		/decl/build_mode_interaction/lighting/clear_values,
		/decl/build_mode_interaction/lighting/configure
	)

	var/light_range = 3
	var/light_power = 3
	var/light_color = COLOR_WHITE

/datum/build_mode/lighting/Configurate()
	var/choice = alert("Change the new light range, power, or color?", "Lighting Editor", "Range", "Power", "Color", "Cancel")
	switch(choice)
		if("Range")
			var/input = input("New light range.", name, light_range) as null|num
			if(input)
				light_range = input
		if("Power")
			var/input = input("New light power, from 0.1 to 1 in decimal increments.", name, light_power) as null|num
			if(input)
				input = clamp(input, 0.1, 1)
				light_power = input
		if("Color")
			var/input = input("New light color.", name, light_color) as null|color
			if(input)
				light_color = input

/decl/build_mode_interaction/lighting
	abstract_type = /decl/build_mode_interaction/lighting

/decl/build_mode_interaction/lighting/set_values
	description = "Apply lighting values to an atom."
	trigger_params = list("left")

/decl/build_mode_interaction/lighting/set_values/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/lighting/light_mode = build_mode
	if(istype(A) && istype(light_mode))
		A.set_light(light_mode.light_range, light_mode.light_power, l_color = light_mode.light_color)
		return TRUE
	return FALSE

/decl/build_mode_interaction/lighting/clear_values
	description = "Clear lighting values from an atom."
	trigger_params = list("right")

/decl/build_mode_interaction/lighting/clear_values/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	if(istype(A))
		A.set_light(0, l_color = COLOR_WHITE)
		return TRUE
	return FALSE

/decl/build_mode_interaction/lighting/configure
	name        = "Right Click on Build Mode Button"
	description = "Change glow properties."
	dummy_interaction = TRUE

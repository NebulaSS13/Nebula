/obj/item/integrated_circuit/input/slime_scanner
	name = "slime_scanner"
	desc = "A very small version of the xenobio analyser. This allows the machine to know every needed properties of slime. Output mutation list is non-associative."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"colour"                = IC_PINTYPE_STRING,
		"adult"                 = IC_PINTYPE_BOOLEAN,
		"nutrition"             = IC_PINTYPE_NUMBER,
		"charge"                = IC_PINTYPE_NUMBER,
		"health"                = IC_PINTYPE_NUMBER,
		"possible mutation"     = IC_PINTYPE_LIST,
		"genetic destability"   = IC_PINTYPE_NUMBER,
		"slime core amount"     = IC_PINTYPE_NUMBER,
		"Growth progress"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/slime_scanner/do_work()
	var/mob/living/slime/T = get_pin_data_as_type(IC_INPUT, 1, /mob/living/slime)
	if(!isslime(T)) //Invalid input
		return
	if(T in view(get_turf(src))) // Like medbot's analyzer it can be used in range..

		var/decl/slime_colour/slime_data = GET_DECL(T.slime_type)
		set_pin_data(IC_OUTPUT, 1, slime_data.name)
		set_pin_data(IC_OUTPUT, 2, T.is_adult)
		set_pin_data(IC_OUTPUT, 3, T.nutrition/T.get_max_nutrition())
		set_pin_data(IC_OUTPUT, 4, T.powerlevel)
		set_pin_data(IC_OUTPUT, 5, round(T.health/T.maxHealth,0.01)*100)
		set_pin_data(IC_OUTPUT, 6, slime_data.descendants?.Copy())
		set_pin_data(IC_OUTPUT, 7, T.mutation_chance)
		set_pin_data(IC_OUTPUT, 8, T.cores)
		set_pin_data(IC_OUTPUT, 9, T.amount_grown/SLIME_EVOLUTION_THRESHOLD)


	push_data()
	activate_pin(2)

/obj/machinery/giga_drill
	name = "alien drill"
	desc = "A giant, alien drill mounted on long treads."
	icon = 'icons/obj/machines/gigadrill.dmi'
	icon_state = "gigadrill"
	density = TRUE
	layer = ABOVE_OBJ_LAYER		//to go over ores
	matter = list(
		/decl/material/solid/metal/plasteel/ocp = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT
	)
	var/active = 0
	var/drill_time = 10
	var/turf/drilling_turf
	matter = list(
		/decl/material/solid/metal/plasteel/ocp = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/phoron = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
	)

/obj/machinery/giga_drill/physical_attack_hand(mob/user)
	if(active)
		active = 0
		icon_state = "gigadrill"
		to_chat(user, "<span class='notice'>You press a button and \the [src] slowly spins down.</span>")
	else
		active = 1
		icon_state = "gigadrill_mov"
		to_chat(user, "<span class='notice'>You press a button and \the [src] shudders to life.</span>")
	return TRUE

/obj/machinery/giga_drill/Bump(atom/A)
	if(active && !drilling_turf)
		if(istype(A,/turf/wall/natural))
			var/turf/wall/natural/M = A
			drilling_turf = get_turf(src)
			src.visible_message("<span class='notice'>\The [src] begins to drill into \the [M].</span>")
			anchored = TRUE
			spawn(drill_time)
				if(get_turf(src) == drilling_turf && active)
					M.dismantle_turf()
					forceMove(M)
				drilling_turf = null
				anchored = FALSE

/obj/machinery/giga_drill/get_artifact_scan_data()
	return "Automated mining drill - structure composed of osmium-carbide alloy, with tip and drill lines edged in a complex lattice of diamond and phoron."

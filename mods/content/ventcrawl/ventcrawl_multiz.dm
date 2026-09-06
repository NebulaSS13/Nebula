/obj/machinery/atmospherics/pipe/zpipe/up/verb/ventcrawl_move_up()
	set name = "Ventcrawl Upwards"
	set desc = "Climb up through a pipe."
	set category = "Abilities"
	set src = usr.loc
	var/obj/machinery/atmospherics/target = check_ventcrawl(GetAbove(loc))
	if(target) ventcrawl_to(usr, target, UP)

/obj/machinery/atmospherics/pipe/zpipe/down/verb/ventcrawl_move_down()
	set name = "Ventcrawl Downwards"
	set desc = "Climb down through a pipe."
	set category = "Abilities"
	set src = usr.loc
	var/obj/machinery/atmospherics/target = check_ventcrawl(GetBelow(loc))
	if(target) ventcrawl_to(usr, target, DOWN)

/obj/machinery/atmospherics/pipe/zpipe/proc/check_ventcrawl(var/turf/target)
	for(var/node in nodes_to_networks)
		if(node in target)
			return node
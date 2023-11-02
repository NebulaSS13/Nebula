/datum/hud/slime/FinalizeInstantiation()
	var/obj/screen/using
	using = new /obj/screen/intent()
	src.adding += using
	action_intent = using
	..()

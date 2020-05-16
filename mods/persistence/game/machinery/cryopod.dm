#define STASIS_CRYO		"cryo"

/obj/machinery/cryopod/robot/despawn_occupant()
	return

/obj/machinery/cryopod/despawn_occupant()
	return

/obj/machinery/cryopod/Process()
	if(occupant)
		if(applies_stasis && iscarbon(occupant) && (world.time > time_entered + 20 SECONDS))
			var/mob/living/carbon/C = occupant
			C.SetStasis(40, STASIS_CRYO)


/obj/machinery/cryopod/set_occupant(var/mob/living/carbon/occupant, var/silent)
	src.occupant = occupant
	if(!occupant)
		SetName(initial(name))
		return

	if(occupant.client)
		if(!silent)
			to_chat(occupant, SPAN_NOTICE("[on_enter_occupant_message]"))
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	occupant.forceMove(src)
	time_entered = world.time

	SetName("[name] ([occupant])")
	icon_state = occupied_icon_state
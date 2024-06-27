/spell/camera_connection/god_vision
	name = "All Seeing Eye"
	desc = "See what your master sees."

	charge_max = 10
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	extension_type = /datum/extension/eye/freelook

	hud_state = "gen_mind"

/spell/camera_connection/god_vision/set_connected_god(var/mob/living/deity/god)
	..()

	var/datum/extension/eye/freelook/fl = get_extension(src, /datum/extension/eye)
	if(!fl)
		return
	fl.set_visualnet(god.eyenet)
	

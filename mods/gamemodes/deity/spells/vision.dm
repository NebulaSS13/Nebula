/decl/ability/deity/god_vision
	name = "All Seeing Eye"
	desc = "See what your master sees."

	cooldown_time = 1 SECOND
	invocation = "none"
	invocation_type = SpI_NONE

	extension_type = /datum/extension/eye/freelook

	ability_icon_state = "gen_mind"

/decl/ability/deity/god_vision/set_connected_god(var/mob/living/deity/god)
	..()

	var/datum/extension/eye/freelook/fl = get_extension(src, /datum/extension/eye)
	if(!fl)
		return
	fl.set_visualnet(god.eyenet)


/spell/camera_connection
	name = "Camera Connection"
	desc = "This spell allows the wizard to connect to the local camera network and see what it sees."

	school = "racial"

	invocation_type = SpI_EMOTE
	invocation = "emits a beeping sound before standing very, very still."

	charge_max = 600 //1 minute
	charge_type = Sp_RECHARGE


	spell_flags = Z2NOCAST
	hud_state = "wiz_IPC"

	var/extension_type = /datum/extension/eye/cameranet

/spell/camera_connection/New()
	..()
	set_extension(src, extension_type)

/spell/camera_connection/choose_targets()
	var/mob/living/L = holder
	if(!istype(L) || L.eyeobj) //no using if we already have an eye on.
		return null
	return list(holder)

/spell/camera_connection/cast(var/list/targets, mob/user)
	var/mob/living/L = targets[1]

	var/datum/extension/eye/cameranet/cn = get_extension(src, /datum/extension/eye/)
	if(!cn)
		to_chat(user, SPAN_WARNING("There's a flash of sparks as the spell fizzles out!"))
		return
	cn.look(L)

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
	

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
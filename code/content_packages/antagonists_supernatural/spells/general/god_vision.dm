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
	var/mob/observer/eye/vision
	var/eye_type = /mob/observer/eye/wizard_eye

/spell/camera_connection/New()
	..()
	vision = new eye_type(src)

/spell/camera_connection/Destroy()
	qdel(vision)
	vision = null
	. = ..()

/spell/camera_connection/choose_targets()
	var/mob/living/L = holder
	if(!istype(L) || L.eyeobj) //no using if we already have an eye on.
		return null
	return list(holder)

/spell/camera_connection/cast(var/list/targets, mob/user)
	var/mob/living/L = targets[1]

	vision.possess(L)
	GLOB.destroyed_event.register(L, src, /spell/camera_connection/proc/release)
	GLOB.logged_out_event.register(L, src, /spell/camera_connection/proc/release)
	L.verbs += /mob/living/proc/release_eye

/spell/camera_connection/proc/release(var/mob/living/L)
	vision.release(L)
	L.verbs -= /mob/living/proc/release_eye
	GLOB.destroyed_event.unregister(L, src)
	GLOB.logged_out_event.unregister(L, src)

/spell/camera_connection/god_vision
	name = "All Seeing Eye"
	desc = "See what your master sees."

	charge_max = 10
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	eye_type = /mob/observer/eye

	hud_state = "gen_mind"

/spell/camera_connection/god_vision/set_connected_god(var/mob/living/deity/god)
	..()
	vision.visualnet = god.eyeobj.visualnet

/spell/camera_connection/god_vision/Destroy()
	vision.visualnet = null
	return ..()

/datum/extension/eye/landing
	expected_type = /obj/machinery/computer/shuttle_control/explore
	eye_type = /mob/observer/eye/landing

	action_type = /datum/action/eye/landing

/datum/action/eye/landing
	eye_type = /mob/observer/eye/landing

/datum/action/eye/landing/finish_landing
	name = "Set landing location"
	procname = "finish_landing"
	button_icon_state = "shuttle_land"
	target_type = HOLDER_TARGET
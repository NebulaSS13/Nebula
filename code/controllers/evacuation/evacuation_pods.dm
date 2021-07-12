#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_JUMP "jump"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"
#define EVAC_OPT_CANCEL_JUMP "cancel_jump"

// Apparently, emergency_evacuation --> "abandon ship" and !emergency_evacuation --> "FTL jump"
// That stuff should be moved to the evacuation option datums but someone can do that later
/datum/evacuation_controller/starship
	name = "escape pod controller"

	evac_prep_delay    = 5 MINUTES
	evac_launch_delay  = 3 MINUTES
	evac_transit_delay = 2 MINUTES

	transfer_prep_additional_delay     = 15 MINUTES
	autotransfer_prep_additional_delay = 5 MINUTES
	emergency_prep_additional_delay    = 0 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_JUMP = new /datum/evacuation_option/jump(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
		EVAC_OPT_CANCEL_JUMP = new /datum/evacuation_option/cancel_jump()
	)

/datum/evacuation_controller/starship/finish_preparing_evac()
	. = ..()
	// Arm the escape pods.
	if (emergency_evacuation)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/starship/launch_evacuation()

	state = EVAC_IN_TRANSIT

	if (emergency_evacuation)
		// Abondon Ship
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods) // Launch the pods!
			if (!pod.arming_controller || pod.arming_controller.armed)
				pod.move_time = (evac_transit_delay/10)
				pod.launch(src)

		priority_announcement.Announce(replacetext(replacetext(global.using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[global.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
	else
		// FTL Jump
		priority_announcement.Announce(replacetext(replacetext(global.using_map.shuttle_leaving_dock, "%dock_name%", "[global.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
		SetUniversalState(/datum/universal_state/jump, arguments=list(global.using_map.station_levels))

/datum/evacuation_controller/starship/finish_evacuation()
	..()
	if(!emergency_evacuation) // FTL jump
		SetUniversalState(/datum/universal_state) //clear jump state

/datum/evacuation_controller/starship/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_JUMP], evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		if (emergency_evacuation)
			return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
		else
			return list(evacuation_options[EVAC_OPT_CANCEL_JUMP])

/datum/evacuation_option/abandon_ship
	option_text = "Abandon spacecraft"
	option_desc = "abandon the spacecraft"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE
	abandon_ship = TRUE

/datum/evacuation_option/abandon_ship/execute(mob/user)
	if (!SSevac.evacuation_controller)
		return
	if (SSevac.evacuation_controller.deny)
		to_chat(user, "Unable to initiate escape procedures.")
		return
	if (SSevac.evacuation_controller.is_on_cooldown())
		to_chat(user, SSevac.evacuation_controller.get_cooldown_message())
		return
	if (SSevac.evacuation_controller.is_evacuating())
		to_chat(user, "Escape procedures already in progress.")
		return
	if (SSevac.evacuation_controller.call_evacuation(user, 1))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated abandonment of the spacecraft.")

/datum/evacuation_option/jump
	option_text = "Initiate FTL jump"
	option_desc = "initiate a FTL jump"
	option_target = EVAC_OPT_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/jump/execute(mob/user)
	if (!SSevac.evacuation_controller)
		return
	if (SSevac.evacuation_controller.deny)
		to_chat(user, "Unable to prepare for FTL jump.")
		return
	if (SSevac.evacuation_controller.is_on_cooldown())
		to_chat(user, SSevac.evacuation_controller.get_cooldown_message())
		return
	if (SSevac.evacuation_controller.is_evacuating())
		to_chat(user, "FTL jump preparation already in progress.")
		return
	if (SSevac.evacuation_controller.call_evacuation(user, 0))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated FTL jump preparation.")

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Cancel abandonment"
	option_desc = "cancel abandonment of the spacecraft"
	option_target = EVAC_OPT_CANCEL_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_abandon_ship/execute(mob/user)
	if (SSevac.evacuation_controller && SSevac.evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled abandonment of the spacecraft.")

/datum/evacuation_option/cancel_jump
	option_text = "Cancel FTL jump"
	option_desc = "cancel the jump preparation"
	option_target = EVAC_OPT_CANCEL_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_jump/execute(mob/user)
	if (SSevac.evacuation_controller && SSevac.evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled the FTL jump.")

/obj/screen/fullscreen/jump_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = ui_entire_screen
	color = "#ff9900"
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_JUMP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_JUMP
#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"

/datum/evacuation_controller/lifepods
	name = "escape pod controller"

	evac_prep_delay    = 5 MINUTES
	evac_launch_delay  = 30 SECONDS
	evac_transit_delay = 2 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
	)

/datum/evacuation_controller/lifepods/launch_evacuation()
	if(waiting_to_leave())
		return
	state = EVAC_IN_TRANSIT
	priority_announcement.Announce(replacetext(replacetext(global.using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[global.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
	return 1

/datum/evacuation_controller/lifepods/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
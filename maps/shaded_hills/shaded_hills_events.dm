/datum/map/shaded_hills
	event_container_mundane  = /datum/event_container/mundane/fantasy
	event_container_moderate = /datum/event_container/moderate/fantasy
	event_container_major    = /datum/event_container/major/fantasy

// TODO: more appropriate events.
/datum/event_container/mundane/fantasy
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing", /datum/event/nothing,	100)
	)

/datum/event_container/moderate/fantasy
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing", /datum/event/nothing,	100)
	)

/datum/event_container/major/fantasy
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing", /datum/event/nothing,	100)
	)

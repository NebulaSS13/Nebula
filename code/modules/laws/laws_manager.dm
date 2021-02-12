/datum/nano_module/law_manager
	name = "Law manager"
	var/mob/owner

/datum/nano_module/law_manager/New(var/mob/M)
	..()
	owner = M

/datum/nano_module/law_manager/Topic(href, href_list)
	if(..())
		return TRUE

	// handle hrefs

	return FALSE

/datum/nano_module/law_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/lawset/laws = owner?.get_laws()
	var/data[0]

	// build data

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "law_manager.tmpl", sanitize("[src] - [owner]"), 800, (laws?.zeroth_law) ? 600 : 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
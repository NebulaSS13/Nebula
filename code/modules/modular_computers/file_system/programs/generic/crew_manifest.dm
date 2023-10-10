/datum/computer_file/program/crew_manifest
	filename = "crewmanifest"
	filedesc = "Crew Manifest"
	extended_desc = "This program allows access to the manifest of active crew."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 4
	available_on_network = 1
	requires_network = 1
	requires_network_feature = NET_FEATURE_RECORDS
	nanomodule_path = /datum/nano_module/program/crew_manifest
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

/datum/nano_module/program/crew_manifest
	name = "Crew Manifest"

/datum/nano_module/program/crew_manifest/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = global.default_topic_state)
	var/list/data = host.initial_data()

	var/datum/computer_network/network = program?.computer?.get_network()
	if(!network)
		return
	data["crew_manifest"] = html_crew_manifest(TRUE, records = network.get_crew_records())

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crew_manifest.tmpl", name, 450, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()
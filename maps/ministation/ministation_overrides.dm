/datum/computer_file/program/merchant/ministation
	read_access = list()

/obj/machinery/computer/modular/preset/merchant/ministation
	default_software = list(
		/datum/computer_file/program/merchant/ministation,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/supply
	)

/datum/map/ministation
	lobby_tracks = list(/decl/music_track/zazie)

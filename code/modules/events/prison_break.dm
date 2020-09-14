/datum/event/prison_break
	startWhen		= 5
	announceWhen	= 75

	var/releaseWhen = 60
	var/list/area/areas = list()  // List of areas to affect. Filled by start()

	var/eventDept = "Security"	  // Department name in announcement
	var/list/areaName =    list()	  // Names of areas mentioned in AI and Engineering announcements
	var/list/areaType =    list()    // Area types to include.
	var/list/areaNotType = list() // Area types to specifically exclude.

/datum/event/prison_break/New()
	..()
	for(var/atype in areaType)
		for(var/subatype in typesof(atype)-areaNotType)
			var/area/A = atype
			areaName |= strip_improper(initial(A.name))

/datum/event/prison_break/medical
	eventDept = "Medical"

/datum/event/prison_break/science
	eventDept = "Science"

/datum/event/prison_break/station
	eventDept = "Local"

/datum/event/prison_break/setup()
	announceWhen = rand(75, 105)
	releaseWhen = rand(60, 90)

	src.endWhen = src.releaseWhen+2

/datum/event/prison_break/announce()
	if(length(areas))
		command_announcement.Announce("[pick("Gr3yT1d3 virus","Malignant trojan",)] detected in [location_name()] [(eventDept == "Security")? "imprisonment":"containment"] subroutines. Secure any compromised areas immediately. [location_name()] AI involvement is recommended.", "[location_name()] Anti-Virus Alert", zlevels = affecting_z)

/datum/event/prison_break/start()
	for(var/area/A in global.areas)
		if(is_type_in_list(A,areaType) && !is_type_in_list(A,areaNotType))
			areas += A

	if(length(areas))
		var/my_department = "[location_name()] Firewall Subroutines"
		var/rc_message = "An unknown malicious program has been detected in the [english_list(areaName)] lighting and airlock control systems at [stationtime2text()]. Systems will be fully compromised within approximately three minutes. Direct intervention is required immediately.<br>"
		var/obj/machinery/network/message_server/MS
		for(var/z in affecting_z)
			MS = get_message_server_for_z(z)
			if(MS)
				MS.send_rc_message("Engineering", my_department, rc_message, "", "", 2)
				break
		for(var/mob/living/silicon/ai/A in global.player_list)
			to_chat(A, "<span class='danger'>Malicious program detected in the [english_list(areaName)] lighting and airlock control systems by [my_department].</span>")
	else
		to_world_log("ERROR: Could not initate grey-tide. Unable to find suitable containment area.")
		kill()

/datum/event/prison_break/tick()
	if(activeFor == releaseWhen && length(areas))
		var/obj/machinery/power/apc/theAPC = null
		for(var/area/A in areas)
			theAPC = A.get_apc()
			if(theAPC && theAPC.operating)	//If the apc's off, it's a little hard to overload the lights.
				for(var/obj/machinery/light/L in A)
					L.flicker(10)


/datum/event/prison_break/end()
	for(var/area/A in shuffle(areas))
		A.prison_break()

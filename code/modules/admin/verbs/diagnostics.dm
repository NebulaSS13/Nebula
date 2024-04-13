/client/proc/air_report()
	set category = "Debug"
	set name = "Show Air Report"

	if(!SSair)
		alert(usr,"SSair not found.","Air Report")
		return

	var/active_groups = SSair.active_zones
	var/inactive_groups = SSair.zones.len - active_groups

	var/hotspots = 0
	for(var/obj/fire/hotspot in world)
		hotspots++

	var/active_on_main_station = 0
	var/inactive_on_main_station = 0
	for(var/zone/zone in SSair.zones)
		var/turf/turf = locate() in zone.contents
		if(turf && isStationLevel(turf.z))
			if(zone.needs_update)
				active_on_main_station++
			else
				inactive_on_main_station++

	var/output = {"<B>AIR SYSTEMS REPORT</B><HR>
<B>General Processing Data</B><BR>
	Cycle: [SSair.times_fired]<br>
	Groups: [SSair.zones.len]<BR>
---- <I>Active:</I> [active_groups]<BR>
---- <I>Inactive:</I> [inactive_groups]<BR><br>
---- <I>Active on station:</i> [active_on_main_station]<br>
---- <i>Inactive on station:</i> [inactive_on_main_station]<br>
<BR>
<B>Special Processing Data</B><BR>
	Hotspot Processing: [hotspots]<BR>
<br>
<B>Geometry Processing Data</B><BR>
	Tile Update: [SSair.tiles_to_update.len]<BR>
"}

	show_browser(usr, output, "window=airreport")

/client/proc/reload_admins()
	set name = "Reload Admins"
	set category = "Debug"

	if(!check_rights(R_SERVER))	return

	message_admins("[usr] manually reloaded admins")
	load_admins()
	SSstatistics.add_field_details("admin_verb","RLDA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/print_jobban_old()
	set name = "Print Jobban Log"
	set desc = "This spams all the active jobban entries for the current round to standard output."
	set category = "Debug"

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		to_chat(usr, "[t]")

/client/proc/print_jobban_old_filter()
	set name = "Search Jobban Log"
	set desc = "This searches all the active jobban entries for the current round and outputs the results to standard output."
	set category = "Debug"

	var/job_filter = input("Contains what?","Filter") as text|null
	if(!job_filter)
		return

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		if(findtext(t, job_filter))
			to_chat(usr, "[t]")

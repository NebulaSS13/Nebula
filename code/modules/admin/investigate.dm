/client/proc/investigate_panel(subject in list("main", "href", "qdel"))
	set name = "Investigate Panel"
	set category = "Admin"
	
	if(!check_rights(R_INVESTIGATE))
		return

	if(!subject)
		return
	
	var/output
	switch(subject)
		if("main")
			output = global.world_main_log

		if("href")
			output = global.world_href_log

		if("qdel")
			output = global.world_qdel_log

	output = file2list(output)

	var/datum/browser/popup = new(mob, "investigate-[subject]", "Investigate Panel", 800, 600)
	popup.set_content(jointext(output, "<br>"))
	popup.open()

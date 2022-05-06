#define INVESTIGATION_SUBJECT_MAIN "main"
#define INVESTIGATION_SUBJECT_HREF "href"
#define INVESTIGATION_SUBJECT_QDEL "qdel"

/client/proc/investigation_panel(subject in list(INVESTIGATION_SUBJECT_MAIN, INVESTIGATION_SUBJECT_HREF, INVESTIGATION_SUBJECT_QDEL))
	set name = "Investigate Panel"
	set category = "Admin"
	
	if(!check_rights(R_INVESTIGATE))
		return

	if(!subject)
		return
	
	var/output
	switch(subject)
		if(INVESTIGATION_SUBJECT_MAIN)
			output = global.world_main_log

		if(INVESTIGATION_SUBJECT_HREF)
			output = global.world_href_log

		if(INVESTIGATION_SUBJECT_QDEL)
			output = global.world_qdel_log

	output = file2list(output)

	var/datum/browser/popup = new(mob, "investigate-[subject]", "Investigate Panel", 800, 600)
	popup.set_content(jointext(output, "<br>"))
	popup.open()

#undef INVESTIGATION_SUBJECT_MAIN
#undef INVESTIGATION_SUBJECT_HREF
#undef INVESTIGATION_SUBJECT_QDEL

/datum/admin_secret_item/admin_secret/list_fingerprints
	name = "List Fingerprints"

/datum/admin_secret_item/admin_secret/list_fingerprints/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Showing Fingerprints.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
	for(var/mob/living/human/H in SSmobs.mob_list)
		if(H.ckey)
			dat += "<tr><td>[H]</td><td>[H.get_full_print(ignore_blockers = TRUE) || "null"]</td></tr>"
	dat += "</table>"
	show_browser(user, dat, "window=fingerprints;size=440x410")

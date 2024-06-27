/datum/admin_secret_item/admin_secret/list_dna
	name = "List DNA (Blood)"

/datum/admin_secret_item/admin_secret/list_dna/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Showing DNA from blood.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
	for(var/mob/living/human/H in SSmobs.mob_list)
		if(H.ckey)
			dat += "<tr><td>[H]</td><td>[H.get_unique_enzymes() || "NULL"]</td><td>[H.get_blood_type() || "NULL"]</td></tr>"
	dat += "</table>"
	show_browser(user, dat, "window=DNA;size=440x410")

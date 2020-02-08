/datum/admin_secret_item/admin_secret/show_crew_manifest
	name = "Show Crew Manifest"

/datum/admin_secret_item/admin_secret/show_crew_manifest/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += html_crew_manifest()

	var/datum/browser/popup = new(user, "manifest", "Crew Manifest", 370, 420)
	popup.set_content(dat)
	popup.open()
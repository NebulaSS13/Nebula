/datum/admin_secret_item/admin_secret/show_signalers
	name = "Show Last Signalers"

/datum/admin_secret_item/admin_secret/show_signalers/name()
	return "Show Last [length(global.lastsignalers)] Signaler\s"

/datum/admin_secret_item/admin_secret/show_signalers/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>Showing last [length(global.lastsignalers)] signalers.</B><HR>"
	for(var/sig in global.lastsignalers)
		dat += "[sig]<BR>"
	show_browser(user, dat, "window=lastsignalers;size=800x500")

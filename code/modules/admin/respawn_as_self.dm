/client/proc/respawn_as_self()
	set name = "Respawn As Self"
	set desc = "Respawn in current client turf with currently selected preferences."
	set category = "Special Verbs"

	if(!check_rights(R_SPAWN))
		return

	var/client/C = input(src, "Specify which client to respawn.", "Respawn As Self", usr.client) as null|anything in global.clients
	if(!C || !(C in global.clients) || !C.prefs)
		return

	var/mob/oldmob = C.mob
	var/mob/living/human/H = new(oldmob.loc)
	C.prefs.copy_to(H)
	H.key = C.key
	qdel(oldmob)

// Freelook Eye
//
// Streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/observer/eye/freelook
	var/list/visibleChunks = list()

	var/datum/visualnet/visualnet

/mob/observer/eye/freelook/Initialize(var/mapload, var/datum/visualnet/net)
	. = ..()
	if(net) visualnet = net

/mob/observer/eye/freelook/Destroy()
	. = ..()
	visualnet = null

/mob/observer/eye/freelook/possess(var/mob/user)
	. = ..()
	visualnet.update_eye_chunks(src, TRUE)

/mob/observer/eye/freelook/release(var/mob/user)
	if(user == owner)
		visualnet.remove_eye(src)
	. = ..()
	
// Streams the chunk that the new loc is in.
/mob/observer/eye/freelook/setLoc(var/T)
	. = ..()

	if(.)
		visualnet.update_eye_chunks(src)
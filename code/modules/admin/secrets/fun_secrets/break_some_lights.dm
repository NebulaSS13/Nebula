/datum/admin_secret_item/fun_secret/break_some_lights
	name = "Break Some Lights"
	var/const/lightsoutRange = 25

/datum/admin_secret_item/fun_secret/break_some_lights/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	command_announcement.Announce("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert")

	var/list/epicentreList = list()
	for(var/i in 1 to 2)
		var/list/possibleEpicentres = list()
		for(var/obj/abstract/landmark/newEpicentre in global.landmarks_list)
			if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
				possibleEpicentres += newEpicentre
		if(length(possibleEpicentres))
			epicentreList += pick(possibleEpicentres)
		else
			break

	if(!length(epicentreList))
		return

	for(var/obj/abstract/landmark/epicentre in epicentreList)
		for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
			apc.overload_lighting()
			CHECK_TICK

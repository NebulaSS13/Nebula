/mob/living/silicon/get_death_message(gibbed)
	return "gives one shrill beep before falling lifeless."

/mob/living/silicon/get_self_death_message(gibbed)
	return "You have suffered a critical system failure, and are dead."

/mob/living/silicon/get_dusted_remains()
	return /obj/item/remains/robot

/mob/living/silicon/get_gibbed_state(dusted)
	return dusted ? "dust-r" : "gibbed-r"

/mob/living/silicon/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..(do_gibs = FALSE)
	if(. && my_turf)
		spawn_gibber(my_turf)

/mob/living/silicon/death(gibbed)
	. = ..()
	if(. && in_contents_of(/obj/machinery/recharge_station))//exit the recharge station
		var/obj/machinery/recharge_station/RC = loc
		RC.go_out()
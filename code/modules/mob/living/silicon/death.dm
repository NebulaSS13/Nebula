/mob/living/silicon/get_death_message(gibbed)
	return "gives one shrill beep before falling lifeless."

/mob/living/silicon/get_self_death_message(gibbed)
	return "You have suffered a critical system failure, and are dead."

/mob/living/silicon/gib()
	..("gibbed-r")
	gibs()

/mob/living/silicon/get_gibber_type()
	return /obj/effect/gibspawner/robot

/mob/living/silicon/dust()
	..("dust-r", /obj/item/remains/robot)

/mob/living/silicon/death(gibbed)
	if(in_contents_of(/obj/machinery/recharge_station))//exit the recharge station
		var/obj/machinery/recharge_station/RC = loc
		RC.go_out()
	return ..()
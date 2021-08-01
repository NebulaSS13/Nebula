/datum/fake_client

/mob/fake_mob
	var/datum/fake_client/fake_client

/mob/fake_mob/Destroy()
	QDEL_NULL(fake_client)
	. = ..()

/mob/fake_mob/get_client()
	if(!fake_client)
		fake_client = new()
	return fake_client


/obj/unit_test_light
	w_class = ITEM_SIZE_TINY

/obj/unit_test_medium
	w_class = ITEM_SIZE_NORMAL

/obj/unit_test_heavy
	w_class = ITEM_SIZE_HUGE

/obj/random/unit_test/spawn_choices()
	return list(/obj/unit_test_light, /obj/unit_test_heavy, /obj/unit_test_medium)

/obj/unit_test
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"

/obj/unit_test/opaque
	opacity = TRUE

/obj/unit_test/transparent
	opacity = FALSE


/obj/machinery/test
	use_power = POWER_USE_ACTIVE

/obj/machinery/test/equip
	power_channel = EQUIP
	active_power_usage = 3

/obj/machinery/test/environ
	power_channel = ENVIRON
	active_power_usage = 5

/obj/machinery/test/light
	power_channel = ENVIRON
	active_power_usage = 7

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

/area/test_area/general
	icon_state = "blue"

/area/test_area/powered_non_dynamic_lighting
	name = "\improper Test Area - Powered - Non-Dynamic Lighting"
	icon_state = "green"
	requires_power = 0
	dynamic_lighting = FALSE

/area/test_area/requires_power_non_dynamic_lighting
	name = "\improper Test Area - Requires Power - Non-Dynamic Lighting"
	icon_state = "red"
	requires_power = 1
	dynamic_lighting = FALSE

/area/test_area/powered_dynamic_lighting
	name = "\improper Test Area - Powered - Dynamic Lighting"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = TRUE

/area/test_area/requires_power_dynamic_lighting
	name = "\improper Test Area - Requires Power - Dynamic Lighting"
	icon_state = "purple"
	requires_power = 1
	dynamic_lighting = TRUE

/area/test_area/edge_of_map
	name = "Edge of Map - Only map space turfs here"

/obj/item/paper/secret_note/example
	secret_key = "secret_note_example_single"

/obj/item/paper/secret_note/random/example
	secret_key = "secret_category_example_random_notes"

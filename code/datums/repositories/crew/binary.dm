/* Binary */
/crew_sensor_modifier/binary/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = FALSE
	var/obj/item/organ/internal/cell/cell = H.should_have_organ(BP_CELL) && GET_INTERNAL_ORGAN(H, BP_CELL)
	if(istype(cell))
		crew_data["alert"] = cell.percent() < 10
	else if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/O = H.get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if (!O || !BP_IS_PROSTHETIC(O)) // Don't make medical freak out over prosthetic hearts
			var/pulse = H.get_pulse()
			if(pulse == PULSE_NONE || pulse == PULSE_THREADY)
				crew_data["alert"] = TRUE
		if(H.get_blood_oxygenation() < BLOOD_VOLUME_SAFE)
			crew_data["alert"] = TRUE
	return ..()

/* Jamming */
/crew_sensor_modifier/binary/jamming
	priority = 5

/crew_sensor_modifier/binary/jamming/alive/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = FALSE
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/binary/jamming/dead/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = TRUE
	return MOD_SUIT_SENSORS_HANDLED

/* Random */
/crew_sensor_modifier/binary/jamming/random
	var/error_prob = 25

/crew_sensor_modifier/binary/jamming/random/moderate
	error_prob = 50

/crew_sensor_modifier/binary/jamming/random/major
	error_prob = 100

/crew_sensor_modifier/binary/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	if(prob(error_prob))
		crew_data["alert"] = pick(TRUE, FALSE)

/* Binary */
/crew_sensor_modifier/binary/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = FALSE
	if(!H.isSynthetic() && H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/O = H.get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if (!O || !BP_IS_PROSTHETIC(O)) // Don't make medical freak out over prosthetic hearts
			var/pulse = H.get_pulse()
			if(pulse == PULSE_NONE || pulse == PULSE_THREADY)
				crew_data["alert"] = TRUE
		if(H.get_blood_oxygenation() < BLOOD_VOLUME_SAFE)
			crew_data["alert"] = TRUE
	if(H.isSynthetic())
		var/obj/item/organ/internal/cell/cell = H.get_organ(BP_CELL, /obj/item/organ/internal/cell)
		if(!cell || cell.percent() < 10)
			crew_data["alert"] = TRUE
	return ..()

/* Jamming */
/crew_sensor_modifier/binary/jamming
	priority = 5

/crew_sensor_modifier/binary/jamming/alive/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = FALSE
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/binary/jamming/dead/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	crew_data["alert"] = TRUE
	return MOD_SUIT_SENSORS_HANDLED

/* Random */
/crew_sensor_modifier/binary/jamming/random
	var/error_prob = 25

/crew_sensor_modifier/binary/jamming/random/moderate
	error_prob = 50

/crew_sensor_modifier/binary/jamming/random/major
	error_prob = 100

/crew_sensor_modifier/binary/jamming/random/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	. = ..()
	if(prob(error_prob))
		crew_data["alert"] = pick(TRUE, FALSE)

/datum/stressor/ate_cooked_food
	name = "Ate Cooked Food"
	desc = "well fed."
	stress_value = -(STRESSOR_DEGREE_MILD)

/datum/stressor/well_groomed
	name = "Well Groomed"
	desc = "neat and tidy."
	stress_value = -(STRESSOR_DEGREE_MILD)

/datum/stressor/ate_raw_food
	name = "Ate Raw Food"
	desc = "queasy from raw food."
	stress_value = STRESSOR_DEGREE_MILD

/datum/stressor/hungry
	name = "Hungry"
	desc = "hungry."
	stress_value = STRESSOR_DEGREE_MILD
	incompatible_with_stressors = list(/datum/stressor/hungry_very)

/datum/stressor/hungry_very
	name = "Starving"
	desc = "starving."
	stress_value = STRESSOR_DEGREE_MODERATE
	suppress_stressors = list(/datum/stressor/hungry)

/datum/stressor/thirsty
	name = "Thirsty"
	desc = "thirsty."
	stress_value = STRESSOR_DEGREE_MILD
	incompatible_with_stressors = list(/datum/stressor/thirsty_very)

/datum/stressor/thirsty_very
	name = "Dehydrated"
	desc = "dehydrated."
	stress_value = STRESSOR_DEGREE_MODERATE
	suppress_stressors = list(/datum/stressor/thirsty)

/datum/stressor/used_chems
	name = "Used Chems"
	desc = "recovering after the use of medication."
	stress_value = STRESSOR_DEGREE_MODERATE

/datum/stressor/comfortable
	name = "Comfortable"
	desc = "comfortable."
	stress_value = -(STRESSOR_DEGREE_MILD)
	incompatible_with_stressors = list(/datum/stressor/comfortable_very)

/datum/stressor/comfortable_very
	name = "Very Comfortable"
	desc = "very comfortable."
	stress_value = -(STRESSOR_DEGREE_MODERATE)
	suppress_stressors = list(/datum/stressor/comfortable)

/datum/stressor/uncomfortable
	name = "Uncomfortable"
	desc = "uncomfortable."
	stress_value = STRESSOR_DEGREE_MILD
	incompatible_with_stressors = list(/datum/stressor/uncomfortable_very)

/datum/stressor/uncomfortable_very
	name = "Very Uncomfortable"
	desc = "very uncomfortable."
	stress_value = STRESSOR_DEGREE_MODERATE
	suppress_stressors = list(/datum/stressor/uncomfortable)

/datum/stressor/well_rested
	name = "Well Rested"
	desc = "well rested."
	stress_value = -(STRESSOR_DEGREE_MODERATE)

/datum/stressor/fatigued
	name = "Fatigued"
	desc = "fatigued."
	stress_value = STRESSOR_DEGREE_MODERATE

/datum/stressor/ate_cooked_food
	name = "Ate Cooked Food"
	desc = "well fed."
	stress_value = -(STRESSOR_DEGREE_MILD)

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

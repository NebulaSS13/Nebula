/datum/stressor/ate_cooked_food
	name = "Ate Cooked Food"
	desc = "feeling satiated after eating a cooked meal"
	stress_value = -(STRESSOR_DEGREE_MILD)

/datum/stressor/hungry
	name = "Hungry"
	desc = "hungry"
	stress_value = STRESSOR_DEGREE_MILD
	incompatible_with_stressors = list(/datum/stressor/hungry_very)

/datum/stressor/hungry_very
	name = "Starving"
	desc = "starving"
	stress_value = STRESSOR_DEGREE_MODERATE
	suppress_stressors = list(/datum/stressor/hungry)

/datum/stressor/thirsty
	name = "Thirsty"
	desc = "thirsty"
	stress_value = STRESSOR_DEGREE_MILD
	incompatible_with_stressors = list(/datum/stressor/thirsty_very)

/datum/stressor/thirsty_very
	name = "Dehydrated"
	desc = "dehydrated"
	stress_value = STRESSOR_DEGREE_MODERATE
	suppress_stressors = list(/datum/stressor/thirsty)

/datum/stressor/used_chems
	name = "Used Chems"
	desc = "recovering after the use of medication"
	stress_value = STRESSOR_DEGREE_MODERATE

/* Example stressor tree:
/datum/stressor/generic_bad
	name = "Bad"
	desc = "feeling stressed"
	stress_value = STRESSOR_DEGREE_MILD
	on_addition_message = "You start feeling bad."
	on_removal_message =  "You stop feeling bad."
	incompatible_with_stressors = list(
		/datum/stressor/generic_bad_very,
		/datum/stressor/generic_bad_very_very
	)

/datum/stressor/generic_bad_very
	name = "Very Bad"
	desc = "feeling very stressed"
	stress_value = STRESSOR_DEGREE_MODERATE
	on_addition_message = "You start feeling very bad."
	on_removal_message =  "You stop feeling very bad."
	suppress_stressors = list(
		/datum/stressor/generic_bad
	)
	incompatible_with_stressors = list(
		/datum/stressor/generic_bad_very_very
	)

/datum/stressor/generic_bad_very_very
	name = "Very Very Bad"
	desc = "feeling very very stressed"
	on_addition_message = "You start feeling very very bad."
	on_removal_message =  "You stop feeling very very bad."
	stress_value = STRESSOR_DEGREE_SEVERE
	suppress_stressors = list(
		/datum/stressor/generic_bad,
		/datum/stressor/generic_bad_very
	)

*/
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
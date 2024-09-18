/datum/appearance_descriptor/headtail_length
	name = "headtail length"
	chargen_label = "headtails (caste)"
	skip_species_mention = TRUE
	standalone_value_descriptors = list(
		"very short and split",
		"very short",
		"short",
		"long",
		"very long"
		)
	chargen_value_descriptors = list(
		"very short and split (Raskinta-Katish)" =  1,
		"very short (Kanin-Katish)" = 2,
		"short (Malish-Katish)" = 3,
		"long (Talum-Katish)" = 4,
		"very long (Qerr-Katish)" = 5
		)

	comparative_value_descriptor_equivalent = "as long as yours"

	comparative_value_descriptors_smaller = list(
		"slightly shorter than yours",
		"shorter than yours",
		"much shorter than yours",
		"tiny and insignificant next to yours"
	)

	comparative_value_descriptors_larger = list(
		"slightly longer than yours",
		"longer than yours",
		"much longer than yours",
		"gigantic compared to yours"
	)

/datum/appearance_descriptor/headtail_length/get_first_person_message_start()
	. = "Your headtails are"

/datum/appearance_descriptor/headtail_length/get_third_person_message_start(var/decl/pronouns/my_gender)
	. = "[my_gender.His] headtails are"

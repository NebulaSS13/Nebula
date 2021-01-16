/datum/extension/obfuscated_medication
	base_type = /datum/extension/obfuscated_medication
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE

	var/original_reagent
	var/skill_threshold = SKILL_BASIC
	var/container_name = "container"
	var/container_description

/datum/extension/obfuscated_medication/proc/update_appearance()
	return

/datum/extension/obfuscated_medication/proc/get_original_reagent(var/obj/item/donor)
	return donor?.reagents?.get_primary_reagent_name()

/datum/extension/obfuscated_medication/proc/get_name()
	return "\improper [get_medication_name_from_reagent_name(original_reagent)] [container_name]"

/datum/extension/obfuscated_medication/bottle
	container_name = "bottle"
	container_description = "A small glass bottle of medication."
	expected_type = /obj/item/chems/glass/bottle

/datum/extension/obfuscated_medication/bottle/update_appearance()
	var/obj/item/bottle = holder
	bottle.icon_state = get_medication_icon_state_from_reagent_name(original_reagent, "bottle-", 1, 4)

/datum/extension/obfuscated_medication/pill
	container_name = "pill"
	container_description = "A small gel capsule of medication."
	expected_type = /obj/item/chems/pill

/datum/extension/obfuscated_medication/pill/update_appearance()
	var/obj/item/pill = holder
	pill.icon_state = get_medication_icon_state_from_reagent_name(original_reagent, "pill", 1, 5)

/datum/extension/obfuscated_medication/syringe
	container_name = "syringe"
	container_description = "A pre-loaded syringe of medication."
	expected_type = /obj/item/chems/syringe

/datum/extension/obfuscated_medication/pill_bottle
	container_name = "pill bottle"
	container_description = "A small plastic bottle of pills."
	expected_type = /obj/item/storage/pill_bottle

/datum/extension/obfuscated_medication/pill_bottle/get_original_reagent(var/obj/item/donor)
	for(var/obj/item/chems/pill/pill in donor?.contents)
		if(pill.reagents?.total_volume)
			return pill.reagents.get_primary_reagent_name()

/datum/extension/obfuscated_medication/pill_bottle/update_appearance()
	var/obj/item/storage/pill_bottle/bottle = holder
	bottle.wrapper_color = get_medication_colour_from_reagent_name(original_reagent)

/datum/extension/obfuscated_medication/foil_pack
	container_name = "foil pack"
	container_description = "A small foil blister pack of pills."
	expected_type = /obj/item/storage/pill_bottle/foil_pack

/datum/extension/obfuscated_medication/foil_pack/get_original_reagent(var/obj/item/donor)
	for(var/obj/item/chems/pill/pill in donor?.contents)
		if(pill.reagents?.total_volume)
			return pill.reagents.get_primary_reagent_name()

/datum/extension/obfuscated_medication/foil_pack/update_appearance()
	var/obj/item/storage/pill_bottle/foil_pack/foil_pack = holder
	foil_pack.wrapper_color = COLOR_OFF_WHITE
	foil_pack.color = get_medication_colour_from_reagent_name(original_reagent)

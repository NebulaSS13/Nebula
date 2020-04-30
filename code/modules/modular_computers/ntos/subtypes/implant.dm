/datum/extension/interactive/ntos/implant
	expected_type = /obj/item/organ/internal/augment/active/cyberbrain

/datum/extension/interactive/ntos/implant/get_component(var/part_type)
	var/obj/item/organ/internal/augment/active/cyberbrain/organ = holder
	return locate(part_type) in organ.stock_parts

/datum/extension/interactive/ntos/implant/get_all_components()
	var/obj/item/organ/internal/augment/active/cyberbrain/organ = holder
	return organ.stock_parts.Copy()

/datum/extension/interactive/ntos/implant/emagged()
	return FALSE

/datum/extension/interactive/ntos/implant/get_hardware_flag()
	return PROGRAM_PDA
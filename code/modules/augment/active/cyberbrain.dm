/obj/item/organ/internal/augment/active/cyberbrain
	name = "cyberbrain module"
	action_button_name = "Access cyberbrain"
	icon_state = "cyberbrain"
	allowed_organs = list(BP_AUGMENT_HEAD)
	augment_flags = AUGMENTATION_MECHANIC
	origin_tech = "{'materials':2,'magnets':3,'engineering':3,'biotech':2,'programming':4}"

	var/list/default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/battery_module/nano,
		/obj/item/stock_parts/computer/tesla_link
	)

/*
 *
 * Section for actual mechanics of cyberbrain.
 *
 */
/obj/item/organ/internal/augment/active/cyberbrain/Initialize()
	. = ..()

	START_PROCESSING(SSobj, src)
	set_extension(src, /datum/extension/interactive/os/device/implant)
	set_extension(src, /datum/extension/assembly/modular_computer/cyberbrain)

	update_icon()

	install_default_hardware()

/obj/item/organ/internal/augment/active/cyberbrain/get_contained_external_atoms()
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly)
		LAZYREMOVE(., assembly.parts)

// Used to perform preset-specific hardware changes.
/obj/item/organ/internal/augment/active/cyberbrain/proc/install_default_hardware()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	for(var/T in default_hardware)
		assembly.try_install_component(null, new T(src))

/obj/item/organ/internal/augment/active/cyberbrain/activate()
	if(!can_activate())
		return

	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.enabled && assembly.screen_on)
		var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
		if(os)
			os.ui_interact(owner)
	else if(!assembly.enabled && assembly.screen_on)
		assembly.turn_on(owner)

/obj/item/organ/internal/augment/active/cyberbrain/attackby(var/obj/item/W, var/mob/user)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.attackby(W, user))
		return
	return ..()

/obj/item/organ/internal/augment/active/cyberbrain/handle_mouse_drop(atom/over, mob/user)
	if(!istype(over, /obj/screen))
		attack_self(user)
		return TRUE
	. = ..()

/obj/item/organ/internal/augment/active/cyberbrain/Process()
	..()
	if(!is_broken() && !(status & ORGAN_DEAD))
		var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
		if(assembly)
			assembly.Process()
			if(!assembly.enabled)
				return
		var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
		if(os)
			os.Process()

/obj/item/organ/internal/augment/active/cyberbrain/get_contained_matter()
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	for(var/obj/part in assembly?.parts)
		. = MERGE_ASSOCS_WITH_NUM_VALUES(., part.get_contained_matter())

/*
 *
 * Section for assembly override for the cyberbrain.
 *
 */
/datum/extension/assembly/modular_computer/cyberbrain
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	enabled_by_default = TRUE
	max_parts = list(
		PART_BATTERY 	= 1,
		PART_CPU		= 1,
		PART_NETWORK	= 1,
		PART_HDD		= 1,
		PART_AI			= 1,
		PART_TESLA		= 1
	)
	expected_type = /obj/item/organ/internal/augment/active/cyberbrain
	assembly_name = "cyberbrain"
	force_synth = TRUE

/datum/extension/interactive/os/device/implant
	expected_type = /obj/item/organ/internal/augment/active/cyberbrain

/datum/extension/interactive/os/device/implant/emagged()
	return FALSE
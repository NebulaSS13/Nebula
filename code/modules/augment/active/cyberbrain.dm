/obj/item/organ/internal/augment/active/cyberbrain
	name = "cyberbrain module"
	action_button_name = "Access cyberbrain"
	allowed_organs = list(BP_AUGMENT_HEAD)
	augment_flags = AUGMENTATION_MECHANIC
	var/list/stock_parts = list()
	var/list/starting_stock_parts = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/hard_drive/silicon,
		/obj/item/stock_parts/computer/network_card
	)

/obj/item/organ/internal/augment/active/cyberbrain/Initialize()
	set_extension(src, /datum/extension/interactive/ntos/implant)
	for(var/T in starting_stock_parts)
		stock_parts += new T(src)

/obj/item/organ/internal/augment/active/cyberbrain/Destroy()
	QDEL_NULL_LIST(stock_parts)

/obj/item/organ/internal/augment/active/cyberbrain/activate()
	if(!can_activate())
		return

	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(!istype(os))
		to_chat(owner, SPAN_WARNING("You seem to be lacking an NTOS capable device!"))
		return

	if(!os.on)
		os.system_boot()
	if(!os.on)
		to_chat(owner, SPAN_WARNING("ERROR: NTOS failed to boot."))
		return

	os.ui_interact(owner)
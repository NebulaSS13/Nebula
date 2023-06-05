/datum/extension/appearance
	base_type = /datum/extension/appearance
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE // | EXTENSION_FLAG_MULTIPLE_INSTANCES
	var/appearance_handler_type
	var/item_equipment_proc
	var/item_removal_proc

/datum/extension/appearance/New(var/holder)
	var/decl/appearance_handler/appearance_handler = GET_DECL(appearance_handler_type)
	if(!appearance_handler)
		CRASH("Unable to acquire the [appearance_handler_type] appearance handler.")

	events_repository.register(/decl/observ/item_equipped, holder, appearance_handler, item_equipment_proc)
	events_repository.register(/decl/observ/item_unequipped, holder, appearance_handler, item_removal_proc)
	..()

/datum/extension/appearance/Destroy()
	var/decl/appearance_handler/appearance_handler = GET_DECL(appearance_handler_type)
	events_repository.unregister(/decl/observ/item_equipped, holder, appearance_handler, item_equipment_proc)
	events_repository.unregister(/decl/observ/item_unequipped, holder, appearance_handler, item_removal_proc)
	. = ..()
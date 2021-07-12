/obj/item/organ/internal/augment/active/polytool
	name = "embedded polytool module"
	action_button_name = "Deploy Tool"
	icon_state = "multitool"
	allowed_organs = list(BP_AUGMENT_R_HAND, BP_AUGMENT_L_HAND)
	augment_flags = AUGMENTATION_MECHANIC
	origin_tech = "{'materials':2,'magnets':2,'engineering':4}"
	var/list/items = list()
	var/list/paths = list() //We may lose them

/obj/item/organ/internal/augment/active/polytool/Initialize()
	. = ..()
	for(var/path in paths)
		var/obj/item/I = new path (src)
		I.canremove = FALSE
		items += I
/obj/item/organ/internal/augment/active/polytool/Destroy()
	QDEL_NULL_LIST(items)
	. = ..()

/obj/item/organ/internal/augment/active/polytool/proc/holding_dropped(var/obj/item/I)

	//Stop caring
	events_repository.unregister(/decl/observ/item_unequipped, I, src)

	if(I.loc != src) //something went wrong and is no longer attached/ it broke
		I.canremove = 1

/obj/item/organ/internal/augment/active/polytool/activate()
	if(!can_activate())
		return
	var/slot = null

	if(limb.organ_tag in list(BP_L_ARM, BP_L_HAND))
		slot = BP_L_HAND
	else if(limb.organ_tag in list(BP_R_ARM, BP_R_HAND))
		slot = BP_R_HAND

	var/obj/I = owner.get_equipped_item(slot)

	if(I)
		if(is_type_in_list(I,paths) && !(I.type in items)) //We don't want several of same but you can replace parts whenever
			if(!owner.drop_from_inventory(I, src))
				to_chat(owner, "\The [I] fails to retract.")
				return
			items += I
			var/decl/pronouns/G = owner.get_pronouns()
			owner.visible_message(
				SPAN_NOTICE("\The [owner] retracts [G.his] [I.name] into [G.his] [limb.name]."),
				SPAN_NOTICE("You retract your [I.name] into your [limb.name].")
			)
		else
			to_chat(owner, SPAN_WARNING("You must drop \the [I] before the polytool can extend."))
	else
		var/obj/item = input(owner, "Select the attachment to deploy.") as null|anything in src
		if(!item || !(src in owner.internal_organs))
			return
		if(owner.equip_to_slot_if_possible(item, slot))
			items -= item
			//Keep track of it, make sure it returns
			events_repository.register(/decl/observ/item_unequipped, item, src, /obj/item/organ/internal/augment/active/simple/proc/holding_dropped )
			var/decl/pronouns/G = owner.get_pronouns()
			owner.visible_message(
				SPAN_NOTICE("\The [owner] extends [G.his] [item.name] from [G.his] [limb.name]."),
				SPAN_NOTICE("You extend your [item.name] from your [limb.name].")
			)
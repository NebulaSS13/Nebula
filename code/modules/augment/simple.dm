//Simple toggleabse module. Just put holding in hands or get it back
/obj/item/organ/internal/augment/active/simple
	origin_tech = null
	var/obj/item/holding

/obj/item/organ/internal/augment/active/simple/Initialize()
	. = ..()
	if(ispath(holding))
		holding = new holding(src)
		holding.canremove = 0
		if(!origin_tech)
			origin_tech = holding.get_origin_tech()

/obj/item/organ/internal/augment/active/simple/Destroy()
	if(holding)
		events_repository.unregister(/decl/observ/item_unequipped, holding, src)
		if(holding.loc == src)
			QDEL_NULL(holding)
	return ..()

/obj/item/organ/internal/augment/active/simple/proc/holding_dropped()

	//Stop caring
	events_repository.unregister(/decl/observ/item_unequipped, holding, src)

	if(holding.loc != src) //something went wrong and is no longer attached/ it broke
		holding.canremove = 1
		holding = null     //We no longer hold this, you will have to get a replacement module or fix it somehow

/obj/item/organ/internal/augment/active/simple/proc/deploy()

	var/slot = null
	if(limb.organ_tag in list(BP_L_ARM, BP_L_HAND))
		slot = BP_L_HAND
	else if(limb.organ_tag in list(BP_R_ARM, BP_R_HAND))
		slot = BP_R_HAND
	if(owner.equip_to_slot_if_possible(holding, slot))
		events_repository.register(/decl/observ/item_unequipped, holding, src, /obj/item/organ/internal/augment/active/simple/proc/holding_dropped)
		var/decl/pronouns/G = owner.get_pronouns()
		owner.visible_message(
			SPAN_NOTICE("\The [owner] extends [G.his] [holding.name] from [G.his] [limb.name]."),
			SPAN_NOTICE("You extend your [holding.name] from your [limb.name].")
		)

/obj/item/organ/internal/augment/active/simple/proc/retract()
	if(holding.loc == src)
		return

	if(ismob(holding.loc) && holding.loc == owner)
		var/mob/M = holding.loc
		if(!M.drop_from_inventory(holding, src))
			to_chat(owner, SPAN_WARNING("\The [holding.name] fails to retract."))
			return
		var/decl/pronouns/G = M.get_pronouns()
		M.visible_message(
			SPAN_NOTICE("\The [M] retracts [G.his] [holding.name] into [G.his] [limb.name]."),
			SPAN_NOTICE("You retract your [holding.name] into [G.his] [limb.name].")
		)

/obj/item/organ/internal/augment/active/simple/activate()
	if(!can_activate())
		return

	if(holding.loc == src) //item not in hands
		deploy()
	else //retract item
		retract()

/obj/item/organ/internal/augment/active/simple/can_activate()
	. = ..()
	if(. && !holding)
		to_chat(owner, SPAN_WARNING("The device is damaged and fails to deploy."))
		. = FALSE

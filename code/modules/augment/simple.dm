//Simple toggleabse module. Just put holding in hands or get it back
/obj/item/organ/internal/augment/active/simple
	origin_tech = null
	var/retracting
	var/obj/item/holding

/obj/item/organ/internal/augment/active/simple/Initialize()
	. = ..()
	if(!ispath(holding))
		return
	holding = new holding(src)
	holding.canremove = FALSE
	if(!origin_tech)
		origin_tech = holding.get_origin_tech()
	events_repository.register(/decl/observ/moved, holding, src, /obj/item/organ/internal/augment/active/simple/proc/check_holding)
	events_repository.register(/decl/observ/destroyed, holding, src, /obj/item/organ/internal/augment/active/simple/proc/check_holding)
	events_repository.register(/decl/observ/item_unequipped, holding, src, /obj/item/organ/internal/augment/active/simple/proc/check_holding)

/obj/item/organ/internal/augment/active/simple/proc/check_holding()

	if(!holding)
		return

	if(QDELETED(holding))
		holding.canremove = TRUE
		events_repository.unregister(/decl/observ/moved, holding, src)
		events_repository.unregister(/decl/observ/destroyed, holding, src)
		events_repository.unregister(/decl/observ/item_unequipped, holding, src)
		holding = null
		return

	if(holding.loc != src && (!owner || holding.loc != owner))
		retract()

/obj/item/organ/internal/augment/active/simple/Destroy()
	QDEL_NULL(holding)
	return ..()

/obj/item/organ/internal/augment/active/simple/proc/deploy()
	var/slot = null
	if(parent_organ in list(BP_L_ARM, BP_L_HAND))
		slot = BP_L_HAND
	else if(parent_organ in list(BP_R_ARM, BP_R_HAND))
		slot = BP_R_HAND
	if(slot && owner.equip_to_slot_if_possible(holding, slot))
		var/obj/item/organ/external/limb = owner?.get_organ(parent_organ)
		var/decl/pronouns/pronouns = owner.get_pronouns()
		owner.visible_message(
			SPAN_NOTICE("\The [owner] extends [pronouns.his] [holding.name] from [pronouns.his] [limb ? limb.name : "limb"]."),
			SPAN_NOTICE("You extend your [holding.name] from your [limb ? limb.name : "limb"].")
		)

/obj/item/organ/internal/augment/active/simple/proc/retract()
	if(holding.loc == src || retracting)
		return
	retracting = TRUE
	holding.canremove = TRUE
	if(owner && holding.loc == owner)
		if(!owner.drop_from_inventory(holding, src))
			to_chat(owner, SPAN_WARNING("\The [holding.name] fails to retract."))
			holding.canremove = FALSE
			retracting = FALSE
			return
		var/obj/item/organ/external/limb = owner?.get_organ(parent_organ)
		var/decl/pronouns/pronouns = owner.get_pronouns()
		owner.visible_message(
			SPAN_NOTICE("\The [owner] retracts [pronouns.his] [holding.name] into [pronouns.his] [limb ? limb.name : "limb"]."),
			SPAN_NOTICE("You retract your [holding.name] into [pronouns.his] [limb ? limb.name : "limb"].")
		)
	else if(ismob(holding.loc))
		var/mob/M = holding.loc
		M.drop_from_inventory(holding)
	holding.forceMove(src)
	holding.canremove = FALSE
	retracting = FALSE

/obj/item/organ/internal/augment/active/simple/activate()
	if(!can_activate())
		return
	if(holding.loc == src)
		deploy()
	else
		retract()

/obj/item/organ/internal/augment/active/simple/can_activate()
	. = ..()
	if(. && !holding)
		to_chat(owner, SPAN_WARNING("The device is damaged and fails to deploy."))
		. = FALSE

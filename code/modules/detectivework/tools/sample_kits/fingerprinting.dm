
/obj/item/forensics/sample_kit/powder
	name = "fingerprint powder"
	desc = "A jar containing aluminium powder and a specialized brush."
	icon_state = "dust"
	evidence_type = "fingerprint"
	evidence_path = /obj/item/forensics/sample/print
	possible_evidence_types = list(
		/datum/forensics/fingerprints
	)
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

// Fingerprint card

/obj/item/forensics/sample/print
	name = "fingerprint card"
	desc = "Records a set of fingerprints."
	icon = 'icons/obj/card.dmi'
	icon_state = "fingerprint0"
	item_state = "paper"
	possible_evidence_types = list(/datum/forensics/fingerprints)
	material = /decl/material/solid/organic/plastic

/obj/item/forensics/sample/print/on_update_icon()
	. = ..()
	if(length(evidence))
		icon_state = "fingerprint1"
	else
		icon_state = "fingerprint0"

/obj/item/forensics/sample/print/merge_evidence_list(var/list/new_evidence)
	for(var/datum/fingerprint/newprint in new_evidence)
		for(var/datum/fingerprint/F in evidence)
			if(F.merge(newprint))
				new_evidence -= newprint
				break
	..()

/obj/item/forensics/sample/print/attack_self(var/mob/user)
	if(!can_take_print_from(user, user))
		return
	to_chat(user, SPAN_NOTICE("You firmly press your fingertips onto the card."))
	add_full_print(user)

/obj/item/forensics/sample/print/proc/add_full_print(var/mob/M)
	var/datum/fingerprint/F = new()
	F.full_print = M.get_full_print()
	F.completeness = 100
	var/datum/forensics/fingerprints/FP = new()
	FP.data = list(F)
	merge_evidence_list(list(FP))
	SetName("[initial(name)] (\the [M])")
	update_icon()

/obj/item/forensics/sample/print/proc/can_take_print_from(mob/living/human/H, user)
	if(LAZYLEN(evidence))
		return

	if(!istype(H))
		return

	var/cover = H.get_covering_equipped_item(SLOT_HAND_LEFT|SLOT_HAND_RIGHT)
	if(cover)
		to_chat(user, SPAN_WARNING("\The [H]'s [cover] is in the way."))
		return

	for(var/tag in list(BP_R_HAND,BP_L_HAND)) //#FIXME: Alien prints??
		var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(H, tag)
		if(O)
			return TRUE
	to_chat(user, SPAN_WARNING("They don't have any hands."))

/obj/item/forensics/sample/print/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(!ishuman(target))
		return ..()

	var/mob/living/human/H = target
	if(!can_take_print_from(H, user))
		return 1

	var/time_to_take = H.a_intent == I_HELP ? 1 SECOND : 3 SECONDS
	user.visible_message(SPAN_NOTICE("\The [user] starts taking fingerprints from \the [H]."))
	if(!do_mob(user, H, time_to_take))
		user.visible_message(SPAN_WARNING("\The [user] tries to take prints from \the [H], but they move away."))
		return 1

	if(!can_take_print_from(H, user))
		return 1

	user.visible_message(SPAN_NOTICE("[user] takes a copy of \the [H]'s fingerprints."))
	add_full_print(H)
	return 1
/obj/item/forensics/sample_kit/swabs
	name = "swab kit"
	desc = "A kit full of sterilized cotton swabs and vials used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab_kit"
	evidence_type = "trace"
	evidence_path = /obj/item/forensics/sample/swab
	possible_evidence_types = list(
		/datum/forensics/gunshot_residue,
		/datum/forensics/trace_dna,
		/datum/forensics/blood_dna
	)
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/cloth = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
	)

/obj/item/forensics/sample_kit/swabs/attack(var/mob/living/carbon/human/H, var/mob/user)
	if(!istype(H))
		return ..()

	var/time_to_take = H.a_intent == I_HELP ? 1 SECOND : 3 SECONDS
	user.visible_message(SPAN_NOTICE("\The [user] starts swabbing a sample from \the [H]."))
	if(!do_mob(user, H, time_to_take))
		user.visible_message(SPAN_WARNING("\The [user] tried to take a swab sample from \the [H], but they moved away."))
		return

	if(user.get_target_zone() == BP_MOUTH)
		var/cover = H.get_covering_equipped_item(SLOT_FACE)
		if(cover)
			to_chat(user, SPAN_WARNING("\The [H]'s [cover] is in the way."))
			return

		if(!H.dna || !H.dna.unique_enzymes)
			to_chat(user, SPAN_WARNING("They don't seem to have DNA!"))
			return

		if(!H.check_has_mouth())
			to_chat(user, SPAN_WARNING("They don't have a mouth."))
			return

		user.visible_message(SPAN_NOTICE("[user] swabs \the [H]'s mouth for a saliva sample."))
		var/datum/forensics/trace_dna/trace = new()
		trace.data = list(H.dna.unique_enzymes)
		var/obj/item/forensics/sample/swab/S = new(get_turf(user))
		S.merge_evidence_list(list(trace))
		S.update_icon()
		user.put_in_hands(S)
	else
		var/zone = user.get_target_zone()
		if(!H.has_organ(zone))
			to_chat(user, SPAN_WARNING("They don't have that part!"))
			return
		var/obj/object_to_swab = GET_EXTERNAL_ORGAN(H, zone)
		var/cover = H.get_covering_equipped_item_by_zone(zone)
		if(cover)
			object_to_swab = cover

		var/datum/extension/forensic_evidence/forensics = get_extension(object_to_swab, /datum/extension/forensic_evidence)
		var/has_evidence
		if(forensics)
			for(var/T in possible_evidence_types)
				if(forensics.has_evidence(T))
					has_evidence = TRUE
		if(!has_evidence)
			to_chat(user, SPAN_WARNING("You can't find anything useful on \the [object_to_swab]."))
			return
		user.visible_message(SPAN_NOTICE("[user] swabs [H]'s [object_to_swab.name] for a sample."))
		var/obj/item/forensics/sample/swab/S = new /obj/item/forensics/sample/swab/(get_turf(user), object_to_swab)
		user.put_in_hands(S)
	update_icon()
	return 1


/obj/item/forensics/sample/swab
	name = "swab"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab"
	possible_evidence_types = list(
		/datum/forensics/gunshot_residue,
		/datum/forensics/trace_dna,
		/datum/forensics/blood_dna
	)

/obj/item/forensics/sample/swab/on_update_icon()
	. = ..()
	icon_state = "swab[length(evidence)? "_used" : ""]"
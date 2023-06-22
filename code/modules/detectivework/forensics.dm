
/atom/var/list/fingerprintshidden
/atom/var/fingerprintslast

/atom/proc/add_hiddenprint(mob/M)
	if(!M || !M.key)
		return
	if(fingerprintslast == M.key)
		return
	fingerprintslast = M.key
	if(!fingerprintshidden)
		fingerprintshidden = list()
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.get_equipped_item(slot_gloves_str))
			src.fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
			return 0

	src.fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
	return 1

/atom/proc/add_fingerprint(mob/M, ignoregloves, obj/item/tool)
	if(isnull(M)) return
	if(isAI(M)) return
	if(!M || !M.key)
		return
	if(istype(tool) && (tool.item_flags & ITEM_FLAG_NO_PRINT))
		return

	var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
	forensics.add_from_atom(/datum/forensics/fingerprints, M, ignoregloves)
	forensics.add_from_atom(/datum/forensics/fibers, M)

	add_hiddenprint(M)
	return 1

/// Reveal any blood on the item and update its color to that of luminol
/atom/proc/reveal_blood()
	return

/atom/proc/add_fibers(obj/item/clothing/source)
	if(!istype(source) || (source.item_flags & ITEM_FLAG_NO_PRINT))
		return
	var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
	forensics.add_from_atom(/datum/forensics/fibers, source)

/atom/proc/transfer_fingerprints_to(var/atom/A)
	var/datum/extension/forensic_evidence/forensics = get_extension(src, /datum/extension/forensic_evidence)
	if(!forensics)
		return
	var/datum/extension/forensic_evidence/other_forensics = get_or_create_extension(A, /datum/extension/forensic_evidence)
	for(var/T in forensics.evidence)
		var/datum/forensics/F = forensics.evidence[T]
		other_forensics.add_data(T, F.data)

/obj/item/proc/add_trace_DNA(mob/living/carbon/M)
	if(!istype(M))
		return
	if(M.isSynthetic())
		return
	if(istype(M.dna))
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
		forensics.add_from_atom(/datum/forensics/trace_dna, M)

// On examination get hints of evidence
/obj/item/examine(mob/user, distance)
	. = ..()

	if(distance <= 1 && user.skill_check(SKILL_FORENSICS, SKILL_ADEPT))
		to_chat(user, SPAN_INFO("As a murder weapon, it's [english_list(get_autopsy_descriptors())]."))

	// Detective is on the case
	var/datum/extension/forensic_evidence/forensics = get_extension(src, /datum/extension/forensic_evidence)
	if(forensics?.check_spotting(user) && user.has_client_color(/datum/client_color/noir))
		user.playsound_local(null, pick('sound/effects/clue1.ogg','sound/effects/clue2.ogg'), 60, is_global = TRUE)

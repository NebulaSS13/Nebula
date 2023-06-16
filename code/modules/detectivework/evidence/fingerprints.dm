/datum/forensics/fingerprints
	name = "fingerprints"
	remove_on_transfer = TRUE

/datum/forensics/fingerprints/Destroy()
	. = ..()
	QDEL_NULL_LIST(data)

/datum/forensics/fingerprints/add_from_atom(mob/M, ignore_gloves)
	var/datum/fingerprint/F = new(M, ignore_gloves)
	if(F.completeness > 0)
		add_data(F)

/datum/forensics/fingerprints/add_data(var/datum/fingerprint/newprint)
	if(!newprint || newprint.completeness <= 0)
		return
	for(var/datum/fingerprint/F in data)
		if(F.merge(newprint))
			return
	..()

/datum/forensics/fingerprints/PopulateClone(datum/clone)
	var/datum/forensics/fingerprints/F = ..()
	for(var/datum/fingerprint/print in data)
		F.add_data(print.copy())
	return F

/datum/forensics/fingerprints/get_formatted_data()
	. = list("<h4>Fingerpints scan</h4>")
	for(var/datum/fingerprint/F in data)
		if(F.completeness > 80)
			. += "<li>[F.full_print]"
		else
			. += "<li>INCOMPLETE FINGERPRINT ([F.completeness]%)"
	return jointext(., "<br>")

/datum/forensics/fingerprints/spot_message(mob/detective, atom/location)
	to_chat(detective, SPAN_NOTICE("You notice a partial print on \the [location]."))

// Single (possibly partial) fingerprint
/datum/fingerprint
	var/full_print
	var/completeness = 0

/datum/fingerprint/proc/copy()
	var/datum/fingerprint/C = new()
	C.full_print = full_print
	C.completeness = completeness
	return C

/datum/fingerprint/New(mob/M, ignore_gloves)
	if(!istype(M))
		return
	full_print = M.get_full_print()
	if(!full_print)
		return

	//Using prints from severed hand items!
	var/obj/item/organ/external/E = M.get_active_hand()
	if(istype(E) && E.get_fingerprint())
		full_print = E.get_fingerprint()
		ignore_gloves = 1

	if(!ignore_gloves)
		var/obj/item/cover = M.get_covering_equipped_item(M.get_active_held_item_slot())
		if(cover)
			cover.add_fingerprint(M, 1)
			return

	var/extra_crispy = 0
	if(!M.skill_check(SKILL_FORENSICS, SKILL_BASIC))
		extra_crispy = 10

	completeness = clamp(rand(10, 70) + extra_crispy, 0, 100)

/datum/fingerprint/proc/merge(datum/fingerprint/other)
	if(full_print != other.full_print)
		return
	if(completeness >= 100)
		return TRUE
	completeness = clamp(max(completeness, other.completeness) + 0.2 * min(completeness, other.completeness), 0, 100)
	return TRUE

// Mob fingerprint getters
/mob/proc/get_full_print()
	return FALSE

/mob/living/carbon/get_full_print()
	if (!dna || (mFingerprints in mutations))
		return FALSE
	return md5(dna.uni_identity)

/mob/living/carbon/human/get_full_print()
	if(!..())
		return FALSE

	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, get_active_held_item_slot())
	if(E)
		return E.get_fingerprint()
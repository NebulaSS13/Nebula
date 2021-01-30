

/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY
	item_flags = ITEM_FLAG_NO_PRINT

// Sampling kits

/obj/item/forensics/sample_kit
	name = "fiber collection kit"
	desc = "A magnifying glass and tweezers. Used to lift suit fibers."
	icon_state = "m_glass"
	w_class = ITEM_SIZE_SMALL
	var/evidence_type = "fiber"
	var/evidence_path = /obj/item/forensics/sample/fibers
	var/possible_evidence_types = list(
		/datum/forensics/fibers
	)

/obj/item/forensics/sample_kit/proc/can_take_sample(var/mob/user, var/atom/supplied)
	var/datum/extension/forensic_evidence/forensics = get_extension(supplied, /datum/extension/forensic_evidence)
	if(forensics)
		for(var/T in possible_evidence_types)
			if(forensics.has_evidence(T))
				return TRUE

/obj/item/forensics/sample_kit/proc/take_sample(var/mob/user, var/atom/supplied)
	var/obj/item/forensics/sample/S = new evidence_path(get_turf(user), supplied)
	to_chat(user, SPAN_NOTICE("You transfer [S.evidence.len] [evidence_type]\s to \the [S]."))

/obj/item/forensics/sample_kit/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return
	if(user.skill_check(SKILL_FORENSICS, SKILL_ADEPT) && can_take_sample(user, A))
		take_sample(user,A)
		. = 1
	else
		to_chat(user, SPAN_WARNING("You are unable to locate any [evidence_type]s on \the [A]."))
		. = ..()

/obj/item/forensics/sample_kit/MouseDrop(atom/over)
	if(ismob(src.loc) && CanMouseDrop(over))
		afterattack(over, usr, TRUE)

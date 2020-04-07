//microscope code itself
/obj/machinery/forensic/microscope
	name = "high powered electron microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	icon_state = "microscope"
	allowed_evidence_types = list(
		/datum/forensics/fingerprints,
		/datum/forensics/fibers,
		/datum/forensics/gunshot_residue
	)
	base_type = /obj/machinery/forensic/microscope

/obj/machinery/forensic/microscope/physical_attack_hand(mob/user)
	. = TRUE
	if(!sample)
		to_chat(user, SPAN_WARNING("The microscope has no sample to examine."))
		return

	to_chat(user, SPAN_NOTICE("The microscope whirrs as you examine \the [sample]."))

	if(!user.do_skilled(25, SKILL_FORENSICS, src) || !sample)
		to_chat(user, SPAN_NOTICE("You stop examining \the [sample]."))
		return

	if(!user.skill_check(SKILL_FORENSICS, SKILL_ADEPT))
		to_chat(user, SPAN_WARNING("You can't figure out what it means..."))
		return
	if(!sample)
		to_chat(user, SPAN_WARNING("The microscope has no sample!"))
		return

	to_chat(user, SPAN_NOTICE("Printing findings now..."))
	print_report()

/obj/machinery/forensic/microscope/on_update_icon()
	icon_state = "microscope"
	if(stat & (NOPOWER|BROKEN))
		icon_state += "_unpowered"
	if(sample)
		icon_state += "_slide"

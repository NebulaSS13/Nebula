/////////////////////////////////////////////////////////////////
// Filling Cabinet
/////////////////////////////////////////////////////////////////
/obj/structure/filing_cabinet
	name                   = "filing cabinet"
	desc                   = "A large cabinet with drawers."
	icon                   = 'icons/obj/structures/filling_cabinets.dmi'
	icon_state             = "filingcabinet"
	material               = /decl/material/solid/metal/steel
	density                = TRUE
	anchored               = TRUE
	atom_flags             = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags              = OBJ_FLAG_ANCHORABLE
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	var/tmp/list/can_hold  = list(
		/obj/item/paper,
		/obj/item/folder,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/forensics/sample
	)

/obj/structure/filing_cabinet/Initialize(ml, _mat, _reinf_mat)
	if(ml)
		for(var/obj/item/I in loc)
			if(is_type_in_list(I, can_hold))
				I.forceMove(src)
	. = ..()

/obj/structure/filing_cabinet/attackby(obj/item/P, mob/user)
	if(is_type_in_list(P, can_hold))
		if(!user.try_unequip(P, src))
			return
		add_fingerprint(user)
		to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
		flick("[initial(icon_state)]-open",src)
		updateUsrDialog()
		return TRUE

	return ..()
/obj/structure/filing_cabinet/interact(mob/user)
	user.set_machine(src)
	var/dat = "<HR><TABLE>"
	for(var/obj/item/P in src)
		dat += "<TR><TD><A href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</A></TD></TR>"
	dat += "</TABLE>"
	show_browser(user, "<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=350x300")

/obj/structure/filing_cabinet/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return interact(user)

/obj/structure/filing_cabinet/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["retrieve"])
		close_browser(user, "window=filingcabinet")
		var/obj/item/P = locate(href_list["retrieve"])
		if(istype(P) && CanPhysicallyInteractWith(user, src))
			user.put_in_hands(P)
			flick("[initial(icon_state)]-open", src)
			updateUsrDialog()
			. = TOPIC_REFRESH

// Subtypes for mapping!
/obj/structure/filing_cabinet/chestdrawer
	name       = "chest drawer"
	icon_state = "chestdrawer"

/obj/structure/filing_cabinet/wall
	name               = "wall-mounted filing cabinet"
	desc               = "A filing cabinet installed into a cavity in the wall to save space. Wow!"
	icon_state         = "wallcabinet"
	obj_flags          = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"

/obj/structure/filing_cabinet/tall
	icon_state = "tallcabinet"

// Record cabinets fill with paper records on first interaction.
/obj/structure/filing_cabinet/records
	name = "security record archive"
	var/generated = FALSE
	var/archive_name = "security record"

// We generate records on first interaction, as latejoin,
// joining crew, etc. are hard to plan for and order around.
// It's also a fair few atoms to worry about.
/obj/structure/filing_cabinet/records/attack_hand(mob/user)
	if(!generated)
		generate_records()
	return ..()

/obj/structure/filing_cabinet/records/proc/generate_records()
	generated = TRUE
	var/datum/computer_network/network = get_local_network_at(get_turf(src))
	if(!network)
		return
	for(var/datum/computer_file/report/crew_record/record in network.get_crew_records())
		var/obj/item/paper/record_paperwork = new(src)
		record_paperwork.name = "[archive_name] - [record.get_name()]"
		record_paperwork.info = collate_data(record)
		record_paperwork.update_icon()

/obj/structure/filing_cabinet/records/proc/collate_data(var/datum/computer_file/report/crew_record/record)
	. = list()
	. += "<b>Name:</b> [record.get_name()]"
	. += "<b>Criminal Status:</b> [record.get_criminalStatus()]"
	. += "<b>Details:</b> [record.get_security_record()]"
	return jointext(., "<br>")

/obj/structure/filing_cabinet/records/medical
	name = "medical record archive"
	archive_name = "medical record"

/obj/structure/filing_cabinet/records/medical/collate_data(var/datum/computer_file/report/crew_record/record)
	. = list()
	. += "<b>Name:</b> [record.get_name()]"
	. += "<b>Gender:</b> [record.get_gender()]"
	. += "<b>Species:</b> [record.get_species_name()]"
	. += "<b>Blood Type:</b> [record.get_bloodtype()]"
	. += "<b>Details:</b> [record.get_medical_record()]"
	return jointext(., "<br>")

/obj/structure/filing_cabinet/records/medical
	name = "employment record archive"
	archive_name = "employment record"

/obj/structure/filing_cabinet/records/medical/collate_data(var/datum/computer_file/report/crew_record/record)
	. = list()
	. += "<b>Name:</b> [record.get_name()]"
	. += "<b>Gender:</b> [record.get_gender()]"
	. += "<b>Species:</b> [record.get_species_name()]"
	. += "<b>Details:</b> [record.get_employment_record()]"
	return jointext(., "<br>")

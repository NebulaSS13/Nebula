/datum/codex_category/surgery
	name = "Surgical Procedures"
	desc = "A list of surgeries, their requirements and their effects."

/datum/codex_category/surgery/Initialize()
	var/list/procedures = decls_repository.get_decls_of_subtype(/decl/surgery_step)
	for(var/stype in procedures)
		var/decl/surgery_step/procedure = procedures[stype]
		if(procedure.hidden_from_codex || !procedure.name)
			continue

		var/list/surgery_info = list()
		var/list/tool_names
		for(var/thing in procedure.allowed_tools)
			var/obj/tool = thing
			LAZYADD(tool_names, "\a [initial(tool.name)]")
		if(LAZYLEN(tool_names))
			surgery_info += "It can be performed with [english_list(tool_names, and_text = " or ")].<br>"
		if(LAZYLEN(procedure.allowed_species))
			surgery_info += "It can be performed on individuals who are [english_list(procedure.allowed_species, and_text = " or ")]."
		if(LAZYLEN(procedure.disallowed_species))
			surgery_info += "It cannot be performed on individuals who are [english_list(procedure.disallowed_species, and_text = " or ")]."
		if(procedure.delicate)
			surgery_info += "It is a very delicate operation and requires a proper operating table to perform."
		if(procedure.surgery_candidate_flags & SURGERY_NO_ROBOTIC)
			surgery_info += "It cannot be performed on prosthetic limbs."
		if(procedure.surgery_candidate_flags & SURGERY_NO_CRYSTAL)
			surgery_info += "It cannot be performed on crystalline limbs."
		if(procedure.surgery_candidate_flags & SURGERY_NO_STUMP)
			surgery_info += "It cannot be performed on the stump of severed limbs."
		if(procedure.surgery_candidate_flags & SURGERY_NO_FLESH)
			surgery_info += "It cannot be performed on non-prosthetic limbs."
		if(procedure.surgery_candidate_flags & SURGERY_NEEDS_INCISION)
			surgery_info += "It requires an incision or other open wound."
		if(procedure.surgery_candidate_flags & SURGERY_NEEDS_RETRACTED)
			surgery_info += "It requires a retracted incision or other large open wound."
		if(procedure.surgery_candidate_flags & SURGERY_NEEDS_ENCASEMENT)
			surgery_info += "It requires the sawing-open of encasing bones, such as the ribcage."
		if(procedure.additional_codex_lines)
			surgery_info += procedure.additional_codex_lines

		var/datum/codex_entry/entry = new(_display_name = lowertext(trim("[lowertext(procedure.name)] (surgery)")), _lore_text = procedure.description, _mechanics_text = jointext(surgery_info, "<br>"))
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	. = ..()
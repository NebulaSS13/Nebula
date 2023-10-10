/decl/codex_category/surgery
	name = "Surgical Procedures"
	desc = "A list of surgeries, their requirements and their effects."

	guide_name = "Surgery Basics"
	guide_html = {"
		<h1>Surgery Basics</h1>
		This guide contains some quick and dirty basic outlines of common surgical procedures.

		<h2>Important Notes</h2>
		<ul>
		<li>Surgery can be attempted by using a variety of items (such as scalpels, or improvised tools) on a patient who is prone on a surgical table, or buckled to a chair or roller bed.</li>
		<li>Performing surgery on a conscious patient will cause quite a lot of pain and screaming.</li>
		<li>Operating tables can be interacted with to turn a neural suppressor on or off, which will render anyone on the table unconscious.</li>
		<li>You can perform some surgeries on yourself using a chair, but this is probably not a good idea.</li>
		<li>Surgery depends heavily on your skill level, and generally shouldn't be attempted unless properly trained.</li>
		<li>Attempting surgery on anything other than help intent can have unexpected effects, or can be used to ignore surgery for items with other effects, like trauma kits.</li>
		<li>When violently severed, limbs will leave behind stumps, which must be removed prior to reattachment and may behave differently to regular limbs when operated on.</li>
		<li>Dosing the patient with regenerative medication, or trying to operate on treated wounds, can fail unexpectedly due to the wound closing. Making a new incision or using retractors to widen the wound may help.</li>
		<li>Surgical tools (and the surgeon's hands!) should be sterilized before surgery to avoid infecting wounds. This can be done with a sink.
		</ul>

		<h2>Making an incision</h2>
		<ol>
		<li>Target the desired bodypart on the target dolly.</li>
		<li>Use a scalpel to make an <span codexlink='make incision (surgery)'>incision</span>.</li>
		<li>Use a retractor to <span codexlink='widen incision (surgery)'>widen the incision</span>, if necessary.</li>
		<li>Use a hemostat to <span codexlink='clamp bleeders (surgery)'>clamp any bleeders</span>, if necessary.</li>
		<li>On bodyparts with bone encasement, like the skull and ribs, use a circular saw to <span codexlink='saw through bone (surgery)'>open the encasing bone</span>.</li>
		</ol>

		<h2>Closing an incision</h2>
		<ol>
		<li>Close and repair the bone, as below.</li>
		<li>Use a cautery to <span codexlink='cauterize incision (surgery)'>seal the incision</span>.</li>
		<li>Apply a bandage and salve to encourage healing.</li>
		</ol>

		<h2>Setting and repairing a broken bone</h2>
		While splints can make a broken limb usable, surgery will be needed to properly repair them.
		<ol>
		<li>Open an incision as above.</li>
		<li><span codexlink='begin bone repair (surgery)'>Apply bone repair gel</span> to the broken bone.</li>
		<li><span codexlink='set bone (surgery)'>Set the bone in place</span> with a bone setter.</li>
		<li><span codexlink='finish bone repair (surgery)'>Apply more bone gel</span> to finalize the repair.</li>
		<li>Close the incision as above.</li>
		</ol>

		<h2>Internal organ surgery</h2>
		All internal organ surgery requires access to the internal organs via an incision, as above.
		<ul>
		<li>A scalpel (or a multitool for a <span codexlink='decouple prosthetic organ (surgery)'>prosthetic</span>) can be used to <span codexlink='detach organ (surgery)'>detach an organ</span>, followed by a hemostat to <span codexlink='remove internal organ (surgery)'>remove the organ</span> entirely for transplant.</li>
		<li>A removed organ can be <span codexlink='replace internal organ (surgery)'>replaced</span> by using it on an empty section of the body, and <span codexlink='attach internal organ (surgery)'>reattached with sutures</span> (or a <span codexlink='reattach prosthetic organ (surgery)'>multitool for a prosthetic</span>).</li>
		<li>A damaged organ can be <span codexlink='repair internal organ (surgery)'>repaired</span> with a trauma pack (or nanopaste for a prosthetic).
		</ul>

		<h2>Amputation</h2>
		Limbs or limb stumps can be <span codexlink='amputate limb (surgery)'>amputated</span> with a circular saw, but any other form of surgery in progress will take precedence. Cauterize any incisions or wounds before trying to amputate the limb. A proper surgical amputation will not leave a stump.

		<h2>Replacement limb installation</h2>
		Fresh limbs can be sourced from donors, organ printers, or prosthetics fabricators.
		<ol>
		<li>Remove the original limb or limb stump via <span codexlink='amputate limb (surgery)'>amputation</span>.</li>
		<li>Target the appropriate limb slot and <span codexlink='replace limb (surgery)'>install the new limb</span> on the patient.</li>
		<li>Use a <span codexlink='connect limb (surgery)'>hemostat to connect the nerves</span> to the new limb.</li>
		</ol>
	"}

/decl/codex_category/surgery/Populate()
	var/list/procedures = decls_repository.get_decls_of_subtype(/decl/surgery_step)
	for(var/stype in procedures)
		var/decl/surgery_step/procedure = procedures[stype]
		if(procedure.hidden_from_codex || !procedure.name)
			continue

		var/list/surgery_info = list()
		var/list/tool_names
		for(var/thing in procedure.allowed_tools)
			if(ispath(thing, /obj))
				var/obj/tool = thing
				LAZYADD(tool_names, "\a [initial(tool.name)]")
			else if(ispath(thing, /decl/tool_archetype))
				var/decl/tool_archetype/tool = GET_DECL(thing)
				if(tool.article)
					LAZYADD(tool_names, "\a [tool.name]")
				else
					LAZYADD(tool_names, tool.name)

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

		var/datum/codex_entry/entry = new(
			_display_name = "[lowertext(procedure.name)] (surgery)",
			_lore_text = procedure.description,
			_mechanics_text = jointext(surgery_info, "<br>")
		)
		items |= entry.name
	. = ..()

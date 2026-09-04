/mob/living/human/get_examine_header(mob/user, distance, infix, suffix, hideflags)
	SHOULD_CALL_PARENT(FALSE)
	. = list(SPAN_INFO("*---------*"))
	var/list/mob_intro = "[user == src ? "You are" : "This is"] <EM>[name]</EM>"
	if(!(hideflags & HIDEJUMPSUIT) || !(hideflags & HIDEFACE))
		var/species_name = "\improper "
		if(isSynthetic() && species.cyborg_noun)
			species_name += "[species.cyborg_noun] [species.name]"
		else
			species_name += "[species.name]"
		mob_intro += ", <b><font color='[species.get_species_flesh_color(src)]'>\a [species_name]!</font></b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value(user))) ?  SPAN_NOTICE(" \[<a href='byond://?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"
	. += SPAN_INFO(JOINTEXT(mob_intro))
	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		. += "[extra_species_text]"
	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += SPAN_INFO(jointext(show_descs, "<br>"))
	var/print_flavour = print_flavor_text()
	if(print_flavour)
		. += SPAN_INFO("*---------*")
		. += SPAN_INFO("[print_flavour]")
	. += SPAN_INFO("*---------*")
	. = list(jointext(., "<br/>"))

/decl/human_examination/jitters/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	var/jitteriness = GET_STATUS(source, STAT_JITTER)
	switch(jitteriness)
		if(300 to INFINITY)
			return SPAN_DANGER("[pronouns.He] [pronouns.is] convulsing violently!")
		if(200 to 300)
			return SPAN_WARNING("[pronouns.He] [pronouns.is] extremely jittery.")
		if(100 to 200)
			return SPAN_WARNING("[pronouns.He] [pronouns.is] twitching ever so slightly.")
		else
			pass()

/decl/human_examination/disfigured
	priority = /decl/human_examination/jitters::priority + 1

/decl/human_examination/disfigured/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	//Disfigured face
	if(hideflags & HIDEFACE) //Disfigurement only matters for the head currently.
		return
	var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(source, BP_HEAD)
	if(!limb || !(limb.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
		return
	if(limb.species) //Check to make sure we have a species
		return limb.species.disfigure_msg(source)
	else //Just in case they lack a species for whatever reason.
		return SPAN_WARNING("[pronouns.His] face is horribly mangled!")

/decl/human_examination/stat
	priority = /decl/human_examination/disfigured::priority + 1

/decl/human_examination/stat/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	if (source.stat)
		. = list(SPAN_WARNING("[pronouns.He] [pronouns.is]n't responding to anything around [pronouns.him] and seems to be unconscious."))
		if((source.stat == DEAD || source.is_asystole() || source.suffocation_counter) && distance <= 3)
			. += SPAN_WARNING("[pronouns.He] [pronouns.does] not appear to be breathing.")

/decl/human_examination/contact_reagents
	priority = /decl/human_examination/stat::priority + 1

/decl/human_examination/contact_reagents/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	var/datum/reagents/touching_reagents = source.get_contact_reagents()
	if(REAGENT_TOTAL_VOLUME(touching_reagents) >= 1)
		var/saturation = REAGENT_TOTAL_VOLUME(touching_reagents) / REAGENT_MAXIMUM_VOLUME(touching_reagents)
		if(saturation > 0.9)
			. += "[pronouns.He] [pronouns.is] completely saturated."
		else if(saturation > 0.6)
			. += "[pronouns.He] [pronouns.is] looking half-drowned."
		else if(saturation > 0.3)
			. += "[pronouns.He] [pronouns.is] looking notably soggy."
		else
			. += "[pronouns.He] [pronouns.is] looking a bit soggy."

/decl/human_examination/fire
	priority = /decl/human_examination/contact_reagents::priority + 1

/decl/human_examination/fire/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	. = list()
	var/fire_level = source.get_fire_intensity()
	if(fire_level > 0)
		. += "[pronouns.He] [pronouns.is] looking highly flammable!"
	else if(fire_level < 0)
		. += "[pronouns.He] [pronouns.is] looking rather incombustible."

	if(source.is_on_fire())
		. += SPAN_WARNING("[pronouns.He] [pronouns.is] on fire!")

/decl/human_examination/ssd
	priority = /decl/human_examination/fire::priority + 1

/decl/human_examination/ssd/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	var/ssd_msg = source.species.get_ssd(source)
	if(ssd_msg && (!source.should_have_organ(BP_BRAIN) || source.has_brain()) && source.stat != DEAD)
		if(!source.key)
			. += SPAN_DEADSAY("[pronouns.He] [pronouns.is] [ssd_msg]. It doesn't look like [pronouns.he] [pronouns.is] waking up anytime soon.")
		else if(!source.client)
			. += SPAN_DEADSAY("[pronouns.He] [pronouns.is] [ssd_msg].")

// TODO: generalize and fold this into limb examine
/decl/human_examination/graffiti
	priority = /decl/human_examination/ssd::priority + 1

/decl/human_examination/graffiti/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	var/obj/item/organ/external/head/H = source.get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		. += SPAN_NOTICE("[pronouns.He] [pronouns.has] \"[H.forehead_graffiti]\" written on [pronouns.his] [H.name] in [H.graffiti_style]!")

/decl/human_examination/limb_examine
	priority = /decl/human_examination/graffiti::priority + 1

// This is still kind of a mess. TODO: /decl/organ_examination? lol
/decl/human_examination/limb_examine/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	. = list()
	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	var/decl/bodytype/root_bodytype = source.get_bodytype()
	for(var/organ_tag in root_bodytype.has_limbs)
		var/list/organ_data = root_bodytype.has_limbs[organ_tag]
		var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(source, organ_tag)

		if(!limb)
			wound_flavor_text[organ_tag] = list(SPAN_DANGER("[pronouns.He] [pronouns.is] missing [pronouns.his] [organ_data["descriptor"]]."))
			continue

		wound_flavor_text[limb.organ_tag] = list()

		if(limb.applied_pressure == source)
			applying_pressure = SPAN_INFO("[pronouns.He] [pronouns.is] applying pressure to [pronouns.his] [limb.name].")

		var/obj/item/clothing/hidden = source.get_covering_equipped_item(limb.body_part)

		if(hidden && user != source)
			if(limb.status & ORGAN_BLEEDING && !(hidden.item_flags & ITEM_FLAG_THICKMATERIAL)) //not through a spacesuit
				if(!hidden_bleeders[hidden])
					hidden_bleeders[hidden] = list()
				hidden_bleeders[hidden] += limb.organ_tag
		else
			// TODO: Make this just report if the bodytype is different than root and parent?
			// That way a robotic right arm would show up but the hand attached to it wouldn't.
			if(!source.isSynthetic() && BP_IS_PROSTHETIC(limb) && (limb.parent && !BP_IS_PROSTHETIC(limb.parent)))
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.He] [pronouns.has] a [limb.name].")
			var/wounddesc = limb.get_wounds_desc()
			if(wounddesc != "nothing")
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.He] [pronouns.has] [wounddesc] on [pronouns.his] [limb.name].")
		if(!hidden || distance <=1)
			if(limb.is_dislocated())
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.His] [limb.joint] is dislocated!")
			if(((limb.status & ORGAN_BROKEN) && limb.brute_dam > limb.min_broken_damage) || (limb.status & ORGAN_MUTATED))
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.His] [limb.name] is dented and swollen!")
			if(limb.status & ORGAN_DEAD)
				if(BP_IS_PROSTHETIC(limb) || BP_IS_CRYSTAL(limb))
					wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.His] [limb.name] is irrecoverably damaged!")
				else
					wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.His] [limb.name] is grey and necrotic!")
			else if((limb.brute_dam + limb.burn_dam) >= limb.max_damage && limb.germ_level >= INFECTION_LEVEL_TWO)
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.His] [limb.name] is likely beyond saving, and has begun to decay!")

		for(var/datum/wound/wound in limb.wounds)
			var/list/embedlist = wound.embedded_objects
			if(LAZYLEN(embedlist))
				shown_objects += embedlist
				var/parsedembed[0]
				for(var/obj/embedded in embedlist)
					var/single_embed_string = "\a [embedded.name]"
					var/plural_embed_string = "multiple [text_make_plural(embedded.name)]"
					if(!parsedembed.len || (!parsedembed.Find(single_embed_string) && !parsedembed.Find(plural_embed_string)))
						parsedembed.Add(single_embed_string)
					else if(!parsedembed.Find(plural_embed_string))
						parsedembed.Remove(single_embed_string)
						parsedembed.Add(plural_embed_string)
				wound_flavor_text[limb.organ_tag] += SPAN_WARNING("The [wound.desc] on [pronouns.his] [limb.name] has \a [english_list(parsedembed, and_text = " and a ", comma_text = ", a ")] sticking out of it!")

		if(limb.splinted && limb.splinted.loc == limb)
			wound_flavor_text[limb.organ_tag] += SPAN_WARNING("[pronouns.He] [pronouns.has] \a [limb.splinted] on [pronouns.his] [limb.name]!")

	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = SPAN_WARNING("[pronouns.He] [pronouns.has] blood soaking through [hidden] around [pronouns.his] [english_list(hidden_bleeders[hidden])]!")

	for(var/section in wound_flavor_text) // originally named limb, but can also include clothes
		if(length(wound_flavor_text[section]))
			. += jointext(wound_flavor_text[section], "<br>")

	if(applying_pressure)
		. += applying_pressure

	// TODO: move this into the limb for loop?
	for(var/obj/implant in source.get_visible_implants(0))
		if(implant in shown_objects)
			continue
		. += SPAN_DANGER("[source] [pronouns.has] \a [implant.name] sticking out of [pronouns.his] flesh!")

/decl/human_examination/digicamo
	priority = /decl/human_examination/limb_examine::priority + 1

/decl/human_examination/digicamo/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	if(source.digitalcamo)
		return SPAN_WARNING("[pronouns.He] [pronouns.is] repulsively uncanny!")

/decl/human_examination/hud
	priority = /decl/human_examination/digicamo::priority + 1

/decl/human_examination/hud/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	var/perpname = source.get_authentification_name(source.get_face_name())
	if(!perpname)
		return

	if(hasHUD(user, HUD_SECURITY))
		var/datum/computer_network/network = user.getHUDnetwork(HUD_SECURITY)
		if(network)
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			LAZYINITLIST(.)
			. += "<span class='deptradio'>Criminal status:</span> <a href='byond://?src=\ref[src];criminal=1'>\[[R?.get_criminalStatus() || "None"]\]</a>"
			. += "<span class='deptradio'>Security records:</span> <a href='byond://?src=\ref[src];secrecord=1'>\[View\]</a>"

	if(hasHUD(user, HUD_MEDICAL))
		var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
		if(network)
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			LAZYINITLIST(.)
			. += "<span class='deptradio'>Physical status:</span> <a href='byond://?src=\ref[src];medical=1'>\[[R?.get_status() || "None"]\]</a>"
			. += "<span class='deptradio'>Medical records:</span> <a href='byond://?src=\ref[src];medrecord=1'>\[View\]</a>"

/decl/human_examination/pose
	priority = /decl/human_examination/hud::priority + 1
	section_prefix = "*---------*"

/decl/human_examination/pose/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	if (!source.pose)
		return
	var/treated_pose = trim(source.handle_autopunctuation(source.pose))
	// if the pose starts with is, are, do, does, or doesn't, apply basic verb correction
	if(starts_with(treated_pose, "is ")) // if the pose starts with is
		treated_pose = "[pronouns.is] [copytext(treated_pose, 1, 4)]"
	if(starts_with(treated_pose, "are ")) // if the pose starts with are
		treated_pose = "[pronouns.is] [copytext(treated_pose, 1, 5)]"
	else if(starts_with(treated_pose, "does "))
		treated_pose = "[pronouns.does] [copytext(treated_pose, 1, 6)]"
	else if(starts_with(treated_pose, "do "))
		treated_pose = "[pronouns.does] [copytext(treated_pose, 1, 4)]"
	else if(starts_with(treated_pose, "doesn't "))
		treated_pose = "[pronouns.does]n't [copytext(treated_pose, 1, 9)]"
	else if(starts_with(treated_pose, "don't "))
		treated_pose = "[pronouns.does]n't [copytext(treated_pose, 1, 7)]"
	return "[pronouns.He] [source.handle_autopunctuation(source.pose)]"

/decl/human_examination/comments
	priority = /decl/human_examination/pose::priority + 99 // OOC info should show up pretty late.
	section_prefix = "*---------*"
	section_postfix = "*---------*" // this only applies if there is something after it

/decl/human_examination/comments/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	// Show IC/OOC info if available.
	if(!source.comments_record_id)
		return
	var/datum/character_information/comments = SScharacter_info.get_record(source.comments_record_id)
	if(comments?.show_info_on_examine && (comments.ic_info || comments.ooc_info))
		if(comments.ic_info)
			if(length(comments.ic_info) <= 40)
				. += "<b>IC Info:</b>"
				. += "&nbsp;&nbsp;&nbsp;&nbsp;[comments.ic_info]"
			else
				. += "<b>IC Info:</b>"
				. += "&nbsp;&nbsp;&nbsp;&nbsp;[copytext_preserve_html(comments.ic_info,1,37)]... <a href='byond://?src=\ref[source];flavor_more=1'>More...</a>"
		if(comments.ooc_info)
			if(length(comments.ooc_info) <= 40)
				. += "<b>OOC Info:</b>"
				. += "&nbsp;&nbsp;&nbsp;&nbsp;[comments.ooc_info]"
			else
				. += "<b>OOC Info:</b>"
				. += "&nbsp;&nbsp;&nbsp;&nbsp;[copytext_preserve_html(comments.ooc_info,1,37)]... <a href='byond://?src=\ref[source];flavor_more=1'>More...</a>"

/mob/living/human/get_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	. = ..()
	var/static/list/priority_examine_decls = sortTim(decls_repository.get_decls_of_subtype_unassociated(/decl/human_examination), /proc/cmp_human_examine_priority)
	var/last_divider = null
	for(var/decl/human_examination/examiner in priority_examine_decls)
		var/adding_text = examiner.do_examine(user, distance, src, hideflags, pronouns)
		if(!LAZYLEN(adding_text))
			continue
		if(last_divider) // insert the divider from the last entry
			. += last_divider
		else if(length(.) && examiner.section_prefix) // we already have prior entries, insert our prefix
			. += examiner.section_prefix
		. += adding_text
		last_divider = examiner.section_postfix

/mob/living/human/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	if(!stat || !ishuman(user) || user.incapacitated() || !Adjacent(user))
		return
	INVOKE_ASYNC(src, PROC_REF(check_heartbeat), user)

/mob/living/human/proc/check_heartbeat(mob/living/human/user)
	if(!stat || !ishuman(user) || user.incapacitated() || !Adjacent(user))
		return
	user.visible_message("<b>\The [user]</b> checks \the [src]'s pulse.", "You check \the [src]'s pulse.")
	if(do_after(user, 1.5 SECONDS, src))
		var/decl/pronouns/seen_pronouns = get_pronouns()
		if(get_pulse() == PULSE_NONE)
			to_chat(user, SPAN_DEADSAY("[seen_pronouns.He] [seen_pronouns.has] no pulse."))
		else
			to_chat(user, SPAN_DEADSAY("[seen_pronouns.He] [seen_pronouns.has] a pulse!"))

//Helper procedure. Called by /mob/living/human/examined_by() and /mob/living/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	return !!M.getHUDsource(hudtype)

/mob/proc/getHUDsource(hudtype)
	return

/mob/living/human/getHUDsource(hudtype)
	var/obj/item/clothing/glasses/glasses = get_equipped_item(slot_glasses_str)
	if(!istype(glasses))
		return ..()
	if(glasses.glasses_hud_type & hudtype)
		return glasses
	if(glasses.hud && (glasses.hud.glasses_hud_type & hudtype))
		return glasses.hud

/mob/living/silicon/robot/getHUDsource(hudtype)
	for(var/obj/item/borg/sight/sight in get_held_items())
		if(istype(sight) && (sight.glasses_hud_type & hudtype))
			return sight

//Gets the computer network M's source of hudtype is using
/mob/proc/getHUDnetwork(hudtype)
	var/obj/O = getHUDsource(hudtype)
	if(!O)
		return
	var/datum/extension/network_device/D = get_extension(O, /datum/extension/network_device)
	return D.get_network()

/mob/living/silicon/getHUDnetwork(hudtype)
	if(getHUDsource(hudtype))
		return get_computer_network()

/mob/living/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/decl/pronouns/pronouns = get_pronouns()
	pose = sanitize(input(usr, "This is [src]. [pronouns.He]...", "Pose", null)  as text)

/mob/living/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/list/HTML = list()
	HTML += "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='byond://?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, jointext(HTML,null), "window=flavor_changes;size=430x300")

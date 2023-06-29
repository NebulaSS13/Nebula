/mob/living/carbon/human/show_examined_short_description(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	var/msg = list("<span class='info'>*---------*\n[user == src ? "You are" : "This is"] <EM>[name]</EM>")
	if(!(hideflags & HIDEJUMPSUIT) || !(hideflags & HIDEFACE))
		var/species_name = "\improper "
		if(isSynthetic() && species.cyborg_noun)
			species_name += "[species.cyborg_noun] [species.get_root_species_name(src)]"
		else
			species_name += "[species.name]"
		msg += ", <b><font color='[species.get_flesh_colour(src)]'>\a [species_name]!</font></b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value(user))) ?  SPAN_NOTICE(" \[<a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"
	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		msg += "<br>[extra_species_text]"
	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		msg += "<br><span class='info'>[jointext(show_descs, "<br>")]</span>"
	var/print_flavour = print_flavor_text()
	if(print_flavour)
		msg += "<br/>*---------*"
		msg += "<br/>[print_flavour]"
	msg += "<br/>*---------*"
	to_chat(user, jointext(msg, null))

/mob/living/carbon/human/show_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)

	var/self_examine = (user == src)
	var/use_He    = self_examine ? "You"  : pronouns.He
	var/use_he    = self_examine ? "you"  : pronouns.he
	var/use_His   = self_examine ? "Your" : pronouns.His
	var/use_his   = self_examine ? "your" : pronouns.his
	var/use_is    = self_examine ? "are"  : pronouns.is
	var/use_does  = self_examine ? "do"   : pronouns.does
	var/use_has   = self_examine ? "have" : pronouns.has
	var/use_him   = self_examine ? "you"  : pronouns.him
	var/use_looks = self_examine ? "look" : "looks"

	var/list/msg = list()
	//Jitters
	var/jitteriness = GET_STATUS(src, STAT_JITTER)
	if(jitteriness >= 300)
		msg += "<span class='warning'><B>[use_He] [use_is] convulsing violently!</B></span>\n"
	else if(jitteriness >= 200)
		msg += "<span class='warning'>[use_He] [use_is] extremely jittery.</span>\n"
	else if(jitteriness >= 100)
		msg += "<span class='warning'>[use_He] [use_is] twitching ever so slightly.</span>\n"

	//Disfigured face
	if(!(hideflags & HIDEFACE)) //Disfigurement only matters for the head currently.
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, BP_HEAD)
		if(E && (E.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
			if(E.species) //Check to make sure we have a species
				msg += E.species.disfigure_msg(src)
			else //Just in case they lack a species for whatever reason.
				msg += "<span class='warning'>[use_His] face is horribly mangled!</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = GET_EXTERNAL_ORGAN(src, organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += "<span class='warning'>[use_He] [use_has] \a [o.splinted] on [use_his] [o.name]!</span>\n"

	if (src.stat)
		msg += "<span class='warning'>[use_He] [use_is]n't responding to anything around [use_him] and seems to be unconscious.</span>\n"
		if((stat == DEAD || is_asystole() || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[use_He] [use_does] not appear to be breathing.</span>\n"
		if(ishuman(user) && !user.incapacitated() && Adjacent(user))
			spawn(0)
				user.visible_message("<b>\The [user]</b> checks \the [src]'s pulse.", "You check \the [src]'s pulse.")
				if(do_after(user, 15, src))
					if(pulse() == PULSE_NONE)
						to_chat(user, "<span class='deadsay'>[use_He] [use_has] no pulse.</span>")
					else
						to_chat(user, "<span class='deadsay'>[use_He] [use_has] a pulse!</span>")

	if(fire_stacks > 0)
		msg += "[use_He] is covered in flammable liquid!\n"
	else if(fire_stacks < 0)
		msg += "[use_He] [use_is] soaking wet.\n"

	if(on_fire)
		msg += "<span class='warning'>[use_He] [use_is] on fire!.</span>\n"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[use_He] [use_is] [ssd_msg]. It doesn't look like [use_he] [use_is] waking up anytime soon.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>[use_He] [use_is] [ssd_msg].</span>\n"

	var/obj/item/organ/external/head/H = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		msg += "<span class='notice'>[use_He] [use_has] \"[H.forehead_graffiti]\" written on [use_his] [H.name] in [H.graffiti_style]!</span>\n"

	if(became_younger)
		msg += "[use_He] [use_looks] a lot younger than you remember.\n"
	if(became_older)
		msg += "[use_He] [use_looks] a lot older than you remember.\n"

	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_tag)

		if(!E)
			wound_flavor_text[organ_descriptor] = "<b>[use_He] [use_is] missing [use_his] [organ_descriptor].</b>\n"
			continue

		wound_flavor_text[E.name] = ""

		if(E.applied_pressure == src)
			applying_pressure = "<span class='info'>[use_He] [use_is] applying pressure to [use_his] [E.name].</span><br>"

		var/obj/item/clothing/hidden
		for(var/slot in global.standard_clothing_slots)
			var/obj/item/clothing/C = get_equipped_item(slot)
			if(istype(C) && (C.body_parts_covered & E.body_part))
				hidden = C
				break

		if(hidden && user != src)
			if(E.status & ORGAN_BLEEDING && !(hidden.item_flags & ITEM_FLAG_THICKMATERIAL)) //not through a spacesuit
				if(!hidden_bleeders[hidden])
					hidden_bleeders[hidden] = list()
				hidden_bleeders[hidden] += E.name
		else
			if(!isSynthetic() && BP_IS_PROSTHETIC(E) && (E.parent && !BP_IS_PROSTHETIC(E.parent)))
				wound_flavor_text[E.name] = "[use_He] [use_has] a [E.name].\n"
			var/wounddesc = E.get_wounds_desc()
			if(wounddesc != "nothing")
				wound_flavor_text[E.name] += "[use_He] [use_has] [wounddesc] on [use_his] [E.name].<br>"
		if(!hidden || distance <=1)
			if(E.is_dislocated())
				wound_flavor_text[E.name] += "[use_His] [E.joint] is dislocated!<br>"
			if(((E.status & ORGAN_BROKEN) && E.brute_dam > E.min_broken_damage) || (E.status & ORGAN_MUTATED))
				wound_flavor_text[E.name] += "[use_His] [E.name] is dented and swollen!<br>"
			if(E.status & ORGAN_DEAD)
				if(BP_IS_PROSTHETIC(E) || BP_IS_CRYSTAL(E))
					wound_flavor_text[E.name] += "[use_His] [E.name] is irrecoverably damaged!<br>"
				else
					wound_flavor_text[E.name] += "[use_His] [E.name] is grey and necrotic!<br>"
			else if(E.damage >= E.max_damage && E.germ_level >= INFECTION_LEVEL_TWO)
				wound_flavor_text[E.name] += "[use_His] [E.name] is likely beyond saving, and has begun to decay!<br>"

		for(var/datum/wound/wound in E.wounds)
			var/list/embedlist = wound.embedded_objects
			if(LAZYLEN(embedlist))
				shown_objects += embedlist
				var/parsedembed[0]
				for(var/obj/embedded in embedlist)
					if(!parsedembed.len || (!parsedembed.Find(embedded.name) && !parsedembed.Find("multiple [embedded.name]")))
						parsedembed.Add(embedded.name)
					else if(!parsedembed.Find("multiple [embedded.name]"))
						parsedembed.Remove(embedded.name)
						parsedembed.Add("multiple "+embedded.name)
				wound_flavor_text["[E.name]"] += "The [wound.desc] on [use_his] [E.name] has \a [english_list(parsedembed, and_text = " and \a ", comma_text = ", \a ")] sticking out of it!<br>"
	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = "[use_He] [use_has] blood soaking through [hidden] around [use_his] [english_list(hidden_bleeders[hidden])]!<br>"

	msg += "<span class='warning'>"
	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
	msg += "</span>"

	for(var/obj/implant in get_visible_implants(0))
		if(implant in shown_objects)
			continue
		msg += "<span class='danger'>[src] [use_has] \a [implant.name] sticking out of [use_his] flesh!</span>\n"
	if(digitalcamo)
		msg += "[use_He] [use_is] repulsively uncanny!\n"

	if(hasHUD(user, HUD_SECURITY))
		var/perpname = "wot"
		var/criminal = "None"

		var/obj/item/card/id/check_id = GetIdCard()
		if(istype(check_id))
			perpname = check_id.registered_name
		else
			perpname = src.name

		if(perpname)
			var/datum/computer_network/network = user.getHUDnetwork(HUD_SECURITY)
			if(network)
				var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
				if(R)
					criminal = R.get_criminalStatus()

				msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
				msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>\n"

	if(hasHUD(user, HUD_MEDICAL))
		var/perpname = "wot"
		var/medical = "None"

		var/obj/item/card/id/check_id = GetIdCard()
		if(istype(check_id))
			perpname = check_id.registered_name
		else
			perpname = src.name

		var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
		if(network)
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			if(R)
				medical = R.get_status()

			msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
			msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a>\n"

	msg += "*---------*</span><br>"
	msg += applying_pressure

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "[use_He] [pose]\n"

	var/list/human_examines = decls_repository.get_decls_of_subtype(/decl/human_examination)
	for(var/exam in human_examines)
		var/decl/human_examination/HE = human_examines[exam]
		var/adding_text = HE.do_examine(user, distance, src)
		if(adding_text)
			msg += adding_text

	to_chat(user, jointext(msg, null))

	..()

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	return !!M.getHUDsource(hudtype)

/mob/proc/getHUDsource(hudtype)
	return

/mob/living/carbon/human/getHUDsource(hudtype)
	var/obj/item/clothing/glasses/G = get_equipped_item(slot_glasses_str)
	if(!istype(G))
		return
	if(G.hud_type & hudtype)
		return G
	if(G.hud && (G.hud.hud_type & hudtype))
		return G.hud

/mob/living/silicon/robot/getHUDsource(hudtype)
	for(var/obj/item/borg/sight/sight in list(module_state_1, module_state_2, module_state_3))
		if(istype(sight) && (sight.hud_type & hudtype))
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

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/decl/pronouns/G = get_pronouns()
	pose = sanitize(input(usr, "This is [src]. [G.He]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
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
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, jointext(HTML,null), "window=flavor_changes;size=430x300")

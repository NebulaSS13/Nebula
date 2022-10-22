/mob/living/carbon/human/examine(mob/user, distance)
	SHOULD_CALL_PARENT(FALSE)
	. = TRUE
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	if(user.zone_sel)
		if(BP_TAIL in species.has_limbs)
			user.zone_sel.icon_state = "zone_sel_tail"
		else
			user.zone_sel.icon_state = "zone_sel"

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipeyes |= wear_mask.flags_inv & HIDEEYES
		skipears |= wear_mask.flags_inv & HIDEEARS
		skipface |= wear_mask.flags_inv & HIDEFACE

	//no accuately spotting headsets from across the room.
	if(distance > 3)
		skipears = 1

	var/list/msg = list("<span class='info'>*---------*\nThis is ")

	var/decl/pronouns/G
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		G = GET_DECL(/decl/pronouns)
	else
		G = get_pronouns()
		if(icon)
			msg += "[html_icon(icon)] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!G)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : gender]'")

	msg += "<EM>[src.name]</EM>"

	var/is_synth = isSynthetic()
	if(!(skipjumpsuit && skipface))
		var/species_name = "\improper "
		if(is_synth && species.cyborg_noun)
			species_name += "[species.cyborg_noun] [species.get_root_species_name(src)]"
		else
			species_name += "[species.name]"
		msg += ", <b><font color='[species.get_flesh_colour(src)]'>\a [species_name]!</font></b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value(user))) ?  SPAN_NOTICE(" \[<a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		msg += "[extra_species_text]<br>"

	msg += "<br>"

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += "[G.He] [G.is] wearing [w_uniform.get_examine_line()].\n"

	//head
	if(head)
		msg += "[G.He] [G.is] wearing [head.get_examine_line()] on [G.his] head.\n"

	//suit/armour
	if(wear_suit)
		msg += "[G.He] [G.is] wearing [wear_suit.get_examine_line()].\n"
		//suit/armour storage
		if(s_store && !skipsuitstorage)
			msg += "[G.He] [G.is] carrying [s_store.get_examine_line()] on [G.his] [wear_suit.name].\n"

	//back
	if(back)
		msg += "[G.He] [G.has] [back.get_examine_line()] on [G.his] back.\n"

	//held items
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, bp)
		if(inv_slot?.holding)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, bp)
			if(E)
				msg += "[G.He] [G.is] holding [inv_slot.holding.get_examine_line()] in [G.his] [E.name].\n"

	//gloves
	if(gloves && !skipgloves)
		msg += "[G.He] [G.has] [gloves.get_examine_line()] on [G.his] hands.\n"
	else
		var/list/jazzhands = get_hands_organs()
		var/datum/reagents/coating
		for(var/obj/item/organ/external/E in jazzhands)
			if(E.coating)
				coating = E.coating
				break
		if(coating)
			msg += "There's <font color='[coating.get_color()]'>something on [G.his] hands</font>!\n"

	//belt
	if(belt)
		msg += "[G.He] [G.has] [belt.get_examine_line()] about [G.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		msg += "[G.He] [G.is] wearing [shoes.get_examine_line()] on [G.his] feet.\n"
	else
		var/datum/reagents/coating
		for(var/bp in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, bp)
			if(E && E.coating)
				coating = E.coating
				break
		if(coating)
			msg += "There's <font color='[coating.get_color()]'>something on [G.his] feet</font>!\n"

	//mask
	if(wear_mask && !skipmask)
		msg += "[G.He] [G.has] [wear_mask.get_examine_line()] on [G.his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		msg += "[G.He] [G.has] [glasses.get_examine_line()] covering [G.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[G.He] [G.has] [l_ear.get_examine_line()] on [G.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[G.He] [G.has] [r_ear.get_examine_line()] on [G.his] right ear.\n"

	//ID
	if(wear_id)
		msg += "[G.He] [G.is] wearing [wear_id.get_examine_line()].\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "<span class='warning'>[G.He] [G.is] [html_icon(handcuffed)] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[G.He] [G.is] [html_icon(handcuffed)] handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[G.He] [G.is] [html_icon(buckled)] buckled to [buckled]!</span>\n"

	//Jitters
	var/jitteriness = GET_STATUS(src, STAT_JITTER)
	if(jitteriness >= 300)
		msg += "<span class='warning'><B>[G.He] [G.is] convulsing violently!</B></span>\n"
	else if(jitteriness >= 200)
		msg += "<span class='warning'>[G.He] [G.is] extremely jittery.</span>\n"
	else if(jitteriness >= 100)
		msg += "<span class='warning'>[G.He] [G.is] twitching ever so slightly.</span>\n"

	//Disfigured face
	if(!skipface) //Disfigurement only matters for the head currently.
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, BP_HEAD)
		if(E && (E.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
			if(E.species) //Check to make sure we have a species
				msg += E.species.disfigure_msg(src)
			else //Just in case they lack a species for whatever reason.
				msg += "<span class='warning'>[G.His] face is horribly mangled!</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = GET_EXTERNAL_ORGAN(src, organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += "<span class='warning'>[G.He] [G.has] \a [o.splinted] on [G.his] [o.name]!</span>\n"

	if(mSmallsize in mutations)
		msg += "[G.He] [G.is] small halfling!\n"

	if (src.stat)
		msg += "<span class='warning'>[G.He] [G.is]n't responding to anything around [G.him] and seems to be unconscious.</span>\n"
		if((stat == DEAD || is_asystole() || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[G.He] [G.does] not appear to be breathing.</span>\n"
		if(ishuman(user) && !user.incapacitated() && Adjacent(user))
			spawn(0)
				user.visible_message("<b>\The [user]</b> checks \the [src]'s pulse.", "You check \the [src]'s pulse.")
				if(do_after(user, 15, src))
					if(pulse() == PULSE_NONE)
						to_chat(user, "<span class='deadsay'>[G.He] [G.has] no pulse.</span>")
					else
						to_chat(user, "<span class='deadsay'>[G.He] [G.has] a pulse!</span>")

	if(fire_stacks > 0)
		msg += "[G.He] is covered in flammable liquid!\n"
	else if(fire_stacks < 0)
		msg += "[G.He] [G.is] soaking wet.\n"

	if(on_fire)
		msg += "<span class='warning'>[G.He] [G.is] on fire!.</span>\n"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[G.He] [G.is] [ssd_msg]. It doesn't look like [G.he] [G.is] waking up anytime soon.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>[G.He] [G.is] [ssd_msg].</span>\n"

	if (admin_paralyzed)
		msg += SPAN_OCCULT("OOC: [G.He] [G.has] been paralyzed by staff. Please avoid interacting with [G.him] unless cleared to do so by staff.") + "\n"

	var/obj/item/organ/external/head/H = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		msg += "<span class='notice'>[G.He] [G.has] \"[H.forehead_graffiti]\" written on [G.his] [H.name] in [H.graffiti_style]!</span>\n"

	if(became_younger)
		msg += "[G.He] looks a lot younger than you remember.\n"
	if(became_older)
		msg += "[G.He] looks a lot older than you remember.\n"

	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_tag)

		if(!E)
			wound_flavor_text[organ_descriptor] = "<b>[G.He] [G.is] missing [G.his] [organ_descriptor].</b>\n"
			continue

		wound_flavor_text[E.name] = ""

		if(E.applied_pressure == src)
			applying_pressure = "<span class='info'>[G.He] [G.is] applying pressure to [G.his] [E.name].</span><br>"

		var/obj/item/clothing/hidden
		var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
		for(var/obj/item/clothing/C in clothing_items)
			if(istype(C) && (C.body_parts_covered & E.body_part))
				hidden = C
				break

		if(hidden && user != src)
			if(E.status & ORGAN_BLEEDING && !(hidden.item_flags & ITEM_FLAG_THICKMATERIAL)) //not through a spacesuit
				if(!hidden_bleeders[hidden])
					hidden_bleeders[hidden] = list()
				hidden_bleeders[hidden] += E.name
		else
			if(!is_synth && BP_IS_PROSTHETIC(E) && (E.parent && !BP_IS_PROSTHETIC(E.parent) && !BP_IS_ASSISTED(E.parent)))
				wound_flavor_text[E.name] = "[G.He] [G.has] a [E.name].\n"
			var/wounddesc = E.get_wounds_desc()
			if(wounddesc != "nothing")
				wound_flavor_text[E.name] += "[G.He] [G.has] [wounddesc] on [G.his] [E.name].<br>"
		if(!hidden || distance <=1)
			if(E.is_dislocated())
				wound_flavor_text[E.name] += "[G.His] [E.joint] is dislocated!<br>"
			if(((E.status & ORGAN_BROKEN) && E.brute_dam > E.min_broken_damage) || (E.status & ORGAN_MUTATED))
				wound_flavor_text[E.name] += "[G.His] [E.name] is dented and swollen!<br>"
			if(E.status & ORGAN_DEAD)
				if(BP_IS_PROSTHETIC(E) || BP_IS_CRYSTAL(E))
					wound_flavor_text[E.name] += "[G.His] [E.name] is irrecoverably damaged!<br>"
				else
					wound_flavor_text[E.name] += "[G.His] [E.name] is grey and necrotic!<br>"
			else if(E.damage >= E.max_damage && E.germ_level >= INFECTION_LEVEL_TWO)
				wound_flavor_text[E.name] += "[G.His] [E.name] is likely beyond saving, and has begun to decay!<br>"

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
				wound_flavor_text["[E.name]"] += "The [wound.desc] on [G.his] [E.name] has \a [english_list(parsedembed, and_text = " and \a ", comma_text = ", \a ")] sticking out of it!<br>"
	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = "[G.He] [G.has] blood soaking through [hidden] around [G.his] [english_list(hidden_bleeders[hidden])]!<br>"

	msg += "<span class='warning'>"
	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
	msg += "</span>"

	for(var/obj/implant in get_visible_implants(0))
		if(implant in shown_objects)
			continue
		msg += "<span class='danger'>[src] [G.has] \a [implant.name] sticking out of [G.his] flesh!</span>\n"
	if(digitalcamo)
		msg += "[G.He] [G.is] repulsively uncanny!\n"

	if(hasHUD(user, HUD_SECURITY))
		var/perpname = "wot"
		var/criminal = "None"

		var/obj/item/card/id/id = GetIdCard()
		if(istype(id))
			perpname = id.registered_name
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

		var/obj/item/card/id/id = GetIdCard()
		if(istype(id))
			perpname = id.registered_name
		else
			perpname = src.name

		var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
		if(network)
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			if(R)
				medical = R.get_status()

			msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
			msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span><br>"
	msg += applying_pressure

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "[G.He] [pose]\n"

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		msg += "<span class='notice'>[jointext(show_descs, "<br>")]</span>"

	var/list/human_examines = decls_repository.get_decls_of_subtype(/decl/human_examination)
	for(var/exam in human_examines)
		var/decl/human_examination/HE = human_examines[exam]
		var/adding_text = HE.do_examine(user, distance, src)
		if(adding_text)
			msg += adding_text

	to_chat(user, jointext(msg, null))

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	return !!M.getHUDsource(hudtype)

/mob/proc/getHUDsource(hudtype)
	return

/mob/living/carbon/human/getHUDsource(hudtype)
	var/obj/item/clothing/glasses/G = glasses
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

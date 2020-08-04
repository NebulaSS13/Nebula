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

	var/list/msg = list("<span class='info'>*---------*<BR>This is ")

	var/datum/gender/T = gender_datums[get_gender()]
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]
	else
		if(icon)
			msg += "[icon2html(icon, user)] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!T)
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
		msg += ", <b><font color='[species.get_flesh_colour(src)]'>\a [species_name]!</font></b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value())) ?  SPAN_NOTICE(" \[<a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		msg += "[extra_species_text]<BR>"

	msg += "<BR>"

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += "[T.He] [T.is] wearing [w_uniform.get_examine_line(user)].<BR>"

	//head
	if(head)
		msg += "[T.He] [T.is] wearing [head.get_examine_line(user)] on [T.his] head.<BR>"

	//suit/armour
	if(wear_suit)
		msg += "[T.He] [T.is] wearing [wear_suit.get_examine_line(user)].<BR>"
		//suit/armour storage
		if(s_store && !skipsuitstorage)
			msg += "[T.He] [T.is] carrying [s_store.get_examine_line(user)] on [T.his] [wear_suit.name].<BR>"

	//back
	if(back)
		msg += "[T.He] [T.has] [back.get_examine_line(user)] on [T.his] back.<BR>"

	//held items
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, bp)
		var/obj/item/organ/external/E = organs_by_name[bp]
		if(inv_slot?.holding)
			msg += "[T.He] [T.is] holding [inv_slot.holding.get_examine_line()] in [T.his] [E.name].<BR>"

	//gloves
	if(gloves && !skipgloves)
		msg += "[T.He] [T.has] [gloves.get_examine_line(user)] on [T.his] hands.<BR>"
	else if(blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!</span><BR>"

	//belt
	if(belt)
		msg += "[T.He] [T.has] [belt.get_examine_line(user)] about [T.his] waist.<BR>"

	//shoes
	if(shoes && !skipshoes)
		msg += "[T.He] [T.is] wearing [shoes.get_examine_line(user)] on [T.his] feet.<BR>"
	else if(feet_blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!</span><BR>"

	//mask
	if(wear_mask && !skipmask)
		msg += "[T.He] [T.has] [wear_mask.get_examine_line(user)] on [T.his] face.<BR>"

	//eyes
	if(glasses && !skipeyes)
		msg += "[T.He] [T.has] [glasses.get_examine_line(user)] covering [T.his] eyes.<BR>"

	//left ear
	if(l_ear && !skipears)
		msg += "[T.He] [T.has] [l_ear.get_examine_line(user)] on [T.his] left ear.<BR>"

	//right ear
	if(r_ear && !skipears)
		msg += "[T.He] [T.has] [r_ear.get_examine_line(user)] on [T.his] right ear.<BR>"

	//ID
	if(wear_id)
		msg += "[T.He] [T.is] wearing [wear_id.get_examine_line(user)].<BR>"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "<span class='warning'>[T.He] [T.is] [icon2html(handcuffed, user)] restrained with cable!</span><BR>"
		else
			msg += "<span class='warning'>[T.He] [T.is] [icon2html(handcuffed, user)] handcuffed!</span><BR>"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[T.He] [T.is] [icon2html(buckled, user)] buckled to [buckled]!</span><BR>"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span><BR>"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[T.He] [T.is] extremely jittery.</span><BR>"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span><BR>"

	//Disfigured face
	if(!skipface) //Disfigurement only matters for the head currently.
		var/obj/item/organ/external/head/E = get_organ(BP_HEAD)
		if(E && (E.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
			if(E.species) //Check to make sure we have a species
				msg += E.species.disfigure_msg(src)
			else //Just in case they lack a species for whatever reason.
				msg += "<span class='warning'>[T.His] face is horribly mangled!</span><BR>"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += "<span class='warning'>[T.He] [T.has] \a [o.splinted] on [T.his] [o.name]!</span><BR>"

	if(mSmallsize in mutations)
		msg += "[T.He] [T.is] small halfling!<BR>"

	if (src.stat)
		msg += "<span class='warning'>[T.He] [T.is]n't responding to anything around [T.him] and seems to be unconscious.</span><BR>"
		if((stat == DEAD || is_asystole() || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[T.He] [T.does] not appear to be breathing.</span><BR>"
		if(ishuman(user) && !user.incapacitated() && Adjacent(user))
			spawn(0)
				user.visible_message("<b>\The [user]</b> checks \the [src]'s pulse.", "You check \the [src]'s pulse.")
				if(do_after(user, 15, src))
					if(pulse() == PULSE_NONE)
						to_chat(user, "<span class='deadsay'>[T.He] [T.has] no pulse.</span>")
					else
						to_chat(user, "<span class='deadsay'>[T.He] [T.has] a pulse!</span>")

	if(fire_stacks > 0)
		msg += "[T.He] is covered in flammable liquid!<BR>"
	else if(fire_stacks < 0)
		msg += "[T.He] [T.is] soaking wet.<BR>"

	if(on_fire)
		msg += "<span class='warning'>[T.He] [T.is] on fire!.</span><BR>"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span><BR>"
		else if(!client)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg].</span><BR>"

	var/obj/item/organ/external/head/H = organs_by_name[BP_HEAD]
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		msg += "<span class='notice'>[T.He] [T.has] \"[H.forehead_graffiti]\" written on [T.his] [H.name] in [H.graffiti_style]!</span><BR>"

	if(became_younger)
		msg += "[T.He] looks a lot younger than you remember.<BR>"
	if(became_older)
		msg += "[T.He] looks a lot older than you remember.<BR>"

	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]
		var/obj/item/organ/external/E = organs_by_name[organ_tag]

		if(!E)
			wound_flavor_text[organ_descriptor] = "<b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b><BR>"
			continue

		wound_flavor_text[E.name] = ""

		if(E.applied_pressure == src)
			applying_pressure = "<span class='info'>[T.He] [T.is] applying pressure to [T.his] [E.name].</span><BR>"

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
			if(E.is_stump())
				wound_flavor_text[E.name] += "<b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b><BR>"
				if(LAZYLEN(E.wounds) && E.parent)
					wound_flavor_text[E.name] += "[T.He] [T.has] [E.get_wounds_desc()] on [T.his] [E.parent.name].<BR>"
			else
				if(!is_synth && BP_IS_PROSTHETIC(E) && (E.parent && !BP_IS_PROSTHETIC(E.parent) && !BP_IS_ASSISTED(E.parent)))
					wound_flavor_text[E.name] = "[T.He] [T.has] a [E.name].<BR>"
				var/wounddesc = E.get_wounds_desc()
				if(wounddesc != "nothing")
					wound_flavor_text[E.name] += "[T.He] [T.has] [wounddesc] on [T.his] [E.name].<BR>"
		if(!hidden || distance <=1)
			if(E.dislocated > 0)
				wound_flavor_text[E.name] += "[T.His] [E.joint] is dislocated!<BR>"
			if(((E.status & ORGAN_BROKEN) && E.brute_dam > E.min_broken_damage) || (E.status & ORGAN_MUTATED))
				wound_flavor_text[E.name] += "[T.His] [E.name] is dented and swollen!<BR>"

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
				wound_flavor_text["[E.name]"] += "The [wound.desc] on [T.his] [E.name] has \a [english_list(parsedembed, and_text = " and \a ", comma_text = ", \a ")] sticking out of it!<BR>"
	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = "[T.He] [T.has] blood soaking through [hidden] around [T.his] [english_list(hidden_bleeders[hidden])]!<BR>"

	msg += "<span class='warning'>"
	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
	msg += "</span>"

	for(var/obj/implant in get_visible_implants(0))
		if(implant in shown_objects)
			continue
		msg += "<span class='danger'>[src] [T.has] \a [implant.name] sticking out of [T.his] flesh!</span><BR>"
	if(digitalcamo)
		msg += "[T.He] [T.is] repulsively uncanny!<BR>"

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

				msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a><BR>"
				msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a><BR>"

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

			msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a><BR>"
			msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a><BR>"


	if(print_flavor_text()) msg += "[print_flavor_text()]<BR>"

	if(mind && user.mind && name == real_name)
		var/list/relations = matchmaker.get_relationships_between(user.mind, mind, TRUE)
		if(length(relations))
			msg += "<BR><span class='notice'>You know them. <a href='byond://?src=\ref[src];show_relations=1'>More...</a></span><BR>"

	msg += "*---------*</span><BR>"
	msg += applying_pressure

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "[T.He] [pose]<BR>"

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		msg += "<span class='notice'>[jointext(show_descs, "<BR>")]</span>"
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

	pose =  sanitize(input(usr, "This is [src]. [get_visible_gender() == MALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/list/HTML = list()
	HTML += "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<BR></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<BR>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<BR>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, jointext(HTML,null), "window=flavor_changes;size=430x300")

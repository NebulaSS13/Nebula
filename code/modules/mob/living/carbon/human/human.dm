/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"
	mob_sort_value = 6
	dna = new /datum/dna()

	var/list/hud_list[10]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/step_count

/mob/living/carbon/human/Initialize(mapload, species_name = null, datum/dna/new_dna = null, decl/bodytype/new_bodytype = null)
	setup_hud_overlays()
	var/list/newargs = args.Copy(2)
	setup(arglist(newargs))
	global.human_mob_list |= src
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		post_setup(arglist(newargs))

/mob/living/carbon/human/proc/setup_hud_overlays()
	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[LIFE_HUD]	      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]          = new /image/hud_overlay(global.using_map.id_hud_icons, src, "hudunknown")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

/mob/living/carbon/human/Destroy()
	global.human_mob_list -= src
	regenerate_body_icon = FALSE // don't bother regenerating if we happen to be queued to update icon
	worn_underwear = null
	QDEL_NULL(attack_selector)
	QDEL_NULL(vessel)
	LAZYCLEARLIST(smell_cooldown)
	. = ..()

/mob/living/carbon/human/get_ingested_reagents()
	if(!should_have_organ(BP_STOMACH))
		return
	var/obj/item/organ/internal/stomach/stomach = get_organ(BP_STOMACH)
	return stomach?.ingested

/mob/living/carbon/human/get_fullness()
	if(!should_have_organ(BP_STOMACH))
		return ..()
	var/obj/item/organ/internal/stomach/stomach = get_organ(BP_STOMACH, /obj/item/organ/internal/stomach)
	if(stomach)
		return nutrition + (stomach.ingested?.total_volume * 10)
	return 0 //Always hungry, but you can't actually eat. :(

/mob/living/carbon/human/get_inhaled_reagents()
	if(!should_have_organ(BP_LUNGS))
		return
	var/obj/item/organ/internal/lungs/lungs = get_organ(BP_LUNGS)
	return lungs?.inhaled

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))

		var/obj/item/gps/G = get_active_hand()
		if(istype(G))
			stat("Coordinates:", "[G.get_coordinates()]")

		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[move_intent.name]")

		if(SSevac.evacuation_controller)
			var/eta_status = SSevac.evacuation_controller.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

		if (istype(internal))
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/obj/item/organ/internal/cell/potato = get_organ(BP_CELL, /obj/item/organ/internal/cell)
		if(potato?.cell)
			stat("Battery charge:", "[potato.get_charge()]/[potato.cell.maxcharge]")

		var/obj/item/rig/rig = get_rig()
		if(rig)
			var/cell_status = "ERROR"
			if(rig.cell)
				cell_status = "[rig.cell.charge]/[rig.cell.maxcharge]"
			stat(null, "Hardsuit charge: [cell_status]")

/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(M, BP_HEAD)
	LAZYDISTINCTADD(affected.implants, L)
	L.part = affected
	L.implanted(src)

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/item/organ/external/O in M.get_external_organs())
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if(get_equipped_item(slot_handcuffed_str))
		return 1
	if(grab_restrained())
		return 1
	if (istype(get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/proc/grab_restrained()
	for (var/obj/item/grab/G in grabbed_by)
		if(G.restrains())
			return TRUE

/mob/living/carbon/human/get_additional_stripping_options()
	. = ..()
	for(var/entry in worn_underwear)
		var/obj/item/underwear/UW = entry
		LAZYADD(., "<BR><a href='?src=\ref[src];item=\ref[UW]'>Remove \the [UW]</a>")


// TODO: remove when is_husked is moved to a parent type (or if husking is removed)
/mob/living/carbon/human/identity_is_visible()
	if(is_husked())
		return FALSE
	return ..()

/mob/living/carbon/human/OnSelfTopic(href_list)
	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(I)
			src.examinate(I)
			return TOPIC_HANDLED

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		if(M)
			src.examinate(M)
			return TOPIC_HANDLED

	return ..()

/mob/living/carbon/human/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	. = ..()
	if(href_list && (href_list["refresh"] || href_list["item"]))
		return min(., ..(user, global.physical_topic_state, href_list))

/mob/living/carbon/human/OnTopic(mob/user, href_list)
	if (href_list["criminal"])
		if(hasHUD(user, HUD_SECURITY))

			var/modified = 0
			var/perpname = "wot"
			var/obj/item/id = get_equipped_item(slot_wear_id_str)
			if(id)
				var/obj/item/card/id/I = id.GetIdCard()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			var/datum/computer_network/network = user.getHUDnetwork(HUD_SECURITY)
			if(!network)
				return TOPIC_HANDLED
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			if(R)
				var/setcriminal = input(user, "Specify a new criminal status for this person.", "Security HUD", R.get_criminalStatus()) as null|anything in global.security_statuses
				if(hasHUD(usr, HUD_SECURITY) && setcriminal)
					R.set_criminalStatus(setcriminal)
					modified = 1

					spawn()
						BITSET(hud_updateflag, WANTED_HUD)
						if(ishuman(user))
							var/mob/living/carbon/human/U = user
							U.handle_regular_hud_updates()
						if(isrobot(user))
							var/mob/living/silicon/robot/U = user
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["secrecord"])
		if(hasHUD(usr, HUD_SECURITY))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name
			var/datum/computer_network/network = user.getHUDnetwork(HUD_SECURITY)
			if(!network)
				return TOPIC_HANDLED
			var/datum/computer_file/report/crew_record/E = network.get_crew_record_by_name(perpname)
			if(E)
				if(hasHUD(user, HUD_SECURITY))
					to_chat(user, "<b>Name:</b> [E.get_name()]")
					to_chat(user, "<b>Criminal Status:</b> [E.get_criminalStatus()]")
					to_chat(user, "<b>Details:</b> [E.get_security_record()]")
					read = 1

			if(!read)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["medical"])
		if(hasHUD(user, HUD_MEDICAL))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
			if(!network)
				return TOPIC_HANDLED
			var/datum/computer_file/report/crew_record/E = network.get_crew_record_by_name(perpname)
			if(E)
				var/setmedical = input(user, "Specify a new medical status for this person.", "Medical HUD", E.get_status()) as null|anything in global.physical_statuses
				if(hasHUD(user, HUD_MEDICAL) && setmedical)
					E.set_status(setmedical)
					modified = 1

					spawn()
						if(ishuman(user))
							var/mob/living/carbon/human/U = user
							U.handle_regular_hud_updates()
						if(isrobot(user))
							var/mob/living/silicon/robot/U = user
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["medrecord"])
		if(hasHUD(user, HUD_MEDICAL))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
			if(!network)
				return TOPIC_HANDLED
			var/datum/computer_file/report/crew_record/E = network.get_crew_record_by_name(perpname)
			if(E)
				if(hasHUD(user, HUD_MEDICAL))
					to_chat(usr, "<b>Name:</b> [E.get_name()]")
					to_chat(usr, "<b>Gender:</b> [E.get_gender()]")
					to_chat(usr, "<b>Species:</b> [E.get_species_name()]")
					to_chat(usr, "<b>Blood Type:</b> [E.get_bloodtype()]")
					to_chat(usr, "<b>Details:</b> [E.get_medical_record()]")
					read = 1
			if(!read)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	return ..()

/mob/living/carbon/human/update_flavor_text(key)
	var/msg
	switch(key)
		if("done")
			show_browser(src, null, "window=flavor_changes")
			return
		if("general")
			msg = sanitize(input(src,"Update the general description of your character. This will be shown regardless of clothing. Do not include OOC information here.","Flavor Text",html_decode(flavor_texts[key])) as message, extra = 0)
		else
			if(!(key in flavor_texts))
				return
			msg = sanitize(input(src,"Update the flavor text for your [key].","Flavor Text",html_decode(flavor_texts[key])) as message, extra = 0)
	if(!CanInteract(src, global.self_topic_state))
		return
	flavor_texts[key] = msg
	set_flavor()

/mob/living/carbon/human/proc/get_darksight_range()
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(root_bodytype.vision_organ)
		var/obj/item/organ/internal/eyes/I = get_organ(root_bodytype.vision_organ, /obj/item/organ/internal/eyes)
		if(istype(I))
			return I.get_darksight_range()
	return root_bodytype.eye_darksight_range

/mob/living/carbon/human/abiotic(var/full_body = TRUE)
	if(full_body)
		for(var/slot in list(slot_head_str, slot_shoes_str, slot_w_uniform_str, slot_wear_suit_str, slot_glasses_str, slot_l_ear_str, slot_r_ear_str, slot_gloves_str))
			if(get_equipped_item(slot))
				return FALSE
	return ..()

/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/check_has_mouth()
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(!H || !istype(H) || !H.can_intake_reagents)
		return FALSE
	return TRUE

/mob/living/carbon/human/empty_stomach()
	SET_STATUS_MAX(src, STAT_STUN, 3)

	var/obj/item/organ/internal/stomach/stomach = get_organ(BP_STOMACH, /obj/item/organ/internal/stomach)
	var/nothing_to_puke = FALSE
	if(should_have_organ(BP_STOMACH))
		if(!stomach || (stomach.ingested.total_volume <= 0 && stomach.contents.len == 0))
			nothing_to_puke = TRUE
	else if(!(locate(/mob) in contents))
		nothing_to_puke = TRUE

	if(nothing_to_puke)
		custom_emote(1,"dry heaves.")
		return

	if(should_have_organ(BP_STOMACH))
		for(var/a in stomach.contents)
			var/atom/movable/A = a
			A.dropInto(get_turf(src))
			if(species.gluttonous & GLUT_PROJECTILE_VOMIT)
				A.throw_at(get_edge_target_turf(src,dir),7,7,src)
	else
		for(var/mob/M in contents)
			M.dropInto(get_turf(src))
			if(species.gluttonous & GLUT_PROJECTILE_VOMIT)
				M.throw_at(get_edge_target_turf(src,dir),7,7,src)

	visible_message(SPAN_DANGER("\The [src] throws up!"),SPAN_DANGER("You throw up!"))
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	var/turf/location = loc
	if(istype(location, /turf/simulated))
		var/obj/effect/decal/cleanable/vomit/splat = new /obj/effect/decal/cleanable/vomit(location)
		if(stomach.ingested.total_volume)
			stomach.ingested.trans_to_obj(splat, min(15, stomach.ingested.total_volume))
		handle_additional_vomit_reagents(splat)
		splat.update_icon()

/mob/living/carbon/human/proc/vomit(var/timevomit = 1, var/level = 3, var/deliberate = FALSE)

	set waitfor = 0

	if(!check_has_mouth() || isSynthetic() || !timevomit || !level || stat == DEAD || lastpuke)
		return

	if(deliberate)
		if(incapacitated())
			to_chat(src, SPAN_WARNING("You cannot do that right now."))
			return
		var/decl/pronouns/G = get_pronouns()
		visible_message(SPAN_DANGER("\The [src] starts sticking a finger down [G.his] own throat. It looks like [G.he] [G.is] trying to throw up!"))
		if(!do_after(src, 30))
			return
		timevomit = max(timevomit, 5)

	timevomit = clamp(timevomit, 1, 10)
	level = clamp(level, 1, 3)

	lastpuke = TRUE
	to_chat(src, SPAN_WARNING("You feel nauseous..."))
	if(level > 1)
		sleep(150 / timevomit)	//15 seconds until second warning
		to_chat(src, SPAN_WARNING("You feel like you are about to throw up!"))
		if(level > 2)
			sleep(100 / timevomit)	//and you have 10 more for mad dash to the bucket
			empty_stomach()
	sleep(350)	//wait 35 seconds before next volley
	lastpuke = FALSE

/mob/living/carbon/human/proc/increase_germ_level(n)
	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	get_bodytype().create_missing_organs(src) // Reset our organs/limbs.
	restore_all_organs()       // Reapply robotics/amputated status from preferences.
	reset_blood()

	if(!client || !key) //Don't boot out anyone already in the mob.
		for(var/mob/living/carbon/brain/brain in global.player_list) // This is really nasty, does it even work anymore?
			if(brain.real_name == src.real_name && brain.mind)
				brain.mind.transfer_to(src)
				qdel(brain.loc)
				break
	ticks_since_last_successful_breath = 0
	UpdateAppearance()
	..()

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M, amount = 2, blood_data)
	if (!..())
		return 0
	var/bloodied
	for(var/obj/item/organ/external/grabber in get_hands_organs())
		bloodied |= grabber.add_blood(M, amount, blood_data)
	if(bloodied)
		update_equipment_overlay(slot_gloves_str)	//handles bloody hands overlays and updating
		verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/clean_blood(var/clean_feet)
	. = ..()
	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves)
		gloves.clean()
		gloves.germ_level = 0
	else
		germ_level = 0

	for(var/obj/item/organ/external/organ in get_external_organs())
		//TODO check that organ is not covered
		if(clean_feet || (organ.organ_tag in list(BP_L_HAND,BP_R_HAND)))
			organ.clean()
	update_equipment_overlay(slot_gloves_str, FALSE)
	update_equipment_overlay(slot_shoes_str)
	return TRUE

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in get_external_organs())
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.get_external_organs())
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/handle_embedded_and_stomach_objects()

	if(embedded_flag)
		for(var/obj/item/organ/external/organ in get_external_organs())
			if(organ.splinted)
				continue
			for(var/obj/item/O in organ.implants)
				if(!istype(O,/obj/item/implant) && O.w_class > ITEM_SIZE_TINY && prob(5)) //Moving with things stuck in you could be bad.
					jostle_internal_object(organ, O)

	var/obj/item/organ/internal/stomach/stomach = get_organ(BP_STOMACH, /obj/item/organ/internal/stomach)
	if(stomach && stomach.contents.len)
		for(var/obj/item/O in stomach.contents)
			if((O.edge || O.sharp) && prob(5))
				var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(src, stomach.parent_organ)
				if(prob(1) && can_feel_pain() && O.can_embed())
					to_chat(src, SPAN_DANGER("You feel something rip out of your [stomach.name]!"))
					O.dropInto(loc)
					if(parent)
						parent.embed(O)
				else
					jostle_internal_object(parent, O)

/mob/living/carbon/human/proc/jostle_internal_object(var/obj/item/organ/external/organ, var/obj/item/O)
	// All kinds of embedded objects cause bleeding.
	if(!organ.can_feel_pain())
		to_chat(src, SPAN_DANGER("You feel [O] moving inside your [organ.name]."))
	else
		var/msg = pick( \
			SPAN_DANGER("A spike of pain jolts your [organ.name] as you bump [O] inside."), \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name] painfully."),       \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name] painfully."))
		custom_pain(msg,40,affecting = organ)
	organ.take_external_damage(rand(1,3) + O.w_class, DAM_EDGE, 0)

/mob/living/carbon/human/proc/set_bodytype(var/decl/bodytype/new_bodytype)
	if(ispath(new_bodytype))
		new_bodytype = GET_DECL(new_bodytype)
	// No check to see if it's the same as our current one, because we don't have a 'mob bodytype' anymore
	// just the torso. It's assumed if we call this we want a full regen.
	if(istype(new_bodytype))
		mob_size = new_bodytype.mob_size
		new_bodytype.create_missing_organs(src, TRUE) // actually rebuild the body
		apply_bodytype_appearance()
		force_update_limbs()

		// Check and clear hair.
		var/decl/sprite_accessory/hair/hairstyle = GET_DECL(h_style)
		if(!hairstyle?.accessory_is_available(src, species, new_bodytype))
			change_hair(new_bodytype.default_h_style, FALSE)
		var/decl/sprite_accessory/hair/facialhairstyle = GET_DECL(f_style)
		if(!facialhairstyle?.accessory_is_available(src, species, new_bodytype))
			change_facial_hair(new_bodytype.default_f_style, FALSE)
		// TODO: check markings.

		update_eyes()
		return TRUE
	return FALSE

//set_species should not handle the entirety of initing the mob, and should not trigger deep updates
//It focuses on setting up species-related data, without force applying them uppon organs and the mob's appearance.
// For transforming an existing mob, look at change_species()
/mob/living/carbon/human/proc/set_species(var/new_species_name, var/new_bodytype = null)
	if(!new_species_name)
		CRASH("set_species on mob '[src]' was passed a null species name '[new_species_name]'!")
	var/new_species = get_species_by_key(new_species_name)
	if(species?.name == new_species_name)
		return
	if(!new_species)
		CRASH("set_species on mob '[src]' was passed a bad species name '[new_species_name]'!")

	//Handle old species transition
	if(species)
		species.remove_base_auras(src)
		species.remove_inherent_verbs(src)

	//Update our species
	species = new_species
	if(dna)
		dna.species = new_species_name
	holder_type = null
	if(species.holder_type)
		holder_type = species.holder_type
	maxHealth = species.total_health
	remove_extension(src, /datum/extension/armor)
	if(species.natural_armour_values)
		set_extension(src, /datum/extension/armor, species.natural_armour_values)
	apply_species_appearance()

	var/decl/pronouns/new_pronouns = get_pronouns_by_gender(get_gender())
	if(!istype(new_pronouns) || !(new_pronouns in species.available_pronouns))
		new_pronouns = species.default_pronouns
		set_gender(new_pronouns.name)

	//Handle bodytype
	if(!new_bodytype)
		new_bodytype = species.get_bodytype_by_pronouns(new_pronouns)
	set_bodytype(new_bodytype)

	available_maneuvers = species.maneuvers.Copy()

	meat_type =     species.meat_type
	meat_amount =   species.meat_amount
	skin_material = species.skin_material
	skin_amount =   species.skin_amount
	bone_material = species.bone_material
	bone_amount =   species.bone_amount

	full_prosthetic = null //code dum thinks ur robot always
	default_walk_intent = null
	default_run_intent = null
	move_intent = null
	move_intents = species.move_intents.Copy()
	set_move_intent(GET_DECL(move_intents[1]))
	if(!istype(move_intent))
		set_next_usable_move_intent()
	update_emotes()
	apply_species_inventory_restrictions()
	refresh_ai_handler()

	// Update codex scannables.
	if(species.secret_codex_info)
		var/datum/extension/scannable/scannable = get_or_create_extension(src, /datum/extension/scannable)
		scannable.associated_entry = "[lowertext(species.name)] (species)"
		scannable.scan_delay = 5 SECONDS
	else if(has_extension(src, /datum/extension/scannable))
		remove_extension(src, /datum/extension/scannable)

	return TRUE

//Syncs cultural tokens to the currently set species, and may trigger a language update
/mob/living/carbon/human/proc/apply_species_cultural_info()
	var/update_lang
	for(var/token in ALL_CULTURAL_TAGS)
		if(species.force_cultural_info && species.force_cultural_info[token])
			update_lang = TRUE
			set_cultural_value(token, species.force_cultural_info[token], defer_language_update = TRUE)
		else if(!cultural_info[token] || !(cultural_info[token] in species.available_cultural_info[token]))
			update_lang = TRUE
			set_cultural_value(token, species.default_cultural_info[token], defer_language_update = TRUE)

	if(update_lang)
		update_languages()

//Drop anything that cannot be worn by the current species of the mob
/mob/living/carbon/human/proc/apply_species_inventory_restrictions()

	if(!(get_bodytype().appearance_flags & HAS_UNDERWEAR))
		QDEL_NULL_LIST(worn_underwear)

	var/list/new_slots
	var/list/held_slots = get_held_item_slots()
	for(var/slot_id in species.hud.inventory_slots)
		var/datum/inventory_slot/old_slot = get_inventory_slot_datum(slot_id)
		if(slot_id in held_slots)
			LAZYSET(new_slots, slot_id, old_slot)
			continue
		var/datum/inventory_slot/new_slot = species.hud.inventory_slots[slot_id]
		if(!old_slot || !old_slot.equivalent_to(new_slot))
			LAZYSET(new_slots, slot_id, new_slot.Clone())
		else
			LAZYSET(new_slots, slot_id, old_slot)
	set_inventory_slots(new_slots)

	//recheck species-restricted clothing
	for(var/obj/item/carrying in get_equipped_items(include_carried = TRUE))
		if(!carrying.mob_can_equip(src, get_equipped_slot_for_item(carrying), TRUE, TRUE, TRUE))
			drop_from_inventory(carrying)

//This handles actually updating our visual appearance
// Triggers deep update of limbs and hud
/mob/living/carbon/human/proc/apply_species_appearance()
	if(!species)
		icon_state = lowertext(SPECIES_HUMAN)
	else
		species.apply_appearance(src)

	force_update_limbs()

	// Rebuild the HUD and visual elements only if we got a client.
	hud_reset(TRUE)

// Like above, but for bodytype. Not as complicated.
/mob/living/carbon/human/proc/apply_bodytype_appearance()
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype)
		skin_colour = COLOR_BLACK
	else
		root_bodytype.apply_appearance(src)
		default_pixel_x = initial(pixel_x) + root_bodytype.pixel_offset_x
		default_pixel_y = initial(pixel_y) + root_bodytype.pixel_offset_y
		default_pixel_z = initial(pixel_z) + root_bodytype.pixel_offset_z

	reset_offsets()

/mob/living/carbon/human/proc/update_languages()
	if(!length(cultural_info))
		log_warning("'[src]'([x], [y], [z]) doesn't have any cultural info set and is attempting to update its language!!")

	var/list/permitted_languages = list()
	var/list/free_languages =      list()
	var/list/default_languages =   list()

	for(var/thing in cultural_info)
		var/decl/cultural_info/check = cultural_info[thing]
		if(istype(check))
			if(check.default_language)
				free_languages    |= check.default_language
				default_languages |= check.default_language
			if(check.language)
				free_languages    |= check.language
			if(check.name_language)
				free_languages    |= check.name_language
			for(var/lang in check.additional_langs)
				free_languages    |= lang
			for(var/lang in check.get_spoken_languages())
				permitted_languages |= lang

	for(var/decl/language/lang in languages)
		// Forbidden languages are always removed.
		if(!(lang.flags & LANG_FLAG_FORBIDDEN))
			// Admin can have whatever available language they want.
			if(has_admin_rights())
				continue
			// Whitelisted languages are fine.
			if((lang.flags & LANG_FLAG_WHITELISTED) && is_alien_whitelisted(src, lang))
				continue
			// Culture-granted languages are fine.
			if(lang.type in permitted_languages)
				continue
		// This language is Not Fine, remove it.
		if(lang.type == default_language)
			default_language = null
		remove_language(lang.type)

	for(var/thing in free_languages)
		add_language(thing)

	if(length(default_languages) && isnull(default_language))
		default_language = default_languages[1]

/mob/living/carbon/human/can_inject(var/mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, target_zone)

	if(!affecting)
		to_chat(user, SPAN_WARNING("\The [src] is missing that limb."))
		return 0

	if(BP_IS_PROSTHETIC(affecting))
		to_chat(user, SPAN_WARNING("That limb is prosthetic."))
		return 0

	. = CAN_INJECT
	for(var/slot in list(slot_head_str, slot_wear_mask_str, slot_wear_suit_str, slot_w_uniform_str, slot_gloves_str, slot_shoes_str))
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(C && (C.body_parts_covered & affecting.body_part) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			if(istype(C, /obj/item/clothing/suit/space))
				. = INJECTION_PORT //it was going to block us, but it's a space suit so it doesn't because it has some kind of port
			else
				to_chat(user, "<span class='warning'>There is no exposed flesh or thin material on [src]'s [affecting.name] to inject into.</span>")
				return 0


/mob/living/carbon/human/print_flavor_text(var/shrink = 1)

	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	var/static/list/equipment = list(
		slot_head_str,
		slot_wear_mask_str,
		slot_glasses_str,
		slot_w_uniform_str,
		slot_wear_suit_str,
		slot_gloves_str,
		slot_shoes_str
	)
	for(var/slot in equipment)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(!istype(C))
			continue
		if(C.body_parts_covered & SLOT_HEAD)
			head_exposed = 0
		if(C.body_parts_covered & SLOT_FACE)
			face_exposed = 0
		if(C.body_parts_covered & SLOT_EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & SLOT_UPPER_BODY)
			torso_exposed = 0
		if(C.body_parts_covered & SLOT_ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & SLOT_HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & SLOT_LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & SLOT_FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/has_brain()
	. = !!GET_INTERNAL_ORGAN(src, BP_BRAIN)

/mob/living/carbon/human/check_has_eyes()
	var/obj/item/organ/internal/eyes = GET_INTERNAL_ORGAN(src, BP_EYES)
	. = eyes?.is_usable()

/mob/living/carbon/human/slip(var/slipped_on, stun_duration = 8)
	if(species.check_no_slip(src))
		return FALSE
	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP))
		return FALSE
	return !!(..(slipped_on,stun_duration))


/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	if(get_rig()?.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))
			var/obj/item/organ/affecting = GET_EXTERNAL_ORGAN(src, limbcheck)
			if(!affecting)
				return FALSE
		return TRUE
	return FALSE


/mob/living/carbon/human/can_devour(atom/movable/victim, var/silent = FALSE)

	if(!should_have_organ(BP_STOMACH))
		return ..()

	var/obj/item/organ/internal/stomach/stomach = get_organ(BP_STOMACH, /obj/item/organ/internal/stomach)
	if(!stomach || !stomach.is_usable())
		if(!silent)
			to_chat(src, SPAN_WARNING("Your stomach is not functional!"))
		return FALSE

	if(!stomach.can_eat_atom(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("You are not capable of devouring \the [victim] whole!"))
		return FALSE

	if(stomach.is_full(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [stomach.name] is full!"))
		return FALSE

	. = stomach.get_devour_time(victim) || ..()

/mob/living/carbon/human/move_to_stomach(atom/movable/victim)
	var/obj/item/organ/internal/stomach = GET_INTERNAL_ORGAN(src, BP_STOMACH)
	if(stomach)
		victim.forceMove(stomach)

/mob/living/carbon/human/get_adjusted_metabolism(metabolism)
	return ..() * (species ? species.metabolism_mod : 1)

/mob/living/carbon/human/is_invisible_to(var/mob/viewer)
	return (is_cloaked() || ..())

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(src != M)
		..()
	else
		var/decl/pronouns/G = get_pronouns()
		visible_message( \
			SPAN_NOTICE("[src] examines [G.self]."), \
			SPAN_NOTICE("You check yourself for injuries.") \
			)

		for(var/obj/item/organ/external/org in get_external_organs())
			var/list/status = list()

			var/feels = 1 + round(org.pain/100, 0.1)
			var/feels_brute = (org.brute_dam * feels)
			if(feels_brute > 0)
				switch(feels_brute / org.max_damage)
					if(0 to 0.35)
						status += "slightly sore"
					if(0.35 to 0.65)
						status += "very sore"
					if(0.65 to INFINITY)
						status += "throbbing with agony"

			var/feels_burn = (org.burn_dam * feels)
			if(feels_burn > 0)
				switch(feels_burn / org.max_damage)
					if(0 to 0.35)
						status += "tingling"
					if(0.35 to 0.65)
						status += "stinging"
					if(0.65 to INFINITY)
						status += "burning fiercely"

			if(org.status & ORGAN_MUTATED)
				status += "misshapen"
			if(org.status & ORGAN_BLEEDING)
				status += "<b>bleeding</b>"
			if(org.is_dislocated())
				status += "dislocated"
			if(org.status & ORGAN_BROKEN)
				status += "hurts when touched"

			if(org.status & ORGAN_DEAD)
				if(BP_IS_PROSTHETIC(org) || BP_IS_CRYSTAL(org))
					status += "is irrecoverably damaged"
				else
					status += "is grey and necrotic"
			else if(org.damage >= org.max_damage && org.germ_level >= INFECTION_LEVEL_TWO)
				status += "is likely beyond saving, and has begun to decay"
			if(!org.is_usable() || org.is_dislocated())
				status += "dangling uselessly"
			if(status.len)
				src.show_message("My [org.name] is <span class='warning'>[english_list(status)].</span>",1)
			else
				src.show_message("My [org.name] is <span class='notice'>OK.</span>",1)

/mob/living/carbon/human/proc/resuscitate()
	if(!is_asystole() || !should_have_organ(BP_HEART))
		return
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(heart && !(heart.status & ORGAN_DEAD))
		var/breathing_organ = get_bodytype().breathing_organ
		var/active_breaths = 0
		if(breathing_organ)
			var/obj/item/organ/internal/lungs/L = get_organ(breathing_organ, /obj/item/organ/internal/lungs)
			if(L)
				active_breaths = L.active_breathing
		if(!nervous_system_failure() && active_breaths)
			visible_message(SPAN_NOTICE("\The [src] jerks and gasps for breath!"))
		else
			var/decl/pronouns/G = get_pronouns()
			visible_message(SPAN_NOTICE("\The [src] twitches a bit as [G.his] [heart.name] restarts!"))

		shock_stage = min(shock_stage, 100) // 120 is the point at which the heart stops.
		var/oxyloss_threshold = round(species.total_health * 0.35)
		if(getOxyLoss() >= oxyloss_threshold)
			setOxyLoss(oxyloss_threshold)
		heart.pulse = PULSE_NORM
		heart.handle_pulse()
		return TRUE

/mob/living/carbon/human/proc/make_reagent(amount, reagent_type)
	if(stat == CONSCIOUS)
		var/limit = max(0, reagents.get_overdose(reagent_type) - REAGENT_VOLUME(reagents, reagent_type))
		reagents.add_reagent(reagent_type, min(amount, limit))

//Get fluffy numbers
/mob/living/carbon/human/proc/get_blood_pressure()
	if(status_flags & FAKEDEATH)
		return "[FLOOR(120+rand(-5,5))*0.25]/[FLOOR(80+rand(-5,5)*0.25)]"
	var/blood_result = get_blood_circulation()
	return "[FLOOR((120+rand(-5,5))*(blood_result/100))]/[FLOOR((80+rand(-5,5))*(blood_result/100))]"

//Point at which you dun breathe no more. Separate from asystole crit, which is heart-related.
/mob/living/carbon/human/nervous_system_failure()
	return getBrainLoss() >= maxHealth * 0.75

/mob/living/carbon/human/melee_accuracy_mods()
	. = ..()
	if(get_shock() > 50)
		. += 15
	if(shock_stage > 10)
		. += 15
	if(shock_stage > 30)
		. += 15

/mob/living/carbon/human/ranged_accuracy_mods()
	. = ..()
	if(get_shock() > 10 && !skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		. -= 1
	if(get_shock() > 50)
		. -= 1
	if(shock_stage > 10)
		. -= 1
	if(shock_stage > 30)
		. -= 1
	if(skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_EXPERT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_PROF))
		. += 2

/mob/living/carbon/human/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume)
		species.fluid_act(src, fluids)

/mob/living/carbon/human/proc/set_cultural_value(var/token, var/decl/cultural_info/_culture, var/defer_language_update)
	if(ispath(_culture, /decl/cultural_info))
		_culture = GET_DECL(_culture)
	if(istype(_culture))
		LAZYSET(cultural_info, token, _culture)
		if(!defer_language_update)
			update_languages()

/mob/living/carbon/human/proc/get_cultural_value(var/token)
	. = LAZYACCESS(cultural_info, token)
	if(!istype(., /decl/cultural_info))
		. = global.using_map.default_cultural_info[token]
		PRINT_STACK_TRACE("get_cultural_value() tried to return a non-instance value for token '[token]' - full culture list: [json_encode(cultural_info)] default species culture list: [json_encode(global.using_map.default_cultural_info)]")

/mob/living/carbon/human/needs_wheelchair()
	var/stance_damage = 0
	for(var/limb_tag in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, limb_tag)
		if(!E || !E.is_usable())
			stance_damage += 2
	return stance_damage >= 4

/mob/living/carbon/human/get_digestion_product()
	return species.get_digestion_product(src)

// A damaged stomach can put blood in your vomit.
/mob/living/carbon/human/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	..()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach = GET_INTERNAL_ORGAN(src, BP_STOMACH)
		if(!stomach || stomach.is_broken() || (stomach.is_bruised() && prob(stomach.damage)))
			if(should_have_organ(BP_HEART))
				vessel.trans_to_obj(vomit, 5)
			else
				reagents.trans_to_obj(vomit, 5)

/mob/living/carbon/human/get_sound_volume_multiplier()
	. = ..()
	for(var/slot in list(slot_l_ear_str, slot_r_ear_str, slot_head_str))
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C))
			. = min(., C.volume_multiplier)

/mob/living/carbon/human/get_bullet_impact_effect_type(var/def_zone)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, def_zone)
	if(!E)
		return BULLET_IMPACT_NONE
	if(BP_IS_PROSTHETIC(E))
		return BULLET_IMPACT_METAL
	return BULLET_IMPACT_MEAT

/mob/living/carbon/human/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(damage && P.damtype == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				if(!QDELETED(B))
					B.icon_state = pick("dir_splatter_1","dir_splatter_2")
					var/scale = min(1, round(P.damage / 50, 0.2))
					B.set_scale(scale)
				new /obj/effect/temp_visual/bloodsplatter(loc, hit_dir, species.get_blood_color(src))

/mob/living/carbon/human/lose_hair()
	if(get_bodytype().set_default_hair(src))
		. = TRUE
	if(species.handle_additional_hair_loss(src))
		. = TRUE
	for(var/obj/item/organ/external/E in get_external_organs())
		for(var/mark in E.markings)
			var/decl/sprite_accessory/marking/mark_datum = GET_DECL(mark)
			if(mark_datum.flags & HAIR_LOSS_VULNERABLE)
				E.markings -= mark
				. = TRUE
	if(.)
		update_body()
		to_chat(src, SPAN_DANGER("You feel a chill and your skin feels lighter..."))

/mob/living/carbon/human/increaseBodyTemp(value)
	bodytemperature += value
	return bodytemperature

/mob/living/carbon/human/get_admin_job_string()
	return job || uppertext(species.name)

/mob/living/carbon/human/can_change_intent()
	return TRUE

/mob/living/carbon/human/get_telecomms_race_info()
	if(isMonkey())
		return list("Monkey", FALSE)
	return list("Sapient Race", TRUE)

/mob/living/carbon/human/breathing_hole_covered()
	. = ..()
	if(!.)
		var/obj/item/head = get_equipped_item(slot_head_str)
		if(head && (head.item_flags & ITEM_FLAG_AIRTIGHT))
			return TRUE

/mob/living/carbon/human/set_internals_to_best_available_tank(var/breathes_gas = /decl/material/gas/oxygen, var/list/poison_gas = list(/decl/material/gas/chlorine))
	. = ..(species.breath_type, species.poison_types)

//Set and force the mob to update according to the given DNA
// Will reset the entire mob's state, regrow limbs/organ etc
/mob/living/carbon/human/proc/apply_dna(var/datum/dna/new_dna)
	if(!new_dna)
		CRASH("mob/living/carbon/human/proc/apply_dna() : Got null dna")
	src.dna = new_dna

	//Set species and real name data
	set_real_name(new_dna.real_name)
	set_species(new_dna.species)
	//Revive actually regen organs, reset their appearance and makes sure if the player is kicked out they get reinserted in
	revive()

	species.handle_pre_spawn(src)
	apply_species_appearance()
	apply_species_cultural_info()
	apply_species_inventory_restrictions()
	species.handle_post_spawn(src)

	try_refresh_visible_overlays()

//Sets the mob's real name and update all the proper fields
/mob/living/carbon/human/proc/set_real_name(var/newname)
	if(!newname)
		return
	real_name = newname
	SetName(newname)
	if(dna)
		dna.real_name = newname
	if(mind)
		mind.name = newname

//Human mob specific init code. Meant to be used only on init.
/mob/living/carbon/human/proc/setup(species_name = null, datum/dna/new_dna = null, decl/bodytype/new_bodytype = null)
	if(new_dna)
		species_name = new_dna.species
		src.dna = new_dna
	else if(!species_name)
		species_name = global.using_map.default_species //Humans cannot exist without a species!

	set_species(species_name, new_bodytype)
	var/decl/bodytype/root_bodytype = get_bodytype() // root bodytype is set in set_species
	if(!skin_colour)
		skin_colour = root_bodytype.base_color
	if(!hair_colour)
		hair_colour = root_bodytype.base_hair_color
	if(!facial_hair_colour)
		facial_hair_colour = root_bodytype.base_hair_color
	if(!eye_colour)
		eye_colour = root_bodytype.base_eye_color
	root_bodytype.set_default_hair(src, override_existing = TRUE, defer_update_hair = TRUE)
	if(!blood_type && length(species?.blood_types))
		blood_type = pickweight(species.blood_types)

	if(new_dna)
		set_real_name(new_dna.real_name)
	else
		try_generate_default_name()
		dna.ready_dna(src) //regen dna filler only if we haven't forced the dna already

	species.handle_pre_spawn(src)
	apply_species_cultural_info()
	species.handle_post_spawn(src)

	UpdateAppearance() //Apply dna appearance to mob, causes DNA to change because filler values are regenerated
	//Prevent attempting to create blood container if its already setup
	if(!vessel)
		reset_blood()

//If the mob has its default name it'll try to generate /obtain a proper one
/mob/living/carbon/human/proc/try_generate_default_name()
	if(name != initial(name))
		return
	if(species)
		set_real_name(species.get_default_name())
	else
		SetName(initial(name))

//Runs last after setup and after the parent init has been executed.
/mob/living/carbon/human/proc/post_setup(var/species_name = null, var/datum/dna/new_dna = null)
	try_refresh_visible_overlays() //Do this exactly once per setup

/mob/living/carbon/human/handle_flashed(var/obj/item/flash/flash, var/flash_strength)
	var/safety = eyecheck()
	if(safety < FLASH_PROTECTION_MODERATE)
		flash_strength = round(getFlashMod() * flash_strength)
		if(safety > FLASH_PROTECTION_NONE)
			flash_strength = (flash_strength / 2)
	. = ..()

/mob/living/carbon/human/handle_nutrition_and_hydration()
	..()

	// Apply stressors.
	if(!client)
		return

	var/nut =    get_nutrition()
	var/maxnut = get_max_nutrition()
	if(nut < (maxnut * 0.3))
		add_stressor(/datum/stressor/hungry_very, STRESSOR_DURATION_INDEFINITE)
	else
		remove_stressor(/datum/stressor/hungry_very)
		if(nut < (maxnut * 0.5))
			add_stressor(/datum/stressor/hungry, STRESSOR_DURATION_INDEFINITE)
		else
			remove_stressor(/datum/stressor/hungry)
	var/hyd =    get_hydration()
	var/maxhyd = get_max_hydration()
	if(hyd < (maxhyd * 0.3))
		add_stressor(/datum/stressor/thirsty_very, STRESSOR_DURATION_INDEFINITE)
	else
		remove_stressor(/datum/stressor/thirsty_very)
		if(hyd < (maxhyd * 0.5))
			add_stressor(/datum/stressor/thirsty, STRESSOR_DURATION_INDEFINITE)
		else
			remove_stressor(/datum/stressor/thirsty)

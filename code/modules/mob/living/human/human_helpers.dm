#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.get_equipment_tint();

/mob/living/human/proc/update_equipment_vision()
	flash_protection = 0
	equipment_tint_total = 0
	equipment_see_invis	= 0
	equipment_vision_flags = 0
	equipment_prescription = 0
	equipment_light_protection = 0
	equipment_darkness_modifier = 0
	equipment_overlays.Cut()

	if (!client || client.eye == src || client.eye == src.loc) // !client is so the unit tests function

		var/obj/item/clothing/head/head = get_equipped_item(slot_head_str)
		if(istype(head))
			add_clothing_protection(head)

		var/obj/item/clothing/glasses/glasses = get_equipped_item(slot_glasses_str)
		if(istype(glasses))
			process_glasses(glasses)

		var/obj/item/clothing/mask/mask = get_equipped_item(slot_wear_mask_str)
		if(istype(mask))
			add_clothing_protection(mask)

		var/obj/item/rig/rig = get_rig()
		if(rig)
			process_rig(rig)

/mob/living/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G)
		// prescription applies regardless of if the glasses are active
		equipment_prescription += G.prescription
		if(G.active)
			equipment_darkness_modifier += G.darkness_view
			equipment_vision_flags |= G.vision_flags
			equipment_light_protection += G.light_protection
			if(G.screen_overlay)
				equipment_overlays |= G.screen_overlay
			if(G.see_invisible >= 0)
				if(equipment_see_invis)
					equipment_see_invis = min(equipment_see_invis, G.see_invisible)
				else
					equipment_see_invis = G.see_invisible

			add_clothing_protection(G)
			G.process_hud(src)

/mob/living/human/proc/process_rig(var/obj/item/rig/O)
	var/obj/item/head = get_equipped_item(slot_head_str)
	if(O.visor && O.visor.active && O.visor.vision && O.visor.vision.glasses && (!O.helmet || (head && O.helmet == head)))
		process_glasses(O.visor.vision.glasses)

/mob/living/human/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	var/old_name = real_name
	. = ..()
	if(!. || !in_depth)
		return

	var/datum/computer_file/report/crew_record/R = get_crewmember_record(old_name)
	if(R)
		R.set_name(new_name)

	//update our pda and id if we have them on our person
	var/list/searching = GetAllContents(searchDepth = 3)
	var/search_id = 1
	var/search_pda = 1

	for(var/A in searching)
		if(search_id && istype(A,/obj/item/card/id))
			var/obj/item/card/id/ID = A
			if(ID.registered_name == old_name)
				ID.registered_name = new_name
				search_id = 0
		else if(search_pda && istype(A,/obj/item/modular_computer/pda))
			var/obj/item/modular_computer/pda/PDA = A
			if(findtext(PDA.name, old_name))
				PDA.SetName(replacetext(PDA.name, old_name, new_name))
				search_pda = 0

	var/obj/item/rig/rig = get_rig()
	if(rig?.update_visible_name)
		rig.visible_name = real_name

/mob/living/human
	var/next_sonar_ping = 0

/mob/living/human/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "IC"

	if(incapacitated())
		to_chat(src, "<span class='warning'>You need to recover before you can use this ability.</span>")
		return
	if(world.time < next_sonar_ping)
		to_chat(src, "<span class='warning'>You need another moment to focus.</span>")
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, "<span class='warning'>You are for all intents and purposes currently deaf!</span>")
		return
	next_sonar_ping += 10 SECONDS
	var/heard_something = FALSE
	to_chat(src, "<span class='notice'>You take a moment to listen in to your environment...</span>")
	for(var/mob/living/L in range(client?.view || world.view, src))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
			continue
		heard_something = TRUE
		var/image/ping_image = image(icon = 'icons/effects/effects.dmi', icon_state = "sonar_ping", loc = src)
		ping_image.plane = ABOVE_LIGHTING_PLANE
		ping_image.layer = BEAM_PROJECTILE_LAYER
		ping_image.pixel_x = (T.x - src.x) * WORLD_ICON_SIZE
		ping_image.pixel_y = (T.y - src.y) * WORLD_ICON_SIZE
		show_image(src, ping_image) // todo: should this use screen stuff instead?
		QDEL_IN(ping_image, 0.8 SECONDS) // qdeling an image is gross but oh well
		var/feedback = list("<span class='notice'>There are noises of movement ")
		var/direction = get_dir(src, L)
		if(direction)
			feedback += "towards the [dir2text(direction)], "
			switch(get_dist(src, L) / get_effective_view(client))
				if(0 to 0.2)
					feedback += "very close by."
				if(0.2 to 0.4)
					feedback += "close by."
				if(0.4 to 0.6)
					feedback += "some distance away."
				if(0.6 to 0.8)
					feedback += "further away."
				else
					feedback += "far away."
		else // No need to check distance if they're standing right on-top of us
			feedback += "right on top of you."
		feedback += "</span>"
		to_chat(src, jointext(feedback,null))
	if(!heard_something)
		to_chat(src, "<span class='notice'>You hear no movement but your own.</span>")

/mob/living/human/proc/has_headset_in_ears()
	return istype(get_equipped_item(slot_l_ear_str), /obj/item/radio/headset) || istype(get_equipped_item(slot_r_ear_str), /obj/item/radio/headset)

/mob/living/human/welding_eyecheck()
	var/vision_organ_tag = get_vision_organ_tag()
	if(!vision_organ_tag)
		return
	var/obj/item/organ/internal/eyes/eyes = get_organ(vision_organ_tag, /obj/item/organ/internal/eyes)
	if(!istype(eyes))
		return
	var/safety = eyecheck()
	switch(safety)
		if(FLASH_PROTECTION_MODERATE)
			to_chat(src, "<span class='warning'>Your eyes sting a little.</span>")
			eyes.adjust_organ_damage(rand(1, 2))
			if(eyes.get_organ_damage() > 12)
				ADJ_STATUS(src, STAT_BLURRY, rand(3,6))
		if(FLASH_PROTECTION_MINOR)
			to_chat(src, "<span class='warning'>Your eyes stings!</span>")
			eyes.adjust_organ_damage(rand(1, 4))
			if(eyes.get_organ_damage() > 10)
				ADJ_STATUS(src, STAT_BLURRY, rand(3,6))
				eyes.adjust_organ_damage(rand(1, 4))
		if(FLASH_PROTECTION_NONE)
			to_chat(src, "<span class='warning'>Your eyes burn!</span>")
			eyes.adjust_organ_damage(rand(2, 4))
			if(eyes.get_organ_damage() > 10)
				eyes.adjust_organ_damage(rand(4,10))
		if(FLASH_PROTECTION_REDUCED)
			to_chat(src, "<span class='danger'>Your equipment intensifies the welder's glow. Your eyes itch and burn severely.</span>")
			ADJ_STATUS(src, STAT_BLURRY, rand(12,20))
			eyes.adjust_organ_damage(rand(12, 16))
	if(safety<FLASH_PROTECTION_MAJOR)
		if(eyes.get_organ_damage() > 10)
			to_chat(src, "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>")
		if (eyes.get_organ_damage() >= eyes.min_bruised_damage)
			to_chat(src, "<span class='danger'>You go blind!</span>")
			SET_STATUS_MAX(src, STAT_BLIND, 5)
			SET_STATUS_MAX(src, STAT_BLURRY, 5)
			add_genetic_condition(GENE_COND_NEARSIGHTED, 10 SECONDS)

/mob/living/human/proc/has_meson_effect()
	var/datum/global_hud/global_hud = get_global_hud()
	return (global_hud.meson in equipment_overlays)

/mob/living/human/proc/is_in_pocket(var/obj/item/I)
	for(var/slot in global.pocket_slots)
		if(get_equipped_item(slot) == I)
			return TRUE
	return FALSE

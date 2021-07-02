/obj/item/organ/internal/eyes/insectoid/serpentid
	name = "compound eyes"
	innate_flash_protection = FLASH_PROTECTION_VULNERABLE
	contaminant_guard = 1
	action_button_name = "Toggle Eye Shields"
	eye_icon = 'mods/species/ascent/icons/species/body/serpentid/eyes.dmi'
	var/eyes_shielded

/obj/item/organ/internal/eyes/insectoid/serpentid/get_special_overlay()
	var/icon/I = get_onhead_icon()
	if(I)
		var/image/eye_overlay = image(I)
		if(owner && owner.is_cloaked())
			eye_overlay.alpha = 100
		if(eyes_shielded)
			eye_overlay.color = "#aaaaaa"
		return eye_overlay

/obj/item/organ/internal/eyes/insectoid/serpentid/additional_flash_effects(var/intensity)
	if(!eyes_shielded)
		take_internal_damage(max(0, 4 * (intensity)))
		return 1
	else
		return -1

/obj/item/organ/internal/eyes/insectoid/serpentid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "serpentid-shield-[eyes_shielded ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/eyes/insectoid/serpentid/attack_self(var/mob/user)
	. = ..()
	if(.)
		eyes_shielded = !eyes_shielded
		if(eyes_shielded)
			to_chat(owner, "<span class='notice'>Nearly opaque lenses slide down to shield your eyes.</span>")
			innate_flash_protection = FLASH_PROTECTION_MAJOR
			owner.overlay_fullscreen("eyeshield", /obj/screen/fullscreen/blind)
			owner.update_icon()
		else
			to_chat(owner, "<span class='notice'>Your protective lenses retract out of the way.</span>")
			innate_flash_protection = FLASH_PROTECTION_VULNERABLE
			addtimer(CALLBACK(src, .proc/remove_shield), 1 SECONDS)
			owner.update_icon()
		refresh_action_button()

/obj/item/organ/internal/eyes/insectoid/serpentid/proc/remove_shield()
	owner.clear_fullscreen("eyeshield")

/obj/item/organ/internal/eyes/serpentid/Initialize()
	. = ..()
	if(dna)
		color = rgb(dna.GetUIValue(DNA_UI_EYES_R), dna.GetUIValue(DNA_UI_EYES_G), dna.GetUIValue(DNA_UI_EYES_B))

/obj/item/organ/internal/eyes/insectoid/serpentid/set_dna(var/datum/dna/new_dna)
	. = ..()
	color = rgb(new_dna.GetUIValue(DNA_UI_EYES_R), new_dna.GetUIValue(DNA_UI_EYES_G), new_dna.GetUIValue(DNA_UI_EYES_B))

/obj/item/organ/internal/liver/insectoid/serpentid
	name = "toxin filter"
	color = "#66ff99"
	organ_tag = BP_LIVER
	parent_organ = BP_CHEST

// These are not actually lungs and shouldn't be thought of as such despite the claims of the parent.
/obj/item/organ/internal/lungs/insectoid/serpentid
	name = "tracheae"
	gender = PLURAL
	organ_tag = BP_TRACH
	parent_organ = BP_GROIN
	active_breathing = 0
	safe_toxins_max = 10

/obj/item/organ/internal/lungs/insectoid/serpentid/rupture()
	to_chat(owner, "<span class='danger'>You feel air rushing through your trachea!</span>")

/obj/item/organ/internal/lungs/insectoid/serpentid/handle_failed_breath()
	var/mob/living/carbon/human/H = owner

	var/oxygenated = GET_CHEMICAL_EFFECT(owner, CE_OXYGENATED)
	H.adjustOxyLoss(-(HUMAN_MAX_OXYLOSS * oxygenated))

	if(breath_fail_ratio < 0.25 && oxygenated)
		H.oxygen_alert = 0
	if(breath_fail_ratio >= 0.25 && (damage || world.time > last_successful_breath + 2 MINUTES))
		H.adjustOxyLoss(HUMAN_MAX_OXYLOSS * breath_fail_ratio)
		if(oxygenated)
			H.oxygen_alert = 1
		else
			H.oxygen_alert = 2

/obj/item/organ/internal/brain/insectoid/serpentid
	var/lowblood_tally = 0
	name = "distributed nervous system"
	parent_organ = BP_CHEST

/obj/item/organ/internal/brain/insectoid/serpentid/Process()
	if(!owner || !owner.should_have_organ(BP_HEART))
		return

	var/blood_volume = owner.get_blood_circulation()

	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			lowblood_tally = 2
			if(prob(1))
				to_chat(owner, "<span class='warning'>You're finding it difficult to move.</span>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			lowblood_tally = 4
			if(prob(1))
				to_chat(owner, "<span class='warning'>Moving has become very difficult.</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			lowblood_tally = 6
			if(prob(15))
				to_chat(owner, "<span class='warning'>You're almost unable to move!</span>")
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
			lowblood_tally = 10
			if(prob(10))
				to_chat(owner, "<span class='warning'>Your body is barely functioning and is starting to shut down.</span>")
				SET_STATUS_MAX(owner, STAT_PARA, 1)
				var/obj/item/organ/internal/I = pick(owner.internal_organs)
				I.take_internal_damage(5)
	..()

/obj/item/organ/external/chest/insectoid/serpentid
	name = "thorax"
	encased = "carapace"
	action_button_name = "Perform Threat Display"

/obj/item/organ/external/chest/insectoid/serpentid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "serpentid-threat"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/chest/insectoid/serpentid/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(owner.incapacitated())
			to_chat(owner, "<span class='warning'>You can't do a threat display in your current state.</span>")
			return
		if(owner.skin_state == SKIN_NORMAL)
			if(owner.pulling_punches)
				to_chat(owner, "<span class='warning'>You must be in your hunting stance to do a threat display.</span>")
			else
				var/message = alert(owner, "Would you like to show a scary message?",,"Cancel","Yes", "No")
				if(message == "Cancel")
					return
				else if(message == "Yes")
					var/decl/pronouns/G = get_pronouns()
					owner.visible_message(SPAN_WARNING("\The [owner]'s skin shifts to a deep red colour with dark chevrons running down in an almost hypnotic \
						pattern. Standing tall, [G.he] strikes, sharp spikes aimed at those threatening [G.him], claws whooshing through the air past them."))
				playsound(owner.loc, 'sound/effects/angrybug.ogg', 60, 0)
				owner.skin_state = SKIN_THREAT
				owner.update_skin()
				addtimer(CALLBACK(owner, /mob/living/carbon/human/proc/reset_skin), 10 SECONDS, TIMER_UNIQUE)
		else if(owner.skin_state == SKIN_THREAT)
			owner.reset_skin()

/obj/item/organ/external/head/insectoid/serpentid
	name = "head"
	vital = 0

/obj/item/organ/external/head/insectoid/serpentid/get_eye_overlay()
	var/obj/item/organ/internal/eyes/eyes = owner.get_internal_organ(owner.species.vision_organ || BP_EYES)
	if(eyes)
		return eyes.get_special_overlay()

/obj/item/organ/external/groin/insectoid/serpentid
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"
	action_button_name = "Toggle Active Camo"
	cavity_max_w_class = ITEM_SIZE_LARGE

/obj/item/organ/external/groin/insectoid/serpentid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "serpentid-cloak-[owner && owner.is_cloaked_by(species) ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/groin/insectoid/serpentid/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(owner.is_cloaked_by(species))
			owner.remove_cloaking_source(species)
		else
			owner.add_cloaking_source(species)
			owner.apply_effect(2, STUN, 0)
		refresh_action_button()

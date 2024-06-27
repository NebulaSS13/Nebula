var/global/image/contamination_overlay = image('icons/effects/contamination.dmi')

/contaminant_control
	var/CONTAMINANT_DMG = 3
	var/CONTAMINANT_DMG_NAME = "Contaminant Damage Amount"
	var/CONTAMINANT_DMG_DESC = "Self Descriptive"

	var/CLOTH_CONTAMINATION = 1
	var/CLOTH_CONTAMINATION_NAME = "Cloth Contamination"
	var/CLOTH_CONTAMINATION_DESC = "If this is on, contaminants do damage by getting into cloth."

	var/STRICT_PROTECTION_ONLY = 0
	var/STRICT_PROTECTION_NAME = "\"Strict Protection Only\""
	var/STRICT_PROTECTION_DESC = "If this is on, only biosuits and spacesuits protect against contamination and ill effects."

	var/GENETIC_CORRUPTION = 0
	var/GENETIC_CORRUPTION_NAME = "Genetic Corruption Chance"
	var/GENETIC_CORRUPTION_DESC = "Chance of genetic corruption as well as toxic damage, X in 10,000."

	var/SKIN_BURNS = 0
	var/SKIN_BURNS_DESC = "Contaminants have an effect similar to mustard gas on the un-suited."
	var/SKIN_BURNS_NAME = "Skin Burns"

	var/EYE_BURNS = 1
	var/EYE_BURNS_NAME = "Eye Burns"
	var/EYE_BURNS_DESC = "Contaminants burn the eyes of anyone not wearing eye protection."

	var/CONTAMINATION_LOSS = 0.02
	var/CONTAMINATION_LOSS_NAME = "Contamination Loss"
	var/CONTAMINATION_LOSS_DESC = "How much toxin damage is dealt from contaminated clothing" //Per tick?  ASK ARYN

	var/CONTAMINANT_HALLUCINATION = 0
	var/CONTAMINANT_HALLUCINATION_NAME = "Contaminant Hallucination"
	var/CONTAMINANT_HALLUCINATION_DESC = "Does being in contaminants cause you to hallucinate?"

	var/N2O_HALLUCINATION = 1
	var/N2O_HALLUCINATION_NAME = "N2O Hallucination"
	var/N2O_HALLUCINATION_DESC = "Does being in sleeping gas cause you to hallucinate?"

/obj/item/proc/contaminate()
	//Do a contamination overlay? Temporary measure to keep contamination less deadly than it was.
	if(!contaminated)
		contaminated = TRUE
		queue_icon_update()

/obj/item/proc/decontaminate()
	contaminated = FALSE
	queue_icon_update()

/mob/proc/contaminate()

/mob/living/human/contaminate()
	//See if anything can be contaminated.

	if(!contaminant_suit_protected())
		suit_contamination()

	if(!contaminant_head_protected())
		if(prob(1)) suit_contamination() // Contaminants can sometimes get through such an open suit.

//Cannot wash backpacks currently.
//	if(istype(back,/obj/item/backpack))
//		back.contaminate()

/mob/proc/handle_contaminants()
	return

/mob/living/human/handle_contaminants()
	//Handles all the bad things contaminants can do.

	//Contamination
	if(vsc.contaminant_control.CLOTH_CONTAMINATION) contaminate()

	//Anything else requires them to not be dead.
	if((stat >= DEAD) || (status_flags & GODMODE))
		return

	//Burn skin if exposed.
	if(vsc.contaminant_control.SKIN_BURNS)
		if(!contaminant_head_protected() || !contaminant_suit_protected())
			if(prob(20))
				to_chat(src, "<span class='danger'>Your skin burns!</span>")
			take_overall_damage(0, 0.75)

	//Burn eyes if exposed.
	if(vsc.contaminant_control.EYE_BURNS)
		var/found_eyeguard = FALSE
		for(var/slot in global.standard_headgear_slots)
			var/obj/item/clothing/thing = get_equipped_item(slot)
			if(istype(thing) && (thing.body_parts_covered & SLOT_EYES))
				found_eyeguard = TRUE
				break
		if(!found_eyeguard)
			burn_eyes()

	//Genetic Corruption
	if(vsc.contaminant_control.GENETIC_CORRUPTION)
		if(rand(1,10000) < vsc.contaminant_control.GENETIC_CORRUPTION)
			add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/disability)))
			to_chat(src, "<span class='danger'>High levels of toxins cause you to spontaneously mutate!</span>")

/mob/living/human/proc/burn_eyes()
	var/obj/item/organ/internal/eyes/E = get_organ(BP_EYES, /obj/item/organ/internal/eyes)
	if(E && !E.bodytype.eye_contaminant_guard)
		if(prob(20)) to_chat(src, "<span class='danger'>Your eyes burn!</span>")
		E.damage += 2.5
		SET_STATUS_MAX(src, STAT_BLURRY, 50)
		if (prob(max(0,E.damage - 15) + 1) && !GET_STATUS(src, STAT_BLIND))
			to_chat(src, "<span class='danger'>You are blinded!</span>")
			SET_STATUS_MAX(src, STAT_BLIND, 20)

/mob/living/human/proc/contaminant_head_protected()
	//Checks if the head is adequately sealed.
	var/obj/item/head = get_equipped_item(slot_head_str)
	if(!head)
		return FALSE
	// If strict protection is on, you must have a head item with ITEM_FLAG_NO_CONTAMINATION.
	if(vsc.contaminant_control.STRICT_PROTECTION_ONLY)
		if(!(head.item_flags & ITEM_FLAG_NO_CONTAMINATION))
			return FALSE
	// Regardless, the head item must cover the face and head. Eyes are checked seperately above.
	return BIT_TEST_ALL(head.body_parts_covered, SLOT_HEAD|SLOT_FACE)

/mob/living/human/proc/contaminant_suit_protected()
	//Checks if the suit is adequately sealed.
	var/coverage = 0
	for(var/slot in list(slot_wear_suit_str, slot_gloves_str, slot_shoes_str))
		var/obj/item/protection = get_equipped_item(slot)
		if(!istype(protection))
			continue
		if(vsc.contaminant_control.STRICT_PROTECTION_ONLY && !(protection.item_flags & ITEM_FLAG_NO_CONTAMINATION))
			return FALSE
		coverage |= protection.body_parts_covered

	if(vsc.contaminant_control.STRICT_PROTECTION_ONLY)
		return TRUE

	return BIT_TEST_ALL(coverage, SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS)

/mob/living/human/proc/suit_contamination()
	//Runs over the things that can be contaminated and does so.
	for(var/slot in list(slot_w_uniform_str, slot_shoes_str, slot_gloves_str))
		var/obj/item/gear = get_equipped_item(slot)
		if(istype(gear))
			gear.contaminate()


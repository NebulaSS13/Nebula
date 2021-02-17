var/image/contamination_overlay = image('icons/effects/contamination.dmi')

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


obj/var/contaminated = 0


/obj/item/proc/can_contaminate()
	//Clothing and backpacks can be contaminated.
	if(obj_flags & ITEM_FLAG_NO_CONTAMINATION) return 0
	else if(istype(src,/obj/item/storage/backpack)) return 0 //Cannot be washed :(
	else if(istype(src,/obj/item/clothing)) return 1

/obj/item/proc/contaminate()
	//Do a contamination overlay? Temporary measure to keep contamination less deadly than it was.
	if(!contaminated)
		contaminated = 1
		overlays += contamination_overlay

/obj/item/proc/decontaminate()
	contaminated = 0
	overlays -= contamination_overlay

/mob/proc/contaminate()

/mob/living/carbon/human/contaminate()
	//See if anything can be contaminated.

	if(!contaminant_suit_protected())
		suit_contamination()

	if(!contaminant_head_protected())
		if(prob(1)) suit_contamination() // Contaminants can sometimes get through such an open suit.

//Cannot wash backpacks currently.
//	if(istype(back,/obj/item/storage/backpack))
//		back.contaminate()

/mob/proc/handle_contaminants()
	return

/mob/living/carbon/human/handle_contaminants()
	//Handles all the bad things contaminants can do.

	//Contamination
	if(vsc.contaminant_control.CLOTH_CONTAMINATION) contaminate()

	//Anything else requires them to not be dead.
	if(stat >= 2)
		return

	//Burn skin if exposed.
	if(vsc.contaminant_control.SKIN_BURNS)
		if(!contaminant_head_protected() || !contaminant_suit_protected())
			take_overall_damage(0, 0.75)
			if(prob(20)) to_chat(src, "<span class='danger'>Your skin burns!</span>")
			updatehealth()

	//Burn eyes if exposed.
	if(vsc.contaminant_control.EYE_BURNS)
		var/found_eyeguard = FALSE
		for(var/obj/item/clothing/thing in list(head, wear_mask, glasses))
			if(istype(thing) && (thing.body_parts_covered & SLOT_EYES))
				found_eyeguard = TRUE
				break
		if(!found_eyeguard)
			burn_eyes()

	//Genetic Corruption
	if(vsc.contaminant_control.GENETIC_CORRUPTION)
		if(rand(1,10000) < vsc.contaminant_control.GENETIC_CORRUPTION)
			randmutb(src)
			to_chat(src, "<span class='danger'>High levels of toxins cause you to spontaneously mutate!</span>")
			domutcheck(src,null)


/mob/living/carbon/human/proc/burn_eyes()
	var/obj/item/organ/internal/eyes/E = get_internal_organ(BP_EYES)
	if(E && !E.contaminant_guard)
		if(prob(20)) to_chat(src, "<span class='danger'>Your eyes burn!</span>")
		E.damage += 2.5
		eye_blurry = min(eye_blurry+1.5,50)
		if (prob(max(0,E.damage - 15) + 1) &&!eye_blind)
			to_chat(src, "<span class='danger'>You are blinded!</span>")
			eye_blind += 20

/mob/living/carbon/human/proc/contaminant_head_protected()
	//Checks if the head is adequately sealed.
	if(head)
		if(vsc.contaminant_control.STRICT_PROTECTION_ONLY)
			if(head.item_flags & ITEM_FLAG_NO_CONTAMINATION)
				return 1
		else if(head.body_parts_covered & SLOT_EYES)
			return 1
	return 0

/mob/living/carbon/human/proc/contaminant_suit_protected()
	//Checks if the suit is adequately sealed.
	var/coverage = 0
	for(var/obj/item/protection in list(wear_suit, gloves, shoes))
		if(!protection)
			continue
		if(vsc.contaminant_control.STRICT_PROTECTION_ONLY && !(protection.item_flags & ITEM_FLAG_NO_CONTAMINATION))
			return 0
		coverage |= protection.body_parts_covered

	if(vsc.contaminant_control.STRICT_PROTECTION_ONLY)
		return 1

	return BIT_TEST_ALL(coverage, SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS)

/mob/living/carbon/human/proc/suit_contamination()
	//Runs over the things that can be contaminated and does so.
	if(w_uniform) w_uniform.contaminate()
	if(shoes) shoes.contaminate()
	if(gloves) gloves.contaminate()


turf/Entered(obj/item/I)
	. = ..()
	//Items that are in contaminants, but not on a mob, can still be contaminated.
	if(istype(I) && vsc && vsc.contaminant_control.CLOTH_CONTAMINATION && I.can_contaminate())
		var/datum/gas_mixture/env = return_air(1)
		if(!env)
			return
		for(var/g in env.gas)
			var/decl/material/mat = GET_DECL(g)
			if((mat.gas_flags & XGM_GAS_CONTAMINANT) && env.gas[g] > mat.gas_overlay_limit + 1)
				I.contaminate()
				break

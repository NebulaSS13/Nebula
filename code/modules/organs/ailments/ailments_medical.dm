/datum/ailment/head
	category = /datum/ailment/head
	applies_to_organ = list(BP_HEAD)

/datum/ailment/head/headache
	name = "headache"
	treated_by_chem_effect = CE_PAINKILLER
	treated_by_chem_effect_strength = 25
	medication_treatment_message = "Your headache grudgingly fades away."

/datum/ailment/head/headache/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your [organ.name] pulses with a sudden headache."))
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 5)
		E.add_pain(5)

/datum/ailment/head/tinnitus
	name = "tinnitus"
	treated_by_reagent_type = /decl/material/liquid/brute_meds
	treated_by_reagent_dosage = 1
	medication_treatment_message = "The high-pitched ringing in your ears slowly fades to nothing."

/datum/ailment/head/tinnitus/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your ears ring with an irritating, high-pitched tone."))
	SET_STATUS_MAX(organ.owner, STAT_DEAF, 3)

/datum/ailment/head/sore_throat
	name = "sore throat"
	treated_by_reagent_type = /decl/material/liquid/nutriment/honey
	treated_by_reagent_dosage = 1
	medication_treatment_message = "You swallow, finding that your sore throat is rapidly recovering."
	manual_diagnosis_string = "$USER_THEIR$ throat is red and inflamed."

/datum/ailment/head/sore_throat/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("You swallow painfully past your sore throat."))

/datum/ailment/head/sneezing
	name = "sneezing"
	treated_by_reagent_type = /decl/material/liquid/antiseptic
	treated_by_reagent_dosage = 1
	medication_treatment_message = "The itching in your sinuses fades away."
	manual_diagnosis_string = "$USER_THEIR$ sinuses are inflamed and running."

/datum/ailment/head/sneezing/can_apply_to(obj/item/organ/_organ)
	. = ..() && _organ.owner
	if(.)
		var/decl/emote/emote = GET_DECL(/decl/emote/audible/sneeze)
		return emote.mob_can_use(_organ.owner)

/datum/ailment/head/sneezing/on_ailment_event()
	organ.owner.emote(/decl/emote/audible/sneeze)
	organ.owner.setClickCooldown(3)

/datum/ailment/sprain
	name = "sprained limb"
	applies_to_organ = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	treated_by_item_type = /obj/item/stack/medical/bandage
	third_person_treatment_message = "$USER$ wraps $TARGET$'s sprained $ORGAN$ in $ITEM$."
	self_treatment_message = "$USER$ wraps $USER_THEIR$ sprained $ORGAN$ in $ITEM$."
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ is visibly swollen."

/datum/ailment/sprain/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your sprained [organ.name] aches distractingly."))
	organ.owner.setClickCooldown(3)
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 3)
		E.add_pain(3)

/datum/ailment/rash
	name = "rash"
	treated_by_item_type = /obj/item/stack/medical/ointment
	third_person_treatment_message = "$USER$ salves $TARGET$'s rash-stricken $ORGAN$ with $ITEM$."
	self_treatment_message = "$USER$ salves $USER_THEIR$ rash-stricken $ORGAN$ with $ITEM$."
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ is covered in a bumpy red rash."

/datum/ailment/rash/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("A bright red rash on your [organ.name] itches distractingly."))
	organ.owner.setClickCooldown(3)

/datum/ailment/coughing
	name = "coughing"
	specific_organ_subtype = /obj/item/organ/internal/lungs
	applies_to_organ = list(BP_LUNGS)
	treated_by_reagent_type = /decl/material/liquid/antiseptic
	medication_treatment_message = "The tickling in your throat fades away."
	manual_diagnosis_string = "$USER_THEIR$ throat is red and inflamed."

/datum/ailment/coughing/can_apply_to(obj/item/organ/_organ)
	. = ..() && _organ.owner
	if(.)
		var/decl/emote/emote = GET_DECL(/decl/emote/audible/cough)
		return emote.mob_can_use(_organ.owner)

/datum/ailment/coughing/on_ailment_event()
	organ.owner.cough()
	organ.owner.setClickCooldown(3)

/datum/ailment/sore_joint
	name = "sore joint"
	treated_by_chem_effect = CE_PAINKILLER
	treated_by_chem_effect_strength = 25
	medication_treatment_message = "The dull pulse of pain in your $ORGAN$ fades away."
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ is visibly swollen."

/datum/ailment/sore_joint/on_ailment_event()
	var/obj/item/organ/external/E = organ
	to_chat(organ.owner, SPAN_DANGER("Your [istype(E) ? E.joint : organ.name] aches uncomfortably."))
	organ.owner.setClickCooldown(3)
	if(istype(E) && E.pain < 3)
		E.add_pain(3)

/datum/ailment/sore_joint/can_apply_to(obj/item/organ/_organ)
	var/obj/item/organ/external/E = _organ
	. = ..() && !isnull(E.joint) && (E.limb_flags & ORGAN_FLAG_CAN_DISLOCATE)

/datum/ailment/sore_back
	name = "sore back"
	applies_to_organ = list(BP_CHEST)
	treated_by_chem_effect = CE_PAINKILLER
	treated_by_chem_effect_strength = 25
	medication_treatment_message = "You straighten, finding that your back is no longer hurting."

/datum/ailment/sore_back/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your back spasms painfully, causing you to hunch for a moment."))
	organ.owner.setClickCooldown(3)

/datum/ailment/stomach_ache
	name = "stomach ache"
	specific_organ_subtype = /obj/item/organ/internal/stomach
	applies_to_organ = list(BP_STOMACH)
	treated_by_reagent_type = /decl/material/solid/carbon
	medication_treatment_message = "The nausea in your $ORGAN$ slowly fades away."

/datum/ailment/stomach_ache/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your stomach roils unpleasantly."))
	organ.owner.setClickCooldown(3)

/datum/ailment/cramps
	name = "cramps"
	treated_by_reagent_type = /decl/material/liquid/sedatives // in lieu of muscle relaxants
	medication_treatment_message = "The painful cramping in your $ORGAN$ relaxes."

/datum/ailment/cramps/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your [organ.name] suddenly clenches in a painful cramp."))
	organ.owner.setClickCooldown(3)
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 3)
		E.add_pain(3)

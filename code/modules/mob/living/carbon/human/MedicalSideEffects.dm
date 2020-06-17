// MEDICAL SIDE EFFECT BASE
// ========================
/datum/medical_effect
	var/name = "None"
	var/strength = 0
	var/start = 0
	var/list/triggers
	var/list/cures
	var/cure_message

/datum/medical_effect/proc/manifest(mob/living/carbon/human/H)
	for(var/R in cures)
		if(!H.reagents || H.reagents.has_reagent(R))
			return FALSE
	for(var/R in triggers)
		if(REAGENT_VOLUME(H.reagents, R) >= triggers[R])
			return TRUE
	return FALSE

/datum/medical_effect/proc/on_life(mob/living/carbon/human/H, strength)
	return

/datum/medical_effect/proc/cure(mob/living/carbon/human/H)
	for(var/R in cures)
		if(H.reagents.has_reagent(R))
			if (cure_message)
				to_chat(H, SPAN_NOTICE("[cure_message]"))
			return TRUE
	return FALSE

// MOB HELPERS
// ===========
/mob/living/carbon/human/var/list/datum/medical_effect/side_effects = list()
/mob/proc/add_side_effect(name, strength = 0)
/mob/living/carbon/human/add_side_effect(name, strength = 0)
	for(var/datum/medical_effect/M in src.side_effects)
		if(M.name == name)
			M.strength = max(M.strength, 10)
			M.start = life_tick
			return

	for(var/T in subtypesof(/datum/medical_effect))
		var/datum/medical_effect/M = T
		if(initial(M.name) == name)
			M = new T
			M.strength = strength
			M.start = life_tick
			side_effects += M
			break

/mob/living/carbon/human/proc/handle_medical_side_effects()
	//Going to handle those things only every few ticks.
	if(life_tick % 15 != 0)
		return FALSE

	var/list/L = subtypesof(/datum/medical_effect)
	for(var/T in L)
		var/datum/medical_effect/M = new T
		if (M.manifest(src))
			src.add_side_effect(M.name)
		else
			qdel(M)

	// One full cycle(in terms of strength) every 10 minutes
	for (var/datum/medical_effect/M in side_effects)
		if (!M) continue
		var/strength_percent = sin((life_tick - M.start) / 2)

		// Only do anything if the effect is currently strong enough
		if(strength_percent >= 0.4)
			if (M.cure(src) || M.strength > 50)
				side_effects -= M
				M = null
			else
				if(life_tick % 45 == 0)
					M.on_life(src, strength_percent*M.strength)
				// Effect slowly growing stronger
				M.strength+=0.08

// HEADACHE
// ========
/datum/medical_effect/headache
	name = "Headache"
	triggers = list(/decl/material/liquid/brute_meds = 15, /decl/material/liquid/regenerator = 15)
	cures = list(/decl/material/liquid/neuroannealer, /decl/material/liquid/painkillers)
	cure_message = "Your head stops throbbing..."

/datum/medical_effect/headache/on_life(mob/living/carbon/human/H, strength)
	var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD)
	if(head)
		switch(strength)
			if(1 to 10)
				H.custom_pain("You feel a light pain in your [head.name].", 5, affecting = head)
			if(11 to 30)
				H.custom_pain("You feel a throbbing pain in your [head.name]!", 15, affecting = head)
				H.eye_blurry += rand(3,6)
				H.stamina -= rand(10,20)
				shake_camera(H, 7, 0.5)
			if(31 to INFINITY)
				H.custom_pain("You feel an excrutiating pain in your [head.name]!", 40, affecting = head)
				H.eye_blurry += rand(10,20)
				H.stamina -= rand(20,35)
				shake_camera(H, 7, 1)

// BAD STOMACH
// ===========
/datum/medical_effect/bad_stomach
	name = "Bad Stomach"
	triggers = list(/decl/material/liquid/burn_meds = 30)
	cures = list(/decl/material/liquid/antitoxins)
	cure_message = "Your stomach feels a little better now..."

/datum/medical_effect/bad_stomach/on_life(mob/living/carbon/human/H, strength)
	var/obj/item/organ/internal/stomach/stomach = H.get_organ(BP_STOMACH) //INF
	if(stomach)
		switch(strength)
			if(1 to 10)
				H.custom_pain("You feel a bit light around \the [stomach.name].", 10, affecting = stomach)
			if(11 to 30)
				H.custom_pain("Your [stomach.name] hurts.", 20, affecting = stomach)
			if(31 to INFINITY)
				H.custom_pain("You feel sick.", 30, affecting = stomach)

// CRAMPS
// ======
/datum/medical_effect/cramps
	name = "Cramps"
	triggers = list(/decl/material/liquid/antitoxins = 30, /decl/material/liquid/painkillers = 15)
	cures = list(/decl/material/liquid/adrenaline)
	cure_message = "The cramps let up..."

/datum/medical_effect/cramps/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("The muscles in your body hurt a little.", 20)
		if(11 to 30)
			H.custom_pain("The muscles in your body cramp up painfully.", 30)
		if(31 to INFINITY)
			H.visible_message("<B>\The [src]</B> flinches as all the muscles in their body cramp up.")
			H.custom_pain("There's pain all over your body.", 70)
			shake_camera(H, 10, 1)

// ITCH
// ====
/datum/medical_effect/itch
	name = "Itch"
	triggers = list(/decl/material/liquid/psychoactives = 10)
	cures = list(/decl/material/liquid/adrenaline)
	cure_message = "The itching stops..."

/datum/medical_effect/itch/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a slight itch.", 10)
		if(11 to 30)
			H.custom_pain("You want to scratch your itch badly.", 15)
		if(31 to INFINITY)
			H.visible_message("<B>\The [src]</B> shivers slightly.")
			H.custom_pain("This itch makes it really hard to concentrate.", 20)
			shake_camera(H, 20, 4)

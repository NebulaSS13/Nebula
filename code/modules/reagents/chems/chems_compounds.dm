/decl/material/acetone
	name = "acetone"
	lore_text = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	icon_colour = "#808080"
	metabolism = REM * 0.2
	value = 0.1

/decl/material/acetone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(removed * 3)

/decl/material/acetone/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	var/volume = REAGENT_VOLUME(holder, type)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/decl/material/surfactant // Foam precursor
	name = "surfacant"
	lore_text = "A isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	icon_colour = "#9e6b38"
	value = 0.1

/decl/material/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "foaming agent"
	lore_text = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	icon_colour = "#664b63"
	value = 0.1

/decl/material/lube
	name = "lubricant"
	lore_text = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	icon_colour = "#009ca8"
	value = 0.1

/decl/material/lube/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) >= 1 && istype(T, /turf/simulated))
		var/turf/simulated/slip = T
		slip.wet_floor(80)

/decl/material/woodpulp
	name = "wood pulp"
	lore_text = "A mass of wood fibers."
	taste_description = "wood"
	icon_colour = WOOD_COLOR_GENERIC
	hidden_from_codex = TRUE

/decl/material/bamboo
	name = "bamboo pulp"
	lore_text = "A mass of bamboo fibers."
	taste_description = "grass"
	icon_colour = WOOD_COLOR_PALE2
	hidden_from_codex = TRUE

/decl/material/luminol
	name = "luminol"
	lore_text = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	icon_colour = "#f2f3f4"

/decl/material/luminol/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.reveal_blood()

/decl/material/luminol/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	M.reveal_blood()

/decl/material/glowsap
	name = "glowsap"
	lore_text = "A popular party drug for adventurous types who want to BE the glowstick. Rumoured to be hallucinogenic in high doses."
	overdose = 15
	icon_colour = "#9eefff"

/decl/material/glowsap/affect_ingest(mob/living/carbon/M, alien, removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed, holder)

/decl/material/glowsap/affect_blood(mob/living/carbon/M, alien, removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_GLOWINGEYES, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_eyes()

/decl/material/glowsap/on_leaving_metabolism(mob/parent, metabolism_class)
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		addtimer(CALLBACK(H, /mob/living/carbon/human/proc/update_eyes), 5 SECONDS)
	. = ..()

/decl/material/glowsap/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	. = ..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)

/decl/material/sodiumchloride
	name = "table salt"
	lore_text = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	icon_colour = "#ffffff"
	overdose = REAGENTS_OVERDOSE
	value = 0.1

/decl/material/blackpepper
	name = "black pepper"
	lore_text = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	icon_colour = "#000000"
	value = 0.1

/decl/material/enzyme
	name = "universal enzyme"
	lore_text = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	icon_colour = "#365e30"
	overdose = REAGENTS_OVERDOSE

/decl/material/frostoil
	name = "chilly oil"
	lore_text = "An oil harvested from a mutant form of chili peppers, it has a chilling effect on the body."
	taste_description = "arctic mint"
	taste_mult = 1.5
	icon_colour = "#07aab2"
	value = 2

/decl/material/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(/decl/material/capsaicin, 5)

/decl/material/capsaicin
	name = "capsaicin oil"
	lore_text = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	icon_colour = "#b31008"
	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10

/decl/material/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.5 * removed)

/decl/material/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] < agony_dose)
		if(prob(5) || M.chem_doses[type] == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, PAIN, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(/decl/material/frostoil, 5)

/decl/material/capsaicin/condensed
	name = "condensed capsaicin"
	lore_text = "A chemical agent used for self-defense and in police work."
	taste_description = "scorching agony"
	taste_mult = 10
	touch_met = 5 // Get rid of it quickly
	icon_colour = "#b31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15
	value = 2

/decl/material/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/partial_mouth_covered = 0
	var/stun_probability = 50
	var/no_pain = 0
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null
	var/obj/item/partial_face_protection = null

	var/effective_strength = 5

	var/list/protection
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		protection = list(H.head, H.glasses, H.wear_mask)
		if(!H.can_feel_pain())
			no_pain = 1 //TODO: living-level can_feel_pain() proc
	else
		protection = list(M.wear_mask)

	for(var/obj/item/I in protection)
		if(I)
			if(I.body_parts_covered & EYES)
				eyes_covered = 1
				eye_protection = I.name
			if((I.body_parts_covered & FACE) && !(I.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name
			else if(I.body_parts_covered & FACE)
				partial_mouth_covered = 1
				partial_face_protection = I.name

	if(eyes_covered)
		if(!mouth_covered)
			to_chat(M, "<span class='warning'>Your [eye_protection] protects your eyes from the pepperspray!</span>")
	else
		to_chat(M, "<span class='warning'>The pepperspray gets in your eyes!</span>")
		M.confused += 2
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
			M.eye_blind = max(M.eye_blind, effective_strength)
		else
			M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
			M.eye_blind = max(M.eye_blind, effective_strength * 2)

	if(mouth_covered)
		to_chat(M, "<span class='warning'>Your [face_protection] protects you from the pepperspray!</span>")
	else if(!no_pain)
		if(partial_mouth_covered)
			to_chat(M, "<span class='warning'>Your [partial_face_protection] partially protects you from the pepperspray!</span>")
			stun_probability *= 0.5
		to_chat(M, "<span class='danger'>Your face and throat burn!</span>")
		if(M.stunned > 0  && !M.lying)
			M.Weaken(4)
		if(prob(stun_probability))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
			M.Stun(3)

/decl/material/capsaicin/condensed/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] == metabolism)
		to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	else
		M.apply_effect(6, PAIN, 0)
		if(prob(5))
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
			M.custom_emote(2, "[pick("coughs.","gags.","retches.")]")
			M.Stun(2)
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(/decl/material/frostoil, 5)

/decl/material/mutagenics
	name = "mutagenics"
	lore_text = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	icon_colour = "#13bc5e"

/decl/material/mutagenics/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(33))
		affect_blood(M, alien, removed, holder)

/decl/material/mutagenics/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(67))
		affect_blood(M, alien, removed, holder)

/decl/material/mutagenics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)

	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & SPECIES_FLAG_NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 0.1)) // Approx. one mutation per 10 injected/20 ingested/30 touching units
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
	M.apply_damage(10 * removed, IRRADIATE, armor_pen = 100)

/decl/material/nitrous_oxide
	name = "nitrous oxide"
	lore_text = "An ubiquitous sleeping agent also known as laughing gas."
	taste_description = "dental surgery"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	var/do_giggle = TRUE

/decl/material/nitrous_oxide/xenon
	name = "xenon"
	lore_text = "A nontoxic gas used as a general anaesthetic."
	do_giggle = FALSE
	taste_description = "nothing"
	icon_colour = COLOR_GRAY80

/decl/material/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dosage = M.chem_doses[type]
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	if(do_giggle && prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/lactate
	name = "lactate"
	lore_text = "Lactate is produced by the body during strenuous exercise. It often correlates with elevated heart rate, shortness of breath, and general exhaustion."
	taste_description = "sourness"
	icon_colour = "#eeddcc"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	metabolism = REM

/decl/material/lactate/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_BREATHLOSS, 0.02 * volume)
	if(volume >= 5)
		M.add_chemical_effect(CE_PULSE, 1)
		M.add_chemical_effect(CE_SLOWDOWN, (volume/5) ** 2)
	else if(M.chem_doses[type] > 20) //after prolonged exertion
		M.make_jittery(10)

/decl/material/nanoblood
	name = "nanoblood"
	lore_text = "A stable hemoglobin-based nanoparticle oxygen carrier, used to rapidly replace lost blood. Toxic unless injected in small doses. Does not contain white blood cells."
	taste_description = "blood with bubbles"
	icon_colour = "#c10158"
	scannable = 1
	overdose = 5
	metabolism = 1

/decl/material/nanoblood/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!M.should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	if(M.regenerate_blood(4 * removed))
		M.immunity = max(M.immunity - 0.1, 0)
		if(M.chem_doses[type] > M.species.blood_volume/8) //half of blood was replaced with us, rip white bodies
			M.immunity = max(M.immunity - 0.5, 0)

/decl/material/tobacco
	name = "tobacco"
	lore_text = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	icon_colour = "#684b3c"
	scannable = 1
	scent = "cigarette smoke"
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 4
	hidden_from_codex = TRUE

	var/nicotine = REM * 0.2

/decl/material/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.reagents.add_reagent(/decl/material/nicotine, nicotine)

/decl/material/tobacco/fine
	name = "fine tobacco"
	taste_description = "fine tobacco"
	value = 1.5
	scent = "fine tobacco smoke"
	scent_descriptor = SCENT_DESC_FRAGRANCE

/decl/material/tobacco/bad
	name = "terrible tobacco"
	taste_description = "acrid smoke"
	value = 0.5
	scent = "acrid tobacco smoke"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR

/decl/material/tobacco/liquid
	name = "nicotine solution"
	lore_text = "A diluted nicotine solution."
	taste_mult = 0
	icon_colour = "#fcfcfc"
	nicotine = REM * 0.1
	scent = null
	scent_intensity = null
	scent_descriptor = null
	scent_range = null

/decl/material/menthol
	name = "menthol"
	lore_text = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	icon_colour = "#80af9c"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	hidden_from_codex = TRUE

/decl/material/menthol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, SPAN_NOTICE("You feel faintly sore in the throat."))

/decl/material/nanitefluid
	name = "Nanite Fluid"
	lore_text = "A solution of repair nanites used to repair robotic organs. Due to the nature of the small magnetic fields used to guide the nanites, it must be used in temperatures below 170K."
	taste_description = "metallic sludge"
	icon_colour = "#c2c2d6"
	scannable = 1
	flags = IGNORE_MOB_SIZE

/decl/material/nanitefluid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.heal_organ_damage(30 * removed, 30 * removed, affect_robo = 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(BP_IS_PROSTHETIC(I))
					I.heal_damage(20*removed)

/decl/material/antiseptic
	name = "antiseptic"
	lore_text = "Sterilizes surfaces (or wounds) in preparation for surgery, and thoroughly removes blood."
	taste_description = "bitterness"
	icon_colour = "#c8a5dc"
	touch_met = 5

/decl/material/antiseptic/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.germ_level < INFECTION_LEVEL_TWO) // rest and antibiotics is required to cure serious infections
		M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/decl/material/antiseptic/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.germ_level -= min(REAGENT_VOLUME(holder, type)*20, O.germ_level)
	O.was_bloodied = null

/decl/material/antiseptic/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	T.germ_level -= min(REAGENT_VOLUME(holder, type)*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/decl/material/crystal
	name = "crystallizing agent"
	taste_description = "sharpness"
	icon_colour = "#13bc5e"

/decl/material/crystal/proc/do_material_check(var/mob/living/carbon/M)
	. = MAT_CRYSTAL

/decl/material/crystal/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/result_mat = do_material_check(M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in shuffle(H.organs.Copy()))
			if(E.is_stump() || BP_IS_PROSTHETIC(E))
				continue

			if(BP_IS_CRYSTAL(E))
				if((E.brute_dam + E.burn_dam) > 0)
					if(prob(35))
						to_chat(M, SPAN_NOTICE("You feel a crawling sensation as fresh crystal grows over your [E.name]."))
					E.heal_damage(rand(5,8), rand(5,8))
					break
				if(BP_IS_BRITTLE(E))
					E.status &= ~ORGAN_BRITTLE
					break
			else if(E.organ_tag != BP_CHEST && E.organ_tag != BP_GROIN && prob(15))
				to_chat(H, SPAN_DANGER("Your [E.name] is being lacerated from within!"))
				if(E.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					for(var/i = 1 to rand(3,5))
						new /obj/item/material/shard(get_turf(E), result_mat)
					E.droplimb(0, DROPLIMB_BLUNT)
				else
					E.take_external_damage(rand(20,30), 0)
					E.status |= ORGAN_CRYSTAL
					E.status |= ORGAN_BRITTLE
				break

		for(var/obj/item/organ/internal/I in shuffle(H.internal_organs.Copy()))
			if(BP_IS_PROSTHETIC(I) || !BP_IS_CRYSTAL(I) || I.damage <= 0 || I.organ_tag == BP_BRAIN)
				continue
			if(prob(35))
				to_chat(M, SPAN_NOTICE("You feel a deep, sharp tugging sensation as your [I.name] is mended."))
			I.heal_damage(rand(1,3))
			break
	else		
		to_chat(M, SPAN_DANGER("Your flesh is being lacerated from within!"))
		M.adjustBruteLoss(rand(3,6))
		if(prob(10))
			new /obj/item/material/shard(get_turf(M), result_mat)

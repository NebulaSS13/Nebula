/datum/reagent/ethanol
	name = "ethanol" //Parent class for all alcoholic reagents.
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	color = "#404030"
	touch_met = 5
	fuel_value = 0.75

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	value = 0.2

/datum/reagent/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 2 * toxicity)
	return

/datum/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/effective_dose = M.chem_doses[type] * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster

	if(effective_dose >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.slurring = max(M.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.confused = max(M.confused, 20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.drowsyness = max(M.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.Paralyse(20)
		M.Sleeping(30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

/datum/reagent/ethanol/touch_obj(var/obj/O)
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
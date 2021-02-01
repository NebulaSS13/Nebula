/decl/material/liquid/paralytics
	name = "paralytics"
	lore_text = "A powerful paralytic agent."
	taste_description = "metallic"
	color = "#ff337d"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 1.5

/decl/material/liquid/paralytics/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/threshold = 2
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose >= metabolism * threshold * 0.5)
		M.confused = max(M.confused, 2)
		M.add_chemical_effect(CE_VOICELOSS, 1)
	if(dose > threshold * 0.5)
		M.make_dizzy(3)
		M.Weaken(2)
	if(dose == round(threshold * 0.5, metabolism))
		to_chat(M, SPAN_WARNING("Your muscles slacken and cease to obey you."))
	if(dose >= threshold)
		M.add_chemical_effect(CE_SEDATE, 1)
		M.eye_blurry = max(M.eye_blurry, 10)

	if(dose > 1 * threshold)
		M.adjustToxLoss(removed)

/decl/material/liquid/presyncopics
	name = "presyncopics"
	lore_text = "A compound that causess presyncopic effects in the taker, including confusion and dizzyness."
	taste_description = "sourness"
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	heating_point = 61 CELSIUS
	heating_products = list(
		/decl/material/solid/potassium =        0.3, 
		/decl/material/liquid/acetone =         0.3, 
		/decl/material/liquid/nutriment/sugar = 0.4
	)
	value = 1.5

/decl/material/liquid/presyncopics/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/drug_strength = 4
	M.make_dizzy(drug_strength)
	M.confused = max(M.confused, drug_strength * 5)

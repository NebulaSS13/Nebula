/decl/material/carbon_monoxide
	name = "carbon monoxide"
	lore_text = "A dangerous carbon comubstion byproduct."
	taste_description = "stale air"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05 // As with helium.

/decl/material/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/warning_message
	var/warning_prob = 10
	var/dosage = M.chem_doses[type]
	if(dosage >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(10,20)
		M.co2_alert = 1
	else if(dosage >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.co2_alert = 1
		M.adjustOxyLoss(3,5)
	else if(dosage >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
		M.co2_alert = 0
	else
		M.co2_alert = 0
	if(dosage > 1 && M.losebreath < 15)
		M.losebreath++
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")

/decl/material/paralytics
	name = "paralytics"
	lore_text = "A powerful paralytic agent."
	taste_description = "metallic"
	icon_colour = "#ff337d"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 1.5

/decl/material/paralytics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/threshold = 2
	if(M.chem_doses[type] >= metabolism * threshold * 0.5)
		M.confused = max(M.confused, 2)
		M.add_chemical_effect(CE_VOICELOSS, 1)
	if(M.chem_doses[type] > threshold * 0.5)
		M.make_dizzy(3)
		M.Weaken(2)
	if(M.chem_doses[type] == round(threshold * 0.5, metabolism))
		to_chat(M, SPAN_WARNING("Your muscles slacken and cease to obey you."))
	if(M.chem_doses[type] >= threshold)
		M.add_chemical_effect(CE_SEDATE, 1)
		M.eye_blurry = max(M.eye_blurry, 10)

	if(M.chem_doses[type] > 1 * threshold)
		M.adjustToxLoss(removed)

/decl/material/presyncopics
	name = "presyncopics"
	lore_text = "A compound that causess presyncopic effects in the taker, including confusion and dizzyness."
	taste_description = "sourness"
	icon_colour = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	heating_point = 61 CELSIUS
	heating_products = list(/decl/material/potassium, /decl/material/acetone, /decl/material/nutriment/sugar)
	value = 1.5

/decl/material/presyncopics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/drug_strength = 4
	M.make_dizzy(drug_strength)
	M.confused = max(M.confused, drug_strength * 5)

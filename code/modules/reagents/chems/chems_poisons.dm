
/datum/reagent/carbon_monoxide
	name = "carbon monoxide"
	description = "A dangerous carbon comubstion byproduct."
	taste_description = "stale air"
	color = COLOR_GRAY80
	metabolism = 0.05 // As with helium.

/datum/reagent/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
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
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")


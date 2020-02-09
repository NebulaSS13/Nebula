
/datum/reagent/amphetamines
	name = "amphetamines"
	description = "A powerful, long-lasting stimulant." 
	taste_description = "acid"
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 3.9

/datum/reagent/amphetamines/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)
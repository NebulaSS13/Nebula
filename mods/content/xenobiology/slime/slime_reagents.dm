/decl/material/liquid/slimejelly
	name = "slime jelly"
	uid = "chem_slime_jelly"
	lore_text = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	taste_description = "slime"
	taste_mult = 1.3
	toxicity = 10
	heating_products = list(
		/decl/material/liquid/denatured_toxin = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "becomes clear."
	color = "#cf3600"
	metabolism = REM * 0.25
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/water/affect_touch(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.adjustToxLoss(10 * removed)
		var/mob/living/slime/S = M
		if(istype(S) && istype(S.ai, /datum/ai/slime))
			var/datum/ai/slime/slime_ai = S.ai
			if(slime_ai.current_target)
				slime_ai.current_target = null
			S.set_feeding_on()
		if(LAZYACCESS(M.chem_doses, type) == removed)
			M.visible_message( \
				SPAN_DANGER("\The [S]'s flesh sizzles where \the [name] touches it!"), \
				SPAN_DANGER("Your flesh is burned by \the [name]!"))
			SET_STATUS_MAX(M, STAT_CONFUSE, 2)
			var/datum/ai/slime/slime_ai = M.ai
			if(istype(slime_ai))
				slime_ai.attacked = max(slime_ai.attacked, rand(7,10)) // angery

/decl/material/liquid/water/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.adjustToxLoss(2 * removed)

/decl/material/liquid/frostoil/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)

/decl/material/liquid/capsaicin/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.bodytemperature += rand(0, 15) + slime_temp_adj

/decl/material/liquid/capsaicin/condensed/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.bodytemperature += rand(15, 30)

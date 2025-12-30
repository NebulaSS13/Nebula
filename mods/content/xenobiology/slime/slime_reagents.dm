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

/decl/material/liquid/water/affect_touch(var/mob/living/victim, var/removed, var/datum/reagents/holder)
	. = ..()
	if(isslime(victim))
		victim.take_damage(10 * removed, TOX)
		var/mob/living/slime/slime_victim = victim
		if(istype(slime_victim) && istype(slime_victim.ai, /datum/mob_controller/slime))
			var/datum/mob_controller/slime/slime_ai = slime_victim.ai
			if(slime_ai.current_target) // don't bother resolving it, we're just clearing it
				slime_ai.current_target = null
			slime_victim.set_feeding_on()
		if(CHEM_DOSE(victim, src) == removed)
			var/reagent_name = get_reagent_name(holder) // mostly to check masked name, but handles phase too
			victim.visible_message( \
				SPAN_DANGER("\The [slime_victim]'s flesh sizzles where \the [reagent_name] touches it!"), \
				SPAN_DANGER("Your flesh is burned by \the [reagent_name]!"))
			SET_STATUS_MAX(victim, STAT_CONFUSE, 2)
			var/datum/mob_controller/slime/slime_ai = victim.ai
			if(istype(slime_ai))
				slime_ai.attacked = max(slime_ai.attacked, rand(7,10)) // angery

/decl/material/liquid/water/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(isslime(M))
		M.take_damage(2 * removed, TOX)

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

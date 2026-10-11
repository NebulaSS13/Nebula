/decl/material/liquid/pigment
	name = "pigment"
	lore_text = "Intensely coloured powder." // then why is it a liquid?
	taste_description = "the back of class"
	liquid_color = "#888888"
	overdose = 5
	hidden_from_codex = TRUE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	opacity = 1.0
	uid = "chem_pigment"

/decl/material/liquid/pigment/red
	name = "red pigment"
	liquid_color = "#fe191a"
	uid = "chem_pigment_red"

/decl/material/liquid/pigment/orange
	name = "orange pigment"
	liquid_color = "#ffbe4f"
	uid = "chem_pigment_orange"

/decl/material/liquid/pigment/yellow
	name = "yellow pigment"
	liquid_color = "#fdfe7d"
	uid = "chem_pigment_yellow"

/decl/material/liquid/pigment/green
	name = "green pigment"
	liquid_color = "#18a31a"
	uid = "chem_pigment_green"

/decl/material/liquid/pigment/blue
	name = "blue pigment"
	liquid_color = "#247cff"
	uid = "chem_pigment_blue"

/decl/material/liquid/pigment/purple
	name = "purple pigment"
	liquid_color = "#cc0099"
	uid = "chem_pigment_purple"

/decl/material/liquid/pigment/grey //Mime
	name = "grey pigment"
	liquid_color = "#808080"
	uid = "chem_pigment_grey"

/decl/material/liquid/pigment/brown //Rainbow
	name = "brown pigment"
	liquid_color = "#846f35"
	uid = "chem_pigment_brown"

/decl/material/liquid/pigment/grey //Mime
	name = "grey pigment"
	liquid_color = "#808080"
	uid = "chem_pigment_grey"

/decl/material/liquid/pigment/black
	name = "black pigment"
	liquid_color = "#222222"
	uid = "chem_pigment_black"

/decl/material/liquid/pigment/black/ink
	name = "ink"
	lore_text = "Ink used for writing or dyeing materials, often made from soot or charcoal and some sort of binder."
	uid = "chem_ink"

/decl/material/liquid/pigment/white
	name = "white pigment"
	liquid_color = "#aaaaaa"
	uid = "chem_pigment_white"

/decl/material/liquid/paint_stripper
	name = "paint stripper"
	uid = "liquid_paint_remover"
	lore_text = "A highly toxic compound used as an effective paint stripper."
	taste_description = "bleach and acid"
	liquid_color = "#a0a0a0"
	metabolism = REM * 0.2
	value = 0.1
	solvent_power = MAT_SOLVENT_MODERATE
	toxicity = 10

/decl/material/liquid/paint_stripper/proc/remove_paint(var/atom/painting, var/datum/reagents/holder)
	if(istype(painting) && istype(holder))
		var/keep_alpha = painting.alpha
		painting.reset_color()
		painting.set_alpha(keep_alpha)

/decl/material/liquid/paint_stripper/touch_turf(var/turf/touching_turf, var/amount, var/datum/reagents/holder)
	if(istype(touching_turf) && !isspaceturf(touching_turf))
		remove_paint(touching_turf, holder)

/decl/material/liquid/paint_stripper/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		remove_paint(O, holder)

/decl/material/liquid/paint_stripper/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		remove_paint(M, holder)

/decl/material/liquid/paint
	name = "paint"
	lore_text = "This paint will stick to almost any object."
	taste_description = "chalk"
	liquid_color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 0
	uid = "chem_pigment_paint"
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/liquid/paint/proc/apply_paint(var/atom/painting, var/datum/reagents/holder, var/threshold = 1)
	if(istype(painting) && istype(holder) && REAGENT_VOLUME(holder, src) >= threshold)
		var/keep_alpha = painting.alpha
		painting.set_color(holder.get_color())
		painting.set_alpha(keep_alpha)

/decl/material/liquid/paint/touch_turf(var/turf/touching_turf, var/amount, var/datum/reagents/holder)
	if(istype(touching_turf) && !isspaceturf(touching_turf))
		apply_paint(touching_turf, holder, FLUID_MINIMUM_TRANSFER)

/decl/material/liquid/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		apply_paint(O, holder, O.get_object_size())

/decl/material/liquid/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		apply_paint(M, holder, M.get_object_size())

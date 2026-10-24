/decl/material/liquid/pigment
	name = "pigment"
	overdose = 5
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	opacity = 1.0
	abstract_type = /decl/material/liquid/pigment

/decl/material/liquid/pigment/red
	name = "red pigment"
	color = "#fe191a"
	uid = "chem_pigment_red"
	lore_text = "Red pigment can be produced from acid treatment of cinnabar."

/decl/material/liquid/pigment/orange
	name = "orange pigment"
	color = "#ffbe4f"
	uid = "chem_pigment_orange"
	lore_text = "Orange pigment can be produced by heat treatment of lead and chromium."

/decl/material/liquid/pigment/yellow
	name = "yellow pigment"
	color = "#fdfe7d"
	uid = "chem_pigment_yellow"
	lore_text = "Yellow pigment can be produced by grinding dried sunflowers."

/decl/material/liquid/pigment/green
	name = "green pigment"
	color = "#18a31a"
	uid = "chem_pigment_green"
	lore_text = "Green pigment can be produced by grinding dried berries."

/decl/material/liquid/pigment/blue
	name = "blue pigment"
	color = "#247cff"
	uid = "chem_pigment_blue"
	lore_text = "Blue pigment can be produced by cooking powdered copper, quartz and ashes together at 800C or higher."

/decl/material/liquid/pigment/purple
	name = "purple pigment"
	color = "#cc0099"
	uid = "chem_pigment_purple"
	lore_text = "Historically rare and expensive. Purple pigment can be produced by grinding up mollusc shells and treating with acid."

/decl/material/liquid/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"
	uid = "chem_pigment_grey"
	lore_text = "Grey pigment can be made by mixing ashes and purified spirits."

/decl/material/liquid/pigment/brown
	name = "brown pigment"
	color = "#846f35"
	uid = "chem_pigment_brown"
	lore_text = "Brown pigment can be produced from acid treatment of clay."

/decl/material/liquid/pigment/black
	name = "black pigment"
	color = "#222222"
	uid = "chem_pigment_black"
	lore_text = "Black pigment can be produced by mixing purified carbon and spirits."

/decl/material/liquid/pigment/black/ink
	name = "black ink"
	lore_text = "Ink used for writing or dyeing materials, often made from soot or charcoal and some sort of binder."
	uid = "chem_ink"

/decl/material/liquid/pigment/white
	name = "white pigment"
	color = "#aaaaaa"
	uid = "chem_pigment_white"
	lore_text = "White pigment can be produced by acid treatment of powdered zinc."

/decl/material/liquid/paint_stripper
	name = "paint stripper"
	uid = "liquid_paint_remover"
	lore_text = "A highly toxic compound used as an effective paint stripper."
	taste_description = "bleach and acid"
	color = "#a0a0a0"
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
	color = "#808080"
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

/decl/reagent/pigment/crayon_dust
	name = "crayon dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "the back of class"
	color = "#888888"
	overdose = 5
	hidden_from_codex = TRUE

/decl/reagent/pigment/crayon_dust/red
	name = "red crayon dust"
	color = "#fe191a"

/decl/reagent/pigment/crayon_dust/orange
	name = "orange crayon dust"
	color = "#ffbe4f"

/decl/reagent/pigment/crayon_dust/yellow
	name = "yellow crayon dust"
	color = "#fdfe7d"

/decl/reagent/pigment/crayon_dust/green
	name = "green crayon dust"
	color = "#18a31a"

/decl/reagent/pigment/crayon_dust/blue
	name = "blue crayon dust"
	color = "#247cff"

/decl/reagent/pigment/crayon_dust/purple
	name = "purple crayon dust"
	color = "#cc0099"

/decl/reagent/pigment/crayon_dust/grey //Mime
	name = "grey crayon dust"
	color = "#808080"

/decl/reagent/pigment/crayon_dust/brown //Rainbow
	name = "brown crayon dust"
	color = "#846f35"

/decl/reagent/paint
	name = "paint"
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20

/decl/reagent/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/decl/reagent/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		O.color = color

/decl/reagent/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M) && !isobserver(M)) //painting observers: not allowed
		M.color = color //maybe someday change this to paint only clothes and exposed body parts for human mobs.

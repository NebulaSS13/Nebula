/decl/reagent/pigment
	name = "pigment"
	description = "Intensely coloured powder."
	taste_description = "the back of class"
	color = "#888888"
	overdose = 5
	hidden_from_codex = TRUE

/decl/reagent/pigment/red
	name = "red pigment"
	color = "#fe191a"

/decl/reagent/pigment/orange
	name = "orange pigment"
	color = "#ffbe4f"

/decl/reagent/pigment/yellow
	name = "yellow pigment"
	color = "#fdfe7d"

/decl/reagent/pigment/green
	name = "green pigment"
	color = "#18a31a"

/decl/reagent/pigment/blue
	name = "blue pigment"
	color = "#247cff"

/decl/reagent/pigment/purple
	name = "purple pigment"
	color = "#cc0099"

/decl/reagent/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/reagent/pigment/brown //Rainbow
	name = "brown pigment"
	color = "#846f35"

/decl/reagent/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/reagent/pigment/black
	name = "black pigment"
	color = "#222222"

/decl/reagent/pigment/white
	name = "white pigment"
	color = "#aaaaaa"

/decl/reagent/paint
	name = "paint"
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 0

/decl/reagent/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !istype(T, /turf/space))
		T.color = holder.get_color()

/decl/reagent/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		O.color = holder.get_color()

/decl/reagent/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M) && !isobserver(M))
		M.color = holder.get_color()

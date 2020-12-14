/decl/material/pigment
	name = "pigment"
	lore_text = "Intensely coloured powder."
	taste_description = "the back of class"
	color = "#888888"
	overdose = 5
	hidden_from_codex = TRUE

/decl/material/pigment/red
	name = "red pigment"
	color = "#fe191a"

/decl/material/pigment/orange
	name = "orange pigment"
	color = "#ffbe4f"

/decl/material/pigment/yellow
	name = "yellow pigment"
	color = "#fdfe7d"

/decl/material/pigment/green
	name = "green pigment"
	color = "#18a31a"

/decl/material/pigment/blue
	name = "blue pigment"
	color = "#247cff"

/decl/material/pigment/purple
	name = "purple pigment"
	color = "#cc0099"

/decl/material/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/material/pigment/brown //Rainbow
	name = "brown pigment"
	color = "#846f35"

/decl/material/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/material/pigment/black
	name = "black pigment"
	color = "#222222"

/decl/material/pigment/white
	name = "white pigment"
	color = "#aaaaaa"

/decl/material/liquid/paint
	name = "paint"
	lore_text = "This paint will stick to almost any object."
	taste_description = "chalk"
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 0

/decl/material/liquid/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !isspaceturf(T))
		T.color = holder.get_color()

/decl/material/liquid/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		O.color = holder.get_color()

/decl/material/liquid/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M) && !isobserver(M))
		M.color = holder.get_color()

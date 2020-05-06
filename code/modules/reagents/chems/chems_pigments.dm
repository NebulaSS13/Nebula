/decl/material/pigment
	name = "pigment"
	lore_text = "Intensely coloured powder."
	taste_description = "the back of class"
	icon_colour = "#888888"
	overdose = 5
	hidden_from_codex = TRUE

/decl/material/pigment/red
	name = "red pigment"
	icon_colour = "#fe191a"

/decl/material/pigment/orange
	name = "orange pigment"
	icon_colour = "#ffbe4f"

/decl/material/pigment/yellow
	name = "yellow pigment"
	icon_colour = "#fdfe7d"

/decl/material/pigment/green
	name = "green pigment"
	icon_colour = "#18a31a"

/decl/material/pigment/blue
	name = "blue pigment"
	icon_colour = "#247cff"

/decl/material/pigment/purple
	name = "purple pigment"
	icon_colour = "#cc0099"

/decl/material/pigment/grey //Mime
	name = "grey pigment"
	icon_colour = "#808080"

/decl/material/pigment/brown //Rainbow
	name = "brown pigment"
	icon_colour = "#846f35"

/decl/material/pigment/grey //Mime
	name = "grey pigment"
	icon_colour = "#808080"

/decl/material/pigment/black
	name = "black pigment"
	icon_colour = "#222222"

/decl/material/pigment/white
	name = "white pigment"
	icon_colour = "#aaaaaa"

/decl/material/paint
	name = "paint"
	lore_text = "This paint will stick to almost any object."
	taste_description = "chalk"
	icon_colour = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	icon_colour_weight = 0

/decl/material/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !istype(T, /turf/space))
		T.color = holder.get_color()

/decl/material/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		O.color = holder.get_color()

/decl/material/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M) && !isobserver(M))
		M.color = holder.get_color()

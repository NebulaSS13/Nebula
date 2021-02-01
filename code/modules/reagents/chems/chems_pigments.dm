/decl/material/liquid/pigment
	name = "pigment"
	lore_text = "Intensely coloured powder."
	taste_description = "the back of class"
	color = "#888888"
	overdose = 5
	hidden_from_codex = TRUE

/decl/material/liquid/pigment/red
	name = "red pigment"
	color = "#fe191a"

/decl/material/liquid/pigment/orange
	name = "orange pigment"
	color = "#ffbe4f"

/decl/material/liquid/pigment/yellow
	name = "yellow pigment"
	color = "#fdfe7d"

/decl/material/liquid/pigment/green
	name = "green pigment"
	color = "#18a31a"

/decl/material/liquid/pigment/blue
	name = "blue pigment"
	color = "#247cff"

/decl/material/liquid/pigment/purple
	name = "purple pigment"
	color = "#cc0099"

/decl/material/liquid/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/material/liquid/pigment/brown //Rainbow
	name = "brown pigment"
	color = "#846f35"

/decl/material/liquid/pigment/grey //Mime
	name = "grey pigment"
	color = "#808080"

/decl/material/liquid/pigment/black
	name = "black pigment"
	color = "#222222"

/decl/material/liquid/pigment/white
	name = "white pigment"
	color = "#aaaaaa"

/decl/material/liquid/paint
	name = "paint"
	lore_text = "This paint will stick to almost any object."
	taste_description = "chalk"
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 0

/decl/material/liquid/paint/proc/apply_paint(var/atom/painting, var/datum/reagents/holder)
	if(istype(painting) && istype(holder))
		var/keep_alpha = painting.alpha
		painting.color = holder.get_color()
		painting.alpha = keep_alpha

/decl/material/liquid/paint/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T) && !isspaceturf(T))
		apply_paint(T, holder)

/decl/material/liquid/paint/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O))
		apply_paint(O, holder)

/decl/material/liquid/paint/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		apply_paint(M, holder)
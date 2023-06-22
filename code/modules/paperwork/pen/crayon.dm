/obj/item/pen/crayon
	name               = "crayon"
	icon               = 'icons/obj/items/crayons.dmi'
	icon_state         = "crayonred"
	w_class            = ITEM_SIZE_TINY
	attack_verb        = list("attacked", "coloured", "crayon'd")
	stroke_colour      = "#ff0000" //RGB
	stroke_colour_name = "red"
	medium_name        = "crayon"
	pen_flag           = PEN_FLAG_ACTIVE | PEN_FLAG_CRAYON | PEN_FLAG_DEL_EMPTY
	pen_quality        = TOOL_QUALITY_BAD //Writing with those things is awkward
	max_uses           = 30
	pen_font           = PEN_FONT_CRAYON
	var/shade_colour   = "#220000" //RGB

/obj/item/pen/crayon/make_pen_description()
	desc = "A colourful [stroke_colour_name] [istype(material)?"[material.name] ":null][medium_name]. Please refrain from eating it or putting it in your nose."

/obj/item/pen/crayon/set_medium_color(_color, _color_name, var/_shade_colour)
	. = ..(_color, _color_name)
	shade_colour = _shade_colour
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_SHADE_COLOR, shade_colour)

/obj/item/pen/crayon/afterattack(turf/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target) && target.is_floor())
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		var/draw_message = "drawing"
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list(global.alphabet)
				draw_message = "drawing a letter"
			if("graffiti")
				draw_message = "drawing graffiti"
			if("rune")
				draw_message = "drawing a rune"
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				draw_message = "drawing an arrow"

		if(do_tool_interaction(TOOL_PEN, user, target, 5 SECONDS, draw_message, "drawing on", fuel_expenditure = 1))
			new /obj/effect/decal/cleanable/crayon(target, stroke_colour, shade_colour, drawtype)
			target.add_fingerprint(user) // Adds their fingerprints to the floor the crayon is drawn on.
	return

/obj/item/pen/crayon/attack(mob/living/M, mob/user)
	if(istype(M) && M == user)
		var/decl/tool_archetype/pen/parch = GET_DECL(TOOL_PEN)
		playsound(src, 'sound/weapons/bite.ogg')
		to_chat(M, SPAN_NOTICE("You take a bite of the crayon and swallow it."))
		M.adjust_nutrition(1)
		var/uses = get_tool_property(TOOL_PEN, TOOL_PROP_USES)
		M.reagents.add_reagent(/decl/material/liquid/pigment, min(5,uses)/3)
		if(parch.decrement_uses(user, src, 5) <= 0)
			to_chat(M, SPAN_WARNING("You ate your crayon!"))
		return
	. = ..()

/obj/item/pen/crayon/red
	icon_state         = "crayonred"
	stroke_colour      = "#da0000"
	shade_colour       = "#810c0c"
	stroke_colour_name = "red"

/obj/item/pen/crayon/orange
	icon_state         = "crayonorange"
	stroke_colour      = "#ff9300"
	stroke_colour_name = "orange"
	shade_colour       = "#a55403"

/obj/item/pen/crayon/yellow
	icon_state         = "crayonyellow"
	stroke_colour      = "#fff200"
	shade_colour       = "#886422"
	stroke_colour_name = "yellow"

/obj/item/pen/crayon/green
	icon_state         = "crayongreen"
	stroke_colour      = "#a8e61d"
	shade_colour       = "#61840f"
	stroke_colour_name = "green"

/obj/item/pen/crayon/blue
	icon_state         = "crayonblue"
	stroke_colour      = "#00b7ef"
	shade_colour       = "#0082a8"
	stroke_colour_name = "blue"

/obj/item/pen/crayon/purple
	icon_state         = "crayonpurple"
	stroke_colour      = "#da00ff"
	shade_colour       = "#810cff"
	stroke_colour_name = "purple"

/obj/item/pen/crayon/mime
	icon_state         = "crayonmime"
	stroke_colour      = "#ffffff"
	shade_colour       = "#000000"
	stroke_colour_name = "mime"
	max_uses           = -1 //Infinite

/obj/item/pen/crayon/mime/make_pen_description()
	desc = "A very sad-looking crayon."

/obj/item/pen/crayon/mime/attack_self(mob/user) //inversion
	if(stroke_colour != "#ffffff" && shade_colour != "#000000")
		set_medium_color("#ffffff", stroke_colour_name, "#000000")
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		set_medium_color("#000000", stroke_colour_name, "#ffffff")
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state         = "crayonrainbow"
	stroke_colour      = "#fff000"
	shade_colour       = "#000fff"
	stroke_colour_name = "rainbow"
	max_uses           = -1

/obj/item/pen/crayon/rainbow/make_pen_description()
	desc = "A very colourful [istype(material)?"[material.name] ":null][medium_name]. Please refrain from eating it or putting it in your nose."

/obj/item/pen/crayon/rainbow/attack_self(mob/user)
	stroke_colour = input(user, "Please select the main colour.",  "Crayon colour") as color
	shade_colour  = input(user, "Please select the shade colour.", "Crayon colour") as color
	set_medium_color(stroke_colour, stroke_colour_name, shade_colour)
	return
